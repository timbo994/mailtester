import '../../i18n/strings.g.dart';
import '../../models/smtp_config.dart';

extension TlsModeUi on TlsMode {
  String get label => switch (this) {
        TlsMode.none => t.tlsMode.none,
        TlsMode.starttls => t.tlsMode.starttls,
        TlsMode.sslTls => t.tlsMode.sslTls,
      };
}
