import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/error/app_failure.dart';
import '../../../shared/validators.dart';
import '../../../shared/widgets/form_error_banner.dart';
import '../../../shared/widgets/password_field.dart';
import '../../../shared/widgets/primary_button.dart';
import 'auth_controller.dart';
import 'auth_layout.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  AppFailure? _failure;

  Map<String, String> get _fieldErrors => _failure is ValidationFailure
      ? (_failure! as ValidationFailure).fieldErrors
      : const {};

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading || !_form.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _failure = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(email: _email.text.trim(), password: _password.text);
      TextInput.finishAutofillContext(); // lets password managers offer to save
    } on AppFailure catch (f) {
      if (mounted) setState(() => _failure = f);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Sign in',
      children: [
        if (_failure != null && _fieldErrors.isEmpty) ...[
          FormErrorBanner(_failure!.message),
          const SizedBox(height: Space.md),
        ],
        Form(
          key: _form,
          child: AutofillGroup(
            child: Column(
              children: [
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  validator: Validators.email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: _fieldErrors['email'],
                  ),
                ),
                const SizedBox(height: Space.md),
                PasswordField(
                  controller: _password,
                  label: 'Password',
                  autofillHints: const [AutofillHints.password],
                  validator: (v) => Validators.required(v, 'password'),
                  errorText: _fieldErrors['password'],
                  onSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Space.lg),
        PrimaryButton(label: 'Sign in', loading: _loading, onPressed: _submit),
        const SizedBox(height: Space.sm),
        TextButton(
          onPressed: _loading ? null : () => context.go('/register'),
          child: const Text('New here? Create an account'),
        ),
      ],
    );
  }
}
