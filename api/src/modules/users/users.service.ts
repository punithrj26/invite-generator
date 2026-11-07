import {
  ConflictException,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

import type { AccessClaims } from '../../common/auth/access-claims';
import { InvitationsService } from '../invitations/invitations.service';
import { MediaService } from '../media/media.service';
import { SessionsService } from '../sessions/sessions.service';
import { UpdateMeDto } from './dto';
import { dummyPasswordHash, hashPassword, verifyPassword } from './password';
import { User, UserDocument } from './user.schema';

@Injectable()
export class UsersService {
  constructor(
    @InjectModel(User.name) private readonly model: Model<User>,
    private readonly sessions: SessionsService,
    private readonly invitations: InvitationsService,
    private readonly media: MediaService,
  ) {}

  async create(
    tenantId: string,
    input: { email: string; password: string; name: string },
  ): Promise<UserDocument> {
    const passwordHash = await hashPassword(input.password);
    try {
      return await this.model.create({
        tenantId,
        email: input.email,
        name: input.name,
        passwordHash,
      });
    } catch (e) {
      if ((e as { code?: number }).code === 11000)
        throw new ConflictException(
          'An account with this email already exists.',
        );
      throw e;
    }
  }

  /** Same error and roughly the same time for unknown email, wrong password and disabled account. */
  async verifyCredentials(
    tenantId: string,
    email: string,
    password: string,
  ): Promise<UserDocument> {
    const user = await this.model
      .findOne({ tenantId, email: email.toLowerCase() })
      .select('+passwordHash');
    const ok = await verifyPassword(
      password,
      user?.passwordHash ?? (await dummyPasswordHash),
    );
    if (!user || !ok || user.status !== 'active')
      throw new UnauthorizedException('Invalid email or password.');
    await this.model.updateOne(
      { _id: user._id },
      { $set: { lastLoginAt: new Date() } },
    );
    return user;
  }

  /** 401 (not 404) when the user is gone or disabled: the client treats it as an ended session. */
  async findActive(tenantId: string, id: string): Promise<UserDocument> {
    const user = await this.model.findOne({ _id: id, tenantId });
    if (!user || user.status !== 'active') throw new UnauthorizedException();
    return user;
  }

  async updateMe(me: AccessClaims, dto: UpdateMeDto): Promise<UserDocument> {
    const changes = Object.fromEntries(
      Object.entries(dto).filter(([, v]) => v !== undefined),
    );
    const user = await this.model.findOneAndUpdate(
      { _id: me.sub, tenantId: me.tid, status: 'active' },
      { $set: changes },
      { new: true, runValidators: true },
    );
    if (!user) throw new UnauthorizedException();
    return user;
  }

  /** Keeps the current session; signs out every other device. */
  async changePassword(
    me: AccessClaims,
    currentPassword: string,
    newPassword: string,
  ): Promise<void> {
    const user = await this.withPassword(me, currentPassword);
    user.passwordHash = await hashPassword(newPassword);
    await user.save();
    await this.sessions.revokeAllForUser(me.sub, me.sid);
  }

  /**
   * App Store / Play requirement (docs/02 §2.4). Media first: if S3 fails, the account still exists and the user
   * can retry, instead of leaving orphaned photos nobody can delete. Public-link invalidation joins in Sprint 4.
   */
  async deleteAccount(me: AccessClaims, password: string): Promise<void> {
    await this.withPassword(me, password);
    await this.media.deleteUserMedia(me.sub);
    await this.invitations.deleteAllForOwner(me.sub);
    await this.sessions.deleteAllForUser(me.sub);
    await this.model.deleteOne({ _id: me.sub, tenantId: me.tid });
  }

  /** 403 on a wrong password: a 401 would make clients think the session expired and try to refresh. */
  private async withPassword(
    me: AccessClaims,
    password: string,
  ): Promise<UserDocument> {
    const user = await this.model
      .findOne({ _id: me.sub, tenantId: me.tid, status: 'active' })
      .select('+passwordHash');
    if (!user) throw new UnauthorizedException();
    if (!(await verifyPassword(password, user.passwordHash)))
      throw new ForbiddenException('Current password is incorrect.');
    return user;
  }
}
