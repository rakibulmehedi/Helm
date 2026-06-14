# 🧠 Helm V2 — Behavioral Nudge Engine Audit
**Auditor:** Behavioral Nudge Engine Specialist
**Date:** June 12, 2026
**Product:** Freelancer Cashflow Clarity App (FinTech, Mobile-First, Flutter)
**Score:** **62/100** — Strong psychology foundation; nudge delivery and personalization absent

---

## 1. PSYCHOLOGICAL FRAMING — Score: 85/100

### What's Working (Strong Foundation)

| Pattern | Mechanism | Location |
|---------|-----------|----------|
| **Safety buffer framing** | "Not locked — a safety margin" / "Breathing room" reduces reactance; frames prudence as choice not constraint | `reserve_section.dart`, `buffer_comfort_page.dart`, `sts_settings_screen.dart` |
| **"Not counted yet"** | Implies money WILL be counted, not "Pending income" which implies false certainty | `not_counted_section.dart`, `pipeline_entry_card.dart` |
| **Loss aversion on buffer slider** | Live S2S preview turns red when negative — user watches safety vs. freedom trade-off in real-time | `buffer_comfort_page.dart` |
| **Anchoring on confirm-received** | "You expected USD X from Client" restates expectation before asking actual — anchors to reference point | `confirm_received_sheet.dart` |
| **Transparency nudge** | "Confirm — adds to liquid" tells consequence before action — user knows what will happen | `confirm_received_sheet.dart` |
| **Self-selection funnel** | "Not really" → honest disqualification message — doesn't try to convince wrong users | `qualifying_question_page.dart` |
| **Progress gradient** | 2pt line never reaches 1.0 during onboarding (stops at 0.90) — creates need-for-closure tension | `onboarding_progress_line.dart` |
| **Forgiveness pattern** | 4-5s undo windows on delete, confirm-received — reduces fear of irreversible mistakes | 3 files |
| **Friction reduction** | "A rough number is fine. You can refine it later." — kills precision paralysis | `liquid_balance_page.dart` |
| **Motor-nudge** | Swipe-right on pipeline entries opens confirm sheet (never auto-commits) — physical gesture builds commitment without removing control | `pipeline_entry_card.dart` |

### Gaps

| Issue | Severity |
|-------|----------|
| No celebration or positive reinforcement anywhere (intentional per ONB-014, but may leave users feeling clinical) | MEDIUM |
| No Gamification — correct for product type, but zero variable-reward loops means no engagement hooks beyond utility | MEDIUM |
| "Exclude from Safe-to-Spend" toggle labeled as exclusion — could be framed as "Track separately" (gain-framed rather than loss-framed) | LOW |

---

## 2. COGNITIVE LOAD MANAGEMENT — Score: 75/100

### Done Right
- ✅ **6-step onboarding with progress line only** (no "Step 3 of 6" text) — reduces enumeration anxiety
- ✅ **Em-dash "—" instead of ৳0** on no-data S2S — doesn't mislead with a zero
- ✅ **Pre-filled categories** in onboarding fixed costs — reduces decision fatigue
- ✅ **Re-ask pattern** on zero fixed costs — soft interceptor, not blocking gate
- ✅ **3-tab navigation** — minimal surface area, no feature overwhelm
- ✅ **FAB label disappears after 5 entries** (scaffolding pattern) — instruction fades as competence grows

### Gaps

| Issue | Severity | Details |
|-------|----------|---------|
| **No micro-sprint decomposition** | HIGH | The pipeline screen groups entries by state, but shows ALL entries in each group. If a user has 8 overdue entries, they see all 8 at once — no "do this one first" prioritization nudge |
| **No "next best action" signal** | HIGH | The dashboard is passive — it displays state but doesn't guide the user. A user with 3 overdue entries sees the same dashboard as a user with 0. No "You have 2 payments overdue — confirm the oldest one?" nudge |
| **Settings screen is one long scroll** | MEDIUM | Tax slider → buffer slider → fixed costs → export → history → danger zone — no section collapsing or progressive disclosure |
| **Pipeline "Needs decision" section shows everything** | MEDIUM | Entries 30+ days overdue are sorted oldest first, but ALL are shown — could show "1 most urgent" with "Show all N" expand |

