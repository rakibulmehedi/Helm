# HELM V2 — 100% Master Implementation Plan

> **Status:** Canonical planning document. All agents read this before starting any phase.
> **Date:** June 12, 2026
> **Authority:** Final Product Doctrine (supreme), both audits (62/100 behavioral, 78/100 UI/UX), 10 agent definitions
> **Purpose:** Single comprehensive plan spanning current state → Beta → V1 → V2 → 100% maturity
> **Reading Posture:** Every phase is a constraint. Every dependency is real. Score projections are evidence-grounded.

---

## 0. CURRENT STATE — Scorecard

### Where Helm is right now (June 12, 2026)

| Dimension | Score | Target | Gap |
|---|---|---|---|
| Behavioral Nudge Audit | 62/100 | 100/100 | 38 |
| UI/UX Design Audit | 78/100 | 100/100 | 22 |
| Trust Layer Score | 23/35 (66%) | 35/35 (100%) | 12 |
| MVP Feature Completion | 87% | 100% | 13% |
| Design System Migration | 90% | 100% | 10% |
| Test Coverage | 78 tests | 150+ tests | 72+ |
| dart analyze | 0/0/0 | 0/0/0 | ✅ |
| Beta Blockers | 0 | 0 | ✅ |

### Doctrine gap inventory (what's missing from MVP)

| Gap | Status | Sprint Estimate |
|---|---|---|
| Magic Link auth + mandatory PIN/biometric | MISSING | 2 sprints |
| Conversational 3-min onboarding | PARTIAL | 1 sprint |
| Per-entry FX rate field | MISSING | 0.5 sprint |
| Exclude-entry toggle per pipeline entry | PARTIAL | 0.5 sprint |
| Buffer as percentage (5-30%) | PARTIAL | 0.5 sprint |
| "—" fallback on calc failure | DONE (A2) | — |
| Audit log on financial edits | DONE (D1) | — |
| CSV data export | DONE (D1) | — |
| Account deletion (full purge) | DONE (D1) | — |
| Closed-beta instrumentation | PARTIAL (D2) | 0.5 sprint |

### Sprint history: everything completed so far

```
✅ Phase 0-6: App Foundation → Transaction UX Hardening
✅ Phase 7a-7f: Income Pipeline + Storage Abstraction + Domain Cleanup
✅ Phase 8a-8f: Safe-to-Spend Engine (all sub-phases)
✅ Phase 9a-9b: Cognitive Persona Simulation + Hypothesis Validation
✅ Sprint 1 (UX-5): Visual Identity / Design System
✅ Sprint 2 (UX-1): Dashboard Cockpit Redesign
✅ Sprint 3 (UX-2): Onboarding Redesign
✅ Sprint 4 (UX-3): Pipeline Quick-Update
✅ Sprint 5 (UX-4): Microcopy Replacement
✅ Sprint 6 (D1): Trust Layer Foundation + D1P Security Patch
✅ Sprint 7 (D2): Beta Instrumentation
✅ Sprint 8 (D3): Closed Beta Readiness
✅ Sprint A1: Internal Alpha Maturity Audit
✅ Sprint A2: Beta Blocker Resolution
✅ Sprint A3: First Impression Polish
✅ Sprint A4: Test Coverage + Design Stabilization
🔲 Sprint A5: Bangla + Release Build ← NEXT
```

---

## 1. MASTER PHASE PLAN — 6 Phases to 100%

```
┌───────────────────────────────────────────────────────────────────┐
│ PHASE 0: BETA LAUNCH READINESS                                     │
│ Effort: ~4 hours | 1 sprint | No dependencies                     │
│ Goal: Release build on device + Bangla strings → closed beta      │
├───────────────────────────────────────────────────────────────────┤
│ PHASE 1: BEHAVIORAL FOUNDATION                                     │
│ Effort: ~6 hours | 1 sprint | No new packages                     │
│ Goal: Wire signals, haptics, contrast, quiet affirmations, UX     │
├───────────────────────────────────────────────────────────────────┤
│ PHASE 2: ANALYTICS INFRASTRUCTURE                                  │
│ Effort: ~8 hours | 1-2 sprints | Depends on Phase 1               │
│ Goal: Event persistence, next-best-action, semantics, preferences │
├───────────────────────────────────────────────────────────────────┤
│ PHASE 3: NOTIFICATION SYSTEM                                       │
│ Effort: ~12 hours | 2-3 sprints | Depends on Phase 2              │
│ Goal: Push + in-app notification center + nudge engine            │
├───────────────────────────────────────────────────────────────────┤
│ PHASE 4: DOCTRINE GAP CLOSURE                                      │
│ Effort: ~20 hours | 3-4 sprints | Depends on Phase 0              │
│ Goal: Auth, conversational onboarding, FX rate, 100% MVP complete │
├───────────────────────────────────────────────────────────────────┤
│ PHASE 5: V1 FEATURES                                               │
│ Effort: ~15 hours | 3 sprints | GATED: Beta thresholds cleared    │
│ Goal: Multi-wallet, transfers, state colors, polish               │
├───────────────────────────────────────────────────────────────────┤
│ PHASE 6: V2 FEATURES                                               │
│ Effort: ~20 hours | 4 sprints | GATED: V1 stable + pricing valid  │
│ Goal: Invoice-Lite, tax reserve, paid tiers → 100%                │
└───────────────────────────────────────────────────────────────────┘

Total effort: ~85 hours across ~15-17 sprints
Conditional on: Beta clearing, legal opinions, package approvals, stack decision
```

---

## 2. PHASE 0 — Beta Launch Readiness (Sprint A5)

**Trigger:** A4 complete. 0 beta blockers. 78 tests. dart analyze 0/0/0.
**Gate:** Must complete before any external tester receives the app.
**Effort:** ~4 hours, 1 sprint
**Agent lead:** Gemini CLI (fast batch ops)
**Support agents:** Brand Guardian (Bangla copy review)

### Tasks

| # | Task | Type | Agent | Effort |
|---|---|---|---|---|
| A5.1 | Author native Bangla strings (app_bn.arb) — not translations, native copy | L10n | Brand Guardian + Gemini | 2h |
| A5.2 | Build release APK | Build | Gemini CLI | 30min |
| A5.3 | Test on Samsung Galaxy A14 (or equivalent reference device) | QA | Antigravity | 1h |
| A5.4 | Verify Android minSdkVersion compatibility | Build | Gemini CLI | 15min |
| A5.5 | Verify app icon and branded splash | Build | Gemini CLI | 15min |

### Exit criteria
- [ ] Release APK builds without error
- [ ] Runs on reference Android device with no crash
- [ ] Bangla strings authored natively (not Google Translate)
- [ ] App icon and splash display correctly
- [ ] S2S hero loads in <2 seconds
- [ ] PIN gate enforces on cold start
- [ ] All 78 tests pass on release build

