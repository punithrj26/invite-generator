import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/config/env.dart';
import '../features/auth/domain/auth_state.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/invitations/presentation/create/details_screen.dart';
import '../features/invitations/presentation/create/event_type_screen.dart';
import '../features/invitations/presentation/editor/preview_screen.dart';
import '../features/invitations/presentation/editor/template_picker_screen.dart';
import '../features/invitations/presentation/list/invitations_list_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/templates/presentation/template_detail_screen.dart';
import '../features/templates/presentation/template_gallery_screen.dart';
import '../features/templates/presentation/template_playground_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ValueNotifier<AsyncValue<AuthState>>(const AsyncLoading());
  ref.listen(
    authControllerProvider,
    (_, next) => auth.value = next,
    fireImmediately: true,
  );

  final router = GoRouter(
    refreshListenable: auth,
    redirect: (context, state) => authRedirect(auth.value, state.uri),
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(path: '/', builder: (_, _) => const InvitationsListScreen()),
      // docs/01 §4.4. Each screen loads by :id, so deep links and web refresh work.
      GoRoute(
        path: '/invitations/new',
        builder: (_, _) => const EventTypeScreen(),
        routes: [
          // Phase 1: birthday is the only event type (D11 adds more).
          GoRoute(path: 'birthday', builder: (_, _) => const DetailsScreen()),
        ],
      ),
      GoRoute(
        path: '/invitations/:id/template',
        builder: (_, s) => TemplatePickerScreen(
          id: s.pathParameters['id']!,
          fromEditor: s.uri.queryParameters['change'] == '1',
        ),
      ),
      GoRoute(
        path: '/invitations/:id/preview',
        builder: (_, s) => PreviewScreen(id: s.pathParameters['id']!),
      ),
      GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
      GoRoute(
        path: '/templates',
        builder: (_, _) => const TemplateGalleryScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, s) =>
                TemplateDetailScreen(id: s.pathParameters['id']!),
          ),
        ],
      ),
      if (!Env.isProd)
        GoRoute(
          path: '/dev/template-playground',
          builder: (_, _) => const TemplatePlaygroundScreen(),
        ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    auth.dispose();
  });
  return router;
});

const _guestOnly = {'/login', '/register'};

/// Where to send the user for [uri] given the session. Pure, so it is unit-tested directly.
/// Keeps the original destination in `?from=` so deep links survive sign-in (and web refreshes).
String? authRedirect(AsyncValue<AuthState> auth, Uri uri) {
  final path = uri.path;
  final from = uri.queryParameters['from'];
  switch (auth) {
    case AsyncData(value: Authenticated()):
      return path == '/splash' || _guestOnly.contains(path)
          ? (_internal(from) ?? '/')
          : null;
    case AsyncData(value: Unauthenticated()):
      if (_guestOnly.contains(path)) return null;
      final target = path == '/splash' ? _internal(from) : uri.toString();
      return Uri(
        path: '/login',
        queryParameters: target == null || target == '/'
            ? null
            : {'from': target},
      ).toString();
    default: // restoring the session, or restore failed (splash offers a retry)
      if (path == '/splash') return null;
      // On a guest page the real destination is its own ?from=; wrapping the guest URL would nest.
      final keep = _guestOnly.contains(path) ? _internal(from) : uri.toString();
      return Uri(
        path: '/splash',
        queryParameters: keep == null ? null : {'from': keep},
      ).toString();
  }
}

/// Only app-internal paths: never let `?from=` redirect somewhere else.
String? _internal(String? from) =>
    from != null && from.startsWith('/') && !from.startsWith('//')
    ? from
    : null;