---

## 3. CADENCE & PERSONALIZATION — Score: 15/100

### What Exists
- **Income pattern preference**: `marketplace` / `direct` / `retainer` — captured during onboarding as `income_pattern` in SharedPreferences. Determines pipeline UI labels.
- **Theme mode**: `ThemeMode.system` — respects device preference (but this is OS-level, not a behavioral preference)
- **Language preference**: EN/BN — but no behavioral impact beyond localization

### What's Missing (Critical)

| Gap | Severity | Details |
|-----|----------|---------|
| **No cadence personalization** | CRITICAL | User is never asked: "How often do you want to check in?" (daily/weekly). No notification frequency setting. |
| **No communication channel selection** | CRITICAL | No in-app banner vs. push notification vs. silent preference. |
| **No motivational trigger preference** | CRITICAL | No gamification vs. direct-instruction preference. |
| **No time-of-day awareness** | CRITICAL | No "preferred check-in time" — can't send nudges when user is most receptive. |
| **No adaptive cadence** | CRITICAL | If user stops engaging, there's no mechanism to detect churn and adjust. |
| **No notification system exists at all** | CRITICAL | `notification_event_stub.dart` has 3 stubbed events but `flutter_local_notifications` is not a dependency. Local push is listed as "Post-Beta / Deferred." |

**This is the single biggest behavioral gap.** Helm has sophisticated in-app psychology but zero out-of-app engagement infrastructure. The user must remember to open the app — the app never reaches out to the user.

---

## 4. DEFAULT BIAS & SMART DEFAULTS — Score: 80/100

### Done Right
- ✅ **Buffer = 15%** — middle ground, neither reckless nor paranoid
- ✅ **Income pattern = marketplace** — assumes Upwork/Fiverr (dominant user type)
- ✅ **Currency = BDT** — target user's spending currency
- ✅ **Status = expected** on new entries — low-commitment initial state
- ✅ **Expected date = today** — gentle urgency without being aggressive
- ✅ **Pre-filled fixed cost categories** — Rent day 1, Internet day 5, Mobile day 10, etc.

### Gaps

| Issue | Severity |
|-------|----------|
| **No "smart" defaults based on patterns** — if user always enters ~$500 on ~15th, the next entry doesn't pre-fill those values | MEDIUM |
| **Tax rate defaults to 0%** — should the default be 10% reflecting typical Bangladesh freelance tax norms? | LOW |
| **No default-bias in pipeline confirmation** — "Confirm — adds to liquid" could have the primary button pre-selected (already the case via InkWell, but no visual priority over "Not yet") | LOW |

---

## 5. NUDGE DELIVERY MECHANISMS — Score: 20/100

### Current Mechanisms (All In-App)
| Mechanism | Location | Format |
|-----------|----------|--------|
| One-time S2S hint banner | Dashboard | In-app pill banner, once per install |
| Onboarding 12-second Bangla rephrase | Qualifier | Timer-triggered language switch |
| Fixed costs re-ask card | Onboarding step 2 | Inline card on skip attempt |
| HelmToast | Throughout | Success/warning/error toasts |
| Trust strip "Tap to audit" | Dashboard hero | Persistent inline label |
| Empty state CTAs | Pipeline, Income, Fixed costs | Action-oriented copy |

### What's Missing

