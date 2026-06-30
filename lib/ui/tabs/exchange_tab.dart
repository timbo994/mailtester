import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/connection_status.dart';
import '../../providers/debug_log_provider.dart';
import '../../providers/oauth_provider.dart';
import '../../services/oauth_service.dart';
import '../app_theme.dart';
import '../widgets/status_chip.dart';

class ExchangeTab extends ConsumerStatefulWidget {
  const ExchangeTab({super.key});

  @override
  ConsumerState<ExchangeTab> createState() => _ExchangeTabState();
}

class _ExchangeTabState extends ConsumerState<ExchangeTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _tenantCtrl = TextEditingController();
  final _clientIdCtrl = TextEditingController();
  final _secretCtrl = TextEditingController();
  final _mailboxCtrl = TextEditingController();
  bool _obscureSecret = true;

  @override
  void dispose() {
    _tenantCtrl.dispose();
    _clientIdCtrl.dispose();
    _secretCtrl.dispose();
    _mailboxCtrl.dispose();
    super.dispose();
  }

  Future<void> _runOauthFlow() async {
    ref.read(oauthStatusProvider.notifier).state = ConnectionStatus.connecting;
    ref.read(debugPanelVisibleProvider.notifier).state = true;
    ref.read(debugLogProvider.notifier).clear();
    ref.read(oauthTokenProvider.notifier).state = null;

    final cfg = ref.read(oauthConfigProvider);
    final service = OAuthService(onLog: ref.read(debugLogProvider.notifier).add);

    try {
      final token = await service.requestToken(cfg);
      ref.read(oauthTokenProvider.notifier).state = token;
      ref.read(oauthStatusProvider.notifier).state = ConnectionStatus.connected;
    } catch (_) {
      ref.read(oauthStatusProvider.notifier).state = ConnectionStatus.error;
    }
  }

  Future<void> _runEwsCheck() async {
    final token = ref.read(oauthTokenProvider);
    if (token == null) return;

    ref.read(oauthStatusProvider.notifier).state = ConnectionStatus.connecting;
    ref.read(debugPanelVisibleProvider.notifier).state = true;

    final cfg = ref.read(oauthConfigProvider);
    final service = OAuthService(onLog: ref.read(debugLogProvider.notifier).add);

    try {
      await service.testEws(token, cfg.mailbox);
      ref.read(oauthStatusProvider.notifier).state = ConnectionStatus.connected;
    } catch (_) {
      ref.read(oauthStatusProvider.notifier).state = ConnectionStatus.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cfg = ref.watch(oauthConfigProvider);
    final status = ref.watch(oauthStatusProvider);
    final token = ref.watch(oauthTokenProvider);
    final running = status == ConnectionStatus.connecting;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: 'Azure-Konfiguration',
            children: [
              _Field(
                label: 'Tenant-ID (UUID)',
                ctrl: _tenantCtrl,
                hint: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                onChanged: ref.read(oauthConfigProvider.notifier).setTenantId,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      label: 'Client-ID',
                      ctrl: _clientIdCtrl,
                      onChanged:
                          ref.read(oauthConfigProvider.notifier).setClientId,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SecretField(
                      ctrl: _secretCtrl,
                      obscure: _obscureSecret,
                      onToggle: () =>
                          setState(() => _obscureSecret = !_obscureSecret),
                      onChanged:
                          ref.read(oauthConfigProvider.notifier).setClientSecret,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Auto-Discovery',
            children: [
              _AutoField(
                label: 'Token-Endpoint',
                value: cfg.tokenEndpoint,
                loading: !cfg.discoveryDone && cfg.tenantId.isNotEmpty,
              ),
              const SizedBox(height: 12),
              _AutoField(
                label: 'Authorization-Endpoint',
                value: cfg.authorizationEndpoint,
                loading: !cfg.discoveryDone && cfg.tenantId.isNotEmpty,
              ),
              const SizedBox(height: 12),
              _AutoField(
                label: 'Scope',
                value: cfg.scope,
                loading: false,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Postfach',
            children: [
              _Field(
                label: 'Exchange-Mailbox (E-Mail)',
                ctrl: _mailboxCtrl,
                onChanged: ref.read(oauthConfigProvider.notifier).setMailbox,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              StatusChip(status: status),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: running ? null : _runOauthFlow,
                icon: const Icon(Icons.key_outlined, size: 16),
                label: const Text('OAuth-Flow testen'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                onPressed: (running || token == null) ? null : _runEwsCheck,
                icon: const Icon(Icons.inbox_outlined, size: 16),
                label: const Text('EWS-Verbindung prüfen'),
              ),
            ],
          ),
          if (token == null && status != ConnectionStatus.idle) ...[
            const SizedBox(height: 8),
            const Text(
              'EWS-Test erst nach erfolgreichem OAuth-Flow verfügbar.',
              style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
            ),
          ],
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final String? hint;
  final ValueChanged<String>? onChanged;

  const _Field({
    required this.label,
    required this.ctrl,
    this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      style: Theme.of(context).textTheme.bodyMedium,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: AppTheme.hintText),
        isDense: true,
      ),
    );
  }
}

class _SecretField extends StatelessWidget {
  final TextEditingController ctrl;
  final bool obscure;
  final VoidCallback onToggle;
  final ValueChanged<String>? onChanged;

  const _SecretField({
    required this.ctrl,
    required this.obscure,
    required this.onToggle,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: Theme.of(context).textTheme.bodyMedium,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Client-Secret',
        isDense: true,
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: 18,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}

class _AutoField extends StatelessWidget {
  final String label;
  final String value;
  final bool loading;

  const _AutoField({
    required this.label,
    required this.value,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
          decoration: InputDecoration(
            labelText: label,
            isDense: true,
            contentPadding: const EdgeInsets.fromLTRB(14, 12, 70, 12),
            hintText: loading ? 'Discovery läuft…' : 'Wird nach Tenant-ID befüllt',
            hintStyle: const TextStyle(fontSize: 12, color: AppTheme.deepHint),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: loading
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppTheme.primary,
                  ),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(40),
                    border: Border.all(color: AppTheme.primary.withAlpha(100)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'AUTO',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.autoBadgeText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
