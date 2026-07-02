///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsDe with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsDe({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
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
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsDe _root = this; // ignore: unused_field

	@override 
	TranslationsDe $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsDe(meta: meta ?? this.$meta);

	// Translations
	@override String get appTitle => 'SMTP & Exchange OAuth Tester';
	@override late final _Translations$connectionStatus$de connectionStatus = _Translations$connectionStatus$de._(_root);
	@override late final _Translations$tlsMode$de tlsMode = _Translations$tlsMode$de._(_root);
	@override late final _Translations$smtp$de smtp = _Translations$smtp$de._(_root);
	@override late final _Translations$exchange$de exchange = _Translations$exchange$de._(_root);
	@override late final _Translations$debug$de debug = _Translations$debug$de._(_root);
}

// Path: connectionStatus
class _Translations$connectionStatus$de implements Translations$connectionStatus$en {
	_Translations$connectionStatus$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get idle => 'Nicht verbunden';
	@override String get connecting => 'Verbinde…';
	@override String get connected => 'Verbunden';
	@override String get error => 'Fehler';
}

// Path: tlsMode
class _Translations$tlsMode$de implements Translations$tlsMode$en {
	_Translations$tlsMode$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get none => 'Keine';
	@override String get starttls => 'STARTTLS';
	@override String get sslTls => 'SSL/TLS';
}

// Path: smtp
class _Translations$smtp$de implements Translations$smtp$en {
	_Translations$smtp$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get sectionConnection => 'Verbindung';
	@override String get host => 'SMTP-Host';
	@override String get port => 'Port';
	@override String get timeout => 'Timeout (s)';
	@override String get tlsModeLabel => 'TLS-Modus';
	@override String get sectionAuth => 'Authentifizierung';
	@override String get username => 'Benutzername';
	@override String get password => 'Passwort';
	@override String get sectionTestMail => 'Test-E-Mail';
	@override String get from => 'Von';
	@override String get to => 'An';
	@override String get subject => 'Betreff';
	@override String get body => 'Nachrichtentext';
	@override String get defaultSubject => 'SMTP Verbindungstest';
	@override String get defaultBody => 'Dies ist eine automatisch generierte Test-E-Mail.';
	@override String get btnTestConnection => 'Verbindung testen';
	@override String get btnSendTestMail => 'Test-Mail senden';
}

// Path: exchange
class _Translations$exchange$de implements Translations$exchange$en {
	_Translations$exchange$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get sectionAzure => 'Azure-Konfiguration';
	@override String get tenantId => 'Tenant-ID (UUID)';
	@override String get tenantIdHint => 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';
	@override String get clientId => 'Client-ID';
	@override String get clientSecret => 'Client-Secret';
	@override String get sectionDiscovery => 'Auto-Discovery';
	@override String get tokenEndpoint => 'Token-Endpoint';
	@override String get authEndpoint => 'Authorization-Endpoint';
	@override String get scope => 'Scope';
	@override String get sectionMailbox => 'Postfach & EWS';
	@override String get mailbox => 'Exchange-Mailbox (E-Mail)';
	@override String get ewsUrl => 'EWS-URL';
	@override String get ewsHint => 'EWS-Test erst nach erfolgreichem OAuth-Flow verfügbar.';
	@override String get discoveryRunning => 'Discovery läuft…';
	@override String get discoveryPlaceholder => 'Wird nach Tenant-ID befüllt';
	@override String get btnTestOAuth => 'OAuth-Flow testen';
	@override String get btnTestEws => 'EWS-Verbindung prüfen';
}

// Path: debug
class _Translations$debug$de implements Translations$debug$en {
	_Translations$debug$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Debug-Ausgabe';
	@override String get tooltipCopy => 'Log kopieren';
	@override String get tooltipClear => 'Log leeren';
	@override String get tooltipClose => 'Panel schließen';
	@override String get emptyHint => 'Noch keine Ausgabe. Starte einen Test.';
}

/// The flat map containing all translations for locale <de>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsDe {
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
			'exchange.sectionMailbox' => 'Postfach & EWS',
			'exchange.mailbox' => 'Exchange-Mailbox (E-Mail)',
			'exchange.ewsUrl' => 'EWS-URL',
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
