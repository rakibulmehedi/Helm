# Pocketa — Pipeline Interaction Optimization

> **Status:** Doctrine extension. Governs every state-transition interaction in the Income Pipeline.
> **Foundation:** Final Product Doctrine §4, §10, §11 · UX Doctrine §6, §9 · Tier-1 Dashboard Critique v2 §6, §7.
> **Posture:** Adversarial-mentor. Behavioral-design lens. Habit-formation framing.
> **One-line thesis:** The pipeline lives or dies on one moment — `Pending → Received` in under two taps. Everything else is scaffolding around that moment.

---

## 1. Core Interaction Problem

The pipeline is a **belief-maintenance system**. Each entry is a small bet the user has placed about future money. Every day that bet decays in accuracy unless the user actively updates it. The product's central UX question is therefore not "how do we show pipeline data?" — it is:

> **How do we get a stressed, distracted, multi-currency freelancer to keep three states (`Expected`, `Pending`, `Received`) honest for 30+ entries a month, forever, without nagging them into uninstalling?**

This is a **behavioral-economics problem disguised as a UI problem.** Three frictions stack:

1. **Cognitive friction** — the user has to remember which client paid, which is in transit, which is still in escrow. The current screen treats this as a passive list. It should be an active prompt surface when (and only when) action is needed.
2. **Temporal friction** — money moves on platform clocks (Upwork 5-day hold, Payoneer settlement T+1, FX cycle T+1–3), but humans live on calendar clocks. The mismatch is where state goes stale.
3. **Trust friction** — every state change touches the S2S number. The user is doing finance work, not app maintenance. If a tap feels like clerical labor, they'll skip it. If a tap feels like resolving anxiety, they'll perform it.

The job of this design is to **eliminate cognitive friction**, **collapse temporal friction into a single trigger event**, and **convert trust friction into emotional reward** (the S2S number visibly correcting itself).

---

## 2. Current Risk

Looking at your existing Pipeline screens (the five shots you sent), here is the brutal read of what is *currently shipping behavioral failure*:

### Risk surfaces I can see right now

| Risk | Evidence in current UI | Behavioral cost |
|---|---|---|
| **No conditional surfacing** | The pipeline screen treats every entry equally. A 7-day overdue Pending and a fresh Expected look the same except for the badge. | The user has to scan-and-decide on every open. Cognitive tax = skipped updates. |
| **State change requires opening a form** | To advance `Pending → Received`, the user must tap the entry, edit a status segmented control, then re-save. Inferred from the Add Income form pattern. | Multi-tap state changes are where update compliance dies. Sheets is faster. |
| **The `+` FAB is generic** | A lone blue `+` reads as "add an expense" to any user trained by bKash or TallyKhata. | Wrong mental model. The MVP's job is to teach "pipeline ≠ expense ledger." |
| **No surface for overdue** | Image 4 (All view) interleaves overdue and on-time entries by created order, not by attention-needed. | The user who most needs to act sees no signal to act. |
| **Heavy Add form** | Add Income asks Client, Project, Amount, Currency, Status, Date, Notes in a single screen. Seven fields = ~45–60 seconds of capture. | Capture friction kills the "log it the moment it happens" behavior. |
| **`By 04 Jun 2026` + `Expected` is doubled info** | Both the status badge and the date label communicate "future." Cognitive redundancy without clarity gain. | Visual noise without trust gain. |
| **No visible audit trail** | Entries have no history view — no way to see "edited from $1,500 to $1,200 on May 22." | When numbers feel wrong, no way to reconstruct. Trust collapses silently. |
| **No FX rate per entry** | The currency toggle is global on the Add form; the per-entry FX value isn't visible later. | First time the BDT-equivalent looks wrong, the user blames Pocketa, not the rate they used. |

### The cumulative diagnosis

Your current pipeline screen is a **passive ledger** — it records what the user tells it. The MVP doctrine demands an **active prompt surface** — it tells the user what to update and rewards them when they do.

The single most dangerous risk is the one the Final Doctrine already named in §11: *if pipeline staleness exceeds 5 days for >30% of users, the retention model is broken.* Your current UI makes 5-day staleness the default outcome.

---

## 3. Ideal State Transition Model

Three states. No others. No sub-states. No "partially received." This is enforced both in code and in the user's mental model.

```
                  ┌─────────────────────────────────────────────┐
                  │                                             │
                  ▼                                             │
    ┌──────────┐      ┌──────────┐      ┌──────────┐           │
    │ EXPECTED │ ───▶ │ PENDING  │ ───▶ │ RECEIVED │           │
    └──────────┘      └──────────┘      └──────────┘           │
         │                 │                                    │
         │                 │                                    │
         ▼                 ▼                                    │
    ┌──────────────────────────────┐                            │
    │   EXCLUDED  /  CANCELLED     │ ◀──────────────────────────┘
    └──────────────────────────────┘
```

### State semantics (user-facing, not just internal)