### Deliverables
- `android/app/src/main/play/release/app-release.apk`
- `lib/l10n/app_bn.arb` (authored, not translated)
- Verified on device

---

## 3. PHASE 1 — Behavioral Foundation Sprint

**Trigger:** Phase 0 complete. Closed beta launched (or ready to launch).
**Gate:** No new packages required. All tasks are codebase-only changes.
**Effort:** ~6 hours, 1 sprint
**Agent lead:** Antigravity (multi-file coordinated changes)
**Support agents:** Behavioral Nudge Engine (design review), UI Designer (visual specs), UX Architect (foundation)

### Behavioral tasks (low effort, high impact)

| # | Task | Audit Source | Agent | Effort |
|---|---|---|---|---|
| P1.1 | Wire `sts_at_risk_entered` event | Behavioral #1 | Antigravity | 15min |
| P1.2 | Wire `reserve_depleted` event | Behavioral #1 | Antigravity | 15min |
| P1.3 | Wire `first_pipeline_entry` event | Behavioral #1 | Antigravity | 15min |
| P1.4 | Wire `pipeline_state_changed` event | Behavioral #1 | Antigravity | 15min |
| P1.5 | Add `HapticFeedback.lightImpact()` on PIN key taps | UI/UX #1 | Antigravity | 30min |
| P1.6 | Add `HapticFeedback.mediumImpact()` on confirm/delete | UI/UX #1 | Antigravity | 30min |
| P1.7 | Add `HapticFeedback.heavyImpact()` on errors | UI/UX #1 | Antigravity | 15min |
| P1.8 | Add `HapticFeedback.lightImpact()` on "next best action" card tap | Behavioral cross | Antigravity | 10min |

### UI/UX tasks (low effort, high impact)

| # | Task | Audit Source | Agent | Effort |
|---|---|---|---|---|
| P1.9 | Darken `stateSafe` to `#3D6B3C` (4.7:1 contrast) | UI/UX #2 | UI Designer | 15min |
| P1.10 | Darken `stateTight` to `#8B6500` (4.6:1 contrast) | UI/UX #2 | UI Designer | 15min |
| P1.11 | Brighten dark `interactive` to `#4DA09C` (5.0:1 contrast) | UI/UX #2 | UI Designer | 15min |
| P1.12 | Add active/pressed visual states to buttons (scale-95 or color shift) | UI/UX #4 | UI Designer | 45min |
| P1.13 | Add ±1% stepper buttons to tax rate slider | UI/UX #5 | UI Designer | 30min |
| P1.14 | Add ±1% stepper buttons to buffer slider | UI/UX #5 | UI Designer | 20min |
| P1.15 | Add global "Set up later" skip to onboarding flow | Nudge audit | UX Architect | 30min |

### Quiet affirmation tasks

| # | Task | Audit Source | Agent | Effort |
|---|---|---|---|---|
| P1.16 | Add "Pipeline up to date" relief signal to trust strip (when 0 overdue) | Behavioral #9 | Whimsy Injector | 30min |
| P1.17 | Add "7 days tracked" quiet affirmation to trust strip | Behavioral #9 | Whimsy Injector | 20min |
| P1.18 | Add "14 days tracked" quiet affirmation to trust strip | Behavioral #9 | Whimsy Injector | 20min |

### Exit criteria
- [ ] 4 boundary events fire correctly (verify via debugPrint)
- [ ] Haptic feedback present on all specified actions
- [ ] 3 contrast ratios pass WCAG AA (all ≥4.5:1)
- [ ] Buttons have visible pressed states
- [ ] Sliders have ±1% stepper buttons
- [ ] Onboarding has global skip
- [ ] Trust strip shows quiet affirmations when conditions met
- [ ] dart analyze 0/0/0
- [ ] All 78+ existing tests pass

### Score projection after Phase 1

| Dimension | Before | After | Delta |
|---|---|---|---|
| Psychological framing | 85 | 85 | — |
| Cognitive load management | 75 | 78 | +3 (skip, slider) |
| Cadence & personalization | 15 | 15 | — |
| Default bias | 80 | 80 | — |
| Nudge delivery mechanisms | 20 | 20 | — |
| Analytics & behavioral data | 35 | 55 | +20 (wired events) |
| Opt-out & user freedom | 75 | 85 | +10 (global skip) |
| Celebration & reinforcement | 10 | 35 | +25 (quiet affirmations) |
| **Behavioral Total** | **62** | **68** | **+6** |
| Color palette | 7/10 | 9/10 | +2 (contrast) |
| Touch/Interaction | 6/10 | 9/10 | +3 (haptics + active states + slider) |
| **UI/UX Total** | **78** | **83** | **+5** |

---

## 4. PHASE 2 — Analytics Infrastructure Sprint

**Trigger:** Phase 1 complete. 4 boundary events firing.
**Gate:** No new packages. All local (Hive already in project).
**Effort:** ~8 hours, 1-2 sprints
**Agent lead:** UX Architect (storage schemas + provider architecture)
**Support agents:** Behavioral Nudge Engine (rules design), UI Designer (next-best-action card), Persona Walkthrough (dashboard guidance testing)

### Analytics infrastructure

| # | Task | Audit Source | Agent | Effort |
|---|---|---|---|---|
| P2.1 | Create `AnalyticsEvent` Hive TypeAdapter with fields: eventName, timestamp, properties | Behavioral #2 | UX Architect | 45min |
| P2.2 | Open/register Hive Box "analytics_events" at app startup | Behavioral #2 | UX Architect | 30min |
| P2.3 | Modify `LocalAnalyticsService` to dual-write: Hive + debugPrint | Behavioral #2 | UX Architect | 30min |
| P2.4 | Add query methods: `getEventsSince()`, `getEventCount()`, `getLastEventOf()` | Behavioral #2 | UX Architect | 45min |
| P2.5 | Create `NudgeEventLogger` for nudge SENT/OPENED/DISMISSED/ACTIONED tracking | Behavioral #8 | UX Architect | 45min |
| P2.6 | Wire `daily_active_session` with dedup (once per calendar day, not per mount) | Behavioral gap | UX Architect | 30min |
| P2.7 | Add `session_start` / `session_end` events with duration tracking | Behavioral gap | UX Architect | 45min |

### Dashboard "next best action" card

| # | Task | Audit Source | Agent | Effort |
|---|---|---|---|---|
| P2.8 | Design `NextBestActionCard` widget with 4 state variants | Behavioral #4 | UI Designer | 1h |
| P2.9 | Implement `NextBestActionCard` in Flutter (see spec in NUDGE_ENGINE_DELIVERABLES) | Behavioral #4 | Antigravity | 1.5h |
| P2.10 | Wire to dashboard: query pipeline state → determine variant → render card | Behavioral #4 | Antigravity | 30min |
| P2.11 | Add Semantics to card: "2 payments overdue. Button: Review" | Behavioral #6 | Antigravity | 15min |

