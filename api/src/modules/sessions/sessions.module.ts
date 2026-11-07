import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { Session, SessionSchema } from './session.schema';
import { SessionsService } from './sessions.service';

/** Own module so both auth (create/rotate) and users (revoke on password change / delete) can use it without a cycle. */
@Module({
  imports: [
    MongooseModule.forFeature([{ name: Session.name, schema: SessionSchema }]),
  ],
  providers: [SessionsService],
  exports: [SessionsService],
})
export class SessionsModule {}
