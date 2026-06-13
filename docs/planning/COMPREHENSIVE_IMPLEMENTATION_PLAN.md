# POCKETA — Comprehensive Implementation & Upgrade Plan

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

### What ships in the beta APK

- **Dashboard**: PocketaRealityStack with 4 tiers (hero S2S, committed costs, reserve, pipeline hope). Nudge evaluator loop, affirmation signals, next-best-action card, one-time S2S hint, FAB → add pipeline entry.
- **Income Pipeline**: 3-state (expected/pending/received), add/edit/list/delete, status transitions with confirm sheet and haptic feedback, exclude-from-calculation toggle.
- **Safe-to-Spend**: Pure Dart calculator with tax reserve, 30-day fixed cost window, anxiety buffer (5-30%), em-dash fallback on failure, transparent breakdown sheet, "Not financial advice" disclaimer.
- **Onboarding**: 6-step conversational flow with pain-point qualifier (Bangla rephrase at 12s), "Set up later" skip, optional first pipeline entry.
- **Auth**: Magic Link screen (email→inbox→verify mock), SessionEntity (Hive typeId 9), GoRouter 3-tier guard (Magic Link→PIN→Home). Biometric stub awaiting `local_auth`.
- **Trust Layer**: PIN with SHA-256 + salt, immutable audit log (typeId 5), 5-file CSV export with native share sheet, full account deletion with PIN verification.
- **Analytics**: 22+ events (session, boundary, transactional), LocalAnalyticsService, 30-min window heuristics, SharedPrefs deduplication.

### What does not ship

- Bangla localization (A5.1)
- Release APK build (A5.2-A5.5)
- Real auth backend (waiting legal L1-L7 + backend stack decision)
- Biometric auth (waiting `local_auth` package approval — Decision 026)
- Multi-wallet, transfers, state colors, skeletons (Phase 5 — gated on beta)
- Invoice-Lite, tax reserve, paid tiers (Phase 6 — gated on V1 stable)
- Cloud sync (Phase 13+ — 12+ months away)

---

## 1. Phase 0 — Sprint A5: Beta Launch Readiness (~4h)

**Gate: Release APK runs on reference device. Bangla authored. All tests pass.**

| ID | Task | Dependencies | Agent |
|---|---|---|---|
| A5.1 | Author `app_bn.arb` — native Bangla, not Google Translate. Participate-style warm tone. All 15+ String keys. | — | Gemini CLI |
| A5.2 | Build release APK — `flutter build apk --release`, verify signing, verify ProGuard/R8 keep rules for Hive | A5.1 | Gemini CLI |
| A5.3 | Test on Samsung Galaxy A14 (or equivalent reference device) — all 6 onboarding steps, pipeline CRUD, S2S calc, PIN flow, export, deletion | A5.2 | Antigravity / manual |
| A5.4 | Verify `minSdkVersion` — `android/app/build.gradle.kts` must match Flutter plugin requirements (Hive, flutter_local_notifications) | A5.2 | Gemini CLI |
| A5.5 | Verify app icon + branded splash display correctly on device | A5.2 | Manual |

**New files**: `lib/l10n/app_bn.arb` (or equivalent ARB path)

---

## 2. Sprint A5.5 — Version Control Infrastructure (~1.5h)

**This runs BEFORE the APK is distributed. Non-negotiable.**

| ID | Task | Files/Docs | Detail |
|---|---|---|---|
| VCI-1 | Create `develop` branch from `main` | Branch | `git branch develop main`. All future feature work commits here. |
| VCI-2 | Create `release/v0.3-beta` branch from `main` | Branch | `git checkout -b release/v0.3-beta main`. Beta APK built from this. |
| VCI-3 | Tag the release | Tag | `git tag -a v0.3-beta.1 -m "Closed beta release 1"`. `pubspec.yaml` → `0.3.0-beta.1+1`. |
| VCI-4 | Write HOTFIX_PROTOCOL.md | `docs/governance/HOTFIX_PROTOCOL.md` | Tester reports bug → `hotfix/` from `release/v0.3-beta` → fix → bump patch → new tag+APK → backport to `develop`. Timebox: <4h. |
| VCI-5 | Write VERSIONING_POLICY.md | `docs/governance/VERSIONING_POLICY.md` | MAJOR.MINOR.PATCH+build (semver). Beta suffix. When to bump each. Co-locate with CI. |
| VCI-6 | Configure branch protection | GitHub repo settings | `main` protected — no direct pushes. PR + analyze + test gate. `develop` open for pushes. `release/*` protected — only hotfix/PR merges. |

