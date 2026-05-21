# POCKETA — Architecture Rules

> Binding constraints for all contributors — human and AI.
> Read POCKETA_BRAIN.md first.

---

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── application/
│   └── providers/                     # App-level providers (theme, locale)
├── config/
│   └── router/                        # GoRouter setup and route definitions
│       ├── app_router.dart
│       └── route_names.dart
├── core/
│   ├── constants/                     # App-wide constants (box names, languages)
│   ├── local_storage/                 # Hive + SharedPreferences services
│   ├── themes/                        # AppTheme, AppColors
│   ├── utils/                         # Utilities (IdGenerator, etc.)
│   └── widgets/                       # Shared widgets (AppButton, ProgressBar)
├── features/
│   ├── dashboard/
│   │   └── presentation/views/        # DashboardScreen
│   ├── onboarding/
│   │   └── presentation/views/        # OnboardingScreen
│   ├── splash/
│   │   └── presentation/views/        # SplashScreen
│   └── transactions/
│       ├── data/
│       │   ├── datasources/           # TransactionLocalDataSource (Hive)
│       │   ├── models/                # TransactionModel (HiveObject)
│       │   └── repositories/          # TransactionRepositoryImpl
│       ├── domain/
│       │   ├── entities/              # TransactionEntity (pure domain)
│       │   └── repositories/          # TransactionRepository (abstract)
│       └── presentation/
│           ├── providers/             # Riverpod providers + notifiers
│           └── views/                 # AddTransactionScreen
├── l10n/                              # Localization ARB files
└── utils/                             # General utilities (responsive, etc.)
```

---

## Layer Rules

### 1. Feature-First Organization

Every feature module follows:

```
feature_name/
├── data/
│   ├── datasources/     # Local or remote data access
│   ├── models/          # Serializable data models (Hive, JSON)
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Pure business objects (no framework imports)
│   └── repositories/    # Abstract repository contracts
└── presentation/
    ├── providers/       # Riverpod providers and state notifiers
    └── views/           # Screens and widgets
```

### 2. Dependency Direction

```
presentation → domain ← data
```

- **Presentation** depends on **domain** (entities, abstract repos)
- **Data** implements **domain** (concrete repos, models)
- **Domain** depends on **nothing** (pure Dart)
- Never import `data/` from `presentation/` directly
- Exception: Riverpod providers may wire data implementations to domain contracts

### 3. State Management — Riverpod

- Use `StateNotifierProvider` for mutable collections (transactions list)
- Use `Provider` for singletons (repositories, data sources)
- Use `FutureProvider` for async initialization
- **No** `ChangeNotifier`, **no** `setState` for business logic
- Providers live in `presentation/providers/` within their feature

### 4. Persistence — Hive

- All Hive boxes declared in `core/constants/app_box_names.dart`
- Box initialization in `core/local_storage/hive_service.dart`
- Models use `@HiveType` and `@HiveField` annotations
- Type adapters registered at app startup
- SharedPreferences for simple flags (onboarding, theme, locale)

### 5. Routing — GoRouter

- All routes defined in `config/router/app_router.dart`
- Route path constants in `config/router/route_names.dart`
- Named routes with `context.pushNamed()` / `context.goNamed()`
- Path parameters for entity IDs (e.g., `/edit-transaction/:id`)

### 6. Theming

- `AppColors` — all color constants (no raw hex in widgets)
- `AppTheme` — light and dark `ThemeData` configurations
- Use `Theme.of(context)` in widgets, never hardcode colors
- Use `withValues(alpha: x)` not deprecated `withOpacity(x)`

---

## Naming Conventions

| Entity | Convention | Example |
|---|---|---|
| Feature folder | `snake_case` | `transactions/` |
| Screen | `PascalCase` + `Screen` suffix | `AddTransactionScreen` |
| Model | `PascalCase` + `Model` suffix | `TransactionModel` |
| Entity | `PascalCase` + `Entity` suffix | `TransactionEntity` |
| Provider | `camelCase` + `Provider` suffix | `transactionsProvider` |
| Notifier | `PascalCase` + `Notifier` suffix | `TransactionsNotifier` |
| Repository | `PascalCase` + `Repository` suffix | `TransactionRepository` |
| DataSource | `PascalCase` + `DataSource` suffix | `TransactionLocalDataSource` |
| Constants file | `snake_case` | `app_box_names.dart` |
| Utility class | `PascalCase` | `IdGenerator` |

---

## Code Quality Rules

### Analyzer
- `dart analyze` must pass with **0 errors, 0 warnings, 0 infos** before every commit
- Analysis options defined in `analysis_options.yaml`

### File Size
- Keep files under **300 lines** where possible
- Extract widgets when a build method exceeds **100 lines**

### Imports
- Use package imports, not relative: `package:pocketa_v2/...`
- Group imports: dart → flutter → packages → project

### Immutability
- Models should be effectively immutable
- Use `final` fields on all model properties
- Use `copyWith` for mutations when needed

### Error Handling
- Wrap async operations in `try/catch`
- Show user-facing error feedback via `SnackBar`
- Guard `setState` and navigation with `mounted` checks

---

## Forbidden Patterns

| Pattern | Why |
|---|---|
| `setState` for business logic | Use Riverpod |
| `BuildContext` across async gaps without `mounted` | Crash risk |
| Raw color hex in widgets | Use `AppColors` |
| `withOpacity()` | Deprecated — use `withValues(alpha:)` |
| God-files > 500 lines | Extract sub-widgets or helpers |
| Circular imports between features | Break with shared `core/` |
| Direct Hive calls from UI | Go through repository layer |
| Adding packages without Chief Architect approval | Scope creep |

---

## Git Discipline

### Commit Format
```
type(scope): description

- detail 1
- detail 2
- dart analyze clean
```

### Types
- `feat` — new feature
- `fix` — bug fix
- `refactor` — code restructure without behavior change
- `docs` — documentation only
- `chore` — build/config changes
- `style` — formatting only

### Rules
- One logical change per commit
- Always run `dart analyze` before committing
- Never commit generated files (`*.g.dart`) without the source change
- Tag milestones: `v0.1-mvp-foundation`, `v0.2-insights`, etc.