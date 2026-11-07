# Delivery progress

Sprint scope and exit criteria: [04 §2](04-delivery-and-operations.md#2-sprint-plan-phase-1). Updated by the `invite-platform` skill (`.claude/skills/invite-platform/SKILL.md`).
Sprint 0 audit: [sprint-0-closure.md](sprint-0-closure.md). Findings C1, H1–H3, M3, M6 (permissions), M7, L1 and L4 were fixed on 2026-11-06 (see "Audit fixes" below).

Legend: `[x]` done and verified · `[ ]` todo · `[~]` blocked (reason given). "Verified" means the check was executed, not just written.

## Sprint 0: Foundations

- [x] Monorepo: Flutter app moved to `app/`, `api/`, `templates/`, `docs/`, git initialised on `main` (no commits yet, no remote)
- [x] API: Nest 11 scaffold, validated env (`src/config/env.ts`), Mongo connection, `GET /health`, helmet, CORS, `/v1` prefix, ValidationPipe, JSON logs outside dev
- [x] API: Dockerfile (node 22, non-root) + `docker-compose.yml` (mongo:7 on host port **27018** + api). Verified: `/health`, API container ↔ compose Mongo, graceful SIGTERM, exit 1 on invalid env
- [x] API tests: env unit tests (4), e2e (2) against the **compose** Mongo. A negative control (compose Mongo stopped → `ECONNREFUSED :27018`) proves they don't fall back to a native mongod.
- [x] App: Riverpod + GoRouter shell, Dart-side flavors (`config/{dev,staging,prod}.json`), Sentry (enabled when `SENTRY_DSN` is set), Material 3 theme + tokens, WCAG contrast test
- [x] App builds: **Android release APK** (minSdk 26), **iOS simulator** (iOS 15.0), **Web release**. All built locally. Min OS decision D13 in docs/01.
- [x] Template schema v1 (`templates/schema.v1.json`) + `birthday-balloons` example + validator with semantic checks and tests
- [ ] CI written (`api.yml`: lint, build, unit, script tests, templates, e2e with Mongo service, audit, docker build. `app.yml`: format, analyze, test, web, Android release, iOS simulator; least-privilege token). The `api` job was reproduced locally on Node 22 and is green. **Not yet run on GitHub** (needs first commit + push).
- [~] Terraform (VPC, ECR, ECS, ALB, S3×2, CloudFront×3, ACM, Route53, Secrets): **blocked**, needs Terraform installed, an AWS account, the region confirmed, and a domain
- [~] MongoDB Atlas project + VPC peering: **blocked**, needs Atlas org access
- [~] CI deploy to staging (GitHub OIDC → ECR → ECS): **blocked** on the two items above
- [~] Sentry projects (Flutter + Nest DSNs): **blocked**, needs a Sentry org
- [ ] Design: 3 birthday template designs (designer)
- [ ] Sign-off: template schema v1 (product + design)
- [ ] Decide: product name and app ids (now `com.example.*`, see audit M1), domain (placeholder `domain.com`), Nest 12 migration timing (audit M4)

**Exit criterion** ("hello API on staging via pipeline; app builds for 3 platforms in CI"):
- All 3 platforms build locally, and CI jobs exist for each. **Not met in CI** until the first GitHub run.
- Staging deploy is blocked on AWS.

### Audit fixes (2026-11-06)

| Finding | Fix | Verified by |
|---------|-----|-------------|
| C1 mobile builds | `minSdk = 26`, `IPHONEOS_DEPLOYMENT_TARGET = 15.0` (3 configs), D13 | `flutter build apk --release` ✓ (APK minSdk 26), `flutter build ios --simulator` ✓ (MinimumOSVersion 15.0) |
| H1 `test:scripts` on Node ≥ 21 | `node --test scripts/*.test.mjs` | Node 22 container: 2 pass, 0 fail |
| H2 overstated progress | This file rewritten | — |
| H3 compose Mongo shadowed | Host port 27018; defaults in `test/e2e-env.ts`, `.env.example`, README, skill | Marker test via `localhost:27018` reaches compose; e2e negative + positive control |
| M3 Node drift | `.nvmrc` = 22, `engines.node >= 22`, CI `node-version-file` | Full api CI job reproduced on Node 22: all steps green |
| M6 (part) token scope | `permissions: contents: read` in both workflows | YAML parsed |
| M7 web-only CI | `android` + `ios` jobs in `app.yml` | YAML parsed; same commands green locally. GitHub run pending |
| L1 INTERNET permission | Declared in `src/main/AndroidManifest.xml` | Present in release APK and in the app manifest |
| L4 skill | Paths fixed; machine-specific note removed; build-all-platforms rule + new gotchas | — |

Still open from the audit (deliberately deferred): M1, M4, M6 SHA-pinning and arm64, L2, L5, L6, L7, L8. (M2 and M8 were closed in Sprint 1, items 1 and 2; M5 and L3 in Sprint 2.)
Local machine still runs Node 20.18.1; upgrade to 22 per `.nvmrc`. `engines` only warns, but `eslint-visitor-keys` officially needs ≥ 20.19.

## Sprint 1: Auth & app shell

Sequence followed: [sprint-0-closure.md §6](sprint-0-closure.md#6-recommended-sprint-1-sequence). Implemented 2026-11-06.

- [x] **1. Dev connectivity (M2):** Android debug and profile manifests allow cleartext (release does not; verified in the APK). Emulator reaches the host via `adb reverse tcp:3000 tcp:3000`. iOS `NSAllowsLocalNetworking`. Web on port 8080 (matches `WEB_APP_ORIGIN`).
- [x] **2. API plumbing:**
  - `AllExceptionsFilter` + `ErrorCode` envelope
  - `requestId` (ALB trace id or UUID) in logs, header and body
  - `trust proxy` via `TRUST_PROXY_HOPS` (M8)
  - global `JwtAuthGuard` (HS256 pinned) with `@Public()`, `RolesGuard`
  - framework text never reaches clients (malformed JSON, 413, route 404, bare exceptions)
- [x] **3. Schemas + indexes:** `users` (unique `{tenantId,email}`), `sessions` (TTL on `expiresAt`, `{userId}`), with `npm run db:indexes` (`src/cli/ensure-indexes.ts`) for envs with `autoIndex` off.
- [x] **4. Auth API:**
  - register, login, refresh, logout
  - scrypt passwords, with uniform-timing login via a dummy hash
  - rotating opaque refresh tokens, replay revokes the session
  - web refresh token only as an `httpOnly` cookie
  - throttling: register 5/min, login 10/min, refresh 30/min per IP
  - `GET`/`PATCH /users/me`, `POST /users/me/password` (signs out other devices)
- [x] **5. Account deletion:** `DELETE /users/me` with password; deletes the user and all sessions.
- [x] **6. Flutter core network:**
  - `AppFailure` + `failure_mapper` (envelope → typed failure)
  - Dio with `X-Client-Platform`; web `withCredentials`
  - `AuthInterceptor`: single-flight refresh, tested with 3 concurrent 401s → 1 refresh
  - `SessionRefresher` (refreshed / expired / unreachable: offline never logs out)
  - `TokenStore`: secure storage on mobile, memory + cookie on web
- [x] **7. Flutter auth flow:**
  - `AuthController`; router with splash, login, register, home, profile and a `?from=` deep-link redirect (open-redirect guarded)
  - login, register and profile screens: validation, loading, server field errors, banner, autofill
  - profile edit, change password, sign out, delete account
- [x] **8. Cross-platform exit check (real API, compose stack):**
  - **Web (Chrome):** register → full reload restores the session from the cookie → profile edit → sign out (reload stays signed out) → login returns to `?from=` → delete account with a wrong password (403), then the right one. No tokens visible to JS.
  - **iOS 26 simulator:** register (Keychain strong-password prompt works) → force-quit + relaunch restores from Keychain.
  - **Android 16 emulator:** register → force-stop + relaunch restores from secure storage.
  - CI-equivalent builds green: web, Android release, iOS simulator (staging config).

**Tests:** API 9 unit + 20 e2e (Node 22, compose Mongo). Flutter 17 (interceptor, failure mapper, redirect rules, widget flow, contrast).

**Bugs found by the exit check and fixed with regression tests:**
1. A bare `UnauthorizedException` leaked "Unauthorized".
2. Malformed JSON leaked the parser message, and oversized bodies returned 500.
3. Reloading `/login?from=/profile` nested `?from=` inside itself.

**Deviations from docs:**
- `sessions` is its own module, so both `auth` and `users` use it without a cycle (docs/01 §5.1 updated).
- Profile request bodies are inline maps (three flat bodies), not DTO classes.
- `avatarUrl` PATCH is deferred to Sprint 5 (needs the CDN and media upload).
- Request logs are pretty-printed objects in dev, JSON elsewhere.

**Not done in Sprint 1 (by design, see 04 §2):** password reset by email (needs SES), email verification, IDOR tests for invitations (Sprint 3), CI run on GitHub (not pushed yet).

## Sprint 2: Template engine

Implemented 2026-11-06. Scope: [04 §2](04-delivery-and-operations.md#2-sprint-plan-phase-1) S2 row, [03](03-template-engine.md).

- [x] **Templates (data):** 3 birthday designs in `templates/` (Balloons, Confetti Night, Classic Gold) with Pacifico + Poppins (OFL, licences alongside) and `templates/samples/photo.png` (generated sample photo).
- [x] **Validator (M5, L3):** relative asset paths must exist and can't traverse (`..`); the binding pattern is anchored (`"{{media.photoUrl}} junk"` rejected); Ajv `discriminator` gives layer-specific errors. 4 script tests.
- [x] **API templates module:**
  - `GET /v1/templates` returns the newest published version per key that the client's `X-Client-Renderer` can draw, with cursor paging
  - `GET /v1/templates/:id` works for any version, with `Cache-Control: immutable` and an in-process cache
  - relative asset paths become absolute under `ASSET_BASE_URL`
  - `npm run db:seed-templates` is idempotent and refuses changed content under an existing version
  - 6 e2e tests
- [x] **Local CDN stand-in:** compose `assets` service (nginx, `docker/assets.conf`, host port 8081). It serves only fonts and images from `templates/`, with `Access-Control-Allow-Origin: *` and immutable caching; `template.json` returns 404.
- [x] **Flutter engine:**
  - Freezed `TemplateSpec`, with unknown layers falling back to `UnknownLayer`
  - `BindingContext` with every formatter
  - `InvitationCanvas` (fixed logical canvas, auto-fit text, image clip/border, shapes)
  - `FontRegistry` (fonts namespaced per template version), `prepareTemplate` render-ready gate, `TemplatePreview`, `Exporter.png`
- [x] **Flutter gallery:**
  - `features/templates` (repository + Hive `cache` box: offline list fallback, versions cache-first)
  - `/templates` grid, `/templates/:id` with preset chips and a non-prod "Export PNG" check, non-prod `/dev/template-playground`
  - "Browse designs" on home
  - Dio sends `X-Client-Renderer`; new `ASSET_BASE_URL` dart-define
- [x] **Exit check:**
  - **Goldens:** 9 goldens (3 templates × 3 presets), reviewed by eye.
  - **Web (release build, :8080, compose Mongo + assets, local API):** the gallery renders with the CDN fonts and CORS photo, and export gives **1080×1920 PNG** (toImage with a cross-origin image works).
  - **iOS 26 simulator (dev build):** Hive opens, the gallery renders, and export gives 1080×1920.
  - **CI-equivalent builds green:** web, Android release APK, iOS simulator.

**Tests:** API 9 unit + 26 e2e + 4 script tests. Flutter 30 non-golden tests (binder 6, spec 2, template repository 3, gallery widget 2, plus Sprint 1) and 9 goldens.

**Bugs found and fixed:**
1. `DateFormat('…', 'en')` threw `LocaleDataException`; the default is now `en_US`.
2. `4:30 PM` contained U+202F (a missing glyph in template fonts); it's now normalised.
3. Template text inherited the no-Material debug underline; fixed by resetting `DefaultTextStyle` in the canvas.
4. Long names were ellipsised in Balloons and touched the frame in Classic Gold; fixed in the templates (seen in goldens).

**Deviations from docs:**
- No `thumbnailUrl` and no `superseded` status: the list returns `spec` and previews render live, and renderer-based selection replaces superseding (docs/02 updated).
- The playground takes pasted JSON rather than hot-reloading a file (docs/03 §7 updated).
- Android was checked by release build only, not run on an emulator this sprint.

**Not done in Sprint 2:** S3 upload in the seed script (no AWS yet), designer sign-off on the 3 designs, list pagination in the app (first page of 50 only, which is enough for Phase 1).

### Sprint 2 verification checklist (follow-up, 2026-11-07)

Status of the post-sprint review list. "Verified" means it was executed.

| # | Item | Status |
|---|------|--------|
| 0 | Gallery + export on an Android emulator | **Not verified.** The Pixel_9 emulator saturates this x86 Mac (qemu ~355% CPU, screenshots time out). Android is covered by release builds only. The iOS simulator and web runs passed. |
| 1 | Playground with valid and invalid JSON, interactively | **Not verified** interactively (analyze only). |
| 2 | Gallery pagination beyond 50 | **Deferred** (first page of 50; Phase 1 has 3 templates). The API cursor paging is e2e-tested. |
| 3 | Seed idempotency, no overwrite of published versions | Verified: e2e "seed idempotent and refuses changes", plus a manual re-run ("unchanged"). |
| 4 | Missing assets, relative paths, traversal, CORS | Verified: validator tests (missing asset, `..`), e2e absolute URLs, curl CORS on fonts/photo. |
| 5 | CDN requirements documented, placeholders flagged | See "Production CDN requirements" below. |
| 6 | Builds with intended configs | Verified 2026-11-07: web, Android release, iOS simulator, all with `config/staging.json`. |
| 7 | Complete API, Flutter and golden suites | Verified 2026-11-07, see the Sprint 3 test line. Bug found: the templates e2e suite read `templates/samples/` as a template and would have crashed; fixed. |
| 8 | Review changes for secrets, temp files, unrelated edits | Verified 2026-11-07: build output, `.env`, logs and temp files are git-ignored; secrets scan clean (only labelled dev-only stand-in values). |

**Production CDN requirements** (not yet operational; `config/staging.json` and `config/prod.json` hold **placeholder** hosts):
- `ASSET_BASE_URL` (app and API) must serve `templates/` fonts, images and `samples/photo.png` with `Access-Control-Allow-Origin` for the web app origin and `Cache-Control: public, max-age=31536000, immutable`. `template.json` must not be served.
- `MEDIA_BASE_URL` must serve `users/*/photos/*` with the same CORS rule (web export draws user photos).
- Until Terraform/CloudFront exist (Sprint 0, blocked), only the local stand-ins (`docker/assets.conf`, compose `s3`) are real.

## Sprint 3: Invitation creation

Implemented 2026-11-06/07. Scope: [04 §2](04-delivery-and-operations.md#2-sprint-plan-phase-1) S3 row, [01 §4](01-architecture.md), [02 §2.6–2.7](02-data-and-api.md).

- [x] **API invitations module:**
  - create, list (cursor `updatedAt|_id`, status filter), get, PUT, soft delete (30-day TTL), all owner-only (404 otherwise)
  - optimistic concurrency: a stale `version` gets 409 and changes nothing
  - `eventData.type` is fixed, and the template must exist and support the event type
- [x] **API media module:**
  - `POST /media/upload-url` returns a presigned S3 POST for photos (server-chosen key; policy pins type and 10 MB)
  - `media.photoUrl` must be the caller's own photo
  - Account deletion now also removes invitations and `users/{uid}/` media
- [x] **Local S3 stand-in:** compose `s3` (SeaweedFS 3.97, host :9000, `docker/s3.json`); CI starts the same image. MinIO was the first choice but its images are no longer published.
- [x] **App:**
  - My invitations (paged, pull to refresh, delete with confirm)
  - event type → birthday form (validation, Hive `drafts` autosave)
  - template picker previewed with the user's own data
  - editor: live preview, edit panel, 800 ms debounced PUT with version, save status in words, conflict reload + notice, photo picker + presigned upload
  - new dependency `image_picker`; iOS `NSPhotoLibraryUsageDescription`
- [x] **Exit check** (local stack, 2026-11-07):
  - **iOS 26 simulator:** filled the form, killed the app, and the form was restored. Draft created, design chosen, photo uploaded and rendered, edits saved.
  - **Web:** the same draft opened with photo and edits. Edits saved, refresh reopened the editor, and a second draft went from create → picker → editor → back to home.
  - **Conflict:** web saved first; the phone's stale PUT got a 409, and the phone reloaded the web copy and showed "Updated on another device".

**Tests:** API 12 unit + 33 e2e (7 new invitations/media cases incl. a real presigned upload) + 4 script tests. Flutter 40 non-golden tests (new: editor controller 5, repository 2, draft autosave 2, list delete 1) and 9 goldens. Builds green: web, Android release, iOS simulator (staging). The compose stack is healthy with the new SDK.

**Bugs found and fixed (with regression tests):**
1. `@Prop({ type: Types.ObjectId })` made every ObjectId field `Mixed`, including Sprint 1's `sessions.userId`; string ids were stored as strings. The fix is `Schema.Types.ObjectId`, with a schema unit test.
2. Freezed omits the union key for a single-variant union, so the app sent `eventData` without `type` and every create got a 400. The fix is `toApiJson()`, with a repository request-body test.
3. Cursor paging used `mongoose.trusted` on the `$or` instead of on each operator value. `sanitizeFilter` rewrote `$lt`, which failed to cast and showed up as a 404.
4. The editor read `state` inside `onDispose` (forbidden in Riverpod 3). It now keeps the unsaved copy in a field.
5. Every preview keystroke re-ran the render gate (skeleton flash). Now only spec, font scope or image-URL changes re-prepare.
6. Navigation used `go`, so the picker and editor had no way back. `push` didn't update the web URL, so refresh went home. Fixed with a home underneath, `?change=1`, a home button at the root, and `optionURLReflectsImperativeAPIs`.
7. The e2e suites shared one database without `--runInBand`. They now run serially.

**Deviations from docs (docs updated):**
- The list returns flattened summary fields (docs/02).
- Media is photo-only until Sprint 4.
- Every event uses `Asia/Kolkata` time (shortcut in `birthday_form.dart`).
- There is no Hive cache of the last list page: the list needs the network.

**Not done in Sprint 3:**
- **3 more templates** (needs design work; not authored).
- Android emulator run (the host can't run the emulator; build only).
- Media lifecycle rules for abandoned uploads (infra, docs/04 §7).
- Publish, unpublish and `render` (Sprint 4).
