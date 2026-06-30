import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/debug_log_provider.dart';
import '../providers/oauth_provider.dart';
import '../providers/smtp_provider.dart';
import 'app_theme.dart';
import 'widgets/log_list_view.dart';
import 'widgets/status_chip.dart';

class DebugPanel extends ConsumerWidget {
  const DebugPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(debugLogProvider);
    final smtpStatus = ref.watch(smtpStatusProvider);
    final oauthStatus = ref.watch(oauthStatusProvider);

    final isSmtpActive = smtpStatus.index > 0;
    final activeStatus = isSmtpActive ? smtpStatus : oauthStatus;

    final logText = entries
        .map((e) => '${e.timeString}  ${e.message}')
        .join('\n');

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.panelBackground,
        border: Border(left: BorderSide(color: AppTheme.cardBorder)),
      ),
      child: Column(
        children: [
          _PanelHeader(
            status: activeStatus,
            hasEntries: entries.isNotEmpty,
            logText: logText,
            onClear: () => ref.read(debugLogProvider.notifier).clear(),
            onClose: () =>
                ref.read(debugPanelVisibleProvider.notifier).state = false,
          ),
          const Divider(height: 1, color: AppTheme.cardBorder),
          Expanded(child: LogListView(entries: entries)),
        ],
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  final dynamic status;
  final bool hasEntries;
  final String logText;
  final VoidCallback onClear;
  final VoidCallback onClose;

  const _PanelHeader({
    required this.status,
    required this.hasEntries,
    required this.logText,
    required this.onClear,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Debug-Ausgabe',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppTheme.panelHeaderText,
            ),
          ),
          const SizedBox(width: 10),
          StatusChip(status: status),
          const Spacer(),
          if (hasEntries) ...[
            _HeaderButton(
              icon: Icons.copy_outlined,
              tooltip: 'Log kopieren',
              onTap: () => Clipboard.setData(ClipboardData(text: logText)),
            ),
            const SizedBox(width: 4),
            _HeaderButton(
              icon: Icons.delete_outline,
              tooltip: 'Log leeren',
              onTap: onClear,
            ),
            const SizedBox(width: 4),
          ],
          _HeaderButton(
            icon: Icons.close,
            tooltip: 'Panel schließen',
            onTap: onClose,
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _HeaderButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(icon, size: 16, color: AppTheme.mutedText),
        ),
      ),
    );
  }
}
