import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { InvitationsModule } from '../invitations/invitations.module';
import { MediaModule } from '../media/media.module';
import { SessionsModule } from '../sessions/sessions.module';
import { User, UserSchema } from './user.schema';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: User.name, schema: UserSchema }]),
    SessionsModule,
    InvitationsModule,
    MediaModule,
  ],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
