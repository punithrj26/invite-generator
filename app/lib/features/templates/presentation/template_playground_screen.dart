import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/config/env.dart';
import '../../../template_engine/model/template_spec.dart';
import '../../../template_engine/render/template_preview.dart';
import 'preset_picker.dart';
import 'templates_providers.dart';

/// Non-prod only (docs/03 §7): paste a template.json (or just its spec) and render it with sample data.
/// Relative asset paths resolve against ASSET_BASE_URL, so repo files paste as-is.
class TemplatePlaygroundScreen extends ConsumerStatefulWidget {
  const TemplatePlaygroundScreen({super.key});

  @override
  ConsumerState<TemplatePlaygroundScreen> createState() =>
      _TemplatePlaygroundScreenState();
}

class _TemplatePlaygroundScreenState
    extends ConsumerState<TemplatePlaygroundScreen> {
  final _json = TextEditingController();
  TemplateSpec? _spec;
  String? _error;
  String _preset = 'full';
  // shortcut: a fresh font scope per render so edited font URLs reload; old scopes stay registered (dev-only leak).
  int _renders = 0;

  @override
  void dispose() {
    _json.dispose();
    super.dispose();
  }

  void _render() {
    try {
      final map = jsonDecode(_json.text) as Map<String, dynamic>;
      final spec = TemplateSpec.fromJson(
        (map['spec'] ?? map) as Map<String, dynamic>,
      );
      final base = Uri.parse('${Env.assetBaseUrl}/');
      setState(() {
        _spec = spec.copyWith(
          fonts: [
            for (final f in spec.fonts)
              f.copyWith(url: base.resolve(f.url).toString()),
          ],
        );
        _error = null;
        _renders++;
      });
    } catch (e) {
      setState(() => _error = 'Not a valid template: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final presets = ref.watch(previewPresetsProvider);
    final editor = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: TextField(
            controller: _json,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            decoration: InputDecoration(
              labelText: 'template.json',
              alignLabelWithHint: true,
              errorText: _error,
              errorMaxLines: 4,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: Space.sm),
        FilledButton(onPressed: _render, child: const Text('Render')),
      ],
    );
    final preview = Column(
      children: [
        PresetPicker(
          presets: presets.keys,
          selected: _preset,
          onSelected: (p) => setState(() => _preset = p),
        ),
        const SizedBox(height: Space.md),
        Expanded(
          child: Center(
            child: _spec == null
                ? const Text('Paste a template and tap Render')
                : TemplatePreview(
                    spec: _spec!,
                    data: presets[_preset]!,
                    fontScope: 'playground$_renders',
                  ),
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Template playground')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Space.md),
          child: LayoutBuilder(
            builder: (_, c) => c.maxWidth >= 800
                ? Row(
                    children: [
                      Expanded(child: editor),
                      const SizedBox(width: Space.md),
                      Expanded(child: preview),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(height: 220, child: editor),
                      const SizedBox(height: Space.md),
                      Expanded(child: preview),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
