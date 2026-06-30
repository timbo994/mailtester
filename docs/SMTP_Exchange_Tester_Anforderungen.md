# SMTP & Exchange OAuth Tester
**Flutter Desktop App – Anforderungsdokument & Umsetzungsplan**  
Version 1.0 · Stand: Juni 2025

---

## 1. Projektübersicht

Der SMTP & Exchange OAuth Tester ist eine Flutter-Desktop-Applikation für Entwickler und Systemadministratoren, mit der sich E-Mail-Verbindungen schnell und zuverlässig diagnostizieren lassen. Die App unterstützt klassische SMTP-Verbindungen sowie moderne Exchange-OAuth-2.0-Flows gegen Azure Active Directory / Entra ID.

### Ziele
- Schnelle Diagnose von SMTP-Verbindungsproblemen mit vollständigem Protokoll-Trace
- Testen von Exchange OAuth 2.0 (Client Credentials Flow) ohne externe Tools
- Auto-Discovery von Azure-Metadaten anhand der Tenant-ID
- Ausführliche, strukturierte Debug-Ausgabe in separatem Fenster
- Keine Persistenz – alle Daten bleiben session-basiert

### Zielgruppe
- Entwickler, die E-Mail-Integrationen implementieren oder debuggen
- Systemadministratoren, die Exchange-/SMTP-Konfigurationen validieren
- DevOps-Teams beim Einrichten von CI/CD-E-Mail-Benachrichtigungen

---

## 2. Funktionale Anforderungen

### 2.1 SMTP-Verbindungstest

#### Verbindungsparameter
| Feld | Typ | Standard |
|---|---|---|
| SMTP-Host | Freitext | – |
| Port | Numerisch | 587 |
| Timeout | Numerisch (Sekunden) | 10 |
| TLS-Modus | Auswahl: Keine / STARTTLS / SSL-TLS | STARTTLS |

#### Authentifizierung
| Feld | Typ |
|---|---|
| Benutzername | E-Mail-Adresse |
| Passwort | Maskiert |

#### Test-E-Mail
| Feld | Typ | Standard |
|---|---|---|
| Von | E-Mail | – |
| An | E-Mail | – |
| Betreff | Freitext | „SMTP Verbindungstest" |
| Nachrichtentext | Textarea (optional) | Standardinhalt |

#### Aktionen
- **Verbindung testen** – reiner Verbindungs- und Authentifizierungstest (kein Mailversand)
- **Test-Mail senden** – vollständiger Versandtest inkl. DATA-Phase
- Statusanzeige: `Nicht verbunden` / `Verbinde…` / `Verbunden` / `Fehler`

---

### 2.2 Exchange OAuth 2.0 Test

#### Manuell einzugebende Parameter
| Feld | Typ | Anmerkung |
|---|---|---|
| Tenant-ID | Freitext (UUID) | Pflichtfeld für Auto-Discovery |
| Client-ID | Freitext (UUID) | Aus Azure App-Registrierung |
| Client-Secret | Maskiert | Einmalig sichtbar bei Erstellung |

> **Hinweis:** Tenant-ID, Client-ID und Client-Secret können nicht automatisch ermittelt werden – sie sind geheime Zugangsdaten der jeweiligen Azure-App-Registrierung und müssen manuell eingegeben werden.

#### Auto-Discovery (automatisch nach Eingabe der Tenant-ID)
Sobald die Tenant-ID eingegeben ist, wird folgendes Discovery-Dokument abgerufen:

```
GET https://login.microsoftonline.com/{tenant-id}/.well-known/openid-configuration
```

Daraus werden automatisch befüllt:

| Parameter | Quelle | Beispiel |
|---|---|---|
| Token-Endpoint | `token_endpoint` | `https://login.microsoftonline.com/{tid}/oauth2/v2.0/token` |
| Authorization-Endpoint | `authorization_endpoint` | `https://login.microsoftonline.com/{tid}/oauth2/v2.0/authorize` |
| Scope | Fest | `https://outlook.office365.com/.default` |

Auto-befüllte Felder werden als readonly mit `AUTO`-Badge dargestellt. Der Discovery-Request wird mit Debounce (~800 ms nach letzter Eingabe) ausgelöst.

#### Postfachkonfiguration
- Exchange-Mailbox (E-Mail-Adresse des zu testenden Postfachs)

#### Aktionen
- **OAuth-Flow testen** – Token anfordern (Client Credentials Grant) und validieren
- **EWS-Verbindung prüfen** – Postfach via Exchange Web Services ansprechen
- Statusanzeige analog zu SMTP

---

### 2.3 Debug-Ausgabefenster

- Öffnet sich als **separates Flutter-Fenster** beim Start eines Tests
- Positionierung: rechts neben dem Hauptfenster, gleiche Höhe
- Bleibt offen bis manuell geschlossen