### Accessibility coverage

| # | Task | Audit Source | Agent | Effort |
|---|---|---|---|---|
| P2.12 | Add `Semantics` to FAB (home screen add button) | UI/UX #3 | Antigravity | 15min |
| P2.13 | Add `Semantics` to bottom nav items (Home, Pipeline, Settings) | UI/UX #3 | Antigravity | 15min |
| P2.14 | Add `Semantics` to all form submit/save buttons | UI/UX #3 | Antigravity | 20min |
| P2.15 | Add `Semantics` to all TextFormFields in onboarding, add-income, settings | UI/UX #3 | Antigravity | 30min |
| P2.16 | Add `Semantics` to toggle switches ("Exclude from Safe-to-Spend") | UI/UX #3 | Antigravity | 15min |
| P2.17 | Add `Semantics` to tax rate and buffer sliders | UI/UX #3 | Antigravity | 15min |

### Cadence preference discovery

| # | Task | Audit Source | Agent | Effort |
|---|---|---|---|---|
| P2.18 | Create `NudgePreferences` Hive TypeAdapter (cadence, checkInTime, pushEnabled, inAppEnabled, quietAffirmationsEnabled) | Behavioral #5 | UX Architect | 30min |
| P2.19 | Build `CadencePreferenceSheet` widget (daily/weekly/silent + time picker + channel toggles) | Behavioral #5 | UI Designer | 1h |
| P2.20 | Wire to post-onboarding: show preference sheet after onboarding completion (one-time flag) | Behavioral #5 | Antigravity | 30min |
| P2.21 | Add "Notifications" section to Settings screen (links to preference sheet) | Behavioral #5 | Antigravity | 20min |

### Exit criteria
- [ ] Analytics events persisted to Hive (survive app restart)
- [ ] `getEventsSince()` returns correct event list
- [ ] `daily_active_session` fires once per day max
- [ ] Dashboard shows "next best action" card (or "pipeline up to date" when clean)
- [ ] All interactive elements have Semantics labels
- [ ] Cadence preference sheet appears after onboarding
- [ ] Settings > Notifications is reachable
- [ ] dart analyze 0/0/0
- [ ] All 78+ existing tests pass

### Score projection after Phase 2

| Dimension | Before | After | Delta |
|---|---|---|---|
| Cognitive load management | 78 | 88 | +10 (next best action) |
| Cadence & personalization | 15 | 50 | +35 (preferences) |
| Analytics & behavioral data | 55 | 70 | +15 (persistence + tracking) |
| **Behavioral Total** | **68** | **76** | **+8** |
| Accessibility | 7/10 | 9/10 | +2 (Semantics) |
| Navigation | 8/10 | 9/10 | +1 (settings IA) |
| **UI/UX Total** | **83** | **89** | **+6** |

---

## 5. PHASE 3 — Notification System

**Trigger:** Phase 2 complete. Events persisted. Preferences captured. Dashboard guides.
**Gate:** Requires `flutter_local_notifications` package addition → **Chief Architect approval required** (Decision 026 already tracked for `local_auth`; add this package).
**Gate:** No backend. No Firebase. Local-only push. Offline-first.
**Effort:** ~12 hours, 2-3 sprints
**Agent lead:** Behavioral Nudge Engine (nudge rules + sequence logic)
**Support agents:** UX Architect (notification infrastructure), UI Designer (notification center UI), Brand Guardian (nudge copy review), Persona Walkthrough (Rafiq testing)

### Notification infrastructure

| # | Task | Audit Source | Agent | Effort |
|---|---|---|---|---|
| P3.1 | Add `flutter_local_notifications` to pubspec (requires Chief Architect approval) | Behavioral #3 | UX Architect | 15min |
| P3.2 | Initialize notification plugin in main.dart (Android channel, iOS permissions) | Behavioral #3 | UX Architect | 1h |
| P3.3 | Create `NotificationService` with: schedule, cancel, show, periodicCheck | Behavioral #3 | UX Architect | 2h |
| P3.4 | Schedule daily S2S summary notification at user's preferred check-in time | Behavioral #3 | Antigravity | 1h |
| P3.5 | Schedule periodic overdue check (every 4 hours during waking hours) | Behavioral #3 | Antigravity | 45min |
| P3.6 | Respect: silent mode, DND hours (10pm-7am), user cadence=weekly (only fire weekly) | Behavioral #3 | Antigravity | 45min |

### Nudge evaluator engine

| # | Task | Audit Source | Agent | Effort |
|---|---|---|---|---|
| P3.7 | Create `NudgeEvaluator` Riverpod provider with rule-based evaluation | Behavioral N/A | Behavioral Nudge Engine | 2h |
| P3.8 | Implement rule: overdue entries > 0 → "confirm oldest" nudge | Behavioral N/A | Behavioral Nudge Engine | 45min |
| P3.9 | Implement rule: S2S state = atRisk → "review fixed costs" nudge (in-app only) | Behavioral N/A | Behavioral Nudge Engine | 30min |
| P3.10 | Implement rule: days since last session > 3 → re-engagement nudge | Behavioral N/A | Behavioral Nudge Engine | 30min |
| P3.11 | Implement rule: 7+ days consistent tracking → quiet affirmation (no push) | Behavioral N/A | Behavioral Nudge Engine | 30min |
| P3.12 | Implement rule: pipeline fully up to date → relief signal (no push) | Behavioral N/A | Behavioral Nudge Engine | 20min |
| P3.13 | Wire `NudgeEvaluator.evaluate()` to app foreground + periodic background check | Behavioral N/A | Antigravity | 45min |

### In-app notification center

