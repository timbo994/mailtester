import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/debug_log_provider.dart';
import 'app_theme.dart';
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
        backgroundColor: AppTheme.background,
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
        color: AppTheme.appBarBackground,
        border: Border(bottom: BorderSide(color: AppTheme.cardBorder)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          const Icon(Icons.email_outlined, size: 18, color: AppTheme.primary),
          const SizedBox(width: 10),
          Text(
            'SMTP & Exchange OAuth Tester',
            style: Theme.of(context).textTheme.titleSmall,
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
