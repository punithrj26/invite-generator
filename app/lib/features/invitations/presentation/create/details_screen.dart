import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/storage/cache_box.dart';
import '../../../../shared/widgets/form_error_banner.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../data/invitations_repository_impl.dart';
import '../../domain/invitation.dart';
import '../list/invitations_list_controller.dart';
import 'birthday_form.dart';

const draftKey = 'new:birthday';

/// Step 2: details, autosaved to Hive on every change until the draft is created on the server.
class DetailsScreen extends ConsumerStatefulWidget {
  const DetailsScreen({super.key});

  @override
  ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {
  final _form = GlobalKey<FormState>();
  late BirthdayValue _value = _restore();
  bool _saving = false;
  AppFailure? _failure;

  BirthdayValue _restore() {
    final raw = ref.read(draftsBoxProvider).get(draftKey);
    if (raw == null) return (event: emptyBirthday, details: emptyDetails);
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      return (
        event: BirthdayData.fromJson(j['event'] as Map<String, dynamic>),
        details: EventDetails.fromJson(j['details'] as Map<String, dynamic>),
      );
    } on Object {
      return (
        event: emptyBirthday,
        details: emptyDetails,
      ); // an old/broken draft never blocks the form
    }
  }

  void _changed(BirthdayValue v) {
    _value = v;
    ref
        .read(draftsBoxProvider)
        .put(
          draftKey,
          jsonEncode({
            'event': v.event.toJson(),
            'details': v.details.toJson(),
          }),
        );
  }

  Future<void> _submit() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _failure = null;
    });
    try {
      final created = await ref
          .read(invitationsRepositoryProvider)
          .create(eventData: _value.event, details: _value.details);
      await ref.read(draftsBoxProvider).delete(draftKey);
      ref.invalidate(invitationsListControllerProvider);
      if (!mounted) return;
      // Home underneath, so "back" from the next steps lands on My invitations, not on a finished form.
      context
        ..go('/')
        ..push('/invitations/${created.id}/template');
    } on AppFailure catch (f) {
      if (mounted) setState(() => _failure = f);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fieldErrors = switch (_failure) {
      ValidationFailure(:final fieldErrors) => fieldErrors,
      _ => const <String, String>{},
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Birthday details')),
      body: SafeArea(
        child: Form(
          key: _form,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: ListView(
                padding: const EdgeInsets.all(Space.lg),
                children: [
                  if (_failure != null) FormErrorBanner(_failure!.message),
                  BirthdayForm(
                    initial: _value,
                    onChanged: _changed,
                    fieldErrors: fieldErrors,
                  ),
                  const SizedBox(height: Space.xl),
                  PrimaryButton(
                    label: 'Next: choose a design',
                    loading: _saving,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: Space.sm),
                  Text(
                    'Your answers are kept on this device until you continue.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
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
