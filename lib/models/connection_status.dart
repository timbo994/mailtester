enum ConnectionStatus { idle, connecting, connected, error }

extension ConnectionStatusExt on ConnectionStatus {
  String get label => switch (this) {
        ConnectionStatus.idle => 'Nicht verbunden',
        ConnectionStatus.connecting => 'Verbinde…',
        ConnectionStatus.connected => 'Verbunden',
        ConnectionStatus.error => 'Fehler',
      };
}