| Gap | Severity | Details |
|-----|----------|---------|
| **No push notifications** | CRITICAL | Cannot nudge outside the app. No "Good morning — you have ৳X safe to spend today" daily summary. |
| **No in-app notification center** | CRITICAL | No place for accumulated nudges to live. Toast system is ephemeral — messages vanish after 3-5s. |
| **No scheduled nudges** | CRITICAL | No "It's been 5 days since you last confirmed a payment — check your pipeline?" |
| **No milestone celebrations** | HIGH | No "You've tracked 100 payments!" or "First month of consistent tracking!" — deliberate omission but leaves product feeling cold |
| **No behavioral triggers** | HIGH | When S2S enters "At Risk," nothing happens beyond the red rail. No "Your safe-to-spend is tight — want to review fixed costs?" |
| **No onboarding follow-up** | HIGH | After onboarding completes, there's no Day 1 / Day 3 / Day 7 check-in nudge |

---

## 6. ANALYTICS & BEHAVIORAL DATA — Score: 35/100

### Current State
- **18 registered events**, 13 wired, 4 boundary events registered but unwired
- **Sink**: `LocalAnalyticsService` — `debugPrint` only, gated by `kDebugMode`
- **Persistence**: Zero — no Hive, no SharedPreferences, no file I/O for events
- **Transmission**: Zero — no HTTP, no Firebase, no third-party SDK

### What's Missing

| Gap | Severity | Details |
|-----|----------|---------|
| **No event persistence** | CRITICAL | Events are `debugPrint` only. App restart = all behavioral data gone. Cannot learn from user behavior. |
| **No behavioral cohorting** | CRITICAL | Cannot segment users by engagement pattern, feature usage, or churn risk. |
| **No churn detection signal** | CRITICAL | If `daily_active_session` stops appearing, no automated alert. Manual Founding Observation Sheet only. |
| **No nudge effectiveness tracking** | CRITICAL | Even if nudges existed, there's no mechanism to measure whether a nudge increased the target action. |
| **4 boundary events unwired** | HIGH | `sts_at_risk_entered`, `reserve_depleted`, `first_pipeline_entry`, `pipeline_state_changed` — registered but never called. These are the exact behavioral signals needed for nudges. |
| **No session length tracking** | MEDIUM | `daily_active_session` fires on every mount, no dedup, no duration tracking. |
| **No feature flag infrastructure** | MEDIUM | Documented as required ("every Doctrine-significant UI surface behind a feature flag") but not implemented. |

### Unwired Boundary Events (High Priority to Wire)
```
sts_at_risk_entered     → Trigger "Your S2S is tight" nudge
reserve_depleted         → Trigger "Your buffer is empty" nudge
first_pipeline_entry     → Activation milestone: trigger Day 1 onboarding follow-up
pipeline_state_changed   → Trigger "Payment confirmed!" celebration
```

---

## 7. OPT-OUT & USER FREEDOM — Score: 75/100

### Done Right
- ✅ **Honest disqualification**: "Helm is built for USD-earning freelancers in Bangladesh. Come back when you start billing internationally." — respectful, specific, no retention trick
- ✅ **"Not yet" escape hatch** on confirm-received sheet — always present, never hidden
- ✅ **Undo pattern everywhere**: 4-5s undo on delete, confirm-received — reversible actions
- ✅ **No double-confirm dialogs** — single conscious confirmation, not nagware
- ✅ **No auto-dismiss timers** on confirmation sheets — user must consciously act
- ✅ **Skip available on fixed costs** and first pipeline entry — "Skip for now" / "Let me add some"
- ✅ **"Exclude from Safe-to-Spend" toggle** — user controls what counts

### Gaps

| Issue | Severity | Details |
|-------|----------|---------|
| **Onboarding has no global skip** | MEDIUM | Individual steps have skips, but no "Set up later — take me to the app" at top-level |
| **No notification opt-out path exists** | LOW | Cannot opt out of something that doesn't exist, but must be designed before launching notifications |
| **Delete account requires PIN or "type DELETE"** | LOW | Appropriate for fintech — not a gap, but verify it doesn't block legitimate deletion |

---

## 8. CELEBRATION & REINFORCEMENT — Score: 10/100

### Current State: Deliberately Absent

Per ONB-014: *"No confetti, no 'Welcome!', no tour."*
Per ONB-012: *"After last step, go straight to home."*

### Analysis

