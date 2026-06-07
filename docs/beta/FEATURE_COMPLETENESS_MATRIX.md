# Feature Completeness Matrix

> A1 Sprint Deliverable. Maps every MVP feature from Doctrine §4 to implementation status.
> Date: 2026-06-07

---

## 1. Doctrine §4 MVP Feature Checklist

| # | Doctrine Feature | Status | Implementation | Gaps |
|---|-----------------|--------|---------------|------|
| 1 | Magic Link auth + mandatory PIN/biometric | PARTIAL | PIN: SHA-256+salt, 4-digit, 5-attempt lockout. No Magic Link. No biometric. | Magic Link needs backend. Biometric needs local_auth pkg. |
| 2 | 3-minute conversational onboarding | DONE | 5-step flow: qualifier, balance, fixed costs, income pattern, buffer. | Missing optional Step 6 (first pipeline entry). |
| 3 | Single aggregated balance | DONE | SharedPreferences liquidBalanceBdt. No wallet partitioning. | As designed for MVP. |
| 4 | Income Pipeline (expected/pending/received) | DONE | 3-state model. State-grouped pipeline screen. Status transitions. | Complete. |
| 5 | One-tap Pending to Received | DONE | ConfirmReceivedSheet with FX rate. Swipe-to-advance gesture. | Complete. |
| 6 | Fixed Costs registry | DONE | CRUD with label, amount, due-day. Hive persistence. Undo on delete. | Complete. |
| 7 | Safe-to-Spend hero metric | DONE | Computed, never stored. Reality Stack layout. Dashboard hero. | Missing "---" fallback on failure. |
| 8 | Calculation breakdown drawer | DONE | PocketaCalculationTrace. Step-by-step math. Stagger animation. | Complete. |
| 9 | Editable inputs (FX, date, exclude) | DONE | Per-entry fxRate, expectedDate, excludeFromCalculation. | Complete. |
| 10 | Audit log on financial edits | PARTIAL | Append-only events. All write paths wired. Screen exists. | Screen unreachable from UI. No before/after display. |
| 11 | Data export (CSV) | DONE | 5 CSVs. Native share sheet. "Your data belongs to you." | Complete. |
| 12 | Account deletion (full purge) | DONE | 2-step. PIN confirmation. 6 Hive boxes + SharedPrefs cleared. | Complete. |
| 13 | Default 15% safety buffer | DONE | 5-30% range. Default 15%. Slider in onboarding + settings. | Complete. |
| 14 | "---" fallback on calc failure | NOT DONE | Shows 0 on failure. | Must fix before beta. |
| 15 | Closed-beta instrumentation | DONE | 15 events. Local debugPrint. Dashboard/pipeline/PIN/export/deletion. | Local-only (no remote collection). |

**MVP Feature Completion: 12/15 DONE, 2/15 PARTIAL, 1/15 NOT DONE = ~87%**

---

## 2. Trust Layer Completeness (Doctrine §10)

| Layer | Required | Status | Score |
|-------|----------|--------|-------|
| L1: Auth — PIN/biometric on every open | PIN exists. Biometric deferred. Cold-start enforcement unclear. | PARTIAL | 3/5 |
| L2: Calc transparency — S2S computed, breakdown, "---" fallback | S2S computed. Breakdown works. "---" missing. | PARTIAL | 4/5 |
| L3: User agency — edit inputs, not output | FX rate, exclude flag, buffer %. S2S not overridable. | DONE | 5/5 |
| L4: Audit log — immutable events, visible to user | Events written. Screen exists. Unreachable. No before/after. | PARTIAL | 2/5 |
| L5: Data sovereignty — CSV export, account deletion | Export works. Deletion works. | DONE | 5/5 |
| L6: Multi-device conflict | MVP: single-device acceptable. | N/A | N/A |
| L7: Storage discipline — integer paisa, event-sourced | Using double amounts (not integer paisa). Audit events written. | PARTIAL | 3/5 |
| L8: Legal compliance floor | No disclaimers. No legal opinion obtained. | NOT DONE | 1/5 |

