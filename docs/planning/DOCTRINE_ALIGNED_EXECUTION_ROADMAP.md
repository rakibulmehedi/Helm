# Doctrine-Aligned Execution Roadmap

> Status: ACTIVE
> Date: 2026-06-04
> Authority: Final Product Doctrine (`docs/strategy/POCKETA_FINAL_PRODUCT_DOCTRINE.md`)
> Prerequisite: `docs/planning/DOCTRINE_TO_CODE_GAP_ANALYSIS.md`

---

## Current State

- Phase 8 (Safe-to-Spend) COMPLETE
- Phase 9b (Hypothesis Validation) COMPLETE
- MVP readiness: ~55%
- Core product logic: strong (S2S + Pipeline aligned with doctrine)
- Critical gaps: trust layer, auth, instrumentation, onboarding

---

## Execution Path: Gap Resolution -> Closed Beta -> V1

```
[NOW]        Sprint D1: Trust Layer (audit log, export, deletion)
[Sprint D2]  Auth + Onboarding (Magic Link, PIN, conversational flow)
[Sprint D3]  Instrumentation + Pipeline Polish (beta events, FX rate, exclude flag)
[Sprint D4]  Integration QA + Beta Prep
[BETA]       4-week closed beta (15-25 freelancers)
[DECISION]   Go / Iterate / Kill per Doctrine S4 thresholds
[V1]         Multi-wallet + polish (only if beta clears)
```

---

## Sprint D1 — Trust Layer Foundation (Recommended Immediate Next Sprint)

> **Goal:** Build the trust infrastructure that the Doctrine treats as non-negotiable.
> **Estimate:** 1.5-2 weeks
> **No backend required** — all local-first implementations

### D1a: Audit Log (2-3 days)

- Create `AuditEvent` entity: `{userId, entityId, entityType, field, oldValue, newValue, timestamp, source}`
- Create `AuditLogRepository` + Hive data source (typeId 4)
- Wire into income entry edits (create, update, status change)
- Wire into fixed cost edits (create, update, delete)
- Wire into STS settings changes (tax rate, buffer)
- Per-entry history view (tap entry -> see edit history)
- Append-only: no delete, no update on audit events

### D1b: CSV Data Export (1-2 days)

- Export all income pipeline entries as CSV
- Export all transactions as CSV
- Export all fixed costs as CSV
- Single "Export All Data" button in settings
- Share sheet integration (no email gate)
- Include metadata: export date, data range, entry count

### D1c: Account Deletion (1 day)

- Settings screen: "Delete Account" button
- Confirmation dialog with explicit "This cannot be undone" warning
- Clear all Hive boxes (transactions, income, fixed costs, STS settings, audit log)
- Clear SharedPreferences
- Navigate to onboarding/splash

### D1d: S2S Fallback Display (0.5 day)

- When S2S calculation fails or inputs are stale, display "---" instead of a number
- Add staleness check: if no income data updated in 7+ days, show "Last updated X days ago"
- Never show a wrong number

### D1 Success Gate
- `dart analyze` 0/0/0
- Audit log captures all financial edits
- CSV export produces valid files
- Account deletion clears all data
- S2S shows "---" on calc failure

---

## Sprint D2 — Auth + Onboarding (Requires Backend Decision)

> **Goal:** Establish trust floor. Magic Link requires backend.
> **Estimate:** 2-3 weeks
> **HARD GATE:** Backend stack must be decided before this sprint starts (Doctrine S14)

### D2 Pre-Requisite: Backend Stack Decision

Per Doctrine S14, choose ONE before Sprint D2:
- **Option A:** Supabase (auth + database + hosting)
- **Option B:** Next.js API routes + PostgreSQL (managed)

Decision criteria:
- Solo founder operational burden
- Bangladesh residency awareness
- Magic Link provider (Resend/Postmark)
- Event-sourced audit log in Postgres

### D2a: Magic Link Auth (1 week)

- Email input -> Magic Link sent -> Verify token -> Session
- Backup recovery method (recovery code at signup)
- No email-only recovery (doctrine explicitly kills this)

### D2b: PIN/Biometric Gate (3-4 days)

- Mandatory on every app open (not optional)
- PIN setup during first launch
- Biometric option (fingerprint/face) via `local_auth`
- No bypass mechanism

### D2c: Conversational Onboarding (4-5 days)

- Replace current swipe cards with conversational flow
- Step 1: "What's your name?" (personal touch)
- Step 2: "How do you receive USD payments?" (Payoneer/nsave/etc.)
- Step 3: "What are your fixed monthly costs?" (capture 2-3 fixed costs)
- Step 4: "How much buffer makes you comfortable?" (set safety buffer)
- Step 5: "Add your first expected payment" (seed pipeline)
- Target: 3 minutes, no form feel
- Qualifying question: "Have you ever spent money thinking a payment had cleared, then realized the BDT hadn't arrived?"

