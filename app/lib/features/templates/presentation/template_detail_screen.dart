import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/config/env.dart';
import '../../../core/error/app_failure.dart';
import '../../../template_engine/export/exporter.dart';
import '../../../template_engine/render/template_preview.dart';
import '../domain/invitation_template.dart';
import 'preset_picker.dart';
import 'templates_providers.dart';

class TemplateDetailScreen extends ConsumerStatefulWidget {
  const TemplateDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<TemplateDetailScreen> createState() =>
      _TemplateDetailScreenState();
}

class _TemplateDetailScreenState extends ConsumerState<TemplateDetailScreen> {
  final _boundary = GlobalKey();
  String _preset = 'full';
  bool _exporting = false;

  /// Dev check for the S2 exit criterion (toImage on every platform, incl. web with CDN images).
  Future<void> _export() async {
    setState(() => _exporting = true);
    String message;
    try {
      final png = await Exporter.png(_boundary);
      final ihdr = ByteData.sublistView(png); // PNG IHDR: width @16, height @20
      message =
          'Exported ${ihdr.getUint32(16)}×${ihdr.getUint32(20)} PNG, ${png.length ~/ 1024} KB';
    } catch (e) {
      message = 'Export failed: $e';
    }
    if (!mounted) return;
    setState(() => _exporting = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final template = ref.watch(templateProvider(widget.id));
    return Scaffold(
      appBar: AppBar(title: Text(template.value?.name ?? 'Design')),
      body: SafeArea(
        child: switch (template) {
          AsyncData(:final value) => _body(value),
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
                    onPressed: () =>
                        ref.invalidate(templateProvider(widget.id)),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          ),
          _ => Center(
            child: Semantics(
              label: 'Loading design',
              child: const CircularProgressIndicator(),
            ),
          ),
        },
      ),
    );
  }

  Widget _body(InvitationTemplate t) {
    final presets = ref.watch(previewPresetsProvider);
    return Padding(
      padding: const EdgeInsets.all(Space.md),
      child: Column(
        children: [
          if (t.description case final d?) ...[
            Text(d, textAlign: TextAlign.center),
            const SizedBox(height: Space.md),
          ],
          PresetPicker(
            presets: presets.keys,
            selected: _preset,
            onSelected: (p) => setState(() => _preset = p),
          ),
          const SizedBox(height: Space.md),
          Expanded(
            child: Center(
              child: TemplatePreview(
                spec: t.spec,
                data: presets[_preset]!,
                fontScope: fontScopeOf(t),
                boundaryKey: _boundary,
              ),
            ),
          ),
          if (!Env.isProd) ...[
            const SizedBox(height: Space.md),
            OutlinedButton.icon(
              onPressed: _exporting ? null : _export,
              icon: const Icon(Icons.image_outlined),
              label: const Text('Export PNG (dev check)'),
            ),
          ],
        ],
      ),
    );
  }
}