**Why this matters**: Without these steps, the beta APK is a snapshot of `main` that becomes invalid the moment you fix any bug. A hotfix requires reverting or rebasing — both destructive on a shared branch with no safety net.

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
| P5.1 | WalletEntity + Hive model (typeId 10) — name, currency, balance, icon, order | `lib/features/wallet/domain/` + `data/models/` | — |
| P5.2 | WalletDataSource + WalletRepository + Hive box + CRUD | `lib/features/wallet/data/` | P5.1 |
| P5.3 | WalletProvider (Riverpod) — active wallet selector, balance aggregation | `lib/features/wallet/presentation/providers/` | P5.2 |
| P5.4 | Wallet picker UI in dashboard header — chip row or dropdown, shows active wallet name + BDT balance | `lib/features/dashboard/presentation/widgets/` | P5.3 |
| P5.5 | Intra-wallet transfer (record-only, audit-logged). No actual movement. Screen: from/to wallet, amount, date, note. | `lib/features/wallet/presentation/views/` | P5.3 |
| P5.6 | Migrate Safe-to-Spend calc to use active wallet balance instead of global received income | `lib/features/safe_to_spend/` + providers | P5.3, P5.5 |

**Tests**: 15+ (entity, model adapter, CRUD, provider, wallet picker widget, transfer screen, calculator integration)
**Files affected**: ~12 new source files, ~4 modified

### Group 5B — Dashboard State Colors (~3h)

| ID | Task | Files | Dependencies |
|---|---|---|---|
| P5.7 | Compute S2S state: `safeToSpend > 0 → Safe`, `rawSafeToSpend > -buffer → Tight`, `<= -buffer → AtRisk` | `lib/features/dashboard/domain/` | — |
| P5.8 | Display state pill/chip in dashboard header — green/amber/red with label. Persist across rebuilds. | `lib/features/dashboard/presentation/widgets/` | P5.7 |

**Tests**: 4+ (state computation matrix, widget renders correct color per state)
**Files affected**: ~2 new source files, ~1 modified

### Group 5C — UX Polish (~4h)

| ID | Task | Files | Dependencies |
|---|---|---|---|
| P5.9 | Duplicate-last-entry button on income list — pre-fills form with previous entry's client/project/amount/currency | `lib/features/income/presentation/views/` + providers | — |
| P5.10 | Skeleton screens for dashboard and income list on cold-start load (Hive). Use shimmer pattern. | `lib/features/*/presentation/widgets/` | — |
| P5.11 | Better empty/error states — illustrated empty state per section (pipeline, wallet, fixed costs), retry button on calc failure | `lib/features/*/presentation/views/` | — |
| P5.12 | Transactional ETA notifications — push when expected income date passes threshold | `lib/core/nudge/` + evalutor rules | Phase 3 notif infra |
| P5.13 | Manual USD→BDT conversion with sanity validation (rate bounds 80-130 BDT per USD) | `lib/features/income/presentation/widgets/` | — |

**Tests**: 8+ (duplicate logic, skeleton renders, conversion validation bounds)
**Files affected**: ~6 new/modified

---

## 4. Phase 6 — V2 Features (Gated: V1 stable 2+ weeks + legal L5 + pricing ≥50% at ৳299)

**Estimated effort: ~20 hours across 4 sprints. Score target: Behavioral 95/100, UI/UX 98/100.**

### Group 6A — Invoice-Lite Sprint 1: Form + List (~5h)

| ID | Task | Dependencies |
|---|---|---|
| P6.1 | InvoiceEntity — sequential INVOICE-001 numbering, client name, TIN, BDT-equivalent amount, status (draft/sent/paid/overdue), issue date, due date | — |
| P6.2 | Invoice form screen — client, amount, due date, notes. Generates INVOICE-{N+1} on save. | P6.1 |
| P6.3 | Invoice list screen — grouped by status, tap to view/edit | P6.2 |