#### Log-Format
```
HH:MM:SS  → EHLO mail-tester.local
HH:MM:SS  ← 250-smtp.gmail.com Hello [123.45.67.89]
HH:MM:SS  ✓ TLS-Handshake erfolgreich (TLSv1.3, AES-256-GCM)
```

#### Farbcodierung
| Farbe | Bedeutung |
|---|---|
| Grün | Erfolg (OK, Verbindung aufgebaut) |
| Grau | Info (gesendete/empfangene Befehle) |
| Orange | Warnung (z.B. Token abgelaufen, Retry) |
| Rot | Fehler (Verbindung abgelehnt, Auth fehlgeschlagen) |

#### SMTP-Trace-Inhalte
- TCP-Verbindungsaufbau
- Vollständiger EHLO/ESMTP-Handshake
- STARTTLS-Verhandlung inkl. TLS-Version und Cipher-Suite
- AUTH-Sequenz (Passwort wird als `****` geloggt)
- MAIL FROM / RCPT TO / DATA (beim Mailversand)
- Servercodes und -antworten im Klartext

#### OAuth-Trace-Inhalte
- Discovery-Request und HTTP-Statuscode
- Geparste Endpoints
- Token-Request (Secret wird als `****` geloggt)
- Token-Metadaten (Typ, Gültigkeitsdauer, Scopes)
- EWS-Request und Antwort

#### Aktionen im Debug-Fenster
- Log leeren
- Log in Zwischenablage kopieren
- Statuschip (Echtzeit-Verbindungsstatus)

---

## 3. Nicht-funktionale Anforderungen

| Kategorie | Priorität | Anforderung |
|---|---|---|
| Performance | Hoch | UI reagiert sofort; alle Netzwerkoperationen laufen asynchron |
| Sicherheit | Hoch | Passwörter und Secrets werden niemals im Klartext geloggt (`****`) |
| Plattform | Hoch | Windows, macOS, Linux (Flutter Desktop) |
| Persistenz | Keine | Keine Speicherung von Verbindungsdaten – alles session-basiert |
| Fehlertoleranz | Mittel | Timeouts, TLS- und Auth-Fehler klar im Debug-Log kommunizieren |
| Zugänglichkeit | Niedrig | Klare Feldbeschriftung, Tastaturnavigation |

---

## 4. Technischer Stack

### Framework & Sprache
- **Flutter 3.x** (Dart) – Desktop-Target (Windows / macOS / Linux)
- **Dart 3.x** mit Null-Safety

### Pakete

| Paket | Verwendung | Begründung |
|---|---|---|
| `enough_mail` | SMTP-Client | Vollständige SMTP-Implementierung inkl. STARTTLS und OAuth |
| `http` | HTTP-Client | OAuth Token-Requests, Discovery-Dokument abrufen |
| `window_manager` | Fensterverwaltung | Zweites Debug-Fenster öffnen und positionieren |
| `riverpod` | State Management | Reaktiver State für Verbindungsstatus und Log-Stream |
| `flutter_secure_storage` | Secrets (optional) | Sichere temporäre Ablage von Tokens im RAM |

> Falls `enough_mail` zu wenig Low-Level-Kontrolle bietet: eigene Socket-Implementierung via `dart:io` für vollständigen SMTP-Trace als Fallback vorsehen.

---

## 5. Architektur

### Schichtenmodell

```
┌─────────────────────────────────────────┐
│           UI-Schicht (Flutter)          │
│  Hauptfenster (Tabs)  │  Debug-Fenster  │
├─────────────────────────────────────────┤
│              Service-Schicht            │
│  SmtpService  │  OAuthService  │  DiscoveryService  │
├─────────────────────────────────────────┤
│              Model-Schicht              │
│  SmtpConfig  │  OAuthConfig  │  LogEntry  │  ConnectionStatus  │
└─────────────────────────────────────────┘
```

### Fensterkonzept

- **Hauptfenster:** Tab-basiert – Tab 1 (SMTP) / Tab 2 (Exchange OAuth)
- **Debug-Fenster:** Separates Flutter-Window via `window_manager`
  - Öffnet sich beim Teststart automatisch rechts neben dem Hauptfenster
  - Kommuniziert mit dem Hauptfenster via `StreamController` / `Riverpod`-Provider
  - Bleibt bis zum manuellen Schließen offen
  - Fallback: Overlay-Panel im Hauptfenster, falls Multi-Window Probleme macht

### Datenfluss SMTP-Test

```
User klickt "Verbindung testen"
  → SmtpService.connect(SmtpConfig)
    → dart:io Socket öffnen
    → Jeden gesendeten/empfangenen Befehl als LogEntry emittieren
    → Stream<LogEntry> → DebugWindowProvider → Debug-Fenster
  → ConnectionStatus aktualisieren → Statuschip im Hauptfenster
```

