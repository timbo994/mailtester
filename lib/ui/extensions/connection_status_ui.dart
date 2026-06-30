import 'package:flutter/material.dart';

import '../../i18n/strings.g.dart';
import '../../models/connection_status.dart';
import '../app_theme.dart';

extension ConnectionStatusUi on ConnectionStatus {
  String get label => switch (this) {
        ConnectionStatus.idle => t.connectionStatus.idle,
        ConnectionStatus.connecting => t.connectionStatus.connecting,
        ConnectionStatus.connected => t.connectionStatus.connected,
        ConnectionStatus.error => t.connectionStatus.error,
      };

  Color get color => switch (this) {
        ConnectionStatus.idle => AppTheme.statusIdle,
        ConnectionStatus.connecting => AppTheme.statusConnecting,
        ConnectionStatus.connected => AppTheme.statusConnected,
        ConnectionStatus.error => AppTheme.statusError,
      };

  IconData get icon => switch (this) {
        ConnectionStatus.idle => Icons.radio_button_unchecked,
        ConnectionStatus.connecting => Icons.sync,
        ConnectionStatus.connected => Icons.check_circle_outline,
        ConnectionStatus.error => Icons.error_outline,
      };
}
