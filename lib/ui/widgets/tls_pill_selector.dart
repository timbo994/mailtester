import 'package:flutter/material.dart';

import '../../models/smtp_config.dart';

class TlsPillSelector extends StatelessWidget {
  final TlsMode selected;
  final ValueChanged<TlsMode> onChanged;

  const TlsPillSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TlsMode>(
      segments: TlsMode.values
          .map((m) => ButtonSegment<TlsMode>(value: m, label: Text(m.label)))
          .toList(),
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
      style: ButtonStyle(
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }
}
