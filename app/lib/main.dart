import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app/app.dart';
import 'core/config/env.dart';
import 'core/storage/cache_box.dart';

Future<void> main() async {
  // Pushed screens update the browser URL too, so web refresh and shared links reopen them (docs/01 §4.4).
  GoRouter.optionURLReflectsImperativeAPIs = true;
  await Hive.initFlutter();
  final cache = await Hive.openBox<String>('cache');
  final drafts = await Hive.openBox<String>('drafts');
  void run() => runApp(
    ProviderScope(
      overrides: [
        cacheBoxProvider.overrideWithValue(cache),
        draftsBoxProvider.overrideWithValue(drafts),
      ],
      child: const App(),
    ),
  );

  // No DSN in local dev builds: run without crash reporting.
  if (Env.sentryDsn.isEmpty) return run();

  await SentryFlutter.init((options) {
    options.dsn = Env.sentryDsn;
    options.environment = Env.flavor;
    options.tracesSampleRate = Env.isProd ? 0.1 : 1.0;
    options.sendDefaultPii = false;
  }, appRunner: run);
}
