import 'reflect-metadata';

import { InvitationSchema } from '../modules/invitations/invitation.schema';
import { SessionSchema } from '../modules/sessions/session.schema';

// Regression: `@Prop({ type: Types.ObjectId })` silently became Mixed, so string ids were stored as strings.
describe('ObjectId references', () => {
  it.each([
    [SessionSchema, 'userId'],
    [InvitationSchema, 'ownerId'],
    [InvitationSchema, 'templateId'],
  ] as const)('%#: %s is a real ObjectId path', (schema, path) => {
    expect(schema.path(path).instance).toBe('ObjectId');
  });
});