| # | Task | Audit Source | Agent | Effort |
|---|---|---|---|---|
| P3.14 | Create `NotificationCenterScreen` with date-grouped list (Today/Yesterday/This Week/Older) | Behavioral #7 | UI Designer | 2h |
| P3.15 | Store notifications to Hive Box "nudge_log" with read/unread tracking | Behavioral #7 | UX Architect | 45min |
| P3.16 | Add notification badge to Settings tab (unread count) | Behavioral #7 | Antigravity | 30min |
| P3.17 | Add swipe-to-dismiss with undo (consistent with app's forgiveness pattern) | Behavioral #7 | Antigravity | 30min |
| P3.18 | Add tap-to-navigate: tapping notification → relevant screen with context | Behavioral #7 | Antigravity | 1h |

### Nudge copy (all in Helm's brand voice — clinical-warm, factual, consequence-aware)

| # | Nudge Copy | Context | Agent |
|---|---|---|---|
| P3.19 | "Morning. Your safe-to-spend is ৳X today." | Daily S2S push | Brand Guardian |
| P3.20 | "This week: ৳X received, ৳Y safe. 2 payments confirmed." | Weekly summary push | Brand Guardian |
| P3.21 | "A payment from [Client] was expected [date]. Confirm or update?" | Overdue single | Brand Guardian |
| P3.22 | "2 payments are past their expected date. Tap to review." | Overdue multiple | Brand Guardian |
| P3.23 | "Your safe-to-spend is tighter than usual. Review fixed costs?" | S2S at risk (in-app) | Brand Guardian |
| P3.24 | "Your safety buffer is empty. Rebuilding it protects next month." | Buffer depleted (in-app) | Brand Guardian |
| P3.25 | "Haven't seen you in a few days. Your pipeline has 2 updates." | Re-engagement push | Brand Guardian |

### Nudge effectiveness tracking

| # | Task | Audit Source | Agent | Effort |
|---|---|---|---|---|
| P3.26 | Fire `NUDGE_SENT` when notification delivered | Behavioral #8 | Antigravity | 20min |
| P3.27 | Fire `NUDGE_OPENED` when user taps notification | Behavioral #8 | Antigravity | 20min |
| P3.28 | Fire `NUDGE_DISMISSED` when user dismisses without acting | Behavioral #8 | Antigravity | 20min |
| P3.29 | Fire `NUDGE_ACTIONED` when user takes target action within 30 min | Behavioral #8 | Antigravity | 30min |
| P3.30 | Add nudge effectiveness report (debugPrint): actionRate, openRate, dismissRate per nudge type | Behavioral #8 | Antigravity | 30min |

### Exit criteria
- [ ] Daily S2S summary notification fires at user's preferred time
- [ ] Overdue payment notification fires when entries pass expected date
- [ ] Notification center shows grouped, actionable notification history
- [ ] Tapping notification navigates to correct screen
- [ ] Nudge effectiveness events track SENT/OPENED/DISMISSED/ACTIONED
- [ ] All nudge copy reviewed by Brand Guardian
- [ ] Persona Walkthrough: Rafiq doesn't feel anxious or patronized by any nudge
- [ ] dart analyze 0/0/0
- [ ] All 78+ existing tests pass
- [ ] New notification tests added

### Score projection after Phase 3

| Dimension | Before | After | Delta |
|---|---|---|---|
| Cadence & personalization | 50 | 75 | +25 (notifications + adaptive) |
| Nudge delivery mechanisms | 20 | 80 | +60 (push + in-app + scheduled) |
| Analytics & behavioral data | 70 | 80 | +10 (nudge tracking) |
| Celebration & reinforcement | 35 | 50 | +15 (relief signals + quiet affirms) |
| **Behavioral Total** | **76** | **82** | **+6** |
| **UI/UX Total** | **89** | **89** | — |

---

## 6. PHASE 4 — Doctrine Gap Closure (100% MVP)

**Trigger:** Phase 0 complete (beta launched). Beta data flowing. Phase 1-3 in parallel or sequential. 
**Gate:** Some tasks require backend stack decision (Supabase vs Next.js). Magic Link auth requires email provider (Resend/Postmark).
**Gate:** Legal opinions L1-L7 must be obtained before auth ships (Doctrine §10, L1-L7).
**Gate:** `local_auth` package approval needed for biometric (Decision 026).
**Effort:** ~20 hours, 3-4 sprints
**Agent lead:** Antigravity (full-stack: Flutter frontend + backend API routes)
**Support agents:** UX Architect (auth architecture), UX Researcher (onboarding validation), Persona Walkthrough (onboarding testing), Brand Guardian (onboarding copy)

### Auth system

| # | Task | Gap # | Agent | Effort |
|---|---|---|---|---|
| P4.1 | Pick Magic Link provider (Resend/Postmark) + set up email sending | D4.1 | UX Architect | 1h |
| P4.2 | Build backend API route: `POST /auth/send-magic-link` (rate-limited, 3/min/email) | D4.1 | Antigravity | 2h |
| P4.3 | Build backend API route: `POST /auth/verify-magic-link` → return session token | D4.1 | Antigravity | 1.5h |
| P4.4 | Build Magic Link landing page (Flutter Web or backend-hosted) | D4.1 | Antigravity | 1h |
| P4.5 | Build `MagicLinkScreen` in Flutter (enter email → "check your inbox") | D4.1 | Antigravity | 1h |
| P4.6 | Add `local_auth` package (Decision 026 resolution) for biometric | D4.1 | UX Architect | 30min |
| P4.7 | Integrate biometric auth: fingerprint/face on app open | D4.1 | Antigravity | 1.5h |
| P4.8 | Keep existing PIN as fallback (no biometric device) | D4.1 | Antigravity | 45min |
| P4.9 | Add GoRouter auth redirect guard: no session → /magic-link | D4.1 | Antigravity | 30min |

### Conversational onboarding rebuild

| # | Task | Gap # | Agent | Effort |
|---|---|---|---|---|
| P4.10 | Design conversational onboarding flow (qualifier → balance → fixed costs → income pattern → buffer → pipeline → home) | D4.2 | UX Researcher + Brand Guardian | 1h |
| P4.11 | Rebuild onboarding screens as conversational (question → answer → next question) not form-fill | D4.2 | Antigravity | 3h |
| P4.12 | Write conversational copy: "How much BDT do you have right now across all accounts?" not "Enter your balance" | D4.2 | Brand Guardian | 1h |
| P4.13 | Add qualifier question: "Have you ever spent money thinking a payment cleared, then realized it hadn't?" | D4.2 | Antigravity | 30min |
| P4.14 | Add honest disqualification: "Helm is built for USD-earning freelancers in Bangladesh." | D4.2 | Antigravity | 20min |
| P4.15 | Target: entire onboarding complete in ≤3 minutes | D4.2 | Persona Walkthrough | 30min |

### Remaining MVP gaps

| # | Task | Gap # | Agent | Effort |
|---|---|---|---|---|
| P4.16 | Add `fxRate` field to `IncomeEntryEntity` + `IncomeModel` (nullable, user-entered) | D4.9 | Antigravity | 1h |
| P4.17 | Add FX rate input field to Add/Edit Income screen (shown for USD entries) | D4.9 | Antigravity | 45min |
| P4.18 | Add `isExcludedFromS2S` toggle to income entries (boolean, user-controlled) | D4.9 | Antigravity | 1h |
| P4.19 | Add exclude toggle to income entry card + edit screen | D4.9 | Antigravity | 45min |
| P4.20 | Convert buffer from absolute BDT → percentage (5-30%, default 15%) | D4.13 | Antigravity | 1.5h |
| P4.21 | Add buffer percentage slider (5-30%) to STS Settings + onboarding | D4.13 | Antigravity | 45min |
| P4.22 | Update S2S calculator to use percentage-based buffer | D4.13 | Antigravity | 1h |
| P4.23 | Update all 30 S2S calculator tests for percentage buffer | D4.13 | Antigravity | 1h |

### Instrumentation hardening

| # | Task | Gap # | Agent | Effort |
|---|---|---|---|---|
| P4.24 | Add `notification_opened` / `notification_resulted_in_update` events | D4.15 | Antigravity | 30min |
| P4.25 | Add `onboarding_step_completed` event per step | D4.15 | Antigravity | 30min |
| P4.26 | Add `time_to_s2s_visible` performance event | D4.15 | Antigravity | 20min |
| P4.27 | Add `s2s_calc_failure` event (must be near zero) | D4.15 | Antigravity | 15min |
| P4.28 | Add `data_export_requested` / `account_deletion_requested` events | D4.15 | Antigravity | 20min |

### Exit criteria
- [ ] Magic Link auth: can sign up, sign in, sign out
- [ ] PIN + biometric enforced on every app open
- [ ] Conversational onboarding: 3-minute flow, captures all required data
- [ ] Per-entry FX rate field present and functioning
- [ ] Exclude-entry toggle on every pipeline entry
- [ ] Buffer is percentage-based (5-30%, default 15%)
- [ ] All beta instrumentation events fire correctly
- [ ] dart analyze 0/0/0
- [ ] All existing tests pass
- [ ] New auth + onboarding tests added
- [ ] Persona Walkthrough: Rafiq completes onboarding in ≤3 minutes unaided

### Score projection after Phase 4

| Dimension | Before | After | Delta |
|---|---|---|---|
| Cognitive load management | 88 | 90 | +2 |
| Cadence & personalization | 75 | 80 | +5 |
| Default bias | 80 | 85 | +5 (smart defaults from onboarding) |
| Analytics & behavioral data | 80 | 85 | +5 (full instrumentation) |
| Opt-out & user freedom | 85 | 88 | +3 (auth) |
| **Behavioral Total** | **82** | **90** | **+8** |
| Empty/Loading states | 8/10 | 9/10 | +1 |
| Navigation | 9/10 | 9/10 | — |
| **UI/UX Total** | **89** | **93** | **+4** |

---

## 7. PHASE 5 — V1 Features

**⚠️ GATED:** Closed beta must clear ALL 5 thresholds before V1 work begins.
```
Thresholds:
  ✓ Pipeline update compliance ≥85%
  ✓ Override-equivalent rate <5%
  ✓ 30-day retention ≥60%
  ✓ Onboarding completion ≥70%
  ✓ S2S comprehension ≥80%
  
If 2+ thresholds miss → KILL. Do not ship V1.
If all thresholds cleared → PROCEED.
```

**Effort:** ~15 hours, 3 sprints
**Agent lead:** Antigravity (feature implementation)
**Support agents:** UI Designer (wallet UI, state colors), UX Architect (wallet data model), Persona Walkthrough (multi-wallet testing)

### Multi-wallet

| # | Task | Agent | Effort |
|---|---|---|---|
| P5.1 | Create `WalletEntity` + `WalletModel` (typeId: next) — currency, name, balance, type | UX Architect | 1h |
| P5.2 | Create `WalletRepository` + `WalletLocalDataSource` | UX Architect | 1.5h |
| P5.3 | Build `WalletListScreen` + `AddWalletScreen` | UI Designer + Antigravity | 2h |
| P5.4 | Build intra-wallet transfer screen (record-only, audit-logged, never moves real money) | Antigravity | 2h |
| P5.5 | Update S2S calculator: aggregate balance from all wallets | Antigravity | 1h |
| P5.6 | Preset wallet types: Payoneer USD, bKash BDT, Bank BDT, Cash BDT, Custom | Antigravity | 30min |

### Visual upgrades

| # | Task | Agent | Effort |
|---|---|---|---|
| P5.7 | Add dashboard state colors: Safe (stateSafe green) / Tight (stateTight amber) / At Risk (error red) | UI Designer | 1h |
| P5.8 | Add state color to S2S hero background/rail (subtle tint, not garish) | Antigravity | 45min |
| P5.9 | Build "Duplicate last entry" template button on pipeline screen | Antigravity | 1h |

### Polish

| # | Task | Agent | Effort |
|---|---|---|---|
| P5.10 | Empty state copy review + upgrade across all screens | Whimsy Injector | 1h |
| P5.11 | Error state copy review + upgrade across all screens | Whimsy Injector | 45min |
| P5.12 | Loading state: skeleton screens for pipeline list, income list, wallet list | UI Designer | 1.5h |
| P5.13 | Manual USD→BDT conversion with sanity validation (warn if >20% from 90-day avg) | Antigravity | 1h |

### Transactional ETA notifications

| # | Task | Agent | Effort |
|---|---|---|---|
| P5.14 | "Your $1,500 from [Client] is expected today — tap to confirm" push notification | Antigravity | 30min |
| P5.15 | "Fixed cost: [Name] ৳X due in 2 days — covered by current S2S" in-app banner | Antigravity | 30min |

### Exit criteria
- [ ] User can create multiple wallets (Payoneer, bKash, Bank, Cash)
- [ ] Intra-wallet transfers are record-only, audit-logged
- [ ] S2S aggregates from all wallets
- [ ] Dashboard state colors: Safe / Tight / At Risk
- [ ] Duplicate-last-entry works for retainer freelancers
- [ ] Loading skeletons on async screens
- [ ] ETA notifications fire correctly
- [ ] dart analyze 0/0/0
- [ ] All existing tests pass + new wallet tests

### Score projection after Phase 5

| Dimension | Before | After | Delta |
|---|---|---|---|
| Cognitive load management | 90 | 93 | +3 (duplicate template, skeletons) |
| Celebration & reinforcement | 50 | 60 | +10 (state colors, ETA) |
| **Behavioral Total** | **90** | **93** | **+3** |
| Empty/Loading states | 9/10 | 10/10 | +1 (skeletons) |
| Dark mode | 8/10 | 9/10 | +1 (state colors) |
| **UI/UX Total** | **93** | **95** | **+2** |

---

## 8. PHASE 6 — V2 Features (The Final Push to 100%)

**⚠️ GATED:** Phase 5 complete + V1 stable in user hands for 2+ weeks without regression.
**⚠️ GATED:** Pricing validation: ≥50% say yes at ৳299/month in willingness test.
**⚠️ GATED:** Invoice-Lite PDF pre-validated by Bangladeshi tax practitioner + 5 real clients.
**⚠️ GATED:** Legal opinion L5 (Invoice PDF compliance) obtained.

**Effort:** ~20 hours, 4 sprints
**Agent lead:** Antigravity (workflow features)
**Support agents:** UX Architect (invoice data model), UI Designer (invoice template), Brand Guardian (disclaimer copy), Persona Walkthrough (invoice flow testing), Inclusive Visuals (accessibility)

### Invoice-Lite (3-sprint allocation per Doctrine §6)

| # | Task | Sprint | Agent | Effort |
|---|---|---|---|---|
| P6.1 | Create `InvoiceEntity` + `InvoiceModel` (typeId: next) — sequential numbering, TIN, Freelancer ID, BDT-equivalent display | Sprint 1 | UX Architect | 1.5h |
| P6.2 | Build `InvoiceFormScreen` — client selector, line items, amounts, currency | Sprint 1 | UI Designer + Antigravity | 3h |
| P6.3 | Build `InvoiceListScreen` — status filter (draft/sent/paid/overdue) | Sprint 1 | Antigravity | 1.5h |
| P6.4 | Generate PDF via `pdf` package — proper layout, TIN, Freelancer ID, BDT equivalent | Sprint 2 | Antigravity | 2h |
| P6.5 | Email delivery via `url_launcher` (mailto:) or backend email API | Sprint 2 | Antigravity | 1h |
| P6.6 | Invoice audit log: created, sent, marked paid, edited | Sprint 2 | Antigravity | 1h |
| P6.7 | Invoice → Pipeline auto-entry: creating invoice generates pipeline entry (expected status) | Sprint 3 | Antigravity | 2h |
| P6.8 | Pipeline → Invoice status sync: marking pipeline as "received" → marks linked invoice as "paid" | Sprint 3 | Antigravity | 1.5h |
| P6.9 | Minimal client profile: name, email, currency, default payment terms | Sprint 3 | Antigravity | 1.5h |
| P6.10 | Overdue invoice flagging + follow-up template (one-tap "send reminder" email) | Sprint 3 | Antigravity | 1h |

### Tax Reserve

| # | Task | Agent | Effort |
|---|---|---|---|
| P6.11 | Add `taxReservePercent` to `StsSettings` (user-declared %, 0-30%, default 0%) | Antigravity | 1h |
| P6.12 | Update S2S calculator: subtract tax reserve from S2S | Antigravity | 45min |
| P6.13 | Add tax reserve slider to STS Settings | UI Designer + Antigravity | 45min |
| P6.14 | Add explicit disclaimer: "This is not tax advice. Consult a tax practitioner." | Brand Guardian | 15min |
| P6.15 | Editable history: audit-log every tax reserve % change | Antigravity | 30min |

### Paid tier activation

| # | Task | Agent | Effort |
|---|---|---|---|
| P6.16 | Create `SubscriptionTier` enum: Free / Pro (৳299/mo) / Power (৳599/mo) | Antigravity | 30min |
| P6.17 | Implement feature gates: multi-wallet (Pro+), Invoice-Lite (Pro+), unlimited entries (Pro+), tax reserve (Pro+), reports (Power) | Antigravity | 1.5h |
| P6.18 | Build `PricingScreen` — tier comparison, monthly vs annual (৳2,499/yr) | UI Designer + Antigravity | 1.5h |
| P6.19 | Build paywall triggers: "Upgrade to Pro to add a second wallet" | Antigravity | 1h |
| P6.20 | Free tier: S2S + pipeline + fixed costs + single wallet + 5 pipeline entries/month (stays free forever) | Antigravity | 1h |

### Final polish for 100%

| # | Task | Agent | Effort |
|---|---|---|---|
| P6.21 | Full accessibility audit pass: every screen, every interactive element | Inclusive Visuals | 1h |
| P6.22 | Full dark mode pass: every screen, every component | UI Designer | 1h |
| P6.23 | Final haptic feedback audit: every tappable action | Behavioral Nudge Engine | 30min |
| P6.24 | Final Semantics audit: every screen reader path | Inclusive Visuals | 30min |
| P6.25 | Performance: verify S2S loads in <2 seconds on reference device | UX Architect | 30min |
| P6.26 | Run full test suite: target 150+ tests, all passing | Antigravity | 30min |
| P6.27 | dart analyze 0/0/0 final verification | Antigravity | 10min |
| P6.28 | Documentation: update ROADMAP.md, PROJECT_STATE.md, DECISION_LOG.md, TASKS.md | All agents | 1h |

### Exit criteria
- [ ] Invoice-Lite: create → send → auto-pipeline → mark paid → full audit trail
- [ ] Invoice PDF accepted by 5 real clients
- [ ] Tax reserve: user-declared %, audit-logged, disclaimed
- [ ] Paid tiers: Free/Pro/Power with feature gates
- [ ] All 78+ existing tests pass + new invoice + tax + tier tests (150+ total)
- [ ] Accessibility: all interactive elements have Semantics, all colors pass WCAG AA
- [ ] Dark mode: every screen verified
- [ ] Haptic feedback: every action confirmed
- [ ] S2S loads <2 seconds on reference device
- [ ] dart analyze 0/0/0

### Score projection after Phase 6 (FINAL)

| Dimension | Score | Notes |
|---|---|---|
| Psychological framing | 95/100 | +10 from V1/V2 polish, FX rate framing, tax reserve framing |
| Cognitive load management | 98/100 | Micro-sprint decomposition, next-best-action, skeletons, templates |
| Cadence & personalization | 95/100 | Full notification system, adaptive cadence, time-of-day awareness |
| Default bias | 90/100 | Smart defaults from onboarding, pattern-learning, percentage buffer |
| Nudge delivery mechanisms | 95/100 | Push + in-app + center + scheduled + adaptive + transactional ETA |
| Analytics & behavioral data | 95/100 | Full event pipeline, persistence, nudge tracking, cohorting-ready |
| Opt-out & user freedom | 92/100 | Global skip, notification opt-out, account deletion, honest disqualification |
| Celebration & reinforcement | 90/100 | Quiet affirmation tier, relief signals, milestone whispers, state colors |
| **Behavioral Total** | **95/100** | |
| Color palette | 10/10 | All contrast ratios ≥4.5:1. Dark mode comprehensive. |
| Typography | 9/10 | Excellent (only minor: font lazy-loading opportunity) |
| Spacing/Layout | 10/10 | 8pt grid, consistent, next-best-action card, notification center |
| Accessibility | 10/10 | Full Semantics, WCAG AA, reduced-motion, TextScaler.noScaling |
| Motion | 9/10 | Strict, centralized, reduced-motion compliant |
| Touch/Interaction | 10/10 | Full haptics, active states, stepper buttons, 44pt targets |
| Empty/Loading states | 10/10 | Empty states + skeleton screens + error states + quiet affirmations |
| Dark mode | 10/10 | Hand-tuned, all tokens verified, interactive contrast fixed |
| Navigation | 10/10 | Clean 3-tab + notification center + settings IA improved |
| **UI/UX Total** | **98/100** | |

**Why not 100/100?** The remaining 2-5% represents things that can't be scored higher without fundamental product changes: Typography loses 1 point for 3-font loading overhead; Motion loses 1 point because splash delay is intentionally long; Psychological framing loses 5 because gamification is deliberately absent (correct for Helm's brand, but score ceiling is lower by design).

