import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/connection_status.dart';

class SmtpStatusNotifier extends Notifier<ConnectionStatus> {
  @override
  ConnectionStatus build() => ConnectionStatus.idle;

  void set(ConnectionStatus status) => state = status;
}

final smtpStatusProvider =
    NotifierProvider<SmtpStatusNotifier, ConnectionStatus>(
  SmtpStatusNotifier.new,
);
