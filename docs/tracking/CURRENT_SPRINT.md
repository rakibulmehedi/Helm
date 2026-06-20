# CURRENT SPRINT

> Details for the active sprint and immediate priorities.

## 0. Master Plan Context

**Reference:** `docs/planning/100_PERCENT_MASTER_PLAN.md` — canonical 6-phase plan, adopted 2026-06-12.

Helm is on a 6-phase journey from current state (Behavioral 62/100, UI/UX 78/100) to 100% maturity (Behavioral 95/100, UI/UX 98/100, Trust Layer 35/35). Current position: Phase 0 (Beta Launch Readiness). Next: Phase 1 (Behavioral Foundation).

| Phase | Status | Score Target | Effort |
|-------|--------|-------------|--------|
| 0 — Beta Launch Readiness (A5) | 🔄 IN PROGRESS | — | ~4h |
| VCI — Version Control Infrastructure | 🔲 PENDING | Branch model + hotfix protocol | ~1.5h |
| 1 — Behavioral Foundation | ✅ COMPLETE | 62→68 behavioral, 78→83 UI/UX | ~6h |
| 2 — Analytics Infrastructure | ✅ COMPLETE | 68→76 behavioral, 83→89 UI/UX | ~8h |
| 3 — Notification System | ✅ COMPLETE (was incorrectly marked PENDING) | 76→82 behavioral | ~12h |
| 4 — Doctrine Gap Closure | ✅ COMPLETE | 82→90 behavioral, 89→93 UI/UX | ~20h |
| 5 — V1 Features (gated) | 🔲 BLOCKED — beta thresholds | 90→93 behavioral, 93→95 UI/UX | ~15h |
| 6 — V2 Features (gated) | 🔲 BLOCKED — V1 stable + legal + pricing | 93→95 behavioral, 95→98 UI/UX | ~20h |

## 1. Active Sprint

**Sprint S1 — Security Hardening (Adversarial Audit Remediation):**
Status: **🔄 IN PROGRESS** — 2026-06-14. 68/97 vulnerability tasks verified done; 29 pending. Depends on: Phase 4 complete (✅).

> **Audit:** `.commandcode/adversarial_audit_report.md` — 12-agent parallel adversarial audit
> **Tasks:** `docs/tracking/TASKS.md` § Sprint S1 — 17 CRITICAL, 35 HIGH, 33 MEDIUM, 12 LOW
> **Dispatch:** `docs/planning/TDD_DISPATCH_SPRINT_S1_SECURITY_HARDENING.md` (per-domain TDD)

**Wave 1 — Critical Auth + Storage (C-1 to C-8, C-13, C-14, C-17):**
- [ ] C-1 Entire auth trust chain client-side → trivial bypass on rooted device
- [ ] C-2 Token prefix `valid_` predictable → 1M token brute force
- [ ] C-3 PIN attempt counter not persisted → infinite cold-start retry
- [ ] C-4 Zero at-rest encryption on all Hive boxes
- [ ] C-6 Release build signed with debug keys
- [ ] C-7 PIN gate fail-open when Hive box unavailable
- [ ] C-8 Hive is abandoned → migrate to hive_ce
- [ ] C-13 `AuditEventModel` uses `late` fields → crash on corrupt read
- [ ] C-14 Negative tax rate & buffer percent in release mode
- [ ] C-17 SDK constraint mismatch

**Wave 2 — Navigation + Data Exfiltration (C-5, C-9 to C-12, C-15, C-16):**
- [ ] C-5 No app lifecycle handling → PIN bypass on app resume
- [ ] C-9 ~180 hardcoded English strings bypass localization
- [ ] C-10 Silent data fabrication — fake "Initial Balance" income entry
- [ ] C-11 `_isSaving` guards bypassable after provider disposal (4 notifiers)
- [ ] C-12 CSV formula injection in export
- [ ] C-15 `s2s_calc_failure` passes `e.toString()` → potential PII leak
- [ ] C-16 `google_fonts` downloads fonts at runtime over internet

**Waves 3-7:** See `docs/tracking/TASKS.md` for full HIGH (35), MEDIUM (33), LOW (12) task breakdown.

**Exit:** 52/97 critical+high resolved. dart analyze 0/0/0. ~40 new security tests. Hive encrypted. Release signing configured. Bundle ID changed. FLAG_SECURE on PIN screens. CSV injection guarded. Security re-audit clean (≤10 LOW remaining).

