import 'package:flutter/material.dart';

enum LogLevel { success, info, warning, error }

class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;

  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
  });

  Color get color => switch (level) {
        LogLevel.success => const Color(0xFF4CAF50),
        LogLevel.info => const Color(0xFF9E9E9E),
        LogLevel.warning => const Color(0xFFFF9800),
        LogLevel.error => const Color(0xFFF44336),
      };

  String get prefix => switch (level) {
        LogLevel.success => '✓',
        LogLevel.info => ' ',
        LogLevel.warning => '⚠',
        LogLevel.error => '✗',
      };

  String get timeString {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    final s = timestamp.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
