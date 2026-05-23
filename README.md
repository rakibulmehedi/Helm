# Pocketa — Flutter Finance App for Freelancers

**Know what money is actually safe to spend.**

[![CI](https://github.com/rakibulmehedi/Pocketa-V2/actions/workflows/ci.yml/badge.svg)](https://github.com/rakibulmehedi/Pocketa-V2/actions/workflows/ci.yml)
[![Version](https://img.shields.io/github/v/release/rakibulmehedi/Pocketa-V2)](https://github.com/rakibulmehedi/Pocketa-V2/releases)
[![License](https://img.shields.io/github/license/rakibulmehedi/Pocketa-V2)](LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/rakibulmehedi/Pocketa-V2)](https://github.com/rakibulmehedi/Pocketa-V2/commits/main)
[![Flutter](https://img.shields.io/badge/Built%20with-Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7%2B-0175C2?logo=dart)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/State-Riverpod-7C4DFF)](https://riverpod.dev)

Pocketa is a Flutter finance app for freelancers with unstable income. Unlike traditional expense trackers that assume a fixed monthly salary, Pocketa calculates a single Safe-to-Spend number from received income minus tax reserve, upcoming fixed costs, and anxiety buffer — so you always know what is actually safe to spend, without anxiety.

> Built for Bangladeshi freelancers and anyone whose income does not arrive on a fixed schedule.

---

## Table of Contents

- [The Problem](#the-problem)
- [Key Features](#key-features)
- [Architecture](#architecture)
- [Current Status](#current-status)
- [Setup](#setup)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

---

## The Problem

Traditional finance apps assume you have a stable monthly salary. Freelancers do not. Money arrives in bursts — some received, some pending, some expected. Without clarity, you either overspend money that has not arrived yet, or under-spend money that is already in your pocket.

Pocketa solves this with a single, honest number: **your Safe-to-Spend balance**.

---

## Key Features

### Income Pipeline
Track every income entry across three status layers:
- **Expected** — invoiced or promised, not yet confirmed
- **Pending** — client confirmed, payment in transit
- **Received** — money in hand, safe to count

### Safe-to-Spend Hero
A single number on the dashboard — not your total balance — showing what you can actually spend after deducting:
- Tax reserve (your estimated rate, not spent yet)
- Upcoming fixed costs (due within 30 days)
- Anxiety buffer (your personal safety margin)

### Transparent Breakdown
Tap the Safe-to-Spend number to see the full math: every deduction, every reason, no black box.

### Transaction Tracking
Log daily expenses. Transactions reduce your liquid cash in real time.

### Fixed Cost Management
Define recurring costs (rent, subscriptions, tools). The engine deducts only what is due within 30 days.

### Tax Reserve Estimate
Set your tax rate (0–40%). Tax is reserved from gross received income, not from net cash. This is an estimate — not legal or tax advice.

### Anxiety Buffer
A personal safety margin you set. Keeps a cushion so you never feel financially exposed.

### Offline-First
No account required. All data is stored locally on device. Nothing leaves your phone.

---

## Architecture

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart 3.7+) |
| State Management | Riverpod (StateNotifier) |
| Local Storage | Hive (MVP; migration to Drift planned post-validation) |
| Navigation | GoRouter |
| Architecture | Feature-first clean architecture |
| Domain separation | Entity / Model split; zero Hive imports in domain layer |
| Engineering OS | Agentic engineering with full governance documentation |

### Folder Structure

```
lib/
├── config/           # Routes, constants
├── core/             # Shared themes, utils, widgets, local storage
├── features/
│   ├── dashboard/    # Dashboard screen
│   ├── income/       # Income pipeline (data, domain, presentation)
│   ├── safe_to_spend/ # Safe-to-Spend engine (calculator, settings, hero)
│   ├── splash/       # Splash screen
│   └── transactions/ # Transaction CRUD (data, domain, presentation)
└── l10n/             # Localization (English + Bengali)
```

---

## Current Status

**Phase 8 Complete — MVP core is production-grade.**

| Phase | Description | Status |
|---|---|---|
| Phase 7 | Freelancer Income Pipeline | Complete |
| Phase 7f | Domain / Storage Abstraction | Complete |
| Phase 8a | Safe-to-Spend Formula & Data Contract | Complete |
| Phase 8b | Calculation Engine (26 unit tests) | Complete |
| Phase 8c | Settings Screen | Complete |
| Phase 8d | Dashboard Hero | Complete |
| Phase 8e | UX Hardening | Complete |
| Phase 8f | Real Device QA + Validation Prep | Complete |
| Next | User Validation Sprint (5–10 real users, 30 days) | Planned |

See [docs/STATUS.md](docs/STATUS.md) for full current state.

---

## Setup

```bash
# 1. Clone
git clone https://github.com/rakibulmehedi/Pocketa-V2.git
cd Pocketa-V2

# 2. Install dependencies
flutter pub get

# 3. Generate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

### Analyzer

```bash
dart analyze
# Expected: No issues found!
```

### Tests

```bash
flutter test
# Expected: 26 tests passing
```

> If using FVM: replace `flutter` with `/path/to/fvm/versions/stable/bin/flutter`
> and `dart` with `/path/to/fvm/versions/stable/bin/dart`

---

## Documentation

Full documentation is organized under [`docs/`](docs/README.md).

| Category | Path |
|---|---|
| Product Brain | [docs/core/POCKETA_BRAIN.md](docs/core/POCKETA_BRAIN.md) |
| Architecture Rules | [docs/core/ARCHITECTURE_RULES.md](docs/core/ARCHITECTURE_RULES.md) |
| Roadmap | [docs/core/ROADMAP.md](docs/core/ROADMAP.md) |
| Safe-to-Spend Formula | [docs/specs/SAFE_TO_SPEND_MODEL.md](docs/specs/SAFE_TO_SPEND_MODEL.md) |
| Current Sprint | [docs/tracking/CURRENT_SPRINT.md](docs/tracking/CURRENT_SPRINT.md) |
| Project State | [docs/tracking/PROJECT_STATE.md](docs/tracking/PROJECT_STATE.md) |
| Decision Log | [docs/tracking/DECISION_LOG.md](docs/tracking/DECISION_LOG.md) |
| All Docs Index | [docs/README.md](docs/README.md) |

---

## Disclaimer

Tax reserve figures are estimates based on the rate you configure. Pocketa is not a tax advisor and does not provide legal or financial advice. Always consult a qualified professional for tax obligations.

---

## Author

**Rakibul Islam Mehedi** — Flutter Developer
[GitHub](https://github.com/rakibulmehedi) · [LinkedIn](https://www.linkedin.com/in/flutter-developer-rakibul-islam-mehedi/) · rakibulmehedi.dev@gmail.com

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT — see [LICENSE](LICENSE).