### Datenfluss OAuth-Test

```
User gibt Tenant-ID ein (Debounce 800ms)
  → DiscoveryService.discover(tenantId)
    → GET .well-known/openid-configuration
    → OAuthConfig automatisch befüllen → UI aktualisieren

User klickt "OAuth-Flow testen"
  → OAuthService.requestToken(OAuthConfig)
    → POST /oauth2/v2.0/token (client_credentials)
    → Token validieren (exp, scope)
    → LogEntries emittieren → Debug-Fenster

User klickt "EWS-Verbindung prüfen"
  → OAuthService.testEws(token, mailbox)
    → EWS GetFolder Request mit Bearer-Token
    → Antwort loggen → Debug-Fenster
```

---

## 6. Umsetzungsplan

### Phasen & Meilensteine

| Phase | Bezeichnung | Inhalt | Aufwand |
|---|---|---|---|
| 1 | Projektsetup | Flutter-Projekt anlegen, `pubspec.yaml`, Ordnerstruktur, `window_manager` konfigurieren | 0,5 Tage |
| 2 | UI-Grundgerüst | Tab-Layout, alle Formularfelder, TLS-Pill-Auswahl, Statuschips, Styling | 1 Tag |
| 3 | Debug-Fenster | Separates Flutter-Window, Log-ListView, Farbcodierung, Aktionsbuttons, Stream-Anbindung | 1 Tag |
| 4 | SMTP-Service | Socket-Implementierung, EHLO, STARTTLS, AUTH, DATA, vollständiger Trace | 2 Tage |
| 5 | OAuth-Service | Discovery-Request, Auto-Fill, Token-Request, EWS-Call, Fehlerbehandlung | 2 Tage |
| 6 | Integration & Tests | End-to-End-Tests, Edge Cases, Fehlerbehandlung, Code Review | 1 Tag |
| 7 | Build & Release | Desktop-Builds Win/macOS/Linux, ggf. Installer | 0,5 Tage |

**Geschätzter Gesamtaufwand: ca. 8 Entwicklungstage**

### Empfohlene Reihenfolge

1. **Phasen 1–3 zuerst:** UI und Debug-Fenster früh zum Laufen bringen – so sieht man während der Service-Entwicklung sofort Feedback
2. **Phase 4 vor Phase 5:** SMTP ist einfacher testbar, gewonnene Erfahrung fließt in den OAuth-Service ein
3. **Tests parallel:** Unit-Tests für Services von Anfang an mitschreiben, nicht erst in Phase 6

### Risiken & Maßnahmen

| Risiko | Wahrscheinlichkeit | Maßnahme |
|---|---|---|
| `enough_mail` bietet zu wenig Low-Level-Trace-Hooks | Mittel | Eigene Socket-Implementierung via `dart:io` als Fallback |
| Multi-Window in Flutter instabil auf bestimmten Plattformen | Niedrig | Debug-Fenster als Overlay-Panel im Hauptfenster als Alternative |
| Azure AD ändert Discovery-Dokumentformat | Sehr niedrig | OpenID Connect ist ein stabiler Standard |
| EWS wird von Microsoft abgekündigt | Mittel | Microsoft Graph API als Alternative für v2 einplanen |

---

## 7. Offene Punkte & Entscheidungen

- [ ] Microsoft Graph API (`/v1.0/me/messages`) als Alternative zu EWS bereits in v1 oder erst in v2?
- [ ] IMAP-Test als dritter Tab in v1 oder spätere Erweiterung?
- [ ] Log-Export als Datei (`.txt` / `.log`) gewünscht?
- [ ] Portable Single-Executable oder klassischer Installer?
- [ ] App-Icon und Branding, oder reines Developer-Tool-Styling?

---

## 8. Projektstruktur (Vorschlag)

```
smtp_exchange_tester/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── smtp_config.dart
│   │   ├── oauth_config.dart
│   │   ├── log_entry.dart
│   │   └── connection_status.dart
│   ├── services/
│   │   ├── smtp_service.dart
│   │   ├── oauth_service.dart
│   │   └── discovery_service.dart
│   ├── providers/
│   │   ├── smtp_provider.dart
│   │   ├── oauth_provider.dart
│   │   └── debug_log_provider.dart
│   └── ui/
│       ├── main_window.dart
│       ├── debug_window.dart
│       ├── tabs/
│       │   ├── smtp_tab.dart
│       │   └── exchange_tab.dart
│       └── widgets/
│           ├── log_list_view.dart
│           ├── status_chip.dart
│           └── tls_pill_selector.dart
├── pubspec.yaml
└── README.md
```
