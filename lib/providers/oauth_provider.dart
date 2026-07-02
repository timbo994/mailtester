import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/connection_status.dart';
import '../models/log_entry.dart';
import '../models/oauth_config.dart';
import '../services/discovery_service.dart';
import 'debug_log_provider.dart';

class OAuthConfigNotifier extends Notifier<OAuthConfig> {
  Timer? _debounce;

  static final _uuidRegex = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  @override
  OAuthConfig build() {
    ref.onDispose(() => _debounce?.cancel());
    return const OAuthConfig();
  }

  void setTenantId(String v) {
    state = state.copyWith(
      tenantId: v,
      tokenEndpoint: '',
      authorizationEndpoint: '',
    );
    _debounce?.cancel();
    if (_uuidRegex.hasMatch(v.trim())) {
      _debounce = Timer(
        const Duration(milliseconds: 800),
        () => _discover(v.trim()),
      );
    }
  }

  void setClientId(String v) => state = state.copyWith(clientId: v);
  void setClientSecret(String v) => state = state.copyWith(clientSecret: v);
  void setMailbox(String v) => state = state.copyWith(mailbox: v);
  void setEwsUrl(String v) => state = state.copyWith(ewsUrl: v);

  Future<void> _discover(String tenantId) async {
    final addLog = ref.read(debugLogProvider.notifier).add;
    addLog(LogEntry(
      timestamp: DateTime.now(),
      level: LogLevel.info,
      message: 'Auto-Discovery für Tenant $tenantId…',
    ));

    try {
      final result = await DiscoveryService.discover(tenantId, addLog);
      state = state.copyWith(
        tokenEndpoint: result['token_endpoint'] ?? '',
        authorizationEndpoint: result['authorization_endpoint'] ?? '',
      );
    } catch (e) {
      addLog(LogEntry(
        timestamp: DateTime.now(),
        level: LogLevel.error,
        message: '✗ Discovery fehlgeschlagen: $e',
      ));
    }
  }
}

final oauthConfigProvider =
    NotifierProvider<OAuthConfigNotifier, OAuthConfig>(
  OAuthConfigNotifier.new,
);

class OAuthStatusNotifier extends Notifier<ConnectionStatus> {
  @override
  ConnectionStatus build() => ConnectionStatus.idle;

  void set(ConnectionStatus status) => state = status;
}

final oauthStatusProvider =
    NotifierProvider<OAuthStatusNotifier, ConnectionStatus>(
  OAuthStatusNotifier.new,
);

class OAuthTokenNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? token) => state = token;
}

final oauthTokenProvider = NotifierProvider<OAuthTokenNotifier, String?>(
  OAuthTokenNotifier.new,
);