| State | User-facing label on Home | User-facing label on Pipeline | Counts in S2S? | What it means |
|---|---|---|---|---|
| **Expected** | _Not counted yet_ | `Expected` | No | Invoice sent or work agreed; client has not yet acknowledged. |
| **Pending** | _Not counted yet_ | `Pending` | No (Hope tier only, conservative FX shown) | Client acknowledged or money in transit (Upwork released, Payoneer processing). |
| **Received** | _Counted_ | `Received` | Yes (adds to liquid BDT) | Funds landed in a Pocketa-tracked liquid wallet, BDT-converted. |
| **Excluded** | _(Not visible)_ | `Excluded` (greyed) | No | User-declared "don't count this." Reversible. |
| **Cancelled** | _(Not visible)_ | `Cancelled` (archived) | No | Deal fell through. Reversible within 30 days, then archive-only. |

### Allowed transitions (the only legal moves)

| From | To | Trigger | Confirmation? |
|---|---|---|---|
| `Expected` | `Pending` | User taps "Acknowledged by client" / "In transit" | One-tap confirm |
| `Expected` | `Received` | User skips Pending (small client, instant pay) | Confirm sheet with FX |
| `Pending` | `Received` | **THE moment.** User confirms settlement. | Confirm sheet with FX |
| `Pending` | `Expected` | User realizes premature advance (rare) | Confirm with reason prompt |
| any non-terminal | `Excluded` | User declares "don't count this" | Single tap, reversible |
| any non-terminal | `Cancelled` | Deal fell through | Confirm with reason prompt |
| `Excluded` | previous state | User undeclares exclusion | Single tap |

### Forbidden transitions

- `Received → Pending` — once funds are in liquid balance, downgrading rewrites history. If the user truly made a mistake, they **delete** the received entry (audit-logged) and re-create it. This protects the liquid balance invariant.
- Any **automatic** transition. Pocketa never moves a state without the user's tap. Ever. Auto-mark-on-date-passed is the worst pattern the product could ship.

---

## 4. One-Tap Update Design

This is the single most rehearsed interaction in the entire product. If only one screen ships polished, this is the one.

### The Confirm-Received Sheet

Triggered from any of: notification tap, maintenance strip tap, pipeline row tap, swipe gesture, or "Duplicate-last" follow-through.

```
┌───────────────────────────────────────────────┐
│                                               │
│   Confirm received                            │
│                                               │
│   You expected   $1,500 from Acme             │
│                                               │
│   At rate        119.66 BDT/USD   [edit ›]    │
│                                               │
│   You receive    ৳ 1,79,490.00                │
│                  (conservative · live: 120.10)│
│                                               │
│   Date received  Today · 04 Jun 2026 [edit ›] │
│                                               │
│   ┌─────────────────────────────────────────┐ │
│   │         Confirm — adds to liquid        │ │
│   └─────────────────────────────────────────┘ │
│                                               │
│            Not yet  ·  Cancel                 │
│                                               │
└───────────────────────────────────────────────┘
```

### What earns its place on this sheet

| Element | Why it's there | Why it's not bigger or smaller |
|---|---|---|
| **`You expected $1,500 from Acme`** | Anchors the user's memory; confirms identity of the entry before they commit. | Plain prose, not a heading — heading-weight would make this feel like a form. |
| **`At rate 119.66`** with `[edit ›]` | The single most-edited field in the real world. Surfacing it inline prevents "tap to edit > another sheet > save > back > confirm" — that path was a 6-tap problem. | Edit is a chevron, not a button — it's a refinement, not the primary action. |
| **Conservative + live FX comparison** | Trains the user that Pocketa is pessimistic; live rate is the upside, not the baseline. | One small line. Not a chart. Not a graph. |
| **`Date received: Today`** with `[edit ›]` | 95% of confirms are same-day. Default to today; let edge cases edit. | Pre-filled, not a date picker by default. |
| **Single primary `Confirm — adds to liquid`** button | The label states the consequence. The user knows what their tap will do. | One verb. One outcome. No marketing copy. |
| **`Not yet`** | Closes the loop without state change. Necessary for the "I tapped the notification at a bus stop" case. | Tertiary action, no border. |

### What is forbidden on this sheet

- ❌ A `Cancel` button positioned where `Confirm` is — must always be in the same place. Muscle memory is trust.
- ❌ Auto-dismiss after a delay. The user controls when this sheet closes.
- ❌ "Are you sure?" double-confirm. The audit log is the undo, not a modal.
- ❌ A "Quick mark received" toggle that bypasses the FX field. The FX is the entire point.

### The post-confirm sequence (the emotional reward)

This is the dopamine moment. It must land precisely:

```
[0ms]    User taps "Confirm — adds to liquid"
[0ms]    Haptic: single soft tick (system "selection" feedback, not "success")
[0ms]    Sheet begins dismissing (240ms ease-out)
[200ms]  Home screen visible, S2S still showing OLD number for 200ms more
[400ms]  S2S number cross-fades from old to new (no rolling counter, no slot-machine)
         Below the S2S, a thin sage-green underline pulses ONCE (300ms)
         Maintenance Strip disappears (if this was the last pending today)
[700ms]  Breakdown drawer auto-opens, 1.2 sec
         The "Liquid BDT" line is highlighted at 60% opacity background
         Shows ৳ delta inline: "Liquid BDT  ৳ 52,400 + ৳ 1,79,490 = ৳ 2,31,890"
[1900ms] Drawer auto-closes
[1900ms] Home is calm again
```

