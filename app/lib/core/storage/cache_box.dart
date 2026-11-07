import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

/// Offline cache of raw JSON strings (non-secret data only; tokens live in TokenStore).
/// Opened in main() before runApp, then injected with overrideWithValue.
final cacheBoxProvider = Provider<Box<String>>(
  (ref) => throw UnimplementedError('cacheBoxProvider is overridden in main()'),
);

/// Unsent "new invitation" forms (docs/01 §4.8): survive an app kill before the first POST.
final draftsBoxProvider = Provider<Box<String>>(
  (ref) =>
      throw UnimplementedError('draftsBoxProvider is overridden in main()'),
);