### Group 6B — Invoice-Lite Sprint 2: PDF + Email (~5h)

| ID | Task | Dependencies |
|---|---|---|
| P6.4 | PDF generation — `pdf` package, template with logo, sequential number, TIN, breakdown, bank details | P6.3 |
| P6.5 | Email/send — attach PDF to share sheet (reuse `share_plus`), email intent | P6.4 |
| P6.6 | Audit log invoice events (created/sent/paid) | P6.4 |

### Group 6C — Invoice-Lite Sprint 3: Pipeline Cascade (~5h)

| ID | Task | Dependencies |
|---|---|---|
| P6.7 | Sent invoice → auto-creates Expected pipeline entry | P6.5 |
| P6.8 | Marked paid → auto-creates Received pipeline entry (if BDT) | P6.7 |
| P6.9 | Client profile (name, email, currency, payment terms, notes) | P6.8 |
| P6.10 | Overdue invoice flagging + follow-up template copy | P6.9 |

### Group 6D — Tax Reserve (~3h)

| ID | Task | Dependencies |
|---|---|---|
| P6.11 | TaxReserveEntity — user-declared %, applied to gross income, NOT to S2S. Explicit "not tax advice" disclaimer. | — |
| P6.12 | Tax reserve UI in STS Settings — separate from existing tax rate slider. Audit-logged. | P6.11 |
| P6.13 | Tax reserve shown in S2S breakdown as separate deduction row with disclaimer label | P6.12 |

### Group 6E — Paid Tier Activation (~2h)

| ID | Task | Dependencies |
|---|---|---|
| P6.14 | Feature gate system — Free / Pro (৳299) / Power (৳599). Feature flags per tier. | — |
| P6.15 | Subscription screen — tier comparison table, payment mock, restore purchases | P6.14 |

### Group 6F — Final 100% Polish (~5h)

| ID | Task | Detail |
|---|---|---|
| P6.16 | Full a11y audit — Semantics, screen reader, focus traversal across all screens. 15+ screens. |
| P6.17 | Dark mode pass — verify all PocketaColors dark variants render correctly on OLED. |
| P6.18 | Haptic audit — all 8 haptic sites fire on correct gestures. No double-fire. |
| P6.19 | Semantics audit — every interactive element has label + hint + trait. |
| P6.20 | Performance — widget rebuild count, provider disposal, list viewport optimization |
| P6.21 | Test coverage to 300+ — fill gaps in auth, wallet, invoice, nudge |
| P6.22 | Document system — update all docs to reflect V2 state |

---

## 5. Ongoing Infrastructure (Throughout All Phases)

### 5A — Documentation Hygiene

| Doc | Rule | When |
|---|---|---|
| `docs/tracking/CURRENT_SPRINT.md` | Must reflect current reality, not previous phase state | Every commit that completes a phase group |
| `docs/tracking/TASKS.md` | Tasks are `[x]` ONLY when acceptance checklist is satisfied — not before | Every phase completion |
| `docs/tracking/DECISION_LOG.md` | Every architectural choice >5 min deliberation gets an entry | At decision time |
| `docs/tracking/LESSONS.md` | Every surprise, mistake, or "if I knew then" insight | At discovery |
| `docs/tracking/PROJECT_STATE.md` | Frozen systems, stable modules, blocked items | Every phase completion |

Known stale items to fix immediately:
- `CURRENT_SPRINT.md` §0 table marks Phase 3 as PENDING — it's COMPLETE since June 12
- `TASKS.md` Phase 4 section has P4.20-P4.28 unchecked — these were completed in D1.11 and Phase 4E

### 5B — Commit Discipline

| Rule | Detail |
|---|---|
| Format | `type(scope): description` — `feat(wallet): add multi-wallet CRUD with Hive typeId 10` |
| Scope per commit | One logical change = one commit. A phase group is 3-8 commits, not 1. |
| Phase boundary | Each phase group ends with a commit message referencing the TDD dispatch doc and task IDs |
| Beta hotfix | `fix(s2s): hero shows NaN on null fxRate — closes beta-issue-004` |
| Changelog trigger | Every commit to `release/*` that isn't a revert must add a CHANGELOG.md entry |

