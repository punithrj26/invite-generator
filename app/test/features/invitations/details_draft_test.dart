import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:invite_generator/core/storage/cache_box.dart';
import 'package:invite_generator/features/invitations/presentation/create/details_screen.dart';

void main() {
  late Directory dir;
  late Box<String> drafts;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('drafts');
    Hive.init(dir.path);
    drafts = await Hive.openBox<String>('drafts');
  });
  tearDown(() async {
    await Hive.close();
    await dir.delete(recursive: true);
  });

  Future<void> pump(WidgetTester t) => t.pumpWidget(
    ProviderScope(
      overrides: [draftsBoxProvider.overrideWithValue(drafts)],
      child: const MaterialApp(home: DetailsScreen()),
    ),
  );

  testWidgets(
    'every change is autosaved and restored after the screen is rebuilt (app kill)',
    (t) async {
      await t.runAsync(() async {
        await pump(t);
        await t.enterText(find.widgetWithText(TextFormField, 'Name'), 'Aarav');
        await t.enterText(
          find.widgetWithText(TextFormField, 'Venue'),
          'Funky Monkeys',
        );
        await t.pump();
        final saved = jsonDecode(drafts.get(draftKey)!) as Map<String, dynamic>;
        expect(saved['event'], containsPair('personName', 'Aarav'));
        expect(
          (saved['details'] as Map)['venue'],
          containsPair('name', 'Funky Monkeys'),
        );

        await t.pumpWidget(const SizedBox()); // screen gone
        await pump(t);
        expect(find.text('Aarav'), findsOneWidget);
        expect(find.text('Funky Monkeys'), findsOneWidget);
      });
    },
  );

  testWidgets('submitting with missing required fields shows errors', (
    t,
  ) async {
    t.view
      ..physicalSize =
          const Size(800, 4000) // whole form on screen, no scrolling
      ..devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await pump(t);
    await t.tap(find.text('Next: choose a design'));
    await t.pumpAndSettle();
    expect(find.text('Enter their name'), findsOneWidget);
    expect(find.text('Choose the date'), findsOneWidget);
    expect(find.text('Choose the start time'), findsOneWidget);
    expect(find.text('Enter the venue'), findsOneWidget);
  });
}
