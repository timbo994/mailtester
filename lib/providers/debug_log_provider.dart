import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/log_entry.dart';

class DebugLogNotifier extends StateNotifier<List<LogEntry>> {
  DebugLogNotifier() : super([]);

  void add(LogEntry entry) => state = [...state, entry];

  void clear() => state = [];
}

final debugLogProvider =
    StateNotifierProvider<DebugLogNotifier, List<LogEntry>>(
  (ref) => DebugLogNotifier(),
);

final debugPanelVisibleProvider = StateProvider<bool>((ref) => false);
