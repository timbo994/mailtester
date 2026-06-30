import 'package:flutter/material.dart';

import '../../models/log_entry.dart';

class LogListView extends StatefulWidget {
  final List<LogEntry> entries;

  const LogListView({super.key, required this.entries});

  @override
  State<LogListView> createState() => _LogListViewState();
}

class _LogListViewState extends State<LogListView> {
  final _scrollCtrl = ScrollController();

  @override
  void didUpdateWidget(LogListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entries.length != oldWidget.entries.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollCtrl.hasClients) {
          _scrollCtrl.animateTo(
            _scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty) {
      return const Center(
        child: Text(
          'Noch keine Ausgabe. Starte einen Test.',
          style: TextStyle(color: Color(0xFF555570), fontSize: 13),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: widget.entries.length,
      itemBuilder: (ctx, i) {
        final e = widget.entries[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.timeString,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: Color(0xFF555570),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  e.message,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: e.color,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
