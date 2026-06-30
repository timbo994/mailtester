import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/log_entry.dart';

class DebugLogNotifier extends Notifier<List<LogEntry>> {
  @override
  List<LogEntry> build() => [];

  void add(LogEntry entry) => state = [...state, entry];
  void clear() => state = [];
}

final debugLogProvider = NotifierProvider<DebugLogNotifier, List<LogEntry>>(
  DebugLogNotifier.new,
);

class DebugPanelVisibleNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final debugPanelVisibleProvider =
    NotifierProvider<DebugPanelVisibleNotifier, bool>(
  DebugPanelVisibleNotifier.new,
);
