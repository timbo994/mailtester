import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/debug_log_provider.dart';
import 'debug_panel.dart';
import 'tabs/exchange_tab.dart';
import 'tabs/smtp_tab.dart';

class MainWindow extends ConsumerWidget {
  const MainWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelVisible = ref.watch(debugPanelVisibleProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1B27),
        body: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  _AppBar(),
                  Expanded(
                    child: TabBarView(
                      children: const [SmtpTab(), ExchangeTab()],
                    ),
                  ),
                ],
              ),
            ),
            if (panelVisible) ...[
              const SizedBox(width: 480, child: DebugPanel()),
            ],
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1F30),
        border: Border(bottom: BorderSide(color: Color(0xFF2D2E45))),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          const Icon(Icons.email_outlined, size: 18, color: Color(0xFF7C6CFF)),
          const SizedBox(width: 10),
          const Text(
            'SMTP & Exchange OAuth Tester',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE0E0F0),
            ),
          ),
          const SizedBox(width: 32),
          const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'SMTP'),
              Tab(text: 'Exchange OAuth'),
            ],
          ),
        ],
      ),
    );
  }
}