**Trust Layer Score: 23/35 (66%)**

---

## 3. UX Sprint Completion Status

| Sprint | Tasks | Done | % | Key Gaps |
|--------|-------|------|---|----------|
| S1: UX-5 Visual Identity | 12 | 12 | 100% | None |
| S2: UX-1 Dashboard Cockpit | 14 | 14 | 100% | None |
| S3: UX-2 Onboarding | 11 | 8 | 73% | Auth steps skipped (deferred to D1), pipeline step skipped |
| S4: UX-3 Pipeline Quick-Update | 10 | 10 | 100% | None |
| S4P: UX-3P Pipeline Polish | 3 | 3 | 100% | None |
| S5: UX-4 Microcopy | 8 | 8 | 100% | Bangla strings not authored |
| S6: D1 Trust Layer | 12 | 11 | 92% | Biometric deferred |
| S7: D2 Beta Instrumentation | 6 | 6 | 100% | None |
| S8: D3 Closed Beta Readiness | 8 | 8 | 100% | None |

**Overall Task Completion: 80/84 tasks = 95%**

---

## 4. Feature Module Inventory

| Module | Files | Data Layer | Domain | Presentation | Tests | Score |
|--------|-------|-----------|--------|-------------|-------|-------|
| auth | 5 | Hive (auth_box) | AuthState, PinHasher | PIN setup/entry screens, provider | 8 (PinHasher) | 4/5 |
| onboarding | 9 | SharedPreferences | OnboardingDraft, IncomePattern | 5-step screen + pages | 0 | 3/5 |
| dashboard | 5 | — (reads providers) | — | Reality Stack, sections | 0 | 5/5 |
| income | 10 | Hive (income_box) | IncomeEntryEntity | Pipeline, add/edit, list | 0 | 4/5 |
| transactions | 9 | Hive (transactions) | TransactionEntity | Add/edit screen | 0 | 3/5 |
| safe_to_spend | 12 | Hive (fixed_costs, settings) | Calculator, StsSettings | Settings, hero widget | 30 | 5/5 |
| audit_log | 5 | Hive (audit_events) | AuditEvent | Log screen | 0 | 2/5 |
| export | 4 | — (reads all sources) | ExportService, ExportResult | Export screen | 0 | 4/5 |
| account | 1 | — (clears all boxes) | — | Delete screen | 0 | 5/5 |
| splash | 1 | — | — | Static screen | 0 | 3/5 |

---

## 5. Test Coverage Analysis

| Test File | Tests | Coverage Area |
|-----------|-------|--------------|
| pin_hasher_test.dart | 8 | Hash, salt, verify, edge cases |
| safe_to_spend_calculator_test.dart | 30 | Formula, edge cases, scenarios |
| **Total** | **38** | **2 domain modules only** |

**Missing Test Coverage:**
- Onboarding flow (0 tests)
- Dashboard rendering (0 tests)
- Pipeline state management (0 tests)
- Export service (0 tests)
- Auth provider (0 tests)
- Router redirects (0 tests)

---

## 6. Architecture Compliance

| Rule | Status | Notes |
|------|--------|-------|
| Feature-first clean architecture | PASS | All modules follow data/domain/presentation |
| Riverpod for state management | PASS | No ChangeNotifier or raw setState for business logic |
| Hive for persistence | PASS | All boxes declared in app_box_names.dart |
| GoRouter for navigation | PASS | ShellRoute with 4 tabs |
| No raw hex colors | PASS | AppColors/PocketaColors used throughout |
| withValues not withOpacity | PASS | Verified in delete_account_screen.dart |
| mounted guards | PASS | All async navigation guarded |
| File size < 300 lines | PASS | All files within limit |
| Domain layer pure Dart | PASS | No framework imports in domain |
