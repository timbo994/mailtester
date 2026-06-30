class OAuthConfig {
  final String tenantId;
  final String clientId;
  final String clientSecret;
  final String tokenEndpoint;
  final String authorizationEndpoint;
  final String scope;
  final String mailbox;

  const OAuthConfig({
    this.tenantId = '',
    this.clientId = '',
    this.clientSecret = '',
    this.tokenEndpoint = '',
    this.authorizationEndpoint = '',
    this.scope = 'https://outlook.office365.com/.default',
    this.mailbox = '',
  });

  bool get discoveryDone =>
      tokenEndpoint.isNotEmpty && authorizationEndpoint.isNotEmpty;

  OAuthConfig copyWith({
    String? tenantId,
    String? clientId,
    String? clientSecret,
    String? tokenEndpoint,
    String? authorizationEndpoint,
    String? scope,
    String? mailbox,
  }) {
    return OAuthConfig(
      tenantId: tenantId ?? this.tenantId,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      tokenEndpoint: tokenEndpoint ?? this.tokenEndpoint,
      authorizationEndpoint:
          authorizationEndpoint ?? this.authorizationEndpoint,
      scope: scope ?? this.scope,
      mailbox: mailbox ?? this.mailbox,
    );
  }
}
