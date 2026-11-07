---
name: invite-platform
description: Read the invitation-platform design docs and sprint tracker, pick up the next sprint item, implement it, verify it, and record progress. Use for any work on this repo (app/ Flutter, api/ NestJS, templates/, infra) — "start/continue sprint N", "do the next task", "what's left", "implement <feature from the docs>".
---

# Invitation platform: delivery flow

The design is in `docs/`. This skill is the **process** for executing it. Never re-derive decisions the docs already make. If a doc is wrong or a decision must change, update the doc in the same change and say so.

| Need | Read |
|------|------|
| Decisions D1–D12, Flutter/Nest structure, auth, errors | `docs/01-architecture.md` |
| Mongo schemas + indexes, API contracts, sequences | `docs/02-data-and-api.md` |
| Template JSON, binding, renderer, export | `docs/03-template-engine.md` |
| Sprint scope + exit criteria, infra, security, cost | `docs/04-delivery-and-operations.md` §2 |
| **What is done / next / blocked** | `docs/progress.md` |

## The flow

1. **Orient.** Read `docs/progress.md`. Take the first unchecked item of the current sprint, unless the user named a task. If it's marked *blocked*, tell the user what unblocks it and move to the next item.
2. **Load only the relevant design.** Use the sprint row in `04 §2` and the doc sections it touches. Read the existing code it extends before writing anything.
3. **Scope.** List every place the change must reach: callers, tests, fixtures, config, CI, docs. Anything not in the sprint row or the docs is out of scope. Name it as skipped rather than building it.
4. **Implement** following the house rules below.
5. **Verify** with the commands below for every area touched. A task is not done until they pass. Report failures with output, don't paper over them.
6. **Record.** Tick the item in `docs/progress.md`, with a one-line note if something deviated. Add new gotchas to the Gotchas section below.
7. **Report.** Tell the user what changed, how it was verified, and what was skipped or remains risky. Don't commit or push unless asked.

## House rules

- **Smallest complete change.** Reuse what exists, then the platform or stdlib, then installed deps. A new dependency needs a reason in the report.
- **Flutter** (`app/`)
  - Feature-first layout: `features/<f>/{data,domain,presentation}`. Riverpod without codegen. GoRouter in `app/lib/app/router.dart`. Freezed models.
  - Repositories throw `AppFailure`, never `Either` (D8). No use-case layer unless it spans repositories (D9).
  - Theme only via `Theme.of(context)` + `Space`/`Radii` from `app/lib/app/theme/tokens.dart`; never hard-coded colors or sizes. 48 dp tap targets, `Semantics` on custom tappables, and the contrast test in `test/widget_test.dart` must stay green.
  - Config only via `core/config/env.dart` (`--dart-define-from-file=config/<flavor>.json`). No secrets in `config/*.json`.
- **NestJS** (`api/`)
  - Stay on the **Nest 11 line**. Pin `@nestjs/*` majors to what `@nestjs/core` is on (see Gotchas).
  - One module per domain under `src/modules/`. Modules export services, never models. New env vars go in `src/config/env.ts` (validated) and `.env.example`.
  - Shared HTTP setup lives in `src/app.setup.ts`, so `main.ts` and e2e tests stay identical. Ownership goes in the query, with 404 for other users' resources. Validate at the DTO boundary.
- **Templates** (`templates/`): any new binding path or formatter must be added to `docs/03 §3`, `api/scripts/validate-templates.mjs`, and (from Sprint 2) the Flutter binder, in the same change.
- **Tests:** new non-trivial logic gets a small test. Bug fixes get a regression test.

## Verify

```bash
# API (from api/) — e2e needs the compose MongoDB: `docker compose up -d mongo` (host port 27018). Node 22 (.nvmrc).
npx eslint "{src,test}/**/*.ts" && npm run build && npm test && npm run test:e2e
npm run test:scripts && npm run templates:validate      # template schema + semantic rules
npm audit --omit=dev --audit-level=high

# App (from app/)
dart format --output=none --set-exit-if-changed lib test && flutter analyze && flutter test
# Build every platform touched: a passing web build says nothing about Android/iOS (plugins raise native minimums).
flutter build web --release --dart-define-from-file=config/staging.json
flutter build apk --release --dart-define-from-file=config/staging.json
flutter build ios --simulator --debug --dart-define-from-file=config/staging.json

# Stack (from repo root)
docker compose up --build -d && curl -sf localhost:3000/health && docker compose down
```

CI mirrors these: `.github/workflows/api.yml` and `.github/workflows/app.yml`.

## Gotchas (append as you learn)

