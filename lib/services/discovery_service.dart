import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/log_entry.dart';

class DiscoveryService {
  static Future<Map<String, String>> discover(
    String tenantId,
    LogCallback onLog,
  ) async {
    void log(LogLevel l, String m) =>
        onLog(LogEntry(timestamp: DateTime.now(), level: l, message: m));

    final url =
        'https://login.microsoftonline.com/$tenantId/.well-known/openid-configuration';
    log(LogLevel.info, '→ GET $url');

    final resp = await http.get(Uri.parse(url));
    log(LogLevel.info, '← HTTP ${resp.statusCode}');

    if (resp.statusCode != 200) {
      log(LogLevel.error, '✗ Discovery fehlgeschlagen: HTTP ${resp.statusCode}');
      throw Exception('Discovery fehlgeschlagen: HTTP ${resp.statusCode}');
    }

    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    final tokenEndpoint = json['token_endpoint'] as String? ?? '';
    final authEndpoint = json['authorization_endpoint'] as String? ?? '';

    log(LogLevel.success, '✓ Discovery erfolgreich');
    log(LogLevel.info, '  token_endpoint: $tokenEndpoint');
    log(LogLevel.info, '  authorization_endpoint: $authEndpoint');

    return {
      'token_endpoint': tokenEndpoint,
      'authorization_endpoint': authEndpoint,
    };
  }
}
