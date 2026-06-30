import 'package:flutter/material.dart';

import '../../models/log_entry.dart';
import '../app_theme.dart';

extension LogEntryUi on LogEntry {
  Color get color => switch (level) {
        LogLevel.success => AppTheme.statusConnected,
        LogLevel.info => AppTheme.statusIdle,
        LogLevel.warning => AppTheme.statusConnecting,
        LogLevel.error => AppTheme.statusError,
      };
}