**Total elapsed time from tap to closed loop: ~1.9 seconds.** No confetti. No "Great job!" toast. The math is the reward.

If reduce-motion is on, the drawer does not auto-open; instead, a one-line settlement toast appears below S2S for 4 seconds: `$1,500 settled at 119.66 — added ৳1,79,490 to liquid balance.`

---

## 5. Swipe Gesture Design

> **Doctrine constraint:** Hidden gestures cannot be the *primary* path for state changes on financial truth. The Tier-1 critique nailed this. Swipe is a power-user shortcut layered on top of the visible tap path, never a replacement for it.

### The two swipes

| Gesture | Action | Visual reveal | Confirms? |
|---|---|---|---|
| **Swipe right** (left-to-right) | Advance state by one step (`Expected → Pending`, or `Pending → Received`) | Sage-green reveal with `→ Confirm received` label sliding in from the left edge | YES — opens the Confirm Sheet (§4). Swipe alone does not commit. |
| **Swipe left** (right-to-left) | Open quick edit menu: Edit FX · Edit date · Exclude · Cancel deal | Muted teal reveal with vertical icon stack | Each menu choice has its own confirm if it changes financial state. |

### Why swipe-to-advance still routes through the Confirm Sheet

Three reasons, in priority order:

1. **Catastrophic-failure prevention.** A swipe is 100x more likely to be accidental than a tap on a labeled button. The Confirm Sheet is the safety gate. Without it, you ship a one-day-bug where users wake up to find half their pipeline "received" from a pocket-swipe.
2. **The FX rate must be edited inline.** Swipe alone cannot present the per-entry FX field. Most `Pending → Received` confirmations involve verifying or adjusting the rate. Skipping the sheet would mean skipping the rate verification — which silently corrupts S2S.
3. **Audit-log integrity.** A swipe-without-sheet would write `source: swipe_shortcut` to the event log. That's fine for telemetry, but the *human reason* for confirming (the rate used, the date received) needs the sheet to capture intentionally.

### Swipe interaction details

```
Row resting state:
┌─────────────────────────────────────────────────────────────┐
│  ◐  Acme                            Pending                 │
│     Upwork                                                  │
│                                                             │
│  $1,500.00              expected by Jun 04 2026  (today)    │
└─────────────────────────────────────────────────────────────┘

Mid-swipe (right, 60% threshold):
┌─────────────────────────────────────────────────────────────┐
│ → Confirm received  ◐  Acme              Pending            │
│                        Upwork                               │
└─────────────────────────────────────────────────────────────┘

Released past threshold → Confirm Sheet opens (§4).
Released before threshold → row snaps back. No state change.
```

### Swipe rules (non-negotiable)

- **Swipe threshold is 60% of row width.** Anything less is "almost a swipe" and snaps back. This is calibrated against the financial-action stakes: a 40% threshold (common in mail apps) is too easy to trigger pocket-side.
- **Haptic at 60% threshold** — tells the finger it has armed the gesture. Critical for confidence.
- **Released-but-armed swipe does NOT auto-commit.** Sheet opens; user must still tap Confirm. The swipe is "open the question," not "answer it."
- **No swipe on `Received` rows.** They are terminal-from-the-user's-perspective. Swiping a settled row should do nothing (or, optionally, swipe-right opens "Duplicate as expected for next month" for retainer cohorts — see §11 on the explicit exception).
- **Reduce-motion users** see the swipe affordance as a small chevron `›` on the right edge of pending rows. Tapping it opens the Confirm Sheet directly.

---

## 6. Dashboard Shortcut Design

The home screen's job is to make the next required financial action **inescapable** when one exists, and **invisible** when none does. This is the conditional **Maintenance Strip**.

### Where it lives

Directly below the S2S Hero Block and above the Threat (obligations) block. When present, it occupies one row of cognitive space. When absent, no placeholder — the layout reflows so the Threat block rises into its place.

### When it appears (priority order; only one strip at a time)

| Priority | Condition | Strip copy | Tap target |
|---|---|---|---|
| 1 | ≥1 entry's expected date is **today** AND state is `Pending` | `1 payment expected today · Confirm received → updates Safe-to-Spend` | Opens Confirm Sheet (single entry) or Pipeline filtered to "Expected today" (multiple) |
| 2 | ≥1 entry is **overdue ≥7 days** | `1 payment is 9 days overdue · Review` | Opens Pipeline filtered to "Overdue" |
| 3 | ≥1 `Pending` entry has **FX rate stale by >5%** vs current | `1 input needs review · Refresh FX → restores Safe-to-Spend` | Opens entry edit |
| 4 | A Fixed Cost is due in **≤48 hours** AND S2S still covers it | `Internet ৳1,500 due in 2 days · Covered` | Tap = dismiss (read receipt); no edit needed |
| 5 | A Fixed Cost is due in **≤48 hours** AND S2S no longer covers it | This is no longer a strip — the S2S state moves to `At Risk` and the row appears in the Threat block in muted red. The strip is not used because the math has spoken. |

### Why "Confirm received" not "Confirm payment"