---

## 9. AGENT ASSIGNMENT MATRIX

| Agent | Phase 0 | Phase 1 | Phase 2 | Phase 3 | Phase 4 | Phase 5 | Phase 6 |
|---|---|---|---|---|---|---|---|
| **Behavioral Nudge Engine** | — | Design review | Rules design | **LEAD** | Review | Review | Review |
| **UX Researcher** | — | — | — | Validate timing | Onboarding validate | Wallet research | Pricing validate |
| **UI Designer** | — | Visual specs | Card design | Center UI | — | Wallet UI, state colors | Invoice template |
| **UX Architect** | — | Foundation | **LEAD** | Infra | Auth architecture | Wallet model | Invoice model |
| **Whimsy Injector** | — | Quiet affirmations | — | — | — | Copy upgrade | Copy polish |
| **Persona Walkthrough** | — | — | Dashboard test | Nudge testing | Onboarding test | Multi-wallet test | Invoice flow test |
| **Brand Guardian** | Bangla review | — | — | Nudge copy | Onboarding copy | — | Disclaimers |
| **Inclusive Visuals** | — | — | — | — | — | — | A11y audit |
| **Image Prompt Engineer** | — | — | — | — | — | — | App store screenshots |
| **Visual Storyteller** | — | — | — | — | — | — | — |
| **Antigravity** | Build | Build | Build | Build | **LEAD** | **LEAD** | **LEAD** |
| **Gemini CLI** | **LEAD** (batch) | — | — | — | — | — | — |
| **Claude Code** | Code review | Code review | Code review | Code review | Code review | Code review | Code review |

