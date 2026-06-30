enum TlsMode { none, starttls, sslTls }

class SmtpConfig {
  final String host;
  final int port;
  final int timeout;
  final TlsMode tlsMode;
  final String username;
  final String password;
  final String from;
  final String to;
  final String subject;
  final String body;

  const SmtpConfig({
    required this.host,
    this.port = 587,
    this.timeout = 10,
    this.tlsMode = TlsMode.starttls,
    required this.username,
    required this.password,
    required this.from,
    required this.to,
    this.subject = '',
    this.body = '',
  });
}