This is a deliberate product decision — Helm is clinical, warm but not congratulatory. The rationale is sound: Rafiq doesn't need confetti, he needs clarity. Celebration would feel patronizing to a user managing real financial stress.

**However:** Absence of ALL positive reinforcement leaves the product emotionally flat. There's a middle ground between confetti and silence:

| What Could Exist | Why |
|------------------|-----|
| "You've tracked 7 days in a row" — quiet acknowledgment in trust strip | Builds tracking habit without gamification |
| "Your pipeline is fully up to date" — status affirmation, not celebration | Confidence signal rather than reward |
| "No overdue payments — everything is on track" — relief signal | Emotional payoff for maintaining good pipeline hygiene |

---

## 9. OVERALL SCORING MATRIX

| Criteria | Score | Notes |
|----------|-------|-------|
| Psychological framing | 85/100 | Excellent — loss aversion, anchoring, framing, default bias all solid |
| Cognitive load management | 75/100 | Good structure, missing micro-sprint decomposition |
| Cadence & personalization | 15/100 | **Critical gap** — zero user preference discovery, zero notification system |
| Default bias | 80/100 | Strong defaults, missing pattern-learning |
| Nudge delivery mechanisms | 20/100 | **Critical gap** — in-app only, ephemeral, no scheduled nudges |
| Analytics & behavioral data | 35/100 | Debug-only, zero persistence, unwired events |
| Opt-out & user freedom | 75/100 | Solid — honest, respectful, reversible |
| Celebration & reinforcement | 10/100 | Deliberately absent — needs subtle positive signals |

**Weighted Total: 62/100**

---

## TOP 5 ACTIONS

| # | Action | Impact | Effort | Category |
|---|--------|--------|--------|----------|
| 1 | **Wire the 4 unwired boundary events** — `sts_at_risk_entered`, `reserve_depleted`, `first_pipeline_entry`, `pipeline_state_changed` | CRITICAL | Low | Analytics |
| 2 | **Add local event persistence** — store events to Hive, not just `debugPrint` | CRITICAL | Medium | Analytics |
| 3 | **Design and implement notification system** — `flutter_local_notifications` + local push for daily S2S summary and overdue payment nudges | CRITICAL | High | Nudge Delivery |
| 4 | **Add "next best action" to dashboard** — if overdue entries exist, show a contextual banner: "You have 2 payments overdue — confirm the oldest?" | HIGH | Medium | Cognitive Load |
| 5 | **Add preference discovery** — during onboarding or first week, ask "How often should Helm check in with you?" (daily/weekly/silent) | HIGH | Medium | Personalization |

---

## NUDGE SEQUENCE DESIGN (Recommended)

```
DAY 0 (Onboarding Complete):
  → "Your Safe-to-Spend is set up. We'll help you stay on top of it."

DAY 1 (Morning):
  → Push: "Morning! Your safe-to-spend is ৳X today. Open Helm →"

DAY 3 (If no pipeline entries added):
  → Push: "Got any money coming in from Upwork? Add an expected payment to track it."

DAY 5 (If first pipeline entry exists but not confirmed):
  → Push: "You marked a payment as expected 5 days ago. Has it arrived?"

DAY 7 (Weekly summary):
  → Push: "This week — ৳X received, ৳Y safe-to-spend. Open to see details."

WEEK 2+ (Adaptive):
  → If user opens daily → reduce push frequency (they're engaged)
  → If user hasn't opened in 3 days → gentle re-engagement nudge
  → If S2S enters "At Risk" → immediate "Your numbers are tight — review fixed costs?"
```

---

## BEHAVIORAL EVENTS TO ADD

```
NUDGE_SENT        → Track which nudges are delivered
NUDGE_OPENED      → Track which nudges drive app opens
NUDGE_DISMISSED   → Track which nudges are annoying
NUDGE_ACTIONED    → Track which nudges led to the target action
SESSION_START     → Track app foreground events (distinct from DAU)
SESSION_END       → Track session duration
CADENCE_SELECTED  → Track user's chosen notification frequency
```