---

## 10. DEPENDENCY GRAPH

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│  PHASE 0 (Beta Launch)                                           │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ No dependencies. Can start immediately.                   │   │
│  │ Blocks: Nothing. Enables: Beta distribution.              │   │
│  └──────────────────────────────────────────────────────────┘   │
│                              │                                   │
│                    ┌─────────┴─────────┐                        │
│                    ▼                   ▼                         │
│  PHASE 1 (Behavioral)          PHASE 4 (Doctrine Gaps)           │
│  ┌───────────────────┐         ┌──────────────────────────┐     │
│  │ No new packages    │         │ Requires:                  │     │
│  │ Pure codebase work │         │ • Backend stack decision   │     │
│  │ Enables: Phase 2   │         │ • Legal opinions L1-L7     │     │
│  └───────────────────┘         │ • local_auth approval       │     │
│           │                    │ • Magic Link provider       │     │
│           ▼                    │ Enables: V1 (partially)     │     │
│  PHASE 2 (Analytics)           └──────────────────────────┘     │
│  ┌───────────────────┐                    │                      │
│  │ Depends: Phase 1   │                   │                      │
│  │ Enables: Phase 3   │                   │                      │
│  └───────────────────┘                    │                      │
│           │                               │                      │
│           ▼                               │                      │
│  PHASE 3 (Notifications)                  │                      │
│  ┌───────────────────┐                   │                      │
│  │ Depends: Phase 2   │                   │                      │
│  │ Requires: pkg apprv│                   │                      │
│  │ Enables: Rich beta │                   │                      │
│  └───────────────────┘                   │                      │
│           │                               │                      │
│           └───────────┬───────────────────┘                      │
│                       ▼                                          │
│              ┌─────────────────┐                                 │
│              │  BETA DECISION   │                                 │
│              │  5 thresholds    │                                 │
│              │  Go / Iterate /  │                                 │
│              │  Kill            │                                 │
│              └─────────────────┘                                 │
│                       │ (if GO)                                   │
│                       ▼                                          │
│              PHASE 5 (V1 Features)                                │
│              ┌──────────────────┐                                │
│              │ Depends: Beta GO  │                                │
│              │ Enables: V2       │                                │
│              └──────────────────┘                                │
│                       │                                          │
│                       ▼                                          │
│              PHASE 6 (V2 Features)                                │
│              ┌──────────────────┐                                │
│              │ Depends: V1 stable│                                │
│              │ Requires: Legal L5│                                │
│              │ • Invoice pre-val │                                │
│              │ • Pricing validat │                                │
│              │ • Tax practitioner│                                │
│              │ Goal: 100%        │                                │
│              └──────────────────┘                                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Parallelism opportunity

