import 'package:flutter/material.dart';

import '../../../app/app.dart';
import '../../../app/theme/tokens.dart';

/// Centered, scrollable, width-capped column for auth forms (phones and wide web windows alike).
class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Space.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    appName,
                    style: text.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Space.sm),
                  Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: text.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: Space.xl),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
