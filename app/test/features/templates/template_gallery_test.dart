import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invite_generator/core/error/app_failure.dart';
import 'package:invite_generator/features/templates/data/template_repository_impl.dart';
import 'package:invite_generator/features/templates/domain/invitation_template.dart';
import 'package:invite_generator/features/templates/domain/template_repository.dart';
import 'package:invite_generator/features/templates/presentation/template_gallery_screen.dart';
import 'package:invite_generator/features/templates/presentation/templates_providers.dart';
import 'package:invite_generator/template_engine/render/font_registry.dart';
import 'package:invite_generator/template_engine/samples.dart';

import '../../template_engine/repo_templates.dart';

class _FakeRepo implements TemplateRepository {
  _FakeRepo(this.result);
  Object result; // List<InvitationTemplate> or an AppFailure to throw
  int calls = 0;

  @override
  Future<List<InvitationTemplate>> list({String eventType = 'birthday'}) async {
    calls++;
    if (result is AppFailure) throw result;
    return result as List<InvitationTemplate>;
  }

  @override
  Future<InvitationTemplate> get(String id) => throw UnimplementedError();
}

final _templates = [
  for (final (i, MapEntry(:key, :value)) in repoTemplates().entries.indexed)
    InvitationTemplate(
      id: 'id$i',
      key: key,
      version: 1,
      name: 'Design $key',
      minRendererVersion: 1,
      spec: value,
    ),
];

Future<void> _pump(WidgetTester tester, TemplateRepository repo) async {
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) =>
          null, // Riverpod 3 retries failures on its own; test the button alone
      overrides: [
        templateRepositoryProvider.overrideWithValue(repo),
        fontRegistryProvider.overrideWithValue(localFontRegistry()),
        previewPresetsProvider.overrideWithValue(SamplePresets.all()),
      ],
      child: const MaterialApp(home: TemplateGalleryScreen()),
    ),
  );
  // Font loading runs in the engine: give it real time, then settle.
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 200)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists every template as a labelled, rendered card', (
    tester,
  ) async {
    await _pump(tester, _FakeRepo(_templates));
    for (final t in _templates) {
      expect(find.bySemanticsLabel('${t.name} design'), findsOneWidget);
    }
    expect(find.text("Couldn't load this design"), findsNothing);
  });

  testWidgets('failure shows its message; retry reloads', (tester) async {
    final repo = _FakeRepo(const NetworkFailure());
    await _pump(tester, repo);
    expect(find.text(const NetworkFailure().message), findsOneWidget);

    repo.result = _templates;
    await tester.tap(find.text('Try again'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pumpAndSettle();
    expect(repo.calls, 2);
    expect(
      find.bySemanticsLabel('${_templates.first.name} design'),
      findsOneWidget,
    );
  });
}
