import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import '../../template_engine/model/template_spec.dart' show kRendererVersion;
import '../storage/token_store.dart';
import 'auth_interceptor.dart';
import 'session_refresher.dart';

String get _platform => kIsWeb
    ? 'web' // the API then delivers the refresh token as an httpOnly cookie only
    : switch (defaultTargetPlatform) {
        TargetPlatform.iOS => 'ios',
        TargetPlatform.android => 'android',
        _ => 'other',
      };

BaseOptions _options() => BaseOptions(
  baseUrl: '${Env.apiBaseUrl}/v1',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 20),
  contentType: Headers.jsonContentType,
  headers: {
    'X-Client-Platform': _platform,
    // The API only lists templates this build can render (docs/02).
    'X-Client-Renderer': '$kRendererVersion',
  },
  // Web: send/receive the refresh cookie on cross-origin calls (dio_web_adapter reads this).
  extra: {if (kIsWeb) 'withCredentials': true},
);

final tokenStoreProvider = Provider<TokenStore>((ref) => DeviceTokenStore());

/// No auth interceptor: used for refresh and for retrying after a refresh.
final bareDioProvider = Provider<Dio>((ref) => Dio(_options()));

final sessionRefresherProvider = Provider<SessionRefresher>(
  (ref) => SessionRefresher(
    ref.watch(bareDioProvider),
    ref.watch(tokenStoreProvider),
  ),
);

/// Fires when the server ends the session. The auth feature listens; core never imports features.
final sessionExpiredEventsProvider = Provider<StreamController<void>>((ref) {
  final controller = StreamController<void>.broadcast();
  ref.onDispose(controller.close);
  return controller;
});

final dioProvider = Provider<Dio>((ref) {
  final events = ref.watch(sessionExpiredEventsProvider);
  return Dio(_options())
    ..interceptors.add(
      AuthInterceptor(
        tokens: ref.watch(tokenStoreProvider),
        refresh: ref.watch(sessionRefresherProvider).refresh,
        retry: ref.watch(bareDioProvider).fetch,
        onSessionExpired: () => events.add(null),
      ),
    );
});
