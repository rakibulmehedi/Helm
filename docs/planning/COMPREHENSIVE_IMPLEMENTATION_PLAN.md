# HELM — Comprehensive Implementation & Upgrade Plan

> **Authority:** Final Product Doctrine, 100% Master Plan, 210-test suite, 0/0/0 analyze
> **Current State:** Phase 4 complete. Sprint A5 (Bangla + Release) pending. Beta readied.
> **Date:** 2026-06-13

---

## 0. Where We Stand

### Scorecard

| Dimension | Score | Target | Gap |
|---|---|---|---|
| Behavioral Nudge | 90/100 | 95/100 | 5 |
| UI/UX Design | 93/100 | 98/100 | 5 |
| Trust Layer | 30/35 | 35/35 | 5 |
| Test Coverage | 210 tests | 150+ | ✅ Exceeded |
| dart analyze | 0/0/0 | 0/0/0 | ✅ |
| Beta Blockers | 0 | 0 | ✅ |
| **Version Control** | **Main-only** | **Branch model** | **🔴 CRITICAL** |

### Completed Phases

| Phase | Status | Reference |
|---|---|---|
| Phase 1 — Auth + PIN + Session | COMPLETE | see `docs/tracking/CURRENT_SPRINT.md` |
| Phase 2 — Nudge + Analytics | COMPLETE | see `docs/tracking/CURRENT_SPRINT.md` |
| Phase 3 — Trust Layer (audit log, export, deletion) | COMPLETE | see `docs/tracking/CURRENT_SPRINT.md` |
| Phase 4 — S1-W4 Security + Input Validation | COMPLETE | see `docs/tracking/CURRENT_SPRINT.md` |

### What ships in the beta APK

- **Dashboard**: HelmRealityStack with 4 tiers, nudge evaluator, affirmation signals, next-best-action card, FAB.
- **Income Pipeline**: 3-state CRUD, status transitions, exclude-from-calculation toggle.
- **Safe-to-Spend**: Pure Dart calculator, tax reserve, 30-day fixed cost window, anxiety buffer (5-30%), breakdown sheet.
- **Onboarding**: 6-step flow, pain-point qualifier, "Set up later" skip, optional first pipeline entry.
- **Auth**: Magic Link screen, SessionEntity (Hive typeId 9), GoRouter 3-tier guard. Biometric stub pending `local_auth`.
- **Trust Layer**: PIN SHA-256+salt, immutable audit log (typeId 5), 5-file CSV export, account deletion.
- **Analytics**: 22+ events, LocalAnalyticsService, 30-min window heuristics, SharedPrefs deduplication.

### What does not ship

- Bangla localization (A5.1)
- Release APK build (A5.2-A5.5)
- Real auth backend (waiting legal L1-L7 + backend decision)
- Biometric auth (waiting `local_auth` — Decision 026)
- Multi-wallet, transfers, state colors, skeletons (Phase 5 — gated on beta)
- Invoice-Lite, tax reserve, paid tiers (Phase 6 — gated on V1 stable)

---

## 1. Phase 0 — Sprint A5: Beta Launch Readiness (~4h)

**Gate: Release APK runs on reference device. Bangla authored. All tests pass.**

| ID | Task | Dependencies | Agent |
|---|---|---|---|
| A5.1 | Author `app_bn.arb` — native Bangla, warm tone, all 15+ string keys | — | Gemini CLI |
| A5.2 | Build release APK — `flutter build apk --release`, signing, ProGuard/R8 Hive keep rules | A5.1 | Gemini CLI |
| A5.3 | Test on Samsung Galaxy A14 — all 6 onboarding steps, pipeline CRUD, S2S, PIN, export, deletion | A5.2 | Manual |
| A5.4 | Verify `minSdkVersion` in `android/app/build.gradle.kts` matches plugin requirements | A5.2 | Gemini CLI |
| A5.5 | Verify app icon + branded splash on device | A5.2 | Manual |

---

## 2. Sprint A5.5 — Version Control Infrastructure (~1.5h)

**Runs BEFORE APK distribution. Non-negotiable.**

| ID | Task | Detail |
|---|---|---|
| VCI-1 | Create `develop` branch from `main` | All future feature work commits here |
| VCI-2 | Create `release/v0.3-beta` from `main` | Beta APK built from this |
| VCI-3 | Tag the release | `v0.3-beta.1`, `pubspec.yaml` → `0.3.0-beta.1+1` |
| VCI-4 | Write `docs/governance/HOTFIX_PROTOCOL.md` | Hotfix flow: branch → fix → bump patch → tag → APK → backport. Timebox <4h |
| VCI-5 | Write `docs/governance/VERSIONING_POLICY.md` | MAJOR.MINOR.PATCH+build semver, beta suffix rules |
| VCI-6 | Configure branch protection on GitHub | `main` protected, `develop` open, `release/*` protected |

