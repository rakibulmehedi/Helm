# Pocketa — Current Status

> Last updated: 2026-05-23

---

## Current Phase

**Post-Phase 8 — User Validation Sprint**

Phase 8 (Safe-to-Spend Engine) is complete and production-grade. The next milestone is real-user validation: 5–10 freelancers using the app for 30 days.

---

## Completed Milestones

| Phase | Description | Completed |
|---|---|---|
| Foundation | Scaffolding, Hive, Riverpod, GoRouter, onboarding, transaction CRUD | 2025-08-18 |
| Phase 7 (7a–7e) | Freelancer income pipeline: domain, data layer, entry UI, list, dashboard, status transitions | 2026-05-22 |
| Phase 7f | Domain abstraction: TransactionEntity, zero Hive in domain/presentation | 2026-05-22 |
| Phase 8a | Safe-to-Spend formula spec and data contract | 2026-05-23 |
| Phase 8b | Calculation engine: pure Dart, 26 unit tests | 2026-05-23 |
| Phase 8c | Settings screen: tax rate, anxiety buffer, fixed costs CRUD | 2026-05-23 |
| Phase 8d | Dashboard Safe-to-Spend Hero (replaces raw balance) | 2026-05-23 |
| Phase 8e | UX hardening: critical bug fixes, deduction coloring, transparency rows | 2026-05-23 |
| Phase 8f | Real device QA checklist, scenario matrix, validation scripts, metrics | 2026-05-23 |

---

## Next Phase

**User Validation Sprint** (Decision 013)

- 5–10 real Bangladeshi freelancers
- 30-day usage observation
- Structured interviews using [docs/validation/FREELANCER_USER_INTERVIEW_QUESTIONS.md](validation/FREELANCER_USER_INTERVIEW_QUESTIONS.md)
- Success metrics defined in [docs/validation/VALIDATION_METRICS.md](validation/VALIDATION_METRICS.md)

Post-validation gate: if validated, proceed to Phase 9 (Subscription Leakage Radar). If not, iterate on core Safe-to-Spend flow.

---

## QA Status

| Type | Status |
|---|---|
| CI (GitHub Actions) | Configured — runs on push/PR to main |
| Unit tests (SafeToSpendCalculator) | 26 passing |
| dart analyze | Clean — 0 errors, 0 warnings, 0 infos |
| Simulated QA | Complete — see [docs/qa/PHASE_8_SIMULATED_QA_REPORT.md](qa/PHASE_8_SIMULATED_QA_REPORT.md) |
| Real device QA | Checklist prepared — human execution pending |
| User validation | Not yet started |

---

## Validation Status

- Interview questions: Ready ([docs/validation/FREELANCER_USER_INTERVIEW_QUESTIONS.md](validation/FREELANCER_USER_INTERVIEW_QUESTIONS.md))
- Founder validation script: Ready ([docs/validation/FOUNDER_VALIDATION_SCRIPT.md](validation/FOUNDER_VALIDATION_SCRIPT.md))
- Success metrics: Defined ([docs/validation/VALIDATION_METRICS.md](validation/VALIDATION_METRICS.md))
- Participants recruited: Not yet started

---

## Known Limitations

| Limitation | Notes |
|---|---|
| No multi-currency conversion | USD income is excluded from STS with transparency note; BDT only |
| No Hive encryption at rest | Relies on OS device security; encryption planned for later phase |
| No PIN/biometric lock | Not implemented in MVP |
| Categories are placeholder labels | No formal category entity yet |
| No cloud sync | Deferred; requires authentication design decision |
| No virtual wallets | Future phase |
| Tax reserve is estimate only | Not legal/tax advice; user-configured rate |

---

## Architecture Freeze

The following systems are frozen and must not be heavily refactored without explicit approval:

- Transaction provider structure
- Hive architecture (migration to Drift deferred — Decision 010)
- Routing structure
- Localization system

---

## Key Decisions

See [docs/tracking/DECISION_LOG.md](tracking/DECISION_LOG.md) for full decision history.

Notable decisions:
- **Decision 010** — Hive migration deferred until post-validation
- **Decision 011** — External positioning pivot: Freelancer Finance OS, not expense tracker
- **Decision 013** — User validation sprint before Phase 9
- **Decision 014** — Safe-to-Spend formula locked
