///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'SMTP & Exchange OAuth Tester'
	String get appTitle => 'SMTP & Exchange OAuth Tester';

	late final Translations$connectionStatus$en connectionStatus = Translations$connectionStatus$en._(_root);
	late final Translations$tlsMode$en tlsMode = Translations$tlsMode$en._(_root);
	late final Translations$smtp$en smtp = Translations$smtp$en._(_root);
	late final Translations$exchange$en exchange = Translations$exchange$en._(_root);
	late final Translations$debug$en debug = Translations$debug$en._(_root);
}

// Path: connectionStatus
class Translations$connectionStatus$en {
	Translations$connectionStatus$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Not connected'
	String get idle => 'Not connected';

	/// en: 'Connecting…'
	String get connecting => 'Connecting…';

	/// en: 'Connected'
	String get connected => 'Connected';

	/// en: 'Error'
	String get error => 'Error';
}

// Path: tlsMode
class Translations$tlsMode$en {
	Translations$tlsMode$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'None'
	String get none => 'None';

	/// en: 'STARTTLS'
	String get starttls => 'STARTTLS';

	/// en: 'SSL/TLS'
	String get sslTls => 'SSL/TLS';
}

// Path: smtp
class Translations$smtp$en {
	Translations$smtp$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Connection'
	String get sectionConnection => 'Connection';

	/// en: 'SMTP Host'
	String get host => 'SMTP Host';

	/// en: 'Port'
	String get port => 'Port';

	/// en: 'Timeout (s)'
	String get timeout => 'Timeout (s)';

	/// en: 'TLS Mode'
	String get tlsModeLabel => 'TLS Mode';

	/// en: 'Authentication'
	String get sectionAuth => 'Authentication';

	/// en: 'Username'
	String get username => 'Username';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Test Email'
	String get sectionTestMail => 'Test Email';

	/// en: 'From'
	String get from => 'From';

	/// en: 'To'
	String get to => 'To';

	/// en: 'Subject'
	String get subject => 'Subject';

	/// en: 'Message Body'
	String get body => 'Message Body';

	/// en: 'SMTP Connection Test'
	String get defaultSubject => 'SMTP Connection Test';

	/// en: 'This is an automatically generated test email.'
	String get defaultBody => 'This is an automatically generated test email.';

	/// en: 'Test Connection'
	String get btnTestConnection => 'Test Connection';

	/// en: 'Send Test Email'
	String get btnSendTestMail => 'Send Test Email';
}

// Path: exchange
class Translations$exchange$en {
	Translations$exchange$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Azure Configuration'
	String get sectionAzure => 'Azure Configuration';

	/// en: 'Tenant ID (UUID)'
	String get tenantId => 'Tenant ID (UUID)';

	/// en: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
	String get tenantIdHint => 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';

	/// en: 'Client ID'
	String get clientId => 'Client ID';

	/// en: 'Client Secret'
	String get clientSecret => 'Client Secret';

	/// en: 'Auto-Discovery'
	String get sectionDiscovery => 'Auto-Discovery';

	/// en: 'Token Endpoint'
	String get tokenEndpoint => 'Token Endpoint';

	/// en: 'Authorization Endpoint'
	String get authEndpoint => 'Authorization Endpoint';

	/// en: 'Scope'
	String get scope => 'Scope';

	/// en: 'Mailbox'
	String get sectionMailbox => 'Mailbox';

	/// en: 'Exchange Mailbox (Email)'
	String get mailbox => 'Exchange Mailbox (Email)';

	/// en: 'EWS test only available after a successful OAuth flow.'
	String get ewsHint => 'EWS test only available after a successful OAuth flow.';

	/// en: 'Discovery running…'
	String get discoveryRunning => 'Discovery running…';

	/// en: 'Will be filled after Tenant ID is entered'
	String get discoveryPlaceholder => 'Will be filled after Tenant ID is entered';

	/// en: 'Test OAuth Flow'
	String get btnTestOAuth => 'Test OAuth Flow';

	/// en: 'Check EWS Connection'
	String get btnTestEws => 'Check EWS Connection';
}

// Path: debug
class Translations$debug$en {
	Translations$debug$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Debug Output'
	String get title => 'Debug Output';

	/// en: 'Copy log'
	String get tooltipCopy => 'Copy log';

	/// en: 'Clear log'
	String get tooltipClear => 'Clear log';

	/// en: 'Close panel'
	String get tooltipClose => 'Close panel';

	/// en: 'No output yet. Start a test.'
	String get emptyHint => 'No output yet. Start a test.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'SMTP & Exchange OAuth Tester',
			'connectionStatus.idle' => 'Not connected',
			'connectionStatus.connecting' => 'Connecting…',
			'connectionStatus.connected' => 'Connected',
			'connectionStatus.error' => 'Error',
			'tlsMode.none' => 'None',
			'tlsMode.starttls' => 'STARTTLS',
			'tlsMode.sslTls' => 'SSL/TLS',
			'smtp.sectionConnection' => 'Connection',
			'smtp.host' => 'SMTP Host',
			'smtp.port' => 'Port',
			'smtp.timeout' => 'Timeout (s)',
			'smtp.tlsModeLabel' => 'TLS Mode',
			'smtp.sectionAuth' => 'Authentication',
			'smtp.username' => 'Username',
			'smtp.password' => 'Password',
			'smtp.sectionTestMail' => 'Test Email',
			'smtp.from' => 'From',
			'smtp.to' => 'To',
			'smtp.subject' => 'Subject',
			'smtp.body' => 'Message Body',
			'smtp.defaultSubject' => 'SMTP Connection Test',
			'smtp.defaultBody' => 'This is an automatically generated test email.',
			'smtp.btnTestConnection' => 'Test Connection',
			'smtp.btnSendTestMail' => 'Send Test Email',
			'exchange.sectionAzure' => 'Azure Configuration',
			'exchange.tenantId' => 'Tenant ID (UUID)',
			'exchange.tenantIdHint' => 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
			'exchange.clientId' => 'Client ID',
			'exchange.clientSecret' => 'Client Secret',
			'exchange.sectionDiscovery' => 'Auto-Discovery',
			'exchange.tokenEndpoint' => 'Token Endpoint',
			'exchange.authEndpoint' => 'Authorization Endpoint',
			'exchange.scope' => 'Scope',
			'exchange.sectionMailbox' => 'Mailbox',
			'exchange.mailbox' => 'Exchange Mailbox (Email)',
			'exchange.ewsHint' => 'EWS test only available after a successful OAuth flow.',
			'exchange.discoveryRunning' => 'Discovery running…',
			'exchange.discoveryPlaceholder' => 'Will be filled after Tenant ID is entered',
			'exchange.btnTestOAuth' => 'Test OAuth Flow',
			'exchange.btnTestEws' => 'Check EWS Connection',
			'debug.title' => 'Debug Output',
			'debug.tooltipCopy' => 'Copy log',
			'debug.tooltipClear' => 'Clear log',
			'debug.tooltipClose' => 'Close panel',
			'debug.emptyHint' => 'No output yet. Start a test.',
			_ => null,
		};
	}
}