### D2 Success Gate
- Magic Link auth works end-to-end
- PIN gate enforced on every app open
- Onboarding completes in <3 minutes
- Fixed costs and buffer captured during onboarding
- `dart analyze` 0/0/0

---

## Sprint D3 — Instrumentation + Pipeline Polish

> **Goal:** Beta-ready instrumentation and UX polish.
> **Estimate:** 1.5-2 weeks

### D3a: Closed-Beta Instrumentation (1 week)

Per Doctrine S16, instrument these events:

| Event | Purpose |
|---|---|
| `s2s_view` (timestamp + S2S value) | Daily active use; habit formation |
| `pipeline_entry_created` | Adoption of forward-looking model |
| `pending_to_received_tapped` (time-since-creation) | Maintenance compliance |
| `input_edit` (field, old, new, S2S delta) | Override-equivalent measurement |
| `notification_opened` / `notification_resulted_in_update` | Notification loop health |
| `onboarding_step_completed` (each step) | Drop-off diagnosis |
| `app_open` / `time_to_s2s_visible` | Performance (<2s target) |
| `s2s_calc_failure` | Trust risk measurement |
| `data_export_requested` / `account_deletion_requested` | Trust hygiene usage |

Local storage for beta (SQLite or Hive box). Export as part of CSV.

### D3b: Income Pipeline Polish (3-4 days)

- Add `fxRate` field to `IncomeEntryEntity` (optional, nullable)
- Add `isExcluded` boolean flag to `IncomeEntryEntity`
- Update S2S calculator to respect `isExcluded` flag
- Update income entry form with FX rate input (optional)
- FX rate sanity warning if deviates >20% (no blocking)

### D3c: Safety Buffer Alignment (1 day)

- Verify default is 15% (Doctrine S4 item 13)
- Enforce range 5-30% (hard floor at 5%, per Doctrine)
- Rename "Anxiety Buffer" to "Safety Buffer" in UI for clarity

### D3 Success Gate
- All 9 event types instrumented
- Events stored locally and exportable
- FX rate editable per entry
- Exclude toggle works per entry
- Safety buffer default 15%, range 5-30%

---

## Sprint D4 — Integration QA + Beta Prep

> **Goal:** Ship-ready for closed beta.
> **Estimate:** 1 week

### D4 Tasks

- Full QA pass on all screens (real device)
- Edge case testing (S2S scenario matrix)
- Performance: app-open-to-S2S < 2 seconds
- Empty states for all screens
- Error states polished (no ugly crashes)
- Beta user recruitment (15-25 from interview cohort)
- Beta agreement (NDA-lite + instrumentation permission + weekly calls)
- TestFlight / Firebase App Distribution setup

---

## Closed Beta (4 Weeks, per Doctrine S16)

### Schedule

| Week | Focus |
|---|---|
| Week 1 | Setup + first impressions |
| Week 2 | Daily-use habit formation |
| Week 3 | Stress-test (edge cases via support) |
| Week 4 | Retention + payment willingness check |

### Measurement Thresholds (Doctrine S4)

| Metric | Target | If Miss |
|---|---|---|
| Pipeline update compliance | >=85% | Iterate; do not ship V1 |
| Override-equivalent rate | <5% | Formula is wrong -- rebuild |
| 30-day retention | >=60% | Product premise weak; reconsider |
| Onboarding completion | >=70% | Onboarding fails; redesign |
| S2S comprehension | >=80% | UI breaks mental model |
| WTP at BDT 299+ | >=50% | Pricing model fails; rethink |

**2+ misses = KILL. Do not launch V1.**

---

## Total Timeline Estimate

| Phase | Duration | Cumulative |
|---|---|---|
| Sprint D1 (Trust Layer) | 2 weeks | Week 2 |
| Sprint D2 (Auth + Onboarding) | 3 weeks | Week 5 |
| Sprint D3 (Instrumentation + Polish) | 2 weeks | Week 7 |
| Sprint D4 (QA + Beta Prep) | 1 week | Week 8 |
| Closed Beta | 4 weeks | Week 12 |
| Beta Decision | 1 week | Week 13 |

**MVP to beta-ready: ~8 weeks from Sprint D1 start.**
**Total to go/no-go decision: ~13 weeks.**

This aligns with Doctrine's "12-week build, 4-week beta" timeline, accounting for existing S2S + Pipeline implementation saving ~4 weeks vs starting from scratch.

---

## What This Roadmap Does NOT Cover

- Backend architecture details (decided in Sprint D2 pre-req)
- V1 implementation (conditional on beta success)
- Legal opinions L1-L7 (parallel track, must start before Sprint D2)
- Founder bandwidth allocation (Doctrine S18 — Chief Architect decision)
- Stage 0 user interviews (Doctrine S20 — may have been completed or skipped)

---

## Immediate Next Action

**Start Sprint D1 (Trust Layer Foundation).**

No backend decision needed. No new packages needed (audit log + export are pure Dart + Hive). Account deletion is a settings screen addition. All work is local-first, incremental, and non-breaking.

Sprint D1 unblocks the trust floor that every subsequent sprint depends on.