**Parallel with Sprint S1:**
- A5 (Bangla + Release Build) — A5.1 ✅, A5.2 ⏳ (human keystore), A5.3 ⏳ (blocked on A5.2)
- Helm Signal Deck UI slice merged to `main` on 2026-06-16; docs and tests updated.
- VCI (Version Control Infrastructure) — PENDING (runs before beta APK distribution)

### S1-W4 — Implementation Record (2026-06-14)

**Agent:** Claude Code. **Focus:** Security Waves 1-2 remediation continuation.
- **4A — Secret Hygiene**: `.gitignore` hardened, release workflow email masked, agent definition docs stripped of project secrets.
- **4E — Platform Hardening**: Android manifest/config updated (FLAG_SECURE, cleartext disabled, auto-backup off), iOS privacy/entitlements/backup hardened, root/jailbreak detection wired to auth gate (`JailbreakRootDetection.checkForRoot()`).
- **4C — Trust-Layer Bugs**: PIN lockout expiry fixed, delete-account PIN verification salt passed correctly, auth provider lockout state hardened.
- **4D — Crypto & Storage Hardening**: PIN KDF via `PinHasher` (SHA-256 + salt), secure storage options used, deleted box wipe + `SecureKeyManager.deleteHiveKey()`, PIN screens use `secure` keyboard configuration.
- **4B — Input Validation & Sanitization**: central `InputValidator` (amount caps, currency whitelist, email normalization, ID validation, DateTime parsing, text sanitization); CSV export sanitized and clamped; `TransactionModel`/`IncomeModel` deserialization hardened; route parameters validated; magic-link email/token validation tightened; nudge actionRoute whitelisted.
- **4G — Audit Log Hardening**: audit schema version constant, unique event ids via `IdGenerator`, `previousValue` populated for updates/deletes, SHA-256 tamper-evidence chain via `AuditChainService`, 90-day retention pruning, exported-event emission, schema version in CSV export, audit chain box cleared on account deletion.
- **4F — Lint Final Sweep**: all non-test `dart analyze` infos resolved (catch clauses, unawaited futures, deprecated `withOpacity`/`Share`), test helper packages added to dev dependencies, test quote style fixed.
- **Codebase mapping**: 68/97 S1 tasks verified done in source/tests; 29 still pending. Key remaining risks: client-side-only auth trust model, onboarding guard, google_fonts runtime download, STS buffer migration, null-assert theme extensions, custom lint rules, several UI/UX consistency issues.
- **Quality gates**: `dart analyze` 0 issues, `flutter test` 251/251 pass, no new runtime dependencies.

---

### S1-W5 — Implementation Record (2026-06-14)

**Agent:** Claude Code. **Focus:** Security Wave 4/5/6 continuation (state, navigation, business logic, platform, input).
- **H-1 / H-4 / M-19 / M-20 — Magic Link trust layer**: `setMagicLinkAuthCompleted` awaited; `UsedMagicLinkTokenStore` persists consumed tokens to encrypted Hive; token reuse and rate-limit race guards tested.
- **H-16 / H-25 / M-7 / M-8 — Safe-to-spend hardening**: `SafeToSpendResult.failure()` replaces silent zero; currency codes normalized to uppercase; `fxRate <= 0` excludes USD entries; new tests added.
- **H-17 / H-20 / L-1 — Fixed-cost integrity**: `FixedCostEntry` constructor throws `ArgumentError` on invalid `dueDayOfMonth` (no release assert bypass); repository rejects duplicate IDs; audit events emitted on create/update/delete.
- **H-18 — Tracking streak**: `SharedPrefServices.incrementTrackingStreak()` now counts consecutive calendar days and resets after a gap.
- **H-22 / M-12 — Navigation/race guards**: `_AddEditFixedCostSheet._save()` awaits async write before `Navigator.pop`; `CadencePreferenceSheet._selectTime()` checks `mounted` after `showTimePicker`.
- **H-27 — Splash timer**: `SplashScreen` stores its `Timer` and cancels it in `dispose`.
- **M-9 — Income state machine**: `IncomeStatus.canTransition()` enforces `expected/pending → received` and forbids `received → expected/pending`; `IncomeNotifier` rejects illegal transitions.
- **M-10 / M-22 — Export double-submit**: `ExportNotifier` now uses an immutable `ExportStatus` enum and returns early if already exporting.
- **M-15 — Notification lock-screen visibility**: `AndroidNotificationDetails` and `DarwinNotificationDetails` set `visibility: secret` / `presentBanner: false` so previews do not leak on lock screen.
- **M-21 — Nudge zombie-entry**: `markRead` / `markActioned` rebuild state from repository after update so a deleted entry is not re-inserted.
- **M-29 — STS defaults audit**: `StsSettingsRepositoryImpl.getSettings()` logs an audit event when falling back to hardcoded defaults.
- **C-17 — SDK constraint**: `pubspec.yaml` pinned to `sdk: ^3.11.0` to eliminate declared/resolved mismatch.
- **Tracking docs**: `TASKS.md` and `S1_CODEBASE_TASK_MAPPING.md` updated to 68 done / 29 pending; new test files mapped to tasks.
- **Quality gates**: `dart analyze` 0 issues, `flutter test` 282/282 pass.