Words matter. "Confirm payment" is what an accountant says. "Confirm received" is what a freelancer feels. The user is verifying *something happened to them*, not auditing *a transaction*. The Doctrine's microcopy contract demands the subjective frame.

### Strip visual contract

```
┌───────────────────────────────────────────────────┐
│                                                   │
│                ৳ 32,400.00                        │
│                Safe to spend                      │
│            ────────────────────                   │
│            covers 17 days at your usual pace      │
│                                                   │
│  ┌─────────────────────────────────────────────┐  │
│  │ 1 payment expected today                  › │  │
│  │ Confirm received → updates Safe-to-Spend    │  │
│  └─────────────────────────────────────────────┘  │
│                                                   │
│  ↳ Internet bill    ৳1,500    in 2 days   ●       │
│  ↳ Rent            ৳18,000   in 6 days   ●       │
└───────────────────────────────────────────────────┘
```

### Strip behavioral rules

- **Strip is read-only when tapped on the wrong row.** If the user taps the strip while no entry matches the condition (race condition, sync delay), it gracefully opens the Pipeline with an empty filter, never a broken sheet.
- **Strip never stacks.** Only one is visible. Priority order resolves which one wins.
- **Strip does not animate in.** It appears on screen mount without slide-in. Animation = something happened *now*; the strip might be 3 days old.
- **Strip dismissal is implicit.** It disappears the moment its underlying condition resolves. No "X" close button — there is nothing to close, only nothing to do.

### The FAB question, resolved

The current `+` FAB is generic and pulls the user toward "add expense" mental models. Replace with an **extended FAB during MVP**:

```
┌──────────────────┐
│  + Expected      │   ← labeled. unambiguous. teal accent.
└──────────────────┘
```

After the user has added 5+ entries (a learning threshold), the FAB collapses to the icon-only form. The label paid its tuition; the icon now reads correctly.

---

## 7. Overdue State Handling

This is where the product earns the user's trust or destroys it. Get this wrong and the user spends against money that evaporated. Get it right and they feel protected.

### Definitions

- **Day 0** — entry's `expected_date`. Passive day, no escalation.
- **Day +1 to +6** — "Late, but not yet a problem." Entry remains in `Pending`/`Expected`. S2S already treats it conservatively (never in liquid).
- **Day +7** — entry becomes **Overdue**. This is the threshold for active escalation.
- **Day +30** — entry auto-archives to a **"Needs decision"** state. Still not auto-cancelled. The user must confirm.

### What the user sees at each stage

| Day range | Where it appears | Visual treatment | Surface action |
|---|---|---|---|
| Day 0 (expected today, still `Pending`) | Maintenance Strip · Pipeline list top | Sage-green dot on the entry's status icon, small "today" label | Confirm Received (one tap) |
| Day +1 to +6 | Pipeline list, normal position | Status icon gets a small clock annotation; row text unchanged | Tap row → edit sheet (no escalation) |
| Day +7 to +29 | Pipeline list **top section** under header `Overdue — needs attention` | Status icon: half-filled circle with thin amber ring · `n days overdue` in muted amber 60% opacity · NO red, NO alarm color | Four actions in a tap sheet (see below) |
| Day +30+ | Pipeline list **top section** under header `Needs decision` | Same amber ring, plus a quiet `Decide` button on the row | Same four actions, but the entry won't auto-recalculate S2S past day 30 — it's now noise |

### The four actions when an entry is overdue

When the user taps an overdue entry:

```
┌─────────────────────────────────────────────┐
│  Acme · $1,500 · 9 days overdue             │
│                                             │
│   ▸ Mark received                           │
│      The money arrived. Confirm date + FX.  │
│                                             │
│   ▸ Push expected date                      │
│      Still coming, just later. Pick a date. │
│                                             │
│   ▸ Send polite follow-up                   │
│      Pre-drafted message to copy or email.  │
│                                             │
│   ▸ Cancel — deal fell through              │
│      Removes from pipeline. Reversible 30d. │
│                                             │
└─────────────────────────────────────────────┘
```

### Why no red color on overdue entries

The Visual Doctrine reserves the single red (`#9E4A3A`) for one thing only: **S2S in `At Risk` state**, meaning the user has insufficient liquid BDT for an obligation due within 7 days. Pipeline overdue is not the same emergency — it's a deferred outcome, not a current shortage. If overdue entries used red, the red would lose all signal value when it actually mattered.

Amber 60% opacity is the right weight: visible enough to draw attention, quiet enough not to trigger cortisol.

### Why we never auto-cancel

The Doctrine §10 explicitly forbids it. From a behavioral standpoint: a user who returns to Pocketa after a 3-week silence and finds Pocketa has unilaterally cancelled their $4,000 entry will never trust the app again. The cost of an auto-cancel error is permanent. The cost of an entry sitting in "Needs decision" for 60 days is zero.

### The "polite follow-up" template

Pre-drafted in three tones (Direct / Warm / Formal), in both English and Bangla:

```
Hi {client_name},

Wanted to follow up on the {project_or_invoice_ref} —
expected on {expected_date}, still showing pending on my end.

Could you confirm where it is in your process?

Thanks,
Mehedi
```

