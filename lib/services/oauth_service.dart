import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;

import '../models/log_entry.dart';
import '../models/oauth_config.dart';

class OAuthService {
  final LogCallback onLog;

  OAuthService({required this.onLog});

  void _log(LogLevel level, String msg) =>
      onLog(LogEntry(timestamp: DateTime.now(), level: level, message: msg));

  Future<String> requestToken(OAuthConfig cfg) async {
    _log(LogLevel.info, '→ POST ${cfg.tokenEndpoint}');
    _log(LogLevel.info, '  grant_type=client_credentials  scope=${cfg.scope}');

    try {
      final client = await oauth2.clientCredentialsGrant(
        Uri.parse(cfg.tokenEndpoint),
        cfg.clientId,
        cfg.clientSecret,
        scopes: [cfg.scope],
      );
      final creds = client.credentials;
      final token = creds.accessToken;

      _log(LogLevel.success, '✓ Token erhalten');
      if (creds.expiration != null) {
        final mins = creds.expiration!.difference(DateTime.now()).inMinutes;
        _log(LogLevel.info, '  expires_in: ~${mins}min');
      }
      if (creds.scopes != null) _log(LogLevel.info, '  scope: ${creds.scopes!.join(' ')}');
      _log(LogLevel.info, '  access_token: ${token.length > 20 ? '${token.substring(0, 20)}…' : token}');

      if (token.isEmpty) throw Exception('Leeres access_token in der Antwort');
      return token;
    } on oauth2.AuthorizationException catch (e) {
      final desc = e.description != null ? ': ${e.description}' : '';
      _log(LogLevel.error, '✗ OAuth-Fehler (${e.error})$desc');
      rethrow;
    } on http.ClientException catch (e) {
      _log(LogLevel.error, '✗ HTTP-Fehler: ${e.message}');
      rethrow;
    } catch (e) {
      _log(LogLevel.error, '✗ Fehler: $e');
      rethrow;
    }
  }

  Future<void> testEws(String token, String mailbox, String ewsUrl) async {
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
