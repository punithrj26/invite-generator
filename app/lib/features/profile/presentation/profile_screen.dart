import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/error/app_failure.dart';
import '../../../shared/validators.dart';
import '../../../shared/widgets/form_error_banner.dart';
import '../../../shared/widgets/password_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../auth/domain/auth_state.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/profile_repository_impl.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  bool _saving = false;
  AppFailure? _failure;

  @override
  void initState() {
    super.initState();
    final auth = ref.read(authControllerProvider).value;
    final user = auth is Authenticated ? auth.user : null;
    _name = TextEditingController(text: user?.name ?? '');
    _phone = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Map<String, String> get _fieldErrors => _failure is ValidationFailure
      ? (_failure! as ValidationFailure).fieldErrors
      : const {};

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _failure = null;
    });
    try {
      final user = await ref
          .read(profileRepositoryProvider)
          .update(name: _name.text.trim(), phone: _phone.text.trim());
      ref.read(authControllerProvider.notifier).setUser(user);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile saved')));
      }
    } on AppFailure catch (f) {
      if (mounted) setState(() => _failure = f);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider).value;
    // Signed out or deleted: the router is already leaving this screen.
    if (auth is! Authenticated) return const SizedBox.shrink();
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Space.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Signed in as', style: text.labelMedium),
                  Text(auth.user.email, style: text.titleMedium),
                  const SizedBox(height: Space.lg),
                  if (_failure != null && _fieldErrors.isEmpty) ...[
                    FormErrorBanner(_failure!.message),
                    const SizedBox(height: Space.md),
                  ],
                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          autofillHints: const [AutofillHints.name],
                          validator: Validators.name,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            errorText: _fieldErrors['name'],
                          ),
                        ),
                        const SizedBox(height: Space.md),
                        TextFormField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          validator: Validators.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone (optional)',
                            helperText:
                                'International format, e.g. +919800000000',
                            errorText: _fieldErrors['phone'],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Space.lg),
                  PrimaryButton(
                    label: 'Save',
                    loading: _saving,
                    onPressed: _save,
                  ),
                  const SizedBox(height: Space.xl),
                  const Divider(),
                  const SizedBox(height: Space.md),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.lock_outline),
                    label: const Text('Change password'),
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (_) => const _ChangePasswordDialog(),
                    ),
                  ),
                  const SizedBox(height: Space.sm),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out'),
                    onPressed: () =>
                        ref.read(authControllerProvider.notifier).logout(),
                  ),
                  const SizedBox(height: Space.xl),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (_) => const _DeleteAccountDialog(),
                    ),
                    child: const Text('Delete account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordDialog extends ConsumerStatefulWidget {
  const _ChangePasswordDialog();

  @override
  ConsumerState<_ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<_ChangePasswordDialog> {
  final _form = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  bool _loading = false;
  AppFailure? _failure;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
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
          .read(profileRepositoryProvider)
          .changePassword(
            currentPassword: _current.text,
            newPassword: _next.text,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed. Other devices were signed out.'),
        ),
      );
    } on AppFailure catch (f) {
      if (mounted) setState(() => _failure = f);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = _failure is ValidationFailure
        ? (_failure! as ValidationFailure).fieldErrors
        : const <String, String>{};
    return AlertDialog(
      title: const Text('Change password'),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_failure != null && fields.isEmpty) ...[
              FormErrorBanner(_failure!.message),
              const SizedBox(height: Space.md),
            ],
            PasswordField(
              controller: _current,
              label: 'Current password',
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.next,
              validator: (v) => Validators.required(v, 'current password'),
            ),
            const SizedBox(height: Space.md),
            PasswordField(
              controller: _next,
              label: 'New password',
              helperText: 'At least 10 characters',
              autofillHints: const [AutofillHints.newPassword],
              validator: Validators.newPassword,
              errorText: fields['newPassword'],
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _loading ? null : _submit,
          child: Text(_loading ? 'Saving…' : 'Change password'),
        ),
      ],
    );
  }
}

class _DeleteAccountDialog extends ConsumerStatefulWidget {
  const _DeleteAccountDialog();

  @override
  ConsumerState<_DeleteAccountDialog> createState() =>
      _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<_DeleteAccountDialog> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  bool _loading = false;
  AppFailure? _failure;

  @override
  void dispose() {
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
          .read(profileRepositoryProvider)
          .deleteAccount(password: _password.text);
      if (!mounted) return;
      Navigator.of(context).pop();
      ref
          .read(authControllerProvider.notifier)
          .setUser(null); // router → /login
    } on AppFailure catch (f) {
      if (mounted) setState(() => _failure = f);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Delete your account?'),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'This permanently deletes your account and signs you out everywhere. '
              'It cannot be undone.',
            ),
            const SizedBox(height: Space.md),
            if (_failure != null) ...[
              FormErrorBanner(_failure!.message),
              const SizedBox(height: Space.md),
            ],
            PasswordField(
              controller: _password,
              label: 'Confirm with your password',
              autofillHints: const [AutofillHints.password],
              validator: (v) => Validators.required(v, 'password'),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: scheme.error,
            foregroundColor: scheme.onError,
          ),
          onPressed: _loading ? null : _submit,
          child: Text(_loading ? 'Deleting…' : 'Delete account'),
        ),
      ],
    );
  }
}
