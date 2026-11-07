import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/error/app_failure.dart';
import 'auth_controller.dart';

/// Shown while the session is restored on start. If the server is unreachable, offers a retry
/// instead of signing the user out (their session may still be valid).
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: switch (auth) {
            AsyncError(:final error) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  error is AppFailure
                      ? error.message
                      : const ServerFailure().message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Space.md),
                FilledButton(
                  onPressed: () => ref.invalidate(authControllerProvider),
                  child: const Text('Try again'),
                ),
              ],
            ),
            _ => Semantics(
              label: 'Loading',
              child: const CircularProgressIndicator(),
            ),
          },
        ),
      ),
    );
  }
}