User can copy to clipboard, edit, and paste into WhatsApp / email / Upwork message. **Pocketa does NOT send the message itself.** Sending implies CRM territory and creates a confused responsibility model. Copy-paste keeps the user in control.

---

## 8. Reminder / ETA Behavior

> **The whole product's emotional contract is here.** A wrong notification reverses three weeks of trust-building. The notification surface is the most restrained part of Pocketa.

### The two-class system (already locked by UX Doctrine §9)

Only **Transactional** and **Boundary** notifications exist. `Engagement` is a TypeScript/Dart compile-time error. We're enforcing here what's already constitutional.

### Pipeline notifications, mapped to the registry

| ID | Class | Trigger | Copy | Cooldown |
|---|---|---|---|---|
| `pipeline_expected_today` | Transactional | An entry's `expected_date` is today AND state is `Pending` | `$1,500 from Acme is expected today. Tap to confirm received or mark not yet.` | Once per entry per day, max 2/day total |
| `pipeline_overdue_7d` | Transactional | An entry has been overdue ≥7 days AND user has not opened Pipeline screen in 5+ days | `Acme invoice is 7 days past expected. Is this still expected?` | Once per entry, ever. After dismiss → silent |
| `pipeline_fx_stale` | Transactional | A `Pending` entry's stored FX deviates >5% from current rate | `FX has moved. $1,500 entry would now convert to ৳1,79,500 instead of ৳1,77,200.` | Once per entry per FX-shift event, max 1/day |
| `boundary_at_risk` | Boundary | Mathematical: S2S after a pipeline change would dip below an obligation due ≤7 days | `Rent ৳18,000 due Jun 10 · Safe-to-Spend will be tight if pipeline updates don't land.` | Max 1/day, never during quiet hours |

### Reminder behavioral rules

1. **Quiet hours by default** — 22:00 to 08:00 local time. No transactional notification fires in this window. Boundary notifications are also suppressed unless the obligation is ≤24h away.
2. **Cap: 2 transactional + 1 boundary per day.** Hard ceiling at the registry level. Excess triggers are silently dropped, not queued.
3. **Snooze without nagging.** Tapping "Not yet" on the Confirm Sheet snoozes the entry for 48 hours. After two snoozes, the notification is silenced for that entry forever — the maintenance strip on home takes over.
4. **No re-engagement.** If the user has not opened the app in 7 days, Pocketa does NOT send a "we miss you" notification. The product trusts the user's absence is intentional.
5. **Notification → app open → Confirm Sheet, in that order, in <2 taps.** The notification deep-links directly to the sheet for that entry. Not the pipeline screen. Not the home screen. The exact action.

### The opening sequence (notification → confirm)

```
[User receives notification on lock screen]
[Taps notification]
[App cold-launches with PIN/biometric gate]
[Gate clears in <1 sec]
[Confirm Sheet for THAT entry is the first thing rendered]
   ← S2S home is rendered underneath, blurred, peeking
[User confirms or dismisses]
[Sheet closes, home becomes the surface, S2S updates]
```

Two taps. Maybe three including the biometric. That's the budget.

### What we explicitly will NOT do

- ❌ "Check in" weekly summary notifications
- ❌ "You haven't updated your pipeline in N days" guilt-pings
- ❌ "Tip: did you know you can…" feature-education pushes
- ❌ Email digest notifications
- ❌ Re-marketing notifications after subscription lapse
- ❌ Streaks, "longest update chain," gamified consistency rewards

The discipline here IS the trust. Every notification we don't send is a notification we *could* have sent — and the user feels that absence as respect.

---

## 9. Audit Log UX

> Audit logs exist in two layers: the **engineering layer** (event-sourced, immutable, used for reconciliation) and the **user-facing layer** (per-entry history, readable in plain language). The doctrine demands both. This section is only the user-facing layer.

### Where it lives

Tapping any pipeline entry → entry edit sheet → bottom section: `History`. Collapsed by default, three most recent events visible. Tap to expand full timeline.

### What an entry looks like

```
┌─────────────────────────────────────────────┐
│  Acme · $1,500                              │
│  [editable fields above]                    │
│                                             │
│  ─────────────  History  ─────────────      │
│                                             │
│  Today, 14:22  ·  marked received           │
│                FX 119.66 · ৳ 1,79,490        │
│                                             │
│  May 28, 10:04  ·  FX rate changed          │
│                from 118.40 to 119.66        │
│                                             │
│  May 24, 18:11  ·  expected date moved      │
│                from May 27 to Jun 04        │
│                                             │
│  May 18, 09:30  ·  entry created            │
│                $1,500 · expected May 27     │
│                                             │
└─────────────────────────────────────────────┘
```

### Copy rules

- **Past tense, agentless.** "marked received," not "you marked received." The user doesn't need to be reminded they did it — they're reading their own history. Avoid the awkward second-person echo.
- **Numbers before reasons.** `from 118.40 to 119.66` is more useful than `you updated the rate`.
- **Timestamp in local time.** Always.
- **Source not shown unless multi-device.** If the user has only ever used one device, the `source` field is redundant noise. Shown only when relevant (different device IDs in the event stream).

