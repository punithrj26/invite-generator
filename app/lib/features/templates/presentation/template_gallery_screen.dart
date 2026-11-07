import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/error/app_failure.dart';
import '../../../template_engine/binding/binding_context.dart';
import '../../../template_engine/render/template_preview.dart';
import '../domain/invitation_template.dart';
import 'templates_providers.dart';

class TemplateGalleryScreen extends ConsumerWidget {
  const TemplateGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(templatesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a design')),
      body: SafeArea(
        child: switch (templates) {
          AsyncData(:final value) when value.isEmpty => const Center(
            child: Text('No designs yet. Check back soon.'),
          ),
          AsyncData(:final value) => RefreshIndicator(
            onRefresh: () => ref.refresh(templatesProvider.future),
            child: GridView.builder(
              padding: const EdgeInsets.all(Space.md),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                mainAxisSpacing: Space.md,
                crossAxisSpacing: Space.md,
                childAspectRatio: 0.5, // 9:16 preview + name row
              ),
              itemCount: value.length,
              itemBuilder: (_, i) => TemplateCard(
                template: value[i],
                data: ref.watch(previewPresetsProvider)['full']!,
                onTap: () => context.push('/templates/${value[i].id}'),
              ),
            ),
          ),
          AsyncError(:final error) => Center(
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
                    onPressed: () => ref.invalidate(templatesProvider),
                    child: const Text('Try again'),
                  ),
                ],
              ),
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

/// A design rendered with [data], named underneath. Used by the gallery (sample data) and the picker (the
/// user's own invitation).
class TemplateCard extends StatelessWidget {
  const TemplateCard({
    super.key,
    required this.template,
    required this.data,
    required this.onTap,
    this.selected = false,
  });

  final InvitationTemplate template;
  final BindingContext data;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: '${template.name} design',
      excludeSemantics: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: selected
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Radii.md),
                side: BorderSide(color: scheme.primary, width: 3),
              )
            : null,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: TemplatePreview(
                    spec: template.spec,
                    data: data,
                    fontScope: fontScopeOf(template),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Space.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        template.name,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (selected)
                      Icon(Icons.check_circle, color: scheme.primary, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
