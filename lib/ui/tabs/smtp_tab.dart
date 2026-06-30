import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../i18n/strings.g.dart';
import '../../models/connection_status.dart';
import '../../models/smtp_config.dart';
import '../../providers/debug_log_provider.dart';
import '../../providers/smtp_provider.dart';
import '../../services/smtp_service.dart';
import '../app_theme.dart';
import '../widgets/section_card.dart';
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
  late final _subjectCtrl = TextEditingController(text: t.smtp.defaultSubject);
  late final _bodyCtrl = TextEditingController(text: t.smtp.defaultBody);

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
    ref.read(smtpStatusProvider.notifier).set(ConnectionStatus.connecting);
    ref.read(debugPanelVisibleProvider.notifier).set(true);
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
      ref.read(smtpStatusProvider.notifier).set(ConnectionStatus.connected);
    } catch (_) {
      ref.read(smtpStatusProvider.notifier).set(ConnectionStatus.error);
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
          SectionCard(
            title: t.smtp.sectionConnection,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _Field(label: t.smtp.host, ctrl: _hostCtrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Field(
                      label: t.smtp.port,
                      ctrl: _portCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Field(
                      label: t.smtp.timeout,
                      ctrl: _timeoutCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    t.smtp.tlsModeLabel,
                    style: const TextStyle(fontSize: 12, color: AppTheme.subtleText),
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
          SectionCard(
            title: t.smtp.sectionAuth,
            children: [
              Row(
                children: [
                  Expanded(child: _Field(label: t.smtp.username, ctrl: _userCtrl)),
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
          SectionCard(
            title: t.smtp.sectionTestMail,
            children: [
              Row(
                children: [
                  Expanded(child: _Field(label: t.smtp.from, ctrl: _fromCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _Field(label: t.smtp.to, ctrl: _toCtrl)),
                ],
              ),
              const SizedBox(height: 12),
              _Field(label: t.smtp.subject, ctrl: _subjectCtrl),
              const SizedBox(height: 12),
              _Field(
                label: t.smtp.body,
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
                label: Text(t.smtp.btnTestConnection),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                onPressed: running ? null : () => _run(sendMail: true),
                icon: const Icon(Icons.send_outlined, size: 16),
                label: Text(t.smtp.btnSendTestMail),
              ),
            ],
          ),
        ],
      ),
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
      style: Theme.of(context).textTheme.bodyMedium,
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
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: t.smtp.password,
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
