// Runs before test files are imported (ES imports are hoisted, and ConfigModule validates at import time).
// Needs a reachable MongoDB: docker compose locally, service container in CI.
process.env.MONGODB_URI ??= 'mongodb://localhost:27018/invite_test';
process.env.NODE_ENV ??= 'test';
process.env.JWT_ACCESS_SECRET ??= 'e2e-only-secret-not-used-anywhere-else-000';
// 1 hop so tests can give each client its own X-Forwarded-For and keep rate-limit buckets apart.
process.env.TRUST_PROXY_HOPS ??= '1';
// Media: the compose `s3` stand-in (docker/s3.json); CI starts the same image.
process.env.S3_ENDPOINT ??= 'http://localhost:9000';
process.env.S3_BUCKET ??= 'invite-media-test';
process.env.MEDIA_BASE_URL ??= 'http://localhost:9000/invite-media-test';
process.env.AWS_ACCESS_KEY_ID ??= 's3-dev';
process.env.AWS_SECRET_ACCESS_KEY ??= 's3-dev-only-secret';