## 0. Master Plan Context — Updated (2026-06-14)

| Phase | Status | Score Target | Effort |
|-------|--------|-------------|--------|
| 0 — Beta Launch Readiness (A5) | 🔄 IN PROGRESS | — | ~4h |
| **S1 — Security Hardening** | **🔄 IN PROGRESS** | **Trust 23→33/35** | **~40h** |
| VCI — Version Control Infrastructure | 🔲 PENDING | — | ~1.5h |
| 1 — Behavioral Foundation | ✅ COMPLETE | 62→68 behavioral, 78→83 UI/UX | ~6h |
| 2 — Analytics Infrastructure | ✅ COMPLETE | 68→76 behavioral, 83→89 UI/UX | ~8h |
| 3 — Notification System | ✅ COMPLETE | 76→82 behavioral | ~12h |
| 4 — Doctrine Gap Closure | ✅ COMPLETE | 82→90 behavioral, 89→93 UI/UX | ~20h |
| 5 — V1 Features (gated) | 🔲 BLOCKED — beta thresholds + security review | 90→93 behavioral, 93→95 UI/UX | ~15h |
| 6 — V2 Features (gated) | 🔲 BLOCKED — V1 stable + legal + pricing | 93→95 behavioral, 95→98 UI/UX | ~20h |