---

## 3. Phase 5 — V1 Features (Gated: Beta thresholds cleared)

**Thresholds (all required, 2+ miss = KILL):**
- Pipeline update compliance ≥85%
- Override-equivalent rate <5%
- 30-day retention ≥60%
- Onboarding completion ≥70%
- S2S comprehension ≥80%

**Estimated effort: ~15 hours across 3 sprints. Score target: Behavioral 93/100, UI/UX 95/100.**

### Group 5A — Multi-Wallet (~8h)

| ID | Task | Files | Dependencies |
|---|---|---|---|
| P5.1 | WalletEntity + Hive model (typeId 10) | `lib/features/wallet/domain/` + `data/models/` | — |
| P5.2 | WalletDataSource + WalletRepository + Hive box + CRUD | `lib/features/wallet/data/` | P5.1 |
| P5.3 | WalletProvider (Riverpod) — active wallet selector, balance aggregation | `lib/features/wallet/presentation/providers/` | P5.2 |
| P5.4 | Wallet picker UI in dashboard header | `lib/features/dashboard/presentation/widgets/` | P5.3 |
| P5.5 | Intra-wallet transfer (record-only, audit-logged) | `lib/features/wallet/presentation/views/` | P5.3 |
| P5.6 | Migrate S2S calc to use active wallet balance | `lib/features/safe_to_spend/` + providers | P5.3, P5.5 |

**Tests**: 15+ | **Files**: ~12 new, ~4 modified

### Group 5B — Dashboard State Colors (~3h)

| ID | Task | Files | Dependencies |
|---|---|---|---|
| P5.7 | Compute S2S state: Safe / Tight / AtRisk | `lib/features/dashboard/domain/` | — |
| P5.8 | State pill/chip in dashboard header — green/amber/red | `lib/features/dashboard/presentation/widgets/` | P5.7 |

**Tests**: 4+ | **Files**: ~2 new, ~1 modified

### Group 5C — UX Polish (~4h)

| ID | Task | Files | Dependencies |
|---|---|---|---|
| P5.9 | Duplicate-last-entry button on income list | `lib/features/income/presentation/views/` + providers | — |
| P5.10 | Skeleton screens for dashboard and income list on cold start | `lib/features/*/presentation/widgets/` | — |
| P5.11 | Better empty/error states — illustrated, retry button | `lib/features/*/presentation/views/` | — |
| P5.12 | Transactional ETA notifications | `lib/core/nudge/` + evaluator rules | Phase 3 notif infra |
| P5.13 | Manual USD→BDT conversion with sanity validation (rate bounds 80-130) | `lib/features/income/presentation/widgets/` | — |

**Tests**: 8+ | **Files**: ~6 new/modified

---

## 4. Phase 6 — V2 Features (Gated: V1 stable 2+ weeks + legal L5 + pricing ≥50% at ৳299)

**Estimated effort: ~20 hours across 4 sprints. Score target: Behavioral 95/100, UI/UX 98/100.**

### Group 6A — Invoice-Lite Sprint 1: Form + List (~5h)

| ID | Task | Dependencies |
|---|---|---|
| P6.1 | InvoiceEntity — sequential INVOICE-001, client, TIN, BDT-equivalent, status, dates | — |
| P6.2 | Invoice form screen | P6.1 |
| P6.3 | Invoice list screen — grouped by status | P6.2 |

### Group 6B — Invoice-Lite Sprint 2: PDF + Email (~5h)

| ID | Task | Dependencies |
|---|---|---|
| P6.4 | PDF generation — `pdf` package, logo, sequential number, TIN, breakdown | P6.3 |
| P6.5 | Email/send — attach PDF to share sheet via `share_plus` | P6.4 |
| P6.6 | Audit log invoice events (created/sent/paid) | P6.4 |

### Group 6C — Invoice-Lite Sprint 3: Pipeline Cascade (~5h)

| ID | Task | Dependencies |
|---|---|---|
| P6.7 | Sent invoice → auto-creates Expected pipeline entry | P6.5 |
| P6.8 | Marked paid → auto-creates Received pipeline entry | P6.7 |
| P6.9 | Client profile (name, email, currency, payment terms, notes) | P6.8 |
| P6.10 | Overdue invoice flagging + follow-up template copy | P6.9 |

### Group 6D — Tax Reserve (~3h)

| ID | Task | Dependencies |
|---|---|---|
| P6.11 | TaxReserveEntity — user-declared %, "not tax advice" disclaimer | — |
| P6.12 | Tax reserve UI in STS Settings — audit-logged | P6.11 |
| P6.13 | Tax reserve shown in S2S breakdown as separate deduction row | P6.12 |

### Group 6E — Paid Tier Activation (~2h)

