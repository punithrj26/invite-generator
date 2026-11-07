import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:invite_generator/template_engine/model/template_spec.dart';
import 'package:invite_generator/template_engine/render/font_registry.dart';

/// The repository's templates (`../templates/<key>/template.json`), as tests see them. `flutter test` runs in app/.
final templatesDir = Directory('../templates');

/// key → spec, in folder order.
Map<String, TemplateSpec> repoTemplates() => {
  for (final dir
      in templatesDir.listSync().whereType<Directory>().toList()
        ..sort((a, b) => a.path.compareTo(b.path)))
    if (File('${dir.path}/template.json').existsSync())
      dir.uri.pathSegments
          .where((s) => s.isNotEmpty)
          .last: TemplateSpec.fromJson(
        (jsonDecode(File('${dir.path}/template.json').readAsStringSync())
                as Map<String, dynamic>)['spec']
            as Map<String, dynamic>,
      ),
};

/// Reads fonts straight from templates/ (repo templates use paths relative to it): no network in tests.
FontRegistry localFontRegistry() => FontRegistry(
  (url) async =>
      ByteData.sublistView(File('${templatesDir.path}/$url').readAsBytesSync()),
);
