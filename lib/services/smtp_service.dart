import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/log_entry.dart';
import '../models/smtp_config.dart';

typedef LogCallback = void Function(LogEntry);

class SmtpService {
  final LogCallback onLog;

  final List<int> _buf = [];
  final List<String> _lineQueue = [];
  final List<Completer<String>> _lineWaiters = [];
  StreamSubscription<List<int>>? _sub;

  SmtpService({required this.onLog});

  void _log(LogLevel level, String msg) =>
      onLog(LogEntry(timestamp: DateTime.now(), level: level, message: msg));

  void _attachSocket(Socket socket) {
    _sub?.cancel();
    _buf.clear();
    _sub = socket.listen(_onData, onError: _onError, cancelOnError: false);
  }

  void _onData(List<int> data) {
    _buf.addAll(data);
    _flush();
  }

  void _onError(Object error) {
    for (final w in _lineWaiters) {
      if (!w.isCompleted) w.completeError(error);
    }
    _lineWaiters.clear();
  }

  void _flush() {
    while (true) {
      int idx = -1;
      for (int i = 0; i < _buf.length - 1; i++) {
        if (_buf[i] == 13 && _buf[i + 1] == 10) {
          idx = i;
          break;
        }
      }
      if (idx == -1) break;
      final line = utf8.decode(_buf.sublist(0, idx), allowMalformed: true);
      _buf.removeRange(0, idx + 2);
      if (_lineWaiters.isNotEmpty) {
        final w = _lineWaiters.removeAt(0);
        if (!w.isCompleted) w.complete(line);
      } else {
        _lineQueue.add(line);
      }
    }
  }

  Future<String> _nextLine(int timeoutSec) {
    if (_lineQueue.isNotEmpty) return Future.value(_lineQueue.removeAt(0));
    final c = Completer<String>();
    _lineWaiters.add(c);
    return c.future.timeout(
      Duration(seconds: timeoutSec),
      onTimeout: () {
        _lineWaiters.remove(c);
        throw TimeoutException('Keine Antwort vom Server nach ${timeoutSec}s');
      },
    );
  }

  Future<_Resp> _readResp(int t) async {
    final lines = <String>[];
    do {
      lines.add(await _nextLine(t));
    } while (lines.last.length >= 4 && lines.last[3] == '-');
    final last = lines.last;
    final code = int.tryParse(last.length >= 3 ? last.substring(0, 3) : '') ?? 0;
    return _Resp(code, lines.join('\n'));
  }

  void _write(Socket s, String cmd) {
    _log(LogLevel.info, '→ $cmd');
    s.write('$cmd\r\n');
  }

  Future<void> testConnection(SmtpConfig cfg) => _run(cfg, sendMail: false);

  Future<void> sendTestMail(SmtpConfig cfg) => _run(cfg, sendMail: true);