| ID | Task | Dependencies |
|---|---|---|
| P6.14 | Feature gate system — Free / Pro (৳299) / Power (৳599) | — |
| P6.15 | Subscription screen — tier comparison, payment mock, restore | P6.14 |

### Group 6F — Final 100% Polish (~5h)

| ID | Task | Detail |
|---|---|---|
| P6.16 | Full a11y audit | Semantics, screen reader, focus traversal, 15+ screens |
| P6.17 | Dark mode pass | All HelmColors dark variants on OLED |
| P6.18 | Haptic audit | All 8 haptic sites, no double-fire |
| P6.19 | Semantics audit | Every interactive element: label + hint + trait |
| P6.20 | Performance | Widget rebuild count, provider disposal, list viewport |
| P6.21 | Test coverage to 300+ | Fill gaps in auth, wallet, invoice, nudge |
| P6.22 | Document system | Update all docs to V2 state |

---

## 5. Ongoing Infrastructure

### 5A — Documentation Hygiene

| Doc | Rule | When |
|---|---|---|
| `docs/tracking/CURRENT_SPRINT.md` | Must reflect current reality | Every phase group completion |
| `docs/tracking/TASKS.md` | Tasks `[x]` only when acceptance checklist satisfied | Every phase completion |
| `docs/tracking/DECISION_LOG.md` | Every architectural choice >5 min deliberation | At decision time |
| `docs/tracking/LESSONS.md` | Every surprise, mistake, insight | At discovery |
| `docs/tracking/PROJECT_STATE.md` | Frozen systems, stable modules, blocked items | Every phase completion |

### 5B — Commit Discipline

| Rule | Detail |
|---|---|
| Format | `type(scope): description` |
| Scope per commit | One logical change = one commit |
| Phase boundary | Each group ends with commit referencing TDD dispatch doc + task IDs |
| Beta hotfix | `fix(s2s): hero shows NaN on null fxRate — closes beta-issue-004` |
| Changelog trigger | Every `release/*` commit (non-revert) adds CHANGELOG.md entry |

### 5C — Quality Gates (Enforced Before Merge to `main`)

| Gate | Tool/Check |
|---|---|
| Analyze | `dart analyze` — 0/0/0 |
| Tests | `flutter test` — all pass (current: 210) |
| New typeId collision | `grep typeId lib/**/*.dart` — no duplicates |
| Route naming | No dead routes, all referenced |
| Docs updated | Relevant tracking docs show new state |

---

## 6. Risk Register

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Pipeline compliance <85% | High | **KILL** | Evaluate week 2. If <70%, simplify transitions. If <50%, invoke kill switch. |
| `local_auth` never approved | Medium | Low | PIN-only sufficient for MVP |
| Legal opinions delay auth backend | Medium | Medium | Mock backend ships in beta |
| Android minSdkVersion conflict | Low | Medium | Test in A5.2. Fallback: `compileSdk 35`, `minSdk 23` |
| Multi-wallet exceeds 15h estimate | Medium | Medium | Ship wallet picker (P5.4) first, defer P5.5-P5.6 if sliding |
| Wrong branch deployed | Medium | Critical | CI must tag every APK with commit SHA + branch + timestamp |

**Kill signals**: Pipeline compliance <50% at week 2 → KILL PHASE 5. Override rate >10% at week 3 → KILL PHASE 5.

---

## 7. Phase Dependency Graph

```
          ┌─────────────────────────┐
          │  A5: Bangla + Release    │  ← Phase 0
          └─────┬───────────┬────────┘
                │           │
    ┌───────────▼──┐  ┌─────▼──────────┐
    │  VCI-1..6    │  │  Legal L1-L7   │  ← Parallel
    └───────┬───────┘  └────────┬────────┘
            │                   │
            ▼                   ▼
┌─────────────────────┐  ┌──────────────┐
│  BETA (4 weeks)     │  │  Auth Backend │  ← Phase 5 gate
└──────────┬──────────┘  └──────┬────────┘
           │                   │
           ▼                   ▼
┌─────────────────────────────────────────┐
│  PHASE 5: V1 Features (~15h, 3 sprints) │
└──────────────────┬────────────────────────┘
                   │
                   ▼
      ┌────────────────────────┐
      │  V1 Stable (2+ weeks)  │
      └──────────────────┬─────┘
                         │
                         ▼
      ┌────────────────────────────────────┐
      │  PHASE 6: V2 Features (~20h, 4 sp) │
      └─────────────────────────────────────┘
```

---

## 8. Immediate Next Steps

1. Create branch model — `develop`, `release/v0.3-beta`, tags
2. Write HOTFIX_PROTOCOL.md and VERSIONING_POLICY.md
3. Start A5.1 — Bangla string authoring
4. A5.2 — release APK build
5. A5.3-A5.5 — device testing
6. Ship beta → setup tester feedback channel (WhatsApp/Telegram)
