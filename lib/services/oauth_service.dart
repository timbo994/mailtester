import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/log_entry.dart';
import '../models/oauth_config.dart';

class OAuthService {
  final LogCallback onLog;

  OAuthService({required this.onLog});

  void _log(LogLevel level, String msg) =>
      onLog(LogEntry(timestamp: DateTime.now(), level: level, message: msg));

  Future<String> requestToken(OAuthConfig cfg) async {
    _log(LogLevel.info, '→ POST ${cfg.tokenEndpoint}');
    _log(LogLevel.info, '  grant_type=client_credentials');
    _log(LogLevel.info, '  client_id=${cfg.clientId}');
    _log(LogLevel.info, '  client_secret=****');
    _log(LogLevel.info, '  scope=${cfg.scope}');

    final resp = await http.post(
      Uri.parse(cfg.tokenEndpoint),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': cfg.clientId,
        'client_secret': cfg.clientSecret,
        'scope': cfg.scope,
      },
    );

    _log(LogLevel.info, '← HTTP ${resp.statusCode}');

    if (resp.statusCode != 200) {
      _log(LogLevel.error, '✗ Token-Anfrage fehlgeschlagen: HTTP ${resp.statusCode}');
      _log(LogLevel.error, resp.body.length > 500 ? '${resp.body.substring(0, 500)}…' : resp.body);
      throw Exception('Token-Anfrage fehlgeschlagen: HTTP ${resp.statusCode}');
    }

    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    final token = json['access_token'] as String? ?? '';
    final tokenType = json['token_type'] as String? ?? 'Bearer';
    final expiresIn = json['expires_in'] as int? ?? 0;
    final scope = json['scope'] as String? ?? '';

    _log(LogLevel.success, '✓ Token erhalten');
    _log(LogLevel.info, '  token_type: $tokenType');
    _log(LogLevel.info, '  expires_in: ${expiresIn}s (${(expiresIn / 60).toStringAsFixed(0)} min)');
    if (scope.isNotEmpty) _log(LogLevel.info, '  scope: $scope');
    _log(LogLevel.info, '  access_token: ${token.length > 20 ? '${token.substring(0, 20)}…' : token}');

    if (token.isEmpty) throw Exception('Leeres access_token in der Antwort');
    return token;
  }

  Future<void> testEws(String token, String mailbox) async {
    const ewsUrl = 'https://outlook.office365.com/EWS/Exchange.asmx';
    _log(LogLevel.info, '→ EWS GetFolder POST $ewsUrl');
    _log(LogLevel.info, '  Postfach: $mailbox');

    final soapEnvelope = '''<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:t="http://schemas.microsoft.com/exchange/services/2006/types"
               xmlns:m="http://schemas.microsoft.com/exchange/services/2006/messages">
  <soap:Header>
    <t:RequestServerVersion Version="Exchange2013_SP1"/>
  </soap:Header>
  <soap:Body>
    <m:GetFolder>
      <m:FolderShape>
        <t:BaseShape>Default</t:BaseShape>
      </m:FolderShape>
      <m:FolderIds>
        <t:DistinguishedFolderId Id="inbox">
          <t:Mailbox>
            <t:EmailAddress>$mailbox</t:EmailAddress>
          </t:Mailbox>
        </t:DistinguishedFolderId>
      </m:FolderIds>
    </m:GetFolder>
  </soap:Body>
</soap:Envelope>''';

    final resp = await http.post(
      Uri.parse(ewsUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'text/xml; charset=UTF-8',
      },
      body: soapEnvelope,
    );

    _log(LogLevel.info, '← HTTP ${resp.statusCode}');

    if (resp.statusCode == 200) {
      if (resp.body.contains('NoError')) {
        _log(LogLevel.success, '✓ EWS-Verbindung erfolgreich');
        _log(LogLevel.success, '✓ Postfach $mailbox ist erreichbar');
      } else if (resp.body.contains('ErrorAccessDenied')) {
        _log(LogLevel.warning, '⚠ EWS erreichbar, aber Zugriff verweigert (ErrorAccessDenied)');
        _log(LogLevel.warning, '  Prüfe: App-Berechtigungen in Azure (full_access_as_app)');
      } else {
        _log(LogLevel.warning, '⚠ EWS antwortete, aber ohne NoError');
        final snippet = resp.body.length > 300 ? '${resp.body.substring(0, 300)}…' : resp.body;
        _log(LogLevel.info, snippet);
      }
    } else if (resp.statusCode == 401) {
      _log(LogLevel.error, '✗ EWS: 401 Unauthorized – Token ungültig oder abgelaufen');
      throw Exception('EWS 401 Unauthorized');
    } else {
      _log(LogLevel.error, '✗ EWS-Fehler: HTTP ${resp.statusCode}');
      throw Exception('EWS-Verbindung fehlgeschlagen: HTTP ${resp.statusCode}');
    }
  }
}
