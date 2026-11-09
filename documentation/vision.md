# Technical Vision — DailyTasks

## Architectural Principles

### Layered Architecture

The application follows a strict layered call chain:

```
Widget (UI) → Control (Business logic) → Repository → DataSource → DAO → Drift (Database)
```

- **Widget** — UI components, interface state
- **Control** — business logic, feature state management
- **Repository** — data access facade
- **DataSource** — data sources (local DB, API, cache)
- **DAO** — data access objects
- **Drift** — ORM for SQLite

Layers are never skipped. Direct calls across layers are forbidden.

### DDD — Domain Driven Design

The application is organized around bounded contexts:

- **daily_tasks** — daily task management
- **weekly_tasks** — weekly task management
- **daily_task_rewards** — reward system for daily tasks
- **weekly_task_rewards** — reward system for weekly tasks
- **settings** — application settings
- **developer** — developer tools (debugging, logging)

High cohesion within a context, minimal coupling between contexts.

### Shared packages

Shared packages are used only for stable, truly application-wide contracts:

- **localization** — multi-language support (i18n)
- **ui** — shared UI components and styles
- **database** — database access layer (Drift, DAO)
- **analytics** — event analytics collection
- **client** — HTTP client and API integration

## Technology Stack

| Layer | Technology |
|------|-----------|
| **Framework** | Flutter 3.29.3+ |
| **Language** | Dart 3.7+ |
| **Database** | SQLite (Drift ORM) |
| **State Management** | Control + ChangeNotifier |
| **Routing** | Octopus |
| **Localization** | flutter_localizations + sheety_localization |
| **Logging** | l + Custom ErrorUtil |

## Platforms

- **Mobile:** Android, iOS
- **Desktop:** Windows, Linux, macOS
- **Web:** support is planned

## Initialization

The application is initialized through the `initialization` feature, which:
1. Loads dependencies
2. Configures services
3. Injects them through the DI container
4. Handles initialization errors

## Error Handling

Global error handling via `AppZone` and `ErrorUtil`. Errors are logged and shown to the user in case of critical failures.

## Application State

Managed through `ApplicationSettingsScope`. User settings (notifications, theme, language) are stored in the local database and synchronized during initialization.