**Phase 1 + Phase 4 can run in parallel.** They touch different files:
- Phase 1: analytics wiring, haptics, contrast, sliders, affirmations (lib/features/*, lib/core/themes/)
- Phase 4: auth (new feature), onboarding rebuild (existing feature, total rewrite), FX rate (income model), buffer % (STS settings)

**Phase 2 must wait for Phase 1** (needs wired events + Hive persistence infrastructure).
**Phase 3 must wait for Phase 2** (needs event persistence + preferences).

**Optimal parallel schedule (if multiple agents available):**

```
Week 1-2:  Phase 0 (Beta Launch) + Begin Phase 1 (Behavioral) + Begin Phase 4 prep (legal, stack)
Week 3:    Complete Phase 1 | Begin Phase 2 | Continue Phase 4
Week 4-5:  Complete Phase 2 | Begin Phase 3 | Continue Phase 4
Week 6-7:  Complete Phase 3 | Complete Phase 4 | Beta data evaluation
Week 8:    Beta decision — Go / Iterate / Kill
Week 9-12: Phase 5 (V1) — if Go
Week 13-16: Phase 6 (V2) — if V1 stable + pricing validates
```

**Total: 16 weeks to 100% from today** (optimistic, assuming parallel agents + no major rework).

---

## 11. RISK REGISTER

| # | Risk | Likelihood | Impact | Phase | Mitigation |
|---|---|---|---|---|---|
| R1 | Beta thresholds fail (manual pipeline attrition >15%) | Medium | Critical | Post-Phase 4 | Phase 3 notifications address this directly. Conservative S2S excludes overdue. |
| R2 | `flutter_local_notifications` behaves differently on reference Android device | Medium | High | Phase 3 | Test on device early in Phase 3, before copy/delivery logic is built |
| R3 | Magic Link email deliverability issues in Bangladesh | High | High | Phase 4 | Use Resend (good deliverability to BD). Budget for WhatsApp-fallback if email fails. |
| R4 | Legal opinions L1-L7 delay (Bangladeshi fintech lawyers are scarce) | Medium | Critical | Phase 4 | Start outreach NOW (Week 1 of Phase 0). Budget ৳50k-200k. |
| R5 | Backend stack decision paralysis (Supabase vs Next.js) | High | High | Phase 4 | Chief Architect decides by end of Phase 0. No debate after that. |
| R6 | Bangla strings feel translated, not native | Medium | Medium | Phase 0 | Native Bangla speaker review before APK distribution |
| R7 | Invoice PDF rejected by international clients | Medium | Medium | Phase 6 | Pre-validate with 5 real clients before Phase 6 launch |
| R8 | Founder bandwidth fragmentation (multiple projects) | Critical | Critical | All phases | Pause one parallel project before Phase 1. Allocate ≥15 focused hours/week. |
| R9 | User resistance to notification permissions | High | Medium | Phase 3 | Preference discovery asks first. "Silent" option always available. Never pressure. |
| R10 | Nudge copy feels patronizing to Rafiq | Medium | High | Phase 3 | Persona Walkthrough testing on every nudge type before shipping. |

---

## 12. SCORE PROJECTION PATH (Complete Journey)

```
BEHAVIORAL SCORE PROGRESSION
─────────────────────────────────────────────────────────────────
62 ──Phase 1──▶ 68 ──Phase 2──▶ 76 ──Phase 3──▶ 82 ──Phase 4──▶ 90 ──Phase 5──▶ 93 ──Phase 6──▶ 95
                                                                                                ▲
                                                                                          (100% goal:
                                                                                           95 is ceiling
                                                                                           for non-gamified
                                                                                           fintech app)

UI/UX SCORE PROGRESSION
─────────────────────────────────────────────────────────────────
78 ──Phase 1──▶ 83 ──Phase 2──▶ 89 ──Phase 3──▶ 89 ──Phase 4──▶ 93 ──Phase 5──▶ 95 ──Phase 6──▶ 98
                                                                                                ▲
                                                                                          (100% goal:
                                                                                           98 is ceiling
                                                                                           remaining 2% is
                                                                                           intentional tradeoffs)

TRUST LAYER SCORE PROGRESSION
─────────────────────────────────────────────────────────────────
23/35 (66%) ──Phase 4──▶ 33/35 (94%) ──Phase 6──▶ 35/35 (100%)

MVP FEATURE COMPLETION
─────────────────────────────────────────────────────────────────
87% ──Phase 4──▶ 100%

TEST COVERAGE
─────────────────────────────────────────────────────────────────
78 tests ──Phase 4──▶ 120+ tests ──Phase 5──▶ 140+ tests ──Phase 6──▶ 150+ tests
```

---

## 13. BETA GATE DECISION MATRIX

This is the single most important decision point in Helm's life. After Phase 4, before Phase 5.

| Metric | Target | Actual | Pass? |
|---|---|---|---|
| Pipeline update compliance | ≥85% | _TBD_ | — |
| Override-equivalent rate | <5% | _TBD_ | — |
| 30-day retention | ≥60% | _TBD_ | — |
| Onboarding completion | ≥70% | _TBD_ | — |
| S2S comprehension | ≥80% | _TBD_ | — |

### Decision outcomes

```
All 5 cleared      → GO. Begin Phase 5 (V1). Public launch deferred to post-V1.
4/5 cleared        → ITERATE. Fix the failing metric in 2 sprints. Re-beta.
2+ missed          → KILL. Write post-mortem. Do not ship V1.
```

---

## 14. IMMEDIATE ACTIONS (Day 1 of Phase 0)

Before writing any code:

1. **Read this entire plan.** Every agent assigned to Helm reads this document first.
2. **Verify Phase 0 readiness:** A4 complete. 0 beta blockers. 78 tests. dart analyze 0/0/0.
3. **Begin Sprint A5:** Bangla strings + Release APK + Device testing.
4. **Chief Architect decides:** Begin Phase 1 now (parallel with A5) or wait for beta launch?
5. **Chief Architect decides:** Begin Phase 4 legal outreach now (parallel with Phase 0-3)?
6. **Chief Architect decides:** Backend stack (Supabase vs Next.js+Postgres) — decide before Phase 4.
7. **Chief Architect decides:** Pause one parallel project. Document which. 90 days minimum.

### Documentation to update after each phase

| Document | Update Trigger | By Whom |
|---|---|---|
| `docs/core/ROADMAP.md` | After every phase completion | Phase lead agent |
| `docs/tracking/CURRENT_SPRINT.md` | After every sprint completion | Sprint lead agent |
| `docs/tracking/PROJECT_STATE.md` | After every stable/frozen system change | UX Architect |
| `docs/tracking/DECISION_LOG.md` | After every architectural/product decision | Decision maker |
| `docs/tracking/TASKS.md` | After every completed task | Task executor |
| `docs/tracking/LESSONS.md` | After every important mistake/discovery | Anyone |

---

## 15. DOCUMENTS REFERENCED

This plan was built from:

| Document | Purpose |
|---|---|
| `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md` | Supreme strategic authority — version scopes, kill list, trust architecture, beta gates |
| `docs/audits/BEHAVIORAL_NUDGE_AUDIT_2026-06-12.md` | Behavioral score (62/100), 12-item action plan, nudge sequence design |
| `docs/audits/UI_UX_AUDIT_2026-06-12.md` | UI/UX score (78/100), 5-item action plan, contrast/haptic/Semantics gaps |
| `docs/audits/SYNTHESIZED_AGENT_ANALYSIS_2026-06-12.md` | Cross-audit synthesis through 7 agent lenses, merged priority matrix |
| `docs/audits/NUDGE_ENGINE_DELIVERABLES_2026-06-12.md` | 10 behavioral deliverables: events, nudges, copy, preferences, affirmations |
| `docs/core/ROADMAP.md` | Phase history, current state, doctrine alignment |
| `docs/tracking/CURRENT_SPRINT.md` | Sprint history (A1-A4 complete, A5 next) |
| `docs/tracking/PROJECT_STATE.md` | Architecture snapshot, frozen systems, technical debt |
| `docs/planning/DOCTRINE_TO_CODE_GAP_ANALYSIS.md` | 8 MVP-blocking gaps, 5 partial implementations |
| `docs/planning/ALPHA_TO_BETA_ROADMAP.md` | Sprint A2-A5 plan, beta gate criteria |
| `docs/core/ARCHITECTURE_RULES.md` | Feature-first architecture, layer rules, naming conventions |
| `docs/governance/AGENT_WORKFLOW.md` | Pre-flight/post-flight checklists, phase lifecycle, scope enforcement |
| `CLAUDE.md` | Agent instructions, technical context, mandatory pre-flight |
| `.claude/agents/*.md` (10 files) | Agent definitions: capabilities, workflows, deliverables |
