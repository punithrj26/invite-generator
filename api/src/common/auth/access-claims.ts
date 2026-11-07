export type Role = 'user' | 'admin' | 'designer';

/** Access-token JWT payload (docs/01 §5.4). */
export interface AccessClaims {
  sub: string; // user id
  tid: string; // tenant id
  roles: Role[];
  sid: string; // session id (refresh-token family)
}

export const DEFAULT_TENANT = 'default';
