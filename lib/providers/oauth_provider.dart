import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/connection_status.dart';
import '../models/log_entry.dart';
import '../models/oauth_config.dart';
import '../services/discovery_service.dart';
import 'debug_log_provider.dart';

class OAuthConfigNotifier extends StateNotifier<OAuthConfig> {
  final Ref _ref;
  Timer? _debounce;

  static final _uuidRegex = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  OAuthConfigNotifier(this._ref) : super(const OAuthConfig());

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

  Future<void> _discover(String tenantId) async {
    final addLog = _ref.read(debugLogProvider.notifier).add;
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

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final oauthConfigProvider =
    StateNotifierProvider<OAuthConfigNotifier, OAuthConfig>(
  (ref) => OAuthConfigNotifier(ref),
);

final oauthStatusProvider =
    StateProvider<ConnectionStatus>((ref) => ConnectionStatus.idle);

final oauthTokenProvider = StateProvider<String?>((ref) => null);