- `npm i @nestjs/<pkg>` installs the latest major (Nest 12, which is **ESM-only**) and breaks Jest on Node < 24.9. Install with an explicit Nest 11 range, e.g. `@nestjs/config@^4`, `@nestjs/mongoose@^11`.
- `class-transformer` used outside Nest's bootstrap (e.g. `validateEnv` in unit tests) needs `import 'reflect-metadata'`. Numeric env vars need an explicit `@Type(() => Number)`, because inferred-type metadata isn't emitted by ts-jest.
- E2E env defaults belong in `test/e2e-env.ts` (Jest `setupFiles`), not in the spec. Imports are hoisted, and `ConfigModule` validates at import time.
- `api/package.json` has `overrides.multer = 2.5.0` for GHSA-q7qp-rjg7-q26m, because `@nestjs/platform-express@11.2.8` pins vulnerable 2.4.0. Remove it once Nest ships a release with multer ≥ 2.5.0.
- Compose publishes MongoDB on host port **27018**, not 27017, so a developer's native `mongod` can never shadow it. Tests must never run against a personal database. Inside the compose network the URI stays `mongodb://mongo:27017`.
- `node --test <dir>` fails on Node ≥ 21 ("Cannot find module"). Pass a glob: `node --test scripts/*.test.mjs`.
- Adding a Flutter plugin can raise native minimums (D13: Android API 26, iOS 15). Build Android and iOS, not just web, before marking done.
- `orange-500` (#F97316) fails 4.5:1 with white text. Light mode uses orange-700 for the CTA/tertiary color.
- Mongoose `sanitizeFilter` is on globally, so it also rewrites **our own** operators (`{ $gt: now }` silently becomes `$eq`). Wrap server-built operator filters in `mongoose.trusted({...})`.
- Error messages reach clients only when they're ours (`AllExceptionsFilter`). For a custom 400, throw `new BadRequestException({ code: ErrorCode.ValidationFailed, message })`; plain `BadRequestException('text')` looks exactly like Nest's wrapped JSON-parse error and gets the default text. 404 messages are never passed through.
- The ecc config-protection hook blocks edits to `eslint.config.mjs`. Fix the source instead (e.g. typed accessors for supertest `res.body`).
- Flutter models are Freezed/json_serializable. After editing one, run `dart run build_runner build --delete-conflicting-outputs` and commit the generated `*.freezed.dart` / `*.g.dart` (CI doesn't regenerate).
- E2E: `TRUST_PROXY_HOPS=1` in `test/e2e-env.ts`, and each request sets its own `X-Forwarded-For`, so per-IP rate limits only bite in the test that targets them.
- Manual app checks: web build served on **:8080** (CORS origin). Android emulator needs `adb -s emulator-5554 reverse tcp:3000 tcp:3000`. If the emulator lacks space for the ~170 MB debug APK, use `flutter build apk --profile --target-platform android-x64` (~30 MB; profile allows local http too). Drive the emulator UI via `uiautomator dump` labels, type in 3-char chunks (the IME drops fast input), and escape spaces as `%s`. A physical phone may also be attached: always pass `-s emulator-5554`.
- Shell scripts: this machine's shell is zsh. Run multi-step helpers with `bash -c`, and never read `$?` after a pipe (`cmd | tail; echo $?` reports `tail`). Confirm builds by artifact timestamp or `✓ Built`.
- `intl` only ships `en_US` without initialisation. `DateFormat(…, 'en')` throws `LocaleDataException`. CLDR time output contains U+202F, which template fonts lack (the binder normalises it).
- Golden tests are tagged `golden` and rasterise per OS. Run `flutter test --exclude-tags golden` for the normal suite and `flutter test --tags golden` on macOS. After an intended visual change, use `--update-goldens`, then **look at the PNGs**: the goldens caught a theme underline leak and truncated names.
- Template versions are immutable. The seed refuses changed content under an existing version. In **local dev only**, when you edit a template that was never released, clear it with `docker compose exec -T mongo mongosh --quiet invite --eval 'db.templates.deleteMany({})'` and re-seed. Anywhere else, bump `version`.
- Template assets are served by the compose `assets` service on **:8081** (`ASSET_BASE_URL`). Android emulator needs `adb -s emulator-5554 reverse tcp:8081 tcp:8081` too. Web export (`toImage`) needs every image served with CORS.
- Riverpod 3 retries failed providers automatically. Widget tests that check error/retry UI need `ProviderScope(retry: (_, _) => null, …)`.
- Mongoose ObjectId props must be `@Prop({ type: MongooseSchema.Types.ObjectId })`. `Types.ObjectId` (the value class) silently becomes `Mixed`, so strings get stored as strings. `src/database/schemas.spec.ts` guards the known paths.
- `mongoose.trusted()` applies **per field value**: write `{ updatedAt: mongoose.trusted({ $lt: d }) }`, not `mongoose.trusted({ $or: [...] })`. A rewritten `$lt` fails to cast, and the filter maps `CastError` to 404.
- Freezed leaves the union key out while a union has one variant. `EventData` goes to the API through `toApiJson()`; keep it until a second event type exists.
- Riverpod 3: no `state` reads in `ref.onDispose`. Keep what dispose needs in fields.
- Local media is the compose `s3` service (SeaweedFS on :9000, `docker/s3.json`). MinIO images are no longer published. Run the API on the host (`set -a; source .env.example; set +a; node dist/main.js`) when testing uploads from the app: presigned URLs carry the API's `S3_ENDPOINT`. Android also needs `adb reverse tcp:9000 tcp:9000`. Restart `s3` after editing `docker/s3.json`.
- The Pixel_9 emulator saturates this x86 Mac; prefer the iOS simulator for phone checks and say so. In the simulator, `select_all` doesn't select inside Flutter fields (delete instead), and the first `return` after typing can race the next text input (tap fields instead).
- In zsh, `E="adb -s emulator-5554"; $E …` fails (no word splitting). Use `bash -c` or a function.