**VCI (Version Control Infrastructure):**
Status: **🔲 PENDING** — Runs BEFORE beta APK distribution. Depends on: S1 + A5 done.
- VCI-1 Create `develop` branch from `main`
- VCI-2 Create `release/v0.3-beta` branch from `main`
- VCI-3 Tag release (v0.3-beta.1), update pubspec.yaml version
- VCI-4 Write HOTFIX_PROTOCOL.md
- VCI-5 Write VERSIONING_POLICY.md
- VCI-6 Configure GitHub branch protection (main + release/* protected)
- Exit: Branch model live. Hotfix protocol documented. Beta APK tagged from release branch.

**Phases 1-4 — All COMPLETE.** See `docs/tracking/DECISION_LOG.md` for architectural decisions.

| Phase | Date | Tests | Score Delta | Notes |
|-------|------|-------|-------------|-------|
| 1 — Behavioral Foundation | 2026-06-13 | 78→104 | B:62→68, U:78→83 | Decision 026; typeId unchanged |
| 2 — Analytics Infrastructure | 2026-06-12 | +34 | B:68→76, U:83→89 | typeId 6+7 |
| 3 — Notification System | 2026-06-12 | 128→162 | B:76→82 | typeId 8; flutter_local_notifications v22 |
| UX Gap Phase 2 | 2026-06-13 | — | 11 files | Haptics, animations, semantics, shimmer |
| 4 — Doctrine Gap Closure | 2026-06-13 | 162→210 | B:82→90, U:89→93 | typeId 9; Magic Link auth; Decision 028 |

**Sprint A5 (Bangla + Release Build):**

**Prior sprints A1-A4 + D1/D2/D3 + UX Canon:** All COMPLETE. See `docs/tracking/TASKS.md` §Completed Sprints for records.

## 2. Current Priority

- **Sprint S1-W6 (ACTIVE)** — QA Pre-Release Fixes: 9 findings from 2026-06-15 QA gate execution. Dispatch: `docs/planning/QA_FIX_DISPATCH.md`.
- **Sprint A5 (PARALLEL)** — Bangla + Release Build. A5.2 needs human keystore. A5.3 blocked on A5.2.
- **Sprint VCI (AFTER S1+A5)** — Version Control Infrastructure. Branch model, hotfix protocol, tagging.
- **Phase 5 (BLOCKED)** — V1 Features. Gated on: S1 exit + beta thresholds cleared + security review pass.
- **Phase 6 (BLOCKED)** — V2 Features. Gated on: V1 stable + legal L5 + pricing validation.

**UI/UX Migration — COMPLETE (branch: feat/ui-ux-migration, 2026-06-20):**
All P1–P6 phases done. 325/325 tests pass. dart analyze 0/0/0. Golden tests: 1 (dashboard).
- P6a ✅ Currency symbol centralization — `NumberFormatter.symbolForCode/prefixForCode/defaultCurrencyCode`; 7 hardcoded `৳` across 6 files eliminated (commit `7abc03d`)
- P6b ✅ Typography token purity — 5 raw `TextStyle(...)` usages replaced with `HelmTypography` tokens in audit_log, sts_settings, add_income (commit `2add3fc`)
- Non-blocking tech debt filed as chore: 58 `BorderRadius.circular(N)` + 8 `EdgeInsets.all(N)` use correct values but not token constant names
- Strategic docs committed (founder-review only; prototype/pilot unauthorized until ratification): `docs/strategy/HELM_GLOBAL_PRODUCT_EXPERIENCE_AND_UI_MIGRATION_BLUEPRINT.md`, `docs/validation/EXPERIMENT_16_1_TEMPORAL_S2S_PROTOCOL.md`
- **Next authorized work:** golden test expansion OR token reference constant cleanup OR Experiment 16.1 prototype (when founder authorizes)

## 3. Sprint Status

All UX Canon sprints (1-8), Alpha sprints (A1-A4), and Phases 1-4 COMPLETE. See `docs/tracking/TASKS.md` for full task inventory.

| Sprint/Phase | Status | Key Outcome |
|---|---|---|
| UX Canon (8 sprints) | COMPLETE | 81 tasks, design system ~90% |
| A1-A4 | COMPLETE | All blockers resolved, 78 tests |
| Phase 1-4 (Behavioral→Doctrine) | COMPLETE | 210 tests, B:90, U:93 |
| S1 Security | IN PROGRESS | 325 tests, W4–W5 done |
| UI/UX Migration (P1–P6) | COMPLETE | 325 tests, 0/0/0, P6a+P6b done |
| A5 Bangla+Build | PENDING | Needs human keystore |
| VCI | PENDING | After S1+A5 |
| Phase 5-6 | BLOCKED | Beta gates + legal |

## 4. Out-of-Scope Systems (Per Final Doctrine)

- Virtual Wallets (V1 — after MVP beta clears)
- Subscription Leakage Radar (**KILLED** — not in doctrine)
- AI assistant (**KILLED**)
- Supabase sync (V1+)
- Charts / analytics dashboards (V3)
- Multi-currency conversion (V1)
- Invoice generation (V2)
- Tax reserve (V2)
- Bank balance sync (**KILLED** — never)
- F-commerce / inventory / POS (**KILLED** — wrong product)
- Generic expense categorization (**KILLED**)
- Gamification (**KILLED**)

## 5. Sprint Success Metric

A freelancer should be able to:
- Open the app and immediately see how much they can spend freely (within 3 seconds)
- Tap to see exactly how that number was calculated (full breakdown)
- Trust the number because pending money is explicitly excluded
- Configure tax rate, anxiety buffer, and fixed costs in under 2 minutes

## 6. UX Canon Planning Deliverables

See `docs/ux/extracted/` (12 constraint/requirements files), `docs/ux/HELM_CANONICAL_UX_IMPLEMENTATION_SPEC.md`, and `docs/planning/UX_EXECUTION_TODO.md`.

## 7. Strategic Context

- **Final Product Doctrine** adopted 2026-06-04 — supersedes all prior roadmaps
- **UX Canon** created 2026-06-05 — supersedes ad-hoc UX decisions
- See `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md` for canonical product scope
- See `docs/ux/HELM_CANONICAL_UX_IMPLEMENTATION_SPEC.md` for canonical UX spec
- See `docs/planning/UX_EXECUTION_TODO.md` for implementation task list
- See `docs/planning/DOCTRINE_TO_CODE_GAP_ANALYSIS.md` for implementation gaps
- Prior decisions (010–021) remain valid where aligned with doctrine and UX canon