Target: ~3-5 commits per phase group, each atomic and reviewable.

### 5C — Quality Gates (Enforced Before Merge to `main`)

| Gate | Tool/Check |
|---|---|
| Analyze | `dart analyze` — 0/0/0 |
| Tests | `flutter test` — all pass (current: 210) |
| New typeId collision | `grep typeId lib/**/*.dart` — no duplicates beyond HIVE_TYPEID_REGISTRY.md |
| Route naming | `grep RouteNames route_names.dart` — no dead routes, all referenced |
| Docs updated | Relevant tracking docs show the new state |

---

## 6. Risk Register

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Beta tester abandons after week 1 (no push notifications in MVP) | High | High | Phase 3 nudge evaluator still runs in-app. Ship push before 2nd tester batch if engagement <50%. |
| Pipeline update compliance <85% (manual friction kills data freshness) | High | **KILL** | Evaluate early (week 2). If <70%, invest in simplified status transition. If <50%, invoke kill switch. |
| `local_auth` package never approved | Medium | Low | PIN-only is sufficient for MVP. Document as known limitation. |
| Legal opinions (L1-L7) delay real auth backend past beta window | Medium | Medium | Mock backend ships in beta. Real backend is Phase 5 concern, not Phase 0. |
| Android minSdkVersion conflict with flutter_local_notifications | Low | Medium | Test early in A5.2. Fallback: `compileSdk 35`, `minSdk 23`. |
| Multi-wallet complexity exceeds 15h estimate | Medium | Medium | Ship wallet picker first (P5.4). Defer intra-wallet transfer (P5.5-P5.6) to post-V1 if sliding. |
| Branch confusion causes beta APK corruption (wrong branch deployed) | Medium | Critical | CI must tag every beta APK with commit SHA + branch name + build timestamp. Automate APK filename. |

**Kill signals**:
- Pipeline compliance <50% at beta week 2 → **KILL PHASE 5**. Do not ship V1.
- Override-equivalent rate >10% at beta week 3 → S2S trust model is failing → **KILL PHASE 5**.
- 3+ hotfixes in first beta week → branch model or QA process is broken → pause, fix infra, resume.

---

## 7. Phase Dependency Graph

```
                  ┌─────────────────────────┐
                  │  A5: Bangla + Release    │  ← Phase 0
                  └─────┬───────────┬────────┘
                        │           │
            ┌───────────▼──┐  ┌─────▼──────────┐
            │  VCI-1..6    │  │  Legal L1-L7   │  ← Parallel
            │  Branch/Tag   │  │  (external)    │
            └───────┬───────┘  └────────┬────────┘
                    │                   │
                    ▼                   ▼
        ┌─────────────────────┐  ┌──────────────┐
        │  BETA (4 weeks)     │  │  Auth Backend │  ← Phase 5 gate
        │  5 thresholds       │  │  Decision     │
        └──────────┬──────────┘  └──────┬────────┘
                   │                   │
                   ▼                   ▼
        ┌─────────────────────────────────────────┐
        │  PHASE 5: V1 Features (~15h, 3 sprints) │
        │  Multi-wallet → State Colors → Polish    │
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
              │  Invoice-Lite → Tax → Tiers → 100%  │
              └─────────────────────────────────────┘
```

---

## 8. Immediate Next Steps (This Session)

1. **Hotfix the stale docs** — `CURRENT_SPRINT.md` Phase 3 status, `TASKS.md` Phase 4 checkboxes
2. **Create branch model** — `develop`, `release/v0.3-beta`, tags
3. **Write HOTFIX_PROTOCOL.md** — 1-pager in `docs/governance/`
4. **Write VERSIONING_POLICY.md** — semver rules for the project
5. **Start A5.1** — Bangla string authoring
6. **After A5.1 → A5.2** — release APK build
7. **After A5.2 → A5.3-A5.5** — device testing
8. **Ship beta**
9. **Day 1 of beta → setup tester feedback channel** (WhatsApp/Telegram group)
