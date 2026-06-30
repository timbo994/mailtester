import 'package:flutter/material.dart';

enum ConnectionStatus { idle, connecting, connected, error }

extension ConnectionStatusExt on ConnectionStatus {
  String get label => switch (this) {
        ConnectionStatus.idle => 'Nicht verbunden',
        ConnectionStatus.connecting => 'Verbinde…',
        ConnectionStatus.connected => 'Verbunden',
        ConnectionStatus.error => 'Fehler',
      };

  Color get color => switch (this) {
        ConnectionStatus.idle => const Color(0xFF9E9E9E),
        ConnectionStatus.connecting => const Color(0xFFFF9800),
        ConnectionStatus.connected => const Color(0xFF4CAF50),
        ConnectionStatus.error => const Color(0xFFF44336),
      };

  IconData get icon => switch (this) {
        ConnectionStatus.idle => Icons.radio_button_unchecked,
        ConnectionStatus.connecting => Icons.sync,
        ConnectionStatus.connected => Icons.check_circle_outline,
        ConnectionStatus.error => Icons.error_outline,
      };
}
