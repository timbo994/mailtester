import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../models/log_entry.dart';
import '../models/smtp_config.dart';

class SmtpService {
  final LogCallback onLog;

  SmtpService({required this.onLog});

  void _log(LogLevel level, String msg) =>
      onLog(LogEntry(timestamp: DateTime.now(), level: level, message: msg));

  SmtpServer _buildServer(SmtpConfig cfg) => SmtpServer(
        cfg.host,
        port: cfg.port,
        username: cfg.username.isEmpty ? null : cfg.username,
        password: cfg.password.isEmpty ? null : cfg.password,
        ssl: cfg.tlsMode == TlsMode.sslTls,
        allowInsecure: cfg.tlsMode == TlsMode.none,
      );

  Future<void> testConnection(SmtpConfig cfg) async {
    final sub = _attachLogger();
    try {
      _log(LogLevel.info, 'Verbinde mit ${cfg.host}:${cfg.port}…');
      await checkCredentials(
        _buildServer(cfg),
        timeout: Duration(seconds: cfg.timeout),
      );
      _log(LogLevel.success, '✓ Verbindung und Authentifizierung erfolgreich');
    } on SocketException catch (e) {
      _log(LogLevel.error, '✗ Verbindungsfehler: ${e.message}');
      rethrow;
    } catch (e) {
      _log(LogLevel.error, '✗ Fehler: $e');
      rethrow;
    } finally {
      sub.cancel();
    }
  }

  Future<void> sendTestMail(SmtpConfig cfg) async {
    final message = Message()
      ..from = Address(cfg.from)
      ..recipients.add(cfg.to)
      ..subject = cfg.subject
      ..text = cfg.body;

    final sub = _attachLogger();
    try {
      _log(LogLevel.info, 'Verbinde mit ${cfg.host}:${cfg.port}…');
      await send(message, _buildServer(cfg), timeout: Duration(seconds: cfg.timeout));
      _log(LogLevel.success, '✓ E-Mail erfolgreich versendet an ${cfg.to}');
    } on MailerException catch (e) {
      for (final p in e.problems) {
        _log(LogLevel.error, '✗ ${p.code}: ${p.msg}');
      }
      rethrow;
    } on SocketException catch (e) {
      _log(LogLevel.error, '✗ Verbindungsfehler: ${e.message}');
      rethrow;
    } catch (e) {
      _log(LogLevel.error, '✗ Fehler: $e');
      rethrow;
    } finally {
      sub.cancel();
    }
  }

  StreamSubscription<LogRecord> _attachLogger() {
    hierarchicalLoggingEnabled = true;
    final logger = Logger('Connection');
    logger.level = Level.ALL;
    return logger.onRecord.listen((rec) {
      final level = rec.level >= Level.WARNING ? LogLevel.warning : LogLevel.info;
      _log(level, rec.message);
    });
  }
}
