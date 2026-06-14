<p align="center">
  <img src="assets/banner.png" alt="Helm safe-to-spend cash flow tracker banner" width="100%">
</p>

# Helm - Safe-to-spend cash flow clarity for freelancers

[![CI](https://github.com/rakibulmehedi/Helm-V2/actions/workflows/ci.yml/badge.svg)](https://github.com/rakibulmehedi/Helm-V2/actions/workflows/ci.yml)
[![Version](https://img.shields.io/github/v/release/rakibulmehedi/Helm-V2)](https://github.com/rakibulmehedi/Helm-V2/releases)
[![License](https://img.shields.io/github/license/rakibulmehedi/Helm-V2)](https://github.com/rakibulmehedi/Helm-V2/blob/main/LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.7%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7%2B-0175C2?logo=dart)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/State-Riverpod-7C4DFF)](https://riverpod.dev)

Freelancers overspend when pipeline income feels real before cash lands in hand. Helm is a Flutter finance app and safe-to-spend cash flow tracker for Bangladeshi USD-earning freelancers. It models expected, pending, and received income, subtracts fixed costs, safety buffer, and estimated tax, then shows one trusted BDT number you can act on now.

> Built for freelancers who earn in USD, spend in BDT, and need clarity faster than a spreadsheet can give it.

## Table of Contents

- [What Helm does](#what-helm-does)
- [Why Helm is different](#why-helm-is-different)
- [Safe-to-spend calculator](#safe-to-spend-calculator)
- [Income pipeline workflow](#income-pipeline-workflow)
- [Getting started](#getting-started)
- [Flutter app architecture](#flutter-app-architecture)
- [Current status](#current-status)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [Disclaimer](#disclaimer)
- [License](#license)

## What Helm does

Helm answers one operational question: how much money is actually safe to spend right now?

| Need | How Helm handles it |
|---|---|
| Future income without false confidence | Tracks expected, pending, and received income separately |
| Spendable cash you can trust | Computes a Safe-to-Spend number from current financial reality |
| Recurring obligations | Deducts fixed costs that are due soon |
| Financial stress margin | Applies an editable safety buffer |
| Trust and auditability | Keeps audit logs, CSV export, PIN protection, and account deletion in product |

## Why Helm is different

Most personal finance apps tell freelancers what happened. Helm is built to tell them what is safe to do next.

| Problem | Spreadsheet or generic tracker | Helm |
|---|---|---|
| USD income, BDT spending | Manual formulas, easy to drift | Designed around dual-currency freelancer cash flow |
| Pending money vs real cash | Often mixed into one mental balance | Three-state income pipeline keeps them separate |
| Safe spending decision | Requires manual subtraction | One computed Safe-to-Spend number |
| Trust in numbers | Hidden logic or fragile formulas | Transparent breakdown, audit trail, exportable data |

## Safe-to-spend calculator

Helm centers product experience around one trusted figure instead of raw balance.

- Safe-to-Spend hero metric, computed in real time and never stored
- Breakdown drawer that shows every deduction behind spendable cash
- Fixed cost registry for recurring obligations
- Adjustable safety buffer from 5% to 30%
- Pending and expected income excluded from primary spendable cash
- Fallback display of `—` when calculation cannot be trusted
- Trust layer support through PIN entry, audit log, CSV export, and account deletion

## Income pipeline workflow

Income stays visible without being mistaken for cash in hand.

| Status | Meaning | Included in Safe-to-Spend |
|---|---|---|
| Expected | Promised or invoiced, not yet confirmed | No |
| Pending | Confirmed and in transit | No |
| Received | Money in hand | Yes |

Current workflow covers:
- create and edit income entries with timing and FX context
- move entries through expected, pending, and received states
- update the most common transition quickly from pending to received
- keep financial edits traceable through the audit log

## Getting started

### Prerequisites

- Flutter SDK with Dart 3.7+
- Android Studio, Xcode, or connected device
- Optional: FVM for version pinning

### Run locally

```bash
git clone https://github.com/rakibulmehedi/Helm-V2.git
cd Helm-V2
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

First run flow:
1. Open welcome and onboarding flow
2. Complete setup inputs
3. Create PIN
4. Land on home cockpit with Safe-to-Spend hero

### Quality checks

```bash
dart analyze
flutter test
```

### Release build (Android)

Release builds must use the obfuscation script so identifiers are stripped from
binaries and debug symbols are preserved separately for crash deobfuscation:

```bash
# 1. Configure your release keystore in android/key.properties
# 2. Run the release build script
./scripts/build_release_android.sh
```

> Keep `android/key.properties` and the generated `symbols/` directory private.
> `symbols/` is required to symbolicate production crash reports.

### Common setup notes

- If you use FVM, replace `flutter` with `fvm flutter` and `dart` with `fvm dart`.
- If generated Hive adapters are stale, rerun `dart run build_runner build --delete-conflicting-outputs`.

## Flutter app architecture

| Layer | Stack |
|---|---|
| Framework | Flutter |
| Language | Dart 3.7+ |
| State management | Riverpod |
| Local storage | Hive |
| Navigation | GoRouter |
| Architecture style | Feature-first, offline-first clean architecture |

```text
lib/
├── application/
├── config/router/
├── core/
├── features/
│   ├── account/
│   ├── audit_log/
│   ├── auth/
│   ├── dashboard/
│   ├── export/
│   ├── income/
│   ├── onboarding/
│   ├── safe_to_spend/
│   ├── splash/
│   └── transactions/
└── l10n/
```

## Current status

Helm is in doctrine-aligned MVP refinement. Trust layer foundation is complete, beta instrumentation is next.

| Area | Status |
|---|---|
| UX canon implementation through Sprint 6 | Complete |
| D1 trust layer | Complete |
| PIN security patch | Complete |
| Audit log | Complete |
| CSV export | Complete |
| Account deletion | Complete |
| D2 beta instrumentation | Pending |
| D3 closed beta readiness | Pending |

## Documentation

Key project docs:

| Topic | Path |
|---|---|
| Product brain | [docs/core/HELM_BRAIN.md](docs/core/HELM_BRAIN.md) |
| Final doctrine | [docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md](docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md) |
| Architecture rules | [docs/core/ARCHITECTURE_RULES.md](docs/core/ARCHITECTURE_RULES.md) |
| Roadmap | [docs/core/ROADMAP.md](docs/core/ROADMAP.md) |
| Current sprint | [docs/tracking/CURRENT_SPRINT.md](docs/tracking/CURRENT_SPRINT.md) |
| Project state | [docs/tracking/PROJECT_STATE.md](docs/tracking/PROJECT_STATE.md) |
| Contributing guide | [CONTRIBUTING.md](CONTRIBUTING.md) |
| Docs index | [docs/README.md](docs/README.md) |

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) before changing code or docs. Helm uses spec-first development, strict architecture boundaries, and documentation-driven workflow.

## Disclaimer

Helm provides automated financial tracking assistance, not legal, tax, or professional financial advice.

## License

MIT. See [LICENSE](LICENSE).
