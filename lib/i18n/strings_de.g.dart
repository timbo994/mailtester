///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsDe = Translations; // ignore: unused_element
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
		    locale: AppLocale.de,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <de>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// de: 'SMTP & Exchange OAuth Tester'
	String get appTitle => 'SMTP & Exchange OAuth Tester';

	late final Translations$connectionStatus$de connectionStatus = Translations$connectionStatus$de._(_root);
	late final Translations$tlsMode$de tlsMode = Translations$tlsMode$de._(_root);
	late final Translations$smtp$de smtp = Translations$smtp$de._(_root);
	late final Translations$exchange$de exchange = Translations$exchange$de._(_root);
	late final Translations$debug$de debug = Translations$debug$de._(_root);
}

// Path: connectionStatus
class Translations$connectionStatus$de {
	Translations$connectionStatus$de._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// de: 'Nicht verbunden'
	String get idle => 'Nicht verbunden';

	/// de: 'Verbinde…'
	String get connecting => 'Verbinde…';

	/// de: 'Verbunden'
	String get connected => 'Verbunden';

	/// de: 'Fehler'
	String get error => 'Fehler';
}

// Path: tlsMode
class Translations$tlsMode$de {
	Translations$tlsMode$de._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// de: 'Keine'
	String get none => 'Keine';

	/// de: 'STARTTLS'
	String get starttls => 'STARTTLS';

	/// de: 'SSL/TLS'
	String get sslTls => 'SSL/TLS';
}

// Path: smtp
class Translations$smtp$de {
	Translations$smtp$de._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// de: 'Verbindung'
	String get sectionConnection => 'Verbindung';

	/// de: 'SMTP-Host'
	String get host => 'SMTP-Host';

	/// de: 'Port'
	String get port => 'Port';

	/// de: 'Timeout (s)'
	String get timeout => 'Timeout (s)';

	/// de: 'TLS-Modus'
	String get tlsModeLabel => 'TLS-Modus';

	/// de: 'Authentifizierung'
	String get sectionAuth => 'Authentifizierung';

	/// de: 'Benutzername'
	String get username => 'Benutzername';

	/// de: 'Passwort'
	String get password => 'Passwort';

	/// de: 'Test-E-Mail'
	String get sectionTestMail => 'Test-E-Mail';

	/// de: 'Von'
	String get from => 'Von';

	/// de: 'An'
	String get to => 'An';

	/// de: 'Betreff'
	String get subject => 'Betreff';

	/// de: 'Nachrichtentext'
	String get body => 'Nachrichtentext';

	/// de: 'SMTP Verbindungstest'
	String get defaultSubject => 'SMTP Verbindungstest';

	/// de: 'Dies ist eine automatisch generierte Test-E-Mail.'
	String get defaultBody => 'Dies ist eine automatisch generierte Test-E-Mail.';

	/// de: 'Verbindung testen'
	String get btnTestConnection => 'Verbindung testen';

	/// de: 'Test-Mail senden'
	String get btnSendTestMail => 'Test-Mail senden';
}

// Path: exchange
class Translations$exchange$de {
	Translations$exchange$de._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// de: 'Azure-Konfiguration'
	String get sectionAzure => 'Azure-Konfiguration';

	/// de: 'Tenant-ID (UUID)'
	String get tenantId => 'Tenant-ID (UUID)';

	/// de: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
	String get tenantIdHint => 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';

	/// de: 'Client-ID'
	String get clientId => 'Client-ID';

	/// de: 'Client-Secret'
	String get clientSecret => 'Client-Secret';

	/// de: 'Auto-Discovery'
	String get sectionDiscovery => 'Auto-Discovery';

	/// de: 'Token-Endpoint'
	String get tokenEndpoint => 'Token-Endpoint';

	/// de: 'Authorization-Endpoint'
	String get authEndpoint => 'Authorization-Endpoint';

	/// de: 'Scope'
	String get scope => 'Scope';

	/// de: 'Postfach'
	String get sectionMailbox => 'Postfach';

	/// de: 'Exchange-Mailbox (E-Mail)'
	String get mailbox => 'Exchange-Mailbox (E-Mail)';

	/// de: 'EWS-Test erst nach erfolgreichem OAuth-Flow verfügbar.'
	String get ewsHint => 'EWS-Test erst nach erfolgreichem OAuth-Flow verfügbar.';

	/// de: 'Discovery läuft…'
	String get discoveryRunning => 'Discovery läuft…';

	/// de: 'Wird nach Tenant-ID befüllt'
	String get discoveryPlaceholder => 'Wird nach Tenant-ID befüllt';

	/// de: 'OAuth-Flow testen'
	String get btnTestOAuth => 'OAuth-Flow testen';

	/// de: 'EWS-Verbindung prüfen'
	String get btnTestEws => 'EWS-Verbindung prüfen';
}

// Path: debug
class Translations$debug$de {
	Translations$debug$de._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// de: 'Debug-Ausgabe'
	String get title => 'Debug-Ausgabe';

	/// de: 'Log kopieren'
	String get tooltipCopy => 'Log kopieren';

	/// de: 'Log leeren'
	String get tooltipClear => 'Log leeren';

	/// de: 'Panel schließen'
	String get tooltipClose => 'Panel schließen';

	/// de: 'Noch keine Ausgabe. Starte einen Test.'
	String get emptyHint => 'Noch keine Ausgabe. Starte einen Test.';
}

/// The flat map containing all translations for locale <de>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'SMTP & Exchange OAuth Tester',
			'connectionStatus.idle' => 'Nicht verbunden',
			'connectionStatus.connecting' => 'Verbinde…',
			'connectionStatus.connected' => 'Verbunden',
			'connectionStatus.error' => 'Fehler',
			'tlsMode.none' => 'Keine',
			'tlsMode.starttls' => 'STARTTLS',
			'tlsMode.sslTls' => 'SSL/TLS',
			'smtp.sectionConnection' => 'Verbindung',
			'smtp.host' => 'SMTP-Host',
			'smtp.port' => 'Port',
			'smtp.timeout' => 'Timeout (s)',
			'smtp.tlsModeLabel' => 'TLS-Modus',
			'smtp.sectionAuth' => 'Authentifizierung',
			'smtp.username' => 'Benutzername',
			'smtp.password' => 'Passwort',
			'smtp.sectionTestMail' => 'Test-E-Mail',
			'smtp.from' => 'Von',
			'smtp.to' => 'An',
			'smtp.subject' => 'Betreff',
			'smtp.body' => 'Nachrichtentext',
			'smtp.defaultSubject' => 'SMTP Verbindungstest',
			'smtp.defaultBody' => 'Dies ist eine automatisch generierte Test-E-Mail.',
			'smtp.btnTestConnection' => 'Verbindung testen',
			'smtp.btnSendTestMail' => 'Test-Mail senden',
			'exchange.sectionAzure' => 'Azure-Konfiguration',
			'exchange.tenantId' => 'Tenant-ID (UUID)',
			'exchange.tenantIdHint' => 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
			'exchange.clientId' => 'Client-ID',
			'exchange.clientSecret' => 'Client-Secret',
			'exchange.sectionDiscovery' => 'Auto-Discovery',
			'exchange.tokenEndpoint' => 'Token-Endpoint',
			'exchange.authEndpoint' => 'Authorization-Endpoint',
			'exchange.scope' => 'Scope',
			'exchange.sectionMailbox' => 'Postfach',
			'exchange.mailbox' => 'Exchange-Mailbox (E-Mail)',
			'exchange.ewsHint' => 'EWS-Test erst nach erfolgreichem OAuth-Flow verfügbar.',
			'exchange.discoveryRunning' => 'Discovery läuft…',
			'exchange.discoveryPlaceholder' => 'Wird nach Tenant-ID befüllt',
			'exchange.btnTestOAuth' => 'OAuth-Flow testen',
			'exchange.btnTestEws' => 'EWS-Verbindung prüfen',
			'debug.title' => 'Debug-Ausgabe',
			'debug.tooltipCopy' => 'Log kopieren',
			'debug.tooltipClear' => 'Log leeren',
			'debug.tooltipClose' => 'Panel schließen',
			'debug.emptyHint' => 'Noch keine Ausgabe. Starte einen Test.',
			_ => null,
		};
	}
}