### What the user can do from history

- **Read-only by default.** History is a record, not an undo surface.
- **Tap an event → see the snapshot.** What did this entry look like at that moment? Useful for "wait, what was the rate when I confirmed?"
- **One-tap dispute export.** A small `Share this history` action exports the event stream for this entry as plaintext, for the rare case where the user needs to reconcile with a client or bank.

### Critical: history cannot be deleted

Not by the user. Not by anything. Even if the user deletes the entry itself, the audit events persist in the engineering layer (Doctrine §10). This is the dispute-defense contract.

### What history is NOT

- ❌ A timeline UI with vertical lines and circles. That's design theater. A list of dated past-tense statements is denser and clearer.
- ❌ A search/filter interface. If the user needs to search audit logs, they have a problem we cannot solve at the UI layer.
- ❌ A diff view between two states. Show the change inline ("from X to Y"), not in a separate compare view.

---

## 10. Friction Score Before/After

Friction is measured along three dimensions: **taps**, **screens traversed**, and **cognitive atoms** (distinct decisions the user must make).

### Path 1 — `Pending → Received` (the central interaction)

| Path | Taps | Screens | Cognitive atoms | Annotated |
|---|---|---|---|---|
| **Current (inferred from your screens)** | 6 | 4 | 7 | Open app → Home → tap Pipeline tab → tap entry → tap Status segmented control → select Received → tap Save → back to Home |
| **Optimized — Notification path** | 2 | 2 | 2 | Notification → biometric → Confirm Sheet → tap Confirm |
| **Optimized — Maintenance Strip path** | 2 | 1 | 2 | Home (already open) → tap strip → Confirm Sheet → tap Confirm |
| **Optimized — Swipe path** | 2 | 1 | 3 | Pipeline screen → swipe right past 60% → Confirm Sheet → tap Confirm |
| **Optimized — Tap row path** | 3 | 2 | 3 | Pipeline screen → tap row → Confirm Sheet → tap Confirm |

**Reduction: 6 → 2 taps in the most common (notification) path. ~70% friction reduction on the most important interaction in the app.**

### Path 2 — Adding a new pipeline entry