  Future<void> _run(SmtpConfig cfg, {required bool sendMail}) async {
    _buf.clear();
    _lineQueue.clear();
    _lineWaiters.clear();
    Socket? socket;

    try {
      _log(LogLevel.info, 'TCP-Verbindung zu ${cfg.host}:${cfg.port}…');

      if (cfg.tlsMode == TlsMode.sslTls) {
        final s = await SecureSocket.connect(
          cfg.host,
          cfg.port,
          timeout: Duration(seconds: cfg.timeout),
        );
        socket = s;
        _attachSocket(s);
        _log(LogLevel.success, 'SSL/TLS-Verbindung aufgebaut');
      } else {
        final s = await Socket.connect(
          cfg.host,
          cfg.port,
          timeout: Duration(seconds: cfg.timeout),
        );
        socket = s;
        _attachSocket(s);
        _log(LogLevel.success, 'TCP-Verbindung aufgebaut');
      }

      final greeting = await _readResp(cfg.timeout);
      _log(LogLevel.info, '← ${greeting.text}');
      if (!greeting.ok) throw Exception('Ablehnung durch Server: ${greeting.text}');

      _write(socket, 'EHLO mail-tester.local');
      final ehlo1 = await _readResp(cfg.timeout);
      _log(LogLevel.info, '← ${ehlo1.text}');
      if (!ehlo1.ok) throw Exception('EHLO fehlgeschlagen');

      if (cfg.tlsMode == TlsMode.starttls) {
        _write(socket, 'STARTTLS');
        final stls = await _readResp(cfg.timeout);
        _log(LogLevel.info, '← ${stls.text}');
        if (!stls.ok) throw Exception('STARTTLS abgelehnt: ${stls.text}');

        final plain = socket;
        final sec = await SecureSocket.secure(plain, host: cfg.host);
        socket = sec;
        _attachSocket(sec);
        _log(LogLevel.success, '✓ TLS-Handshake erfolgreich');

        _write(socket, 'EHLO mail-tester.local');
        final ehlo2 = await _readResp(cfg.timeout);
        _log(LogLevel.info, '← ${ehlo2.text}');
        if (!ehlo2.ok) throw Exception('EHLO nach STARTTLS fehlgeschlagen');
      }

      if (cfg.username.isNotEmpty) {
        _write(socket, 'AUTH LOGIN');
        final ch1 = await _readResp(cfg.timeout);
        _log(LogLevel.info, '← ${ch1.text}');

        socket.write('${base64.encode(utf8.encode(cfg.username))}\r\n');
        _log(LogLevel.info, '→ [username base64]');

        final ch2 = await _readResp(cfg.timeout);
        _log(LogLevel.info, '← ${ch2.text}');

        socket.write('${base64.encode(utf8.encode(cfg.password))}\r\n');
        _log(LogLevel.info, '→ ****');

        final auth = await _readResp(cfg.timeout);
        _log(LogLevel.info, '← ${auth.text}');
        if (!auth.ok) throw Exception('Authentifizierung fehlgeschlagen (${auth.code}): ${auth.text}');
        _log(LogLevel.success, '✓ Authentifizierung erfolgreich');
      }

      if (sendMail) {
        _write(socket, 'MAIL FROM:<${cfg.from}>');
        final mf = await _readResp(cfg.timeout);
        _log(LogLevel.info, '← ${mf.text}');
        if (!mf.ok) throw Exception('MAIL FROM fehlgeschlagen');

        _write(socket, 'RCPT TO:<${cfg.to}>');
        final rt = await _readResp(cfg.timeout);
        _log(LogLevel.info, '← ${rt.text}');
        if (!rt.ok) throw Exception('RCPT TO fehlgeschlagen');

        _write(socket, 'DATA');
        final dataResp = await _readResp(cfg.timeout);
        _log(LogLevel.info, '← ${dataResp.text}');
        if (dataResp.code != 354) throw Exception('DATA fehlgeschlagen (${dataResp.code})');

        final dt = DateTime.now().toUtc();
        final msgLines = [
          'From: <${cfg.from}>',
          'To: <${cfg.to}>',
          'Subject: ${cfg.subject}',
          'Date: ${_rfc2822(dt)}',
          'Content-Type: text/plain; charset=UTF-8',
          'X-Mailer: SMTP & Exchange OAuth Tester',
          '',
          cfg.body,
          '.',
        ];
        socket.write('${msgLines.join('\r\n')}\r\n');
        _log(LogLevel.info, '→ [Nachrichteninhalt + Kopfzeilen]');
        _log(LogLevel.info, '→ .');

        final sent = await _readResp(cfg.timeout);
        _log(LogLevel.info, '← ${sent.text}');
        if (!sent.ok) throw Exception('Versand fehlgeschlagen');
        _log(LogLevel.success, '✓ E-Mail erfolgreich versendet an ${cfg.to}');
      } else {
        _log(LogLevel.success, '✓ Verbindungs- und Authentifizierungstest erfolgreich');
      }

      _write(socket, 'QUIT');
      try {
        await _readResp(5);
      } catch (_) {}
    } on SocketException catch (e) {
      _log(LogLevel.error, '✗ Verbindungsfehler: ${e.message}');
      rethrow;
    } on TlsException catch (e) {
      _log(LogLevel.error, '✗ TLS-Fehler: ${e.message}');
      rethrow;
    } on TimeoutException catch (e) {
      _log(LogLevel.error, '✗ Timeout: ${e.message ?? 'Zeitüberschreitung'}');
      rethrow;
    } catch (e) {
      _log(LogLevel.error, '✗ Fehler: $e');
      rethrow;
    } finally {
      _sub?.cancel();
      _sub = null;
      for (final w in _lineWaiters) {
        if (!w.isCompleted) w.completeError(Exception('Verbindung beendet'));
      }
      _lineWaiters.clear();
      socket?.destroy();
    }
  }

  static String _rfc2822(DateTime dt) {
    const wd = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const mo = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    String p(int n) => n.toString().padLeft(2, '0');
    return '${wd[dt.weekday - 1]}, ${dt.day} ${mo[dt.month - 1]} ${dt.year} '
        '${p(dt.hour)}:${p(dt.minute)}:${p(dt.second)} +0000';
  }
}

class _Resp {
  final int code;
  final String text;
  const _Resp(this.code, this.text);
  bool get ok => code >= 200 && code < 400;
}
