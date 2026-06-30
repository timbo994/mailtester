# SMTP & Exchange OAuth Tester

A Flutter desktop application for diagnosing email connections — SMTP and Exchange OAuth 2.0 (Azure AD / Entra ID).

Built for developers and sysadmins who need to validate mail configurations without external tools.

## Features

**SMTP**
- TCP connection test with full protocol trace (EHLO, STARTTLS, AUTH, DATA)
- TLS modes: None / STARTTLS / SSL-TLS
- Send test emails or run connection-only checks
- Passwords masked as `****` in logs

**Exchange OAuth 2.0**
- Auto-discovery of Azure endpoints from Tenant ID (OpenID Connect)
- Client Credentials Grant flow
- EWS (Exchange Web Services) mailbox connectivity check
- Client secrets masked as `****` in logs

**Debug Panel**
- Real-time log stream with color-coded entries (green = success, grey = info, orange = warning, red = error)
- Copy log to clipboard
- Clear log

No data is persisted — everything is session-based.

## Platform Support

| Platform | Status |
|----------|--------|
| Linux    | Supported |
| macOS    | Supported |
| Windows  | Supported |

## Tech Stack

- **Flutter 3.x / Dart 3.x** — Desktop targets
- **flutter_riverpod** — State management
- **http** — OAuth token requests and discovery
- **window_manager** — Window sizing and positioning

## Getting Started

**Prerequisites:** Flutter SDK ≥ 3.x with desktop support enabled.

```bash
flutter pub get
flutter run -d linux    # or macos / windows
```

**Build release binary:**

```bash
flutter build linux     # or macos / windows
```

## Project Structure

```
lib/
├── main.dart
├── models/          # SmtpConfig, OAuthConfig, LogEntry, ConnectionStatus
├── providers/       # Riverpod providers for SMTP, OAuth, debug log
├── services/        # SmtpService, OAuthService, DiscoveryService
└── ui/
    ├── main_window.dart
    ├── debug_panel.dart
    ├── tabs/        # smtp_tab.dart, exchange_tab.dart
    └── widgets/     # log_list_view.dart, status_chip.dart, tls_pill_selector.dart
```

## Security Notes

- Secrets and passwords are never stored to disk
- All credentials exist in memory for the duration of the session only
- Log output masks sensitive values (`****`)