import 'package:flutter/material.dart';

import '../../models/connection_status.dart';

extension ConnectionStatusUi on ConnectionStatus {
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
