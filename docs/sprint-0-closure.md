# Sprint 0 closure audit

Date: 2026-11-06 · Scope: everything in the repo at audit time, which is uncommitted (`git status`: all untracked, branch `main`, no remote).
Method: every check below marked **Executed** was run during the audit. **Read** means the conclusion comes from inspecting files only. **Not verified** means it was not executed.
Experiments that needed config changes ran in a throwaway copy (`/tmp/ci-sim.JsA2`). **The repository was not modified by the audit** apart from adding this file.

> **Status since this audit (this report is a dated record and isn't rewritten):** tasks 1–9 of §5 were fixed on 2026-11-06, and M2 and M8 were closed in Sprint 1. Live status: [progress.md](progress.md).

## Verdict

**Sprint 0 is not closed.**
- The Flutter app **does not build for Android or iOS** (C1).
- The API CI job **will fail on its first GitHub run** (H1).
- Local tests were silently running against the developer's own MongoDB instead of the Compose instance (H3).
- The sprint exit criterion ("hello API on staging via pipeline; app builds for 3 platforms in CI") is unmet.

The API itself is in good shape: validation, security headers, CORS, container behavior, and lockfiles all passed executed checks.

---

## 1. Findings by severity

### Critical

**C1: The app fails to build for Android and iOS.** *Executed.*
- **Android:** `flutter build apk --release` → `Manifest merger failed: uses-sdk:minSdkVersion 24 cannot be smaller than version 26 declared in library [:sentry_flutter]`.
- **iOS:** `flutter build ios --simulator --debug` → `The package product 'sentry-flutter' requires minimum platform version 15.0 for the iOS platform, but this target supports 13.0`.
- **Cause:** `sentry_flutter ^10.3.0`, added in Sprint 0, was only ever built for Web. The project inherits Flutter defaults: `minSdk = flutter.minSdkVersion` (24) and `IPHONEOS_DEPLOYMENT_TARGET = 13.0`.
- **Fix path:**
  - Android: raising `minSdk` to 26 in a throwaway copy produced a working release APK. *Executed.*
  - iOS: raising the deployment target to 15.0 was started, then skipped at the user's request. **Not verified.**
- **Decision needed:** minimum supported OS versions are not in any doc. Options:
  - (a) raise to Android 8.0 (API 26) and iOS 15, or
  - (b) pin `sentry_flutter` to a major that supports the current minimums. Its requirements are not verified.

### High

**H1: `npm run test:scripts` fails on Node 22, so the API CI job fails.** *Executed* in `node:22` (v22.23.4).
- `node --test scripts/` → `Error: Cannot find module '/repo/api/scripts'` (0 pass, 1 fail). Node ≥ 21 treats the argument as a file, not a directory. It passed locally only because the machine runs Node 20.18.1.
- `node --test scripts/*.test.mjs` passes 2/2 on Node 22. *Executed.*
- **Fix:** change the script to that glob.

**H2: Sprint 0 progress was overstated.** *Executed / Read.* `docs/progress.md` marks items done that were not verified as described:
- "e2e against real Mongo" ran against the **native** mongod, not Compose (see H3).
- "CI" is `[x]`, but neither workflow has ever run on GitHub.
- The exit criterion "app builds for 3 platforms in CI" is unmet: CI builds Web only, and Android/iOS don't build at all (C1).

**H3: The Compose MongoDB is unreachable from the host, which reaches the native mongod instead.** *Executed.*
- **Listeners on 27017:** native `mongod` on `127.0.0.1` and `[::1]`; Docker on `*`.
- **Marker test:** a document written into the Compose Mongo was **not** visible via `localhost`, `127.0.0.1`, or `[::1]`. All three reach native mongod 7.0.11.
- **Inside the Docker network, it works:**
  - The API container (172.18.0.3) holds a Mongoose connection to the Compose Mongo. *Executed.*
  - E2E tests run on the Compose network with `MONGODB_URI=mongodb://mongo:27017/…` pass 2/2. *Executed.*
  - A negative control with an unreachable host fails with `MongooseServerSelectionError … ENOTFOUND`, proving the suite needs a live Mongo. *Executed.*
- **Risk:** from Sprint 1, e2e tests write users and sessions. On this machine they would write into the developer's personal MongoDB.
- **Fix:** publish Compose Mongo on a non-conflicting host port (e.g. `27018:27017`), and point `test/e2e-env.ts` and `.env.example` defaults at it.

### Medium

| # | Finding | Evidence |
|---|---------|----------|
| M1 | App identifiers are template placeholders: Android `com.example.invite_generator`, iOS `com.example.inviteGenerator`. Play rejects `com.example.*`, and both ids are permanent after first store upload. A single id for all flavors means staging and prod can't be installed side by side. | Read (`build.gradle.kts`, `project.pbxproj`); APK badging *Executed* |
| M2 | Local dev can't reach the API from two targets. **Android emulator:** `localhost` is the emulator itself, and cleartext HTTP is blocked by default (no `usesCleartextTraffic` or network-security config). **Flutter Web:** `flutter run -d chrome` uses a random port, but CORS allows only `http://localhost:8080`. **iOS simulator:** ATS behavior for `http://localhost` is not verified. | CORS fixed-origin behavior *Executed*; the rest Read |
| M3 | Node version drift. Local is 20.18.1, Docker and CI are 22. `eslint-visitor-keys@5.0.1` requires `^20.19.0 \|\| ^22.13.0 \|\| >=24`. There's no `.nvmrc` or `engines` field. | *Executed* (engine scan) |
| M4 | Nest 11 is now the `legacy` dist-tag. `@nestjs/platform-express@11.2.8` pins vulnerable `multer@2.4.0`, and only `12.3.3` (ESM) ships 2.5.0. The multer override may be permanent unless we move to Nest 12. | *Executed* (`npm view`) |
| M5 | The template validator is missing the **asset-existence check** that docs/03 §2.3 promises. The schema `source` pattern accepts trailing junk (`"{{media.photoUrl}} junk"` → accepted). | *Executed* (11 negative cases: 10 rejected, 1 wrongly accepted) |
| M6 | Workflows set no `permissions:` (default token scopes apply), and actions are pinned by tag, not commit SHA. They've never run on GitHub. The Docker job builds amd64, while docs/04 §3.3 specifies arm64 (Graviton). | *Executed* (YAML parse); GitHub run **Not verified** |
| M7 | CI builds Web only, with no Android or iOS build job, so C1 would not have been caught by CI. | Read |
| M8 | `trust proxy` is not configured. Behind the ALB, `req.ip` will be the load balancer, so it must be set before Sprint 1's per-IP throttling. | Read (`src/app.setup.ts`) |

### Low

| # | Finding | Evidence |
|---|---------|----------|
| L1 | `android/app/src/main/AndroidManifest.xml` declares no `INTERNET` permission. The release APK *does* request it, but only because it's merged in from `sentry_flutter`'s manifest. Declare it explicitly. (Initially suspected High; the APK dump disproved that.) | *Executed* (`aapt2 dump permissions`) |
| L2 | Placeholder branding: Android label `invite_generator`, iOS `Invite Generator`, web `<title>`/manifest "A new Flutter project", web theme color `#0175C2`. Pending the product-name decision. | Read |
| L3 | Schema errors for layers are misleading. A bad image layer reports "must have required property 'text'" because `oneOf` reports the first branch. Use Ajv's `discriminator` on `type`. | *Executed* |
| L4 | Skill issues: paths `app/router.dart` and `app/theme/tokens.dart` should be `app/lib/app/…`. The machine-specific gotcha (native mongod) doesn't belong in a repo-level skill. "docker compose up -d mongo" doesn't make Mongo reachable on this machine (H3). | *Executed* (reference check); harness discovery of the skill *Executed* (listed as available) |
| L5 | `api/README.md` is NestJS boilerplate, and its placeholder badge `token=abc123def456` trips secret scanners. | *Executed* (scan) |
| L6 | Docker: base images are not digest-pinned (docs/04 §5 says pinned), there's no `HEALTHCHECK`, and the image is 317 MB. | *Executed* (`docker image inspect`) |
| L7 | Desktop platform folders (`linux/`, `macos/`, `windows/`) exist, though the targets are iOS, Android, and Web only. | Read |
| L8 | The multer CVE fix was **not independently reproduced**. My reproduction passed on vulnerable 2.4.0 too, so it doesn't trigger the bug. The fix rests on the advisory and release notes. | *Executed* (control run) |
| L9 | The audit left a 1-document `audit` database in the Compose Mongo volume. `docker compose down -v` removes it. | *Executed* |

---

## 2. Results per audit item

| # | Item | Result |
|---|------|--------|
| 1 | Compose Mongo independent of native | **Works only inside the Docker network.** API container → Compose Mongo verified, and e2e on the Compose network passes 2/2 with a negative control. **Host access is shadowed by native mongod (H3).** |
| 2 | Multer override | Documented in §3. Nest upload compatibility verified; CVE fix not independently reproduced (L8). |
| 3 | Dependencies and lockfiles | Clean `npm ci` (Node 22, Linux) ✓, `npm ls --all` clean ✓. All `@nestjs/*` on the 11 line and CommonJS ✓. `flutter pub get --enforce-lockfile` ✓. Node drift (M3). `cupertino_icons` 1.0.9 → 2.0.0 available (not needed). |
| 4 | Flutter platforms | **Android ✗ and iOS ✗ build (C1)**; Web ✓ (Sprint 0 release build). Ids (M1), dev connectivity (M2), permission (L1), branding (L2). |
| 5 | Env, CORS, headers, Docker | **All executed, all pass.** Missing or malformed env exits with code 1 and a precise message. Helmet headers present and `X-Powered-By` removed. CORS only allows `WEB_APP_ORIGIN`, with credentials. JSON logs in production. Runs as uid 1000 `node` with no `.env` in the image. `SIGTERM` exits 0 in 606 ms. Gaps: M8, L6. |
| 6 | Schema vs docs/03 | Every docs/03 §2.2 field is in the schema ✓. 10/11 malformed cases rejected. Asset check missing and pattern gap (M5), error quality (L3). |
| 7 | CI | **Never run on GitHub.** The `api` job was reproduced in `node:22` against Compose Mongo: everything passes **except `test:scripts` (H1)**. `app` job steps executed on macOS, not Ubuntu. Both YAML files parse, all referenced scripts exist, and Flutter 3.44.7 is a published Linux stable release. Not verified: action resolution, the Mongo service health-check quoting, the runner environment. |
| 8 | README and skill | README links all resolve ✓, but the Quick start hits M2/H3 on this machine. Skill frontmatter parses ✓, the harness lists the skill ✓, two wrong paths (L4). |
| 9 | Sprint 0 requirements | See §4. |
| 10 | Credentials and secrets | **None found.** All 172 to-be-committed files were scanned for AWS, GitHub, Slack, Stripe, Google, JWT, PEM, and Sentry DSN patterns, plus Mongo URIs with credentials and generic `password`/`secret`/`token=` values. Two hits, both false positives: the boilerplate badge token (L5) and a dummy `user:pw@cluster0.example.net` test fixture. No `.env`, keystore, `key.properties`, `.p8`, or `.p12` files exist. `SENTRY_DSN` is empty in all configs. *Executed.* |

---

## 3. Multer security override

| | |
|---|---|
| **Advisory** | [GHSA-q7qp-rjg7-q26m](https://github.com/advisories/GHSA-q7qp-rjg7-q26m) · CVE-2026-113872 · **High**, CVSS 7.5 (`AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H`) · CWE-248, CWE-404 · published 2026-10-23 |
| **Vulnerability** | With an **asynchronous `fileFilter`**, aborting a request while another file's filter is pending resumes a torn-down busboy stream. The result is an unhandled `'error'` event and the Node process exits. One unauthenticated request is enough. A synchronous `fileFilter` is not affected. |
| **Affected / patched** | `multer >= 2.0.0, < 2.5.0` / **2.5.0** |
| **Our exposure today** | None. There are no upload endpoints until Sprint 3 (`POST /media/upload-url` uses presigned S3 POST, so files never pass through the API). |
| **Why an override** | `@nestjs/platform-express@11.2.8` (the latest Nest 11) pins `multer` to exactly `2.4.0`. Only `@nestjs/platform-express@12.3.3` ships 2.5.0. |
| **Override** | `api/package.json` → `"overrides": { "multer": "2.5.0" }`; lockfile resolves `node_modules/multer` 2.5.0 ✓ |
| **Compatibility** | 2.4.0 → 2.5.0 has identical dependencies and `engines` `node >= 10.16.0`. Changes: the CVE fix, "don't add a failed upload to the abort cleanup list", and "allow a field value exactly at the fieldSize limit", a boundary change to keep in mind if we ever rely on `fieldSize`. **Executed:** Nest 11 `FileInterceptor` single upload and multi-file async-filter upload work on 2.5.0. **Not reproduced:** the crash on 2.4.0 (L8). |
| **Removal criteria** | Delete the override when **any** of these holds: (1) the installed `@nestjs/platform-express` depends on `multer >= 2.5.0`, via a Nest 11 patch release or the move to Nest 12; (2) `@nestjs/platform-express` is replaced by a non-multer adapter (e.g. Fastify). Check with `npm view @nestjs/platform-express@<installed> dependencies.multer` at each dependency update. After removal, `npm audit --omit=dev --audit-level=high` must stay clean. |
| **Rule while in place** | Any Sprint 3+ upload handler must use a **synchronous** `fileFilter` anyway (defense in depth). |

---

## 4. Sprint 0 requirements (docs/04 §2, S0 row)

| Requirement | Status |
|-------------|--------|
| Nest 11 scaffold, env validation, health, Dockerfile, docker-compose (Mongo 7) | ✅ Done and executed (H3 caveat for host access) |
| Move app to `app/`, folder skeleton | ✅ Done (feature folders are created per sprint, by design) |
| Flavors via `--dart-define-from-file` | ⚠️ Dart-side only. No native flavors or per-environment app ids (M1) |
| Sentry | ⚠️ Wired, but **breaks Android/iOS builds (C1)**. Never exercised with a real DSN. |
| Terraform (VPC, ECR, ECS, ALB, S3×2, CloudFront×3, ACM, Route53, Secrets) | ❌ Blocked: AWS account, region, domain; Terraform not installed |
| Atlas project + peering | ❌ Blocked: Atlas org |
| GitHub Actions | ⚠️ Written and partly reproduced locally. **Never run on GitHub**, will fail (H1), web only (M7). |
| Template JSON schema v1 sign-off | ⚠️ Schema exists and is tested. **No human sign-off recorded.** Asset check missing (M5). |
| 3 birthday designs | ❌ Not started (designer) |
| Exit: "hello" API on staging via pipeline | ❌ Blocked on AWS |
| Exit: app builds for 3 platforms in CI | ❌ Web only; mobile builds fail |

---

## 5. Outstanding tasks (exact)

**Fix before Sprint 1 (no new features):**
1. **C1:** Decide minimum OS versions. If Android 8.0 / iOS 15: set `minSdk = 26` in `app/android/app/build.gradle.kts` and `IPHONEOS_DEPLOYMENT_TARGET = 15.0` (3 occurrences) in `app/ios/Runner.xcodeproj/project.pbxproj`. Record the decision in docs/01 §1 as D13. Verify with `flutter build apk --release` and `flutter build ios --simulator --debug`.
2. **H1:** In `api/package.json`, set `"test:scripts": "node --test scripts/*.test.mjs"`. Verify with Node 22 (`docker run … node:22`).
3. **H3:** Change the Compose Mongo port to `"27018:27017"`. Set `test/e2e-env.ts`, `api/.env.example`, the README, and the skill to `mongodb://localhost:27018/…`. Verify with the marker test (host write → visible in the Compose container).
4. **H2:** Correct `docs/progress.md`: un-tick CI, note the e2e Mongo caveat and the mobile-build failure, and link this report.
5. **M7:** Add an Android `flutter build apk --debug` job (ubuntu) and an iOS `flutter build ios --simulator --debug` job (macos-latest) to `app.yml`.
6. **M3:** Add `.nvmrc` (`22`) at the repo root and `"engines": { "node": ">=22" }` in `api/package.json`. Upgrade local Node to 22.
7. **M6:** Add `permissions: { contents: read }` to both workflows.
8. **L1:** Add `<uses-permission android:name="android.permission.INTERNET"/>` to the main manifest.
9. **L4:** Fix the two skill paths. Move the native-mongod note out of the skill into a local-only note.
10. **First GitHub run:** create the remote, make the first commit and push (needs your go-ahead), then confirm both workflows go green.

**Decide (owner: product/tech lead):** minimum OS versions (C1); app ids and product name (M1, L2); Nest 12 migration timing (M4); schema v1 sign-off.

**Blocked on accounts:** AWS and Terraform, Atlas, Sentry DSNs, staging deploy, ECR push. Then: arm64 builds (M6), digest-pinned base images (L6).

**Defer to the sprint where needed:**
- M5 asset check and pattern anchoring → Sprint 2 (when assets exist).
- L3 schema error messages → Sprint 2.
- M8 `trust proxy` → Sprint 1, before the throttler.
- M2 dev connectivity → Sprint 1, first task (see below).
- L5, L7 → any time.

---

## 6. Recommended Sprint 1 sequence

Precondition: outstanding tasks 1–9 are done and green, and ideally task 10 too, so Sprint 1 starts on a pipeline known to work.

1. **Dev connectivity (M2):**
   - Per-platform dev base URL: Android emulator `http://10.0.2.2:3000`, plus a debug-only network-security config for cleartext.
   - Fixed web port: `flutter run -d chrome --web-port 8080`, documented in the README and skill.
   - Verify that each target reaches `/health`.
2. **API shared plumbing:**
   - `AllExceptionsFilter` + `ErrorCode` envelope (docs/02 §2.1)
   - Request logger with `requestId`
   - `app.set('trust proxy', …)` (M8)
   - Global `JwtAuthGuard` with `@Public()`, `RolesGuard`
   - e2e tests for the error envelope and for unauthenticated access returning 401.
3. **Users + sessions schemas and indexes:** `users` `{tenantId, email}` unique, and `sessions` with a TTL on `expiresAt` (docs/02 §1.3–1.4). Add the first migration script, because `autoIndex` is off outside dev/test.
4. **Auth API:**
   - scrypt `password.ts` (unit tests)
   - register and login, plus `/users/me` GET/PATCH
   - refresh rotation with reuse detection
   - logout and password change
   - `@nestjs/throttler` on auth routes
   - Web refresh cookie
   - e2e: full lifecycle, replay revokes the session, IDOR (user B can't read user A).
5. **Account deletion:** `DELETE /users/me`, an App Store requirement. Its cascade reaches only users and sessions until invitations exist.
6. **Flutter core network:** `AppFailure` + `failure_mapper`, Dio provider, `AuthInterceptor` (single-flight refresh; unit-test concurrent 401s), `TokenStore` (`flutter_secure_storage` on mobile, memory + cookie on web).
7. **Flutter auth flow:**
   - `AuthController`, router redirect
   - login, register, and profile screens (validation, loading, and error states; Semantics)
   - widget tests per screen.
8. **Cross-platform exit check:** register → login → wait out the access token → refresh → logout on Android emulator, iOS simulator, and Chrome. Confirm the CI mobile build jobs are green. Update `docs/progress.md` through the skill.
