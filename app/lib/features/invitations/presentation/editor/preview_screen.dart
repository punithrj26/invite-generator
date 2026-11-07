import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../template_engine/render/template_preview.dart';
import '../../../media/data/photo_uploader.dart';
import '../../../templates/presentation/templates_providers.dart';
import '../../domain/invitation.dart';
import '../create/birthday_form.dart';
import 'invitation_editor_controller.dart';

/// `/invitations/:id/preview`: live preview + edit panel. Every keystroke re-renders locally; saves are debounced.
class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  final _form = GlobalKey<FormState>();
  bool _uploading = false;

  InvitationEditor get _editor =>
      ref.read(invitationEditorProvider(widget.id).notifier);

  Future<void> _leave(String location) async {
    await _editor.flush();
    if (mounted) await context.push(location);
  }

  Future<void> _pickPhoto() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000, // enough for a 1080-px canvas, and keeps uploads small
      maxHeight: 2000,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;
    setState(() => _uploading = true);
    try {
      final url = await ref.read(photoUploaderProvider).upload(file);
      _editor.edit((i) => i.copyWith(media: InvitationMedia(photoUrl: url)));
    } on AppFailure catch (f) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(f.message)));
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editor = ref.watch(invitationEditorProvider(widget.id));
    ref.listen(invitationEditorProvider(widget.id), (prev, next) {
      if ((next.value?.conflicts ?? 0) > (prev?.value?.conflicts ?? 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Updated on another device. Showing the latest version.',
            ),
          ),
        );
      }
    });

    return switch (editor) {
      AsyncData(value: final s) => PopScope(
        // Save before leaving; the dispose fallback is best effort only.
        canPop: s.status == SaveStatus.saved || s.status == SaveStatus.invalid,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          await _editor.flush();
          if (context.mounted) context.pop();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const HomeIfRoot(),
            title: Text(
              s.invitation.details.eventName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [_SaveIndicator(s, onRetry: _editor.retry)],
          ),
          body: SafeArea(child: _layout(s)),
        ),
      ),
      AsyncError(:final error) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Column(
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
                  onPressed: () =>
                      ref.invalidate(invitationEditorProvider(widget.id)),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      ),
      _ => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Semantics(
            label: 'Loading invitation',
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    };
  }

  Widget _layout(EditorState s) => LayoutBuilder(
    builder: (context, c) {
      final preview = Padding(
        padding: const EdgeInsets.all(Space.md),
        child: _Preview(s.invitation, id: widget.id),
      );
      final panel = _panel(s);
      return c.maxWidth >= 900
          ? Row(
              children: [
                Expanded(child: preview),
                const VerticalDivider(width: 1),
                SizedBox(width: 440, child: panel),
              ],
            )
          : Column(
              children: [
                SizedBox(height: c.maxHeight * 0.42, child: preview),
                const Divider(height: 1),
                Expanded(child: panel),
              ],
            );
    },
  );

  Widget _panel(EditorState s) {
    final inv = s.invitation;
    final fieldErrors = switch (s.error) {
      ValidationFailure(:final fieldErrors)
          when s.status == SaveStatus.failed =>
        fieldErrors,
      _ => const <String, String>{},
    };
    return Form(
      key: _form,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.all(Space.lg),
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _leave('/invitations/${widget.id}/template?change=1'),
                  icon: const Icon(Icons.style_outlined),
                  label: Text(
                    inv.templateId == null ? 'Choose design' : 'Change design',
                  ),
                ),
              ),
              const SizedBox(width: Space.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _uploading ? null : _pickPhoto,
                  icon: _uploading
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_photo_alternate_outlined),
                  label: Text(
                    _uploading
                        ? 'Uploading…'
                        : inv.media.photoUrl == null
                        ? 'Add photo'
                        : 'Change photo',
                  ),
                ),
              ),
            ],
          ),
          if (inv.media.photoUrl != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _editor.edit(
                  (i) => i.copyWith(media: const InvitationMedia()),
                ),
                child: const Text('Remove photo'),
              ),
            ),
          BirthdayForm(
            // A conflict replaces local edits with the server copy: rebuild the fields from it.
            key: ValueKey(s.conflicts),
            initial: (
              event: inv.eventData as BirthdayData,
              details: inv.details,
            ),
            fieldErrors: fieldErrors,
            onChanged: (v) => _editor.edit(
              (i) => i.copyWith(eventData: v.event, details: v.details),
              save: _form.currentState?.validate() ?? true,
            ),
          ),
        ],
      ),
    );
  }
}

class _Preview extends ConsumerWidget {
  const _Preview(this.invitation, {required this.id});

  final Invitation invitation;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templateId = invitation.templateId;
    if (templateId == null) {
      return Center(
        child: FilledButton.icon(
          onPressed: () => context.push('/invitations/$id/template?change=1'),
          icon: const Icon(Icons.style_outlined),
          label: const Text('Choose a design'),
        ),
      );
    }
    return switch (ref.watch(templateProvider(templateId))) {
      AsyncData(value: final t) => Center(
        child: TemplatePreview(
          spec: t.spec,
          data: bindingFor(invitation),
          fontScope: fontScopeOf(t),
        ),
      ),
      AsyncError() => Center(
        child: TextButton(
          onPressed: () => ref.invalidate(templateProvider(templateId)),
          child: const Text("Couldn't load the design. Try again"),
        ),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

/// Save state in words, always visible (WCAG: status not by color alone), with a retry when it failed.
class _SaveIndicator extends StatelessWidget {
  const _SaveIndicator(this.s, {required this.onRetry});

  final EditorState s;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme.labelLarge;
    final label = switch (s.status) {
      SaveStatus.saved => 'Saved',
      SaveStatus.pending || SaveStatus.saving => 'Saving…',
      SaveStatus.invalid => 'Fix highlighted fields',
      SaveStatus.failed => null,
    };
    return Padding(
      padding: const EdgeInsets.only(right: Space.sm),
      child: Semantics(
        liveRegion: true,
        child: label != null
            ? Center(child: Text(label, style: text))
            : TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.sync_problem),
                label: const Text('Not saved · Retry'),
              ),
      ),
    );
  }
}

/// Opened straight from a link or a web refresh there is nothing to pop: offer the way home instead.
class HomeIfRoot extends StatelessWidget {
  const HomeIfRoot({super.key});

  @override
  Widget build(BuildContext context) => context.canPop()
      ? const BackButton()
      : IconButton(
          tooltip: 'My invitations',
          icon: const Icon(Icons.home_outlined),
          onPressed: () => context.go('/'),
        );
}
