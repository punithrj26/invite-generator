/// Build-time config from `--dart-define-from-file=config/<flavor>.json`.
abstract final class Env {
  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// Public template assets (fonts, sample photo): the CDN in staging/prod, docker/assets.conf locally.
  static const assetBaseUrl = String.fromEnvironment(
    'ASSET_BASE_URL',
    defaultValue: 'http://localhost:8081',
  );
  static const sentryDsn = String.fromEnvironment('SENTRY_DSN');

  static bool get isProd => flavor == 'prod';
}