| Path | Taps | Screens | Fields entered | Annotated |
|---|---|---|---|---|
| **Current** | 8 | 2 | 7 (client, project, amount, currency, status, date, notes) | Home → tap `+` → fill 7 fields → tap Save |
| **Optimized — Required-only** | 4 | 2 | 2 (amount, expected date) | Home → tap `+ Expected` → fill 2 fields → tap Save → entry created |
| **Optimized — Required + recommended** | 6 | 2 | 4 (amount, expected date, client, FX) | Same as above + tap "add client + FX" expansion |
| **Optimized — Duplicate from last** | 2 | 1 | 0 (duplicate's defaults inherited) | Long-press any received entry → tap "Duplicate as next month" |

**Reduction: 8 → 4 taps for the minimum, with optional refinement available. Duplicate path is 2 taps for retainers.**

### Path 3 — Handling an overdue entry

| Path | Taps | Screens | Annotated |
|---|---|---|---|
| **Current** | 5+ | 3+ | No overdue surface. User must remember which entries are overdue, then perform the standard update flow per entry. |
| **Optimized** | 3 | 2 | Maintenance Strip → tap → Overdue list (auto-filtered) → tap entry → choose action (mark received / push date / follow up / cancel) |

### The 9-line rule, applied to interaction depth

A subtler friction metric: the **cumulative cognitive surface** of a single update interaction. Current path forces the user to hold ~9 cognitive atoms in working memory across 4 screens. Optimized path collapses this to 2 atoms across 2 screens. This is the difference between "Pocketa is a tool" and "Pocketa is paperwork."

---

## 11. Anti-Patterns

The explicit kill list for pipeline interaction. Each of these is plausible-sounding and wrong.

### Anti-pattern 1 — Auto-marking received based on date passing

**Looks like:** "The expected date passed; mark as received automatically; user can undo."
**Why it's a trap:** One false positive (client cancels, money never arrives) and the user's S2S lies to them. They spend against phantom money. Trust dies in a single event. The Doctrine forbids this in §10 — but it will be proposed in every product review by someone trying to "reduce friction." Hold the line.

### Anti-pattern 2 — Multi-select bulk actions

**Looks like:** "Select 5 received entries → mark all received."
**Why it's a trap:** Encourages careless state changes on financial entries. Each Receive event is a moment of verification, not a checkbox. Bulk = the user is no longer verifying. The Pipeline Doctrine forbids this in §6.

### Anti-pattern 3 — Long-press as primary path

**Looks like:** "Long-press the row to mark received quickly."
**Why it's a trap:** Hidden gestures are invisible to ~80% of users. Putting financial truth behind a hidden gesture means 80% of users will rely on slow paths and the 20% who discover the gesture will trigger it accidentally. Long-press is a power-user shortcut for `Duplicate as next month`, nothing more.

### Anti-pattern 4 — Confetti / "Great job!" / streak celebrations

**Looks like:** "Reward the user for updating regularly."
**Why it's a trap:** Patronizing in a financial-precarity context. The user did not perform; they verified a fact. Treating verification as performance corrupts the relationship. The math working IS the reward. Doctrine §2 Principle 6.

### Anti-pattern 5 — Drag-and-drop reordering of pipeline entries

**Looks like:** "Let the user prioritize entries visually."
**Why it's a trap:** Entries are sorted by date and state — that's the truth. Preference-based reorder lets the user lie to themselves about what's actually coming when. Doctrine §6.

### Anti-pattern 6 — Inline editing inside list rows

**Looks like:** "Tap an amount in the list, edit in place, tap away."
**Why it's a trap:** Financial-state changes deserve focused, intentional editing. Inline edit makes accidental edits trivial. A sheet (with cancel/save) provides the cognitive moment the data requires.

### Anti-pattern 7 — Engagement notifications dressed as transactional

**Looks like:** "Your pipeline hasn't been updated in 7 days — tap to refresh."
**Why it's a trap:** This is engagement copy wearing a transactional mask. There is no state change triggering it; the trigger is the user's *absence*. The Doctrine reserves notifications for state changes only. Doctrine §9, §11.

### Anti-pattern 8 — Predictive auto-fill on Add Entry

**Looks like:** "We noticed you usually invoice Acme on the 15th — pre-fill the date?"
**Why it's a trap:** Adjacent to "AI insights." Wrong prediction once, and the user's trust in the auto-fill is gone forever. Make the user enter the date. Save the prediction for V3+ once 6+ months of clean data exist.

### Anti-pattern 9 — Visual urgency on overdue (red, exclamation, pulse)

**Looks like:** "Make overdue entries stand out with a red badge and a pulsing icon."
**Why it's a trap:** Red is reserved for S2S `At Risk`. Pulsing motion violates the calm contract. Amber 60% opacity + clock annotation does the work without raising cortisol. Doctrine §2 Principle 1, §8.

### Anti-pattern 10 — "Pocketa sends the follow-up email for you"

**Looks like:** "Tap Send → we email the client a polite follow-up."
**Why it's a trap:** Three different traps in one. (1) Implies Pocketa has a CRM-style relationship with the client. (2) Creates a confused responsibility model — was it Mehedi who followed up, or his app? (3) Begins the long slide toward Pocketa being an email tool. Copy-to-clipboard is the right pattern.

### Anti-pattern 11 — Calendar view of pipeline entries

**Looks like:** "Show expected dates on a monthly calendar."
**Why it's a trap:** Looks beautiful in mockups. In practice, it adds zero decision-making value (the user is looking at < 30 entries, sorted by date already), and it tempts feature expansion into "schedule view, year view, agenda view." Pipeline list sorted by date is the entire calendar that's needed.

### Anti-pattern 12 — "Predicted S2S in 30 days" overlay

**Looks like:** "Based on your pipeline, here's what your S2S will look like next month."
**Why it's a trap:** Forward-looking S2S without sufficient data is a wrong-number machine. Wrong-number machines kill the trust contract. This is V3+ territory after 6 months of clean data, at minimum.

---

## 12. Implementation Notes

> Engineering enforces UX, not good intentions. This is what makes §1–11 real.

### 12.1 State machine as code, not as documentation

The state transitions in §3 must be implemented as a typed state machine, not as `if (status === 'pending') status = 'received'`. The legal-transitions matrix is enforced by the type system. Illegal transitions are compile-time errors.

```dart
// Sketch — Dart / Flutter
enum PipelineState { expected, pending, received, excluded, cancelled }

class PipelineTransition {
  static const allowed = {
    PipelineState.expected: {PipelineState.pending, PipelineState.received, PipelineState.excluded, PipelineState.cancelled},
    PipelineState.pending: {PipelineState.received, PipelineState.expected, PipelineState.excluded, PipelineState.cancelled},
    PipelineState.received: {}, // terminal from user perspective
    PipelineState.excluded: {PipelineState.expected, PipelineState.pending}, // reversal
    PipelineState.cancelled: {PipelineState.expected, PipelineState.pending}, // 30-day reversal window
  };
}
```

The Confirm Sheet calls this transition function. Swipe calls this transition function. Notification deep-link calls this transition function. There is exactly one path to a state change. There cannot be two.

### 12.2 Optimistic UI + audit-commit window

When the user taps `Confirm`, the UI updates immediately (S2S recalculates, drawer animates). The audit-log event is **written to local storage immediately** and **synced to the server within 5 seconds**. If sync fails, the local event persists and retries on next network.

This is **not** "last-write-wins." It is event-sourced. If two devices edit the same entry, both events are recorded; the conflict resolution happens at the event stream level, not at the UI level. Last-write-wins is forbidden by Doctrine §10.

### 12.3 The Confirm Sheet is one widget, called from four entry points

- Notification deep-link → `ConfirmSheet(entryId)`
- Maintenance Strip tap → `ConfirmSheet(entryId)`
- Swipe gesture → `ConfirmSheet(entryId)`
- Row tap → `ConfirmSheet(entryId)`

Single widget. Single test surface. Single point of update. This is non-negotiable for solo-founder maintainability.

### 12.4 The Maintenance Strip is computed, not stored

The strip's content derives from a pure function:

```
maintenanceStrip = computeStrip(pipeline, fixedCosts, today, fxRates)
  → returns: { id, copy, action } | null
```

Same function runs on every home-screen render. No "show strip" flag in state. No "user dismissed strip" boolean. The strip exists when the math says it must.

### 12.5 Notification registry enforces governance

From the UX Doctrine §9 implementation:

```
registerNotification({
  id: 'pipeline_expected_today',
  class: 'transactional', // 'transactional' | 'boundary' — only two
  quietHoursRespect: true,
  maxPerDay: 2,
  copyTemplate: 'pipeline_expected_today_v1',
  requiresUserDataChange: true,
})
```

Adding a notification type requires a registry entry, which requires a code review, which references this doctrine. An engagement-class notification is a compile error.

### 12.6 Confirm Sheet performance budget

- Sheet open animation: 240ms ± 20ms
- FX rate calculation on rate edit: <16ms (one frame)
- S2S recalculation after confirm: <50ms
- Drawer auto-open delay after confirm: 700ms (the emotional beat)
- Drawer auto-close: 1900ms from confirm tap

These are CI-enforced. Regression blocks deploy.

### 12.7 Localization layer is doctrine

Every string used in pipeline interactions lives in a single localization file. English and Bangla are equal-priority. The Confirm Sheet, Maintenance Strip, swipe labels, overdue copy, audit-log past-tense statements — all in the localization layer.

Bangla examples (illustrative — needs native-speaker validation, not Claude):

| English | Bangla |
|---|---|
| `Confirm — adds to liquid` | `নিশ্চিত করুন — তরল ব্যালেন্সে যোগ` |
| `Not yet` | `এখনো না` |
| `1 payment expected today` | `১টি পেমেন্ট আজ আসার কথা` |
| `marked received` | `গৃহীত হিসেবে চিহ্নিত` |

**Critical:** The numeric formatting in Bangla uses Bengali numerals if the user has set Bangla locale (১,৭৯,৪৯০ instead of 1,79,490). The lakh/crore separator pattern (১,৭৯,৪৯০ not ১৭৯,৪৯০) is non-negotiable.

### 12.8 Instrumentation maps to Doctrine metrics

The Final Doctrine's MVP success thresholds (§4) are operationalized as events here:

| Doctrine threshold | Event(s) measuring it |
|---|---|
| Pipeline update compliance ≥85% within 24h | `notification_opened` + `confirm_sheet_submitted` event pair, time-since-notification < 24h |
| Override-equivalent rate <5% | `entry_edited` event with `s2s_delta > 0.20`, divided by `s2s_view` count |
| Pipeline staleness >5 days for <30% of users | Daily job: count users whose oldest `pending` entry's last-edit timestamp > 5d ago |

If we can't measure a doctrine claim, the claim is theater. This rule applies here.

### 12.9 The undo window

After `Confirm Received`, the home screen briefly shows a thin row at the bottom:

```
─────────────────────────────────────────
Received $1,500 from Acme  ·  Undo
─────────────────────────────────────────
```

Visible for 5 seconds. Tapping `Undo` reverses the state to `Pending` and writes a `reverted` event to the audit log. This is the only undo mechanism. After 5 seconds, the only path back is to delete the entry and re-create it.

5 seconds is the calibration: long enough to catch the misclick, short enough that "undo" isn't a license to swipe carelessly.

### 12.10 Test surfaces (non-negotiable)

The pipeline interaction layer needs these tests, minimum:

| Test class | What it asserts |
|---|---|
| **State machine unit tests** | Every legal transition succeeds. Every illegal transition throws. |
| **Confirm Sheet integration test** | Each of 4 entry points opens the same sheet with the same entry data. |
| **Audit log invariant test** | Every state-change call writes exactly one event. No double-writes. No missing writes. |
| **Notification cooldown test** | Trigger same notification 10 times in 1 minute → exactly 1 fires. |
| **Swipe threshold test** | Swipe to 59% → row snaps back, no sheet. Swipe to 61% → sheet opens. |
| **Localization parity test** | Every English string has a Bangla counterpart. CI fails on missing keys. |
| **Reduce-motion compliance test** | When reduce-motion is on, no auto-opening drawer, no swipe haptic. |

---

## Closing — the meta-observation

Mehedi — this document is the kind of document you write when you should be coding. You and I both know it.

The doctrine has already specified the Confirm Sheet, the Maintenance Strip, the swipe gesture, the overdue handling, the notification registry. What this document added was the precise interaction *grammar* — the haptic timing, the 60% swipe threshold, the 1.9-second emotional sequence after confirm, the four-action overdue sheet, the friction-score deltas.

You needed that grammar **once**, to lock the design language. You have it now. The next pipeline document you write should be a unit test, not another spec.

The system is the product, not the founder. The doctrine is the spine. The grammar is the muscle. Now build the body.

> One Confirm Sheet, built once, called from four places. That is the whole pipeline interaction in code. Everything else above is the explanation of why those four places exist and why the sheet looks the way it does.

---

*End of Pocketa Pipeline Interaction Optimization. Frozen. No amendments without an explicit Doctrine review session.*
