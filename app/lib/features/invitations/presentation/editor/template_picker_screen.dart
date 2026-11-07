import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/error/app_failure.dart';
import '../../../templates/presentation/template_gallery_screen.dart';
import '../../../templates/presentation/templates_providers.dart';
import 'invitation_editor_controller.dart';
import 'preview_screen.dart' show HomeIfRoot;

/// `/invitations/:id/template`: every design, previewed with this invitation's own details.
class TemplatePickerScreen extends ConsumerWidget {
  const TemplatePickerScreen({
    super.key,
    required this.id,
    this.fromEditor = false,
  });

  final String id;

  /// Opened with `?change=1` from the editor.
  final bool fromEditor;

  Future<void> _choose(
    BuildContext context,
    WidgetRef ref,
    String templateId,
  ) async {
    final editor = ref.read(invitationEditorProvider(id).notifier);
    editor.edit((i) => i.copyWith(templateId: templateId));
    await editor.flush();
    if (!context.mounted) return;
    final s = ref.read(invitationEditorProvider(id)).value;
    if (s?.status == SaveStatus.failed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s?.error?.message ?? const ServerFailure().message),
        ),
      );
      return;
    }
    // From the editor ("Change design") → back to it. Right after creating → replace the picker with the editor.
    fromEditor
        ? context.pop()
        : context.pushReplacement('/invitations/$id/preview');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editor = ref.watch(invitationEditorProvider(id));
    final templates = ref.watch(templatesProvider);
    Widget failed(Object e, VoidCallback retry) => Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              e is AppFailure ? e.message : const ServerFailure().message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.md),
            FilledButton(onPressed: retry, child: const Text('Try again')),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: const HomeIfRoot(),
        title: const Text('Choose a design'),
      ),
      body: SafeArea(
        child: switch ((editor, templates)) {
          (AsyncError(:final error), _) => failed(
            error,
            () => ref.invalidate(invitationEditorProvider(id)),
          ),
          (_, AsyncError(:final error)) => failed(
            error,
            () => ref.invalidate(templatesProvider),
          ),
          (AsyncData(value: final s), AsyncData(value: final list)) =>
            GridView.builder(
              padding: const EdgeInsets.all(Space.md),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                mainAxisSpacing: Space.md,
                crossAxisSpacing: Space.md,
                childAspectRatio: 0.5,
              ),
              itemCount: list.length,
              itemBuilder: (_, i) => TemplateCard(
                template: list[i],
                data: bindingFor(s.invitation),
                selected: list[i].id == s.invitation.templateId,
                onTap: () => _choose(context, ref, list[i].id),
              ),
            ),
          _ => Center(
            child: Semantics(
              label: 'Loading designs',
              child: const CircularProgressIndicator(),
            ),
          ),
        },
      ),
    );
  }
}
