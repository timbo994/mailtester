import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/connection_status.dart';
import '../app_theme.dart';
import '../../models/smtp_config.dart';
import '../../providers/debug_log_provider.dart';
import '../../providers/smtp_provider.dart';
import '../../services/smtp_service.dart';
import '../widgets/status_chip.dart';
import '../widgets/tls_pill_selector.dart';

class SmtpTab extends ConsumerStatefulWidget {
  const SmtpTab({super.key});

  @override
  ConsumerState<SmtpTab> createState() => _SmtpTabState();
}

class _SmtpTabState extends ConsumerState<SmtpTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _hostCtrl = TextEditingController();
  final _portCtrl = TextEditingController(text: '587');
  final _timeoutCtrl = TextEditingController(text: '10');
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController(text: 'SMTP Verbindungstest');
  final _bodyCtrl = TextEditingController(
    text: 'Dies ist eine automatisch generierte Test-E-Mail.',
  );

  TlsMode _tlsMode = TlsMode.starttls;
  bool _obscurePass = true;

  @override
  void dispose() {
    for (final c in [
      _hostCtrl, _portCtrl, _timeoutCtrl, _userCtrl, _passCtrl,
      _fromCtrl, _toCtrl, _subjectCtrl, _bodyCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  SmtpConfig _buildConfig() => SmtpConfig(
        host: _hostCtrl.text.trim(),
        port: int.tryParse(_portCtrl.text) ?? 587,
        timeout: int.tryParse(_timeoutCtrl.text) ?? 10,
        tlsMode: _tlsMode,
        username: _userCtrl.text,
        password: _passCtrl.text,
        from: _fromCtrl.text.trim(),
        to: _toCtrl.text.trim(),
        subject: _subjectCtrl.text,
        body: _bodyCtrl.text,
      );

  Future<void> _run({required bool sendMail}) async {
    ref.read(smtpStatusProvider.notifier).state = ConnectionStatus.connecting;
    ref.read(debugPanelVisibleProvider.notifier).state = true;
    ref.read(debugLogProvider.notifier).clear();

    final service = SmtpService(
      onLog: ref.read(debugLogProvider.notifier).add,
    );

    try {
      if (sendMail) {
        await service.sendTestMail(_buildConfig());
      } else {
        await service.testConnection(_buildConfig());
      }
      ref.read(smtpStatusProvider.notifier).state = ConnectionStatus.connected;
    } catch (_) {
      ref.read(smtpStatusProvider.notifier).state = ConnectionStatus.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final status = ref.watch(smtpStatusProvider);
    final running = status == ConnectionStatus.connecting;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: 'Verbindung',
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _Field(label: 'SMTP-Host', ctrl: _hostCtrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Field(
                      label: 'Port',
                      ctrl: _portCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Field(
                      label: 'Timeout (s)',
                      ctrl: _timeoutCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Text(
                    'TLS-Modus',
                    style: TextStyle(fontSize: 12, color: AppTheme.subtleText),
                  ),
                  const SizedBox(width: 16),
                  TlsPillSelector(
                    selected: _tlsMode,
                    onChanged: (v) => setState(() => _tlsMode = v),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Authentifizierung',
            children: [
              Row(
                children: [
                  Expanded(child: _Field(label: 'Benutzername', ctrl: _userCtrl)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PasswordField(
                      ctrl: _passCtrl,
                      obscure: _obscurePass,
                      onToggle: () => setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Test-E-Mail',
            children: [
              Row(
                children: [
                  Expanded(child: _Field(label: 'Von', ctrl: _fromCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _Field(label: 'An', ctrl: _toCtrl)),
                ],
              ),
              const SizedBox(height: 12),
              _Field(label: 'Betreff', ctrl: _subjectCtrl),
              const SizedBox(height: 12),
              _Field(
                label: 'Nachrichtentext',
                ctrl: _bodyCtrl,
                maxLines: 4,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              StatusChip(status: status),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: running ? null : () => _run(sendMail: false),
                icon: const Icon(Icons.cable_outlined, size: 16),
                label: const Text('Verbindung testen'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                onPressed: running ? null : () => _run(sendMail: true),
                icon: const Icon(Icons.send_outlined, size: 16),
                label: const Text('Test-Mail senden'),
              ),
            ],
          ),
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
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.mutedText,
            letterSpacing: 0.8,
          ),
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
  final TextInputType? keyboardType;
  final int maxLines;

  const _Field({
    required this.label,
    required this.ctrl,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController ctrl;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.ctrl,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: 'Passwort',
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
