import 'package:flutter/material.dart';

import '../../../app/theme/tokens.dart';

const _labels = {
  'full': 'Sample',
  'long-name': 'Long name',
  'minimal': 'Minimal',
};

/// Switches the sample data a preview renders with (SamplePresets keys).
class PresetPicker extends StatelessWidget {
  const PresetPicker({
    super.key,
    required this.presets,
    required this.selected,
    required this.onSelected,
  });

  final Iterable<String> presets;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Space.sm,
      runSpacing: Space.sm,
      alignment: WrapAlignment.center,
      children: [
        for (final p in presets)
          ChoiceChip(
            label: Text(_labels[p] ?? p),
            selected: p == selected,
            onSelected: (_) => onSelected(p),
          ),
      ],
    );
  }
}
