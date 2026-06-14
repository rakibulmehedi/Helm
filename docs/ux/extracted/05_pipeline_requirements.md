# Pipeline Interaction Requirements Extraction

> **Source:** `docs/research/ux/Helm_Pipeline_Interaction_Optimization.md`
> **Authority level:** Doctrine extension. Governs every state-transition interaction in the Income Pipeline.
> **Foundation:** Final Product Doctrine Sections 4, 10, 11; UX Doctrine Sections 6, 9; Tier-1 Dashboard Critique v2 Sections 6, 7.
> **Extracted:** 2026-06-04

---

## 1. Pipeline States and Transitions

### PIPE-001: Three states only, no sub-states

**Statement:** The pipeline has exactly three active states: `Expected`, `Pending`, `Received`. Plus two terminal/removal states: `Excluded` and `Cancelled`. No sub-states. No "partially received." This is enforced both in code and in the user's mental model.

**Rationale:** State proliferation kills user comprehension. Three states map to the user's natural mental model: "promised," "in transit," "in my pocket."

**Implementation implication:** A typed Dart enum with exactly 5 values. The type system must make illegal states unrepresentable.

---

### PIPE-002: State semantics and S2S connection

**Statement:**

| State | Pipeline label | Counts in S2S? | Meaning |
|---|---|---|---|
| Expected | `Expected` | No | Invoice sent or work agreed; client has not acknowledged |
| Pending | `Pending` | No (Hope tier only, conservative FX) | Client acknowledged or money in transit |
| Received | `Received` | Yes (adds to liquid BDT) | Funds landed in liquid wallet, BDT-converted |
| Excluded | `Excluded` (greyed) | No | User-declared "don't count this." Reversible |
| Cancelled | `Cancelled` (archived) | No | Deal fell through. Reversible within 30 days, then archive-only |

**Rationale:** Only `Received` touches S2S. This is the core conservatism of the pipeline -- money does not count until the user explicitly confirms it landed.

**Implementation implication:** The S2S computation function must only sum `Received` entries into liquid balance. `Pending` entries appear in the Hope tier for informational purposes with conservative FX, but never inflate S2S.

---

### PIPE-003: Allowed state transitions (the only legal moves)

**Statement:**

| From | To | Trigger | Confirmation |
|---|---|---|---|
| Expected | Pending | User taps "Acknowledged by client" / "In transit" | One-tap confirm |
| Expected | Received | User skips Pending (small client, instant pay) | Confirm Sheet with FX |
| Pending | Received | THE central moment. User confirms settlement. | Confirm Sheet with FX |
| Pending | Expected | User realizes premature advance (rare) | Confirm with reason prompt |
| any non-terminal | Excluded | User declares "don't count this" | Single tap, reversible |
| any non-terminal | Cancelled | Deal fell through | Confirm with reason prompt |
| Excluded | previous state | User undeclares exclusion | Single tap |

**Rationale:** Each transition is deliberately designed with appropriate confirmation friction proportional to its financial impact.

**Implementation implication:** A static `allowed` map in the state machine class. Transition function checks legality before executing. Illegal transitions are compile-time or runtime errors, never silent no-ops.

---

### PIPE-004: Forbidden transitions

**Statement:** (1) `Received -> Pending` is forbidden -- once funds are in liquid balance, downgrading rewrites history. If the user made a mistake, they delete the received entry (audit-logged) and re-create it. (2) Any automatic transition is forbidden -- Helm never moves a state without the user's tap. Auto-mark-on-date-passed is the worst pattern the product could ship.

**Rationale:** (1) Protects the liquid balance invariant. (2) One false positive (auto-marking received when money never arrived) means the user spends against phantom money. Trust dies in a single event.

**Implementation implication:** The state machine must reject `Received -> Pending` at the type level. No scheduled jobs, no date-based triggers, no automatic state advancement anywhere in the codebase.

---

### PIPE-005: Cancelled entries have a 30-day reversal window

**Statement:** Cancelled entries are reversible within 30 days, then become archive-only.

**Rationale:** Users sometimes cancel prematurely. A reversal window respects that. After 30 days, the entry is cold enough to archive permanently.

**Implementation implication:** Cancelled entries store a `cancelled_at` timestamp. Reversal logic checks `now - cancelled_at <= 30 days`. After 30 days, the entry moves to archive storage and is no longer interactive.

---

## 2. Quick-Update Interaction Patterns

### PIPE-006: The Confirm-Received Sheet is the single most important interaction

**Statement:** The Confirm Sheet is triggered from any of: notification tap, maintenance strip tap, pipeline row tap, swipe gesture, or "duplicate last" follow-through. It is one widget called from four entry points. It shows: expected amount + client, FX rate (editable), BDT conversion (conservative + live comparison), date received (default today, editable), and a single primary "Confirm -- adds to liquid" button.

**Rationale:** The label states the consequence. The user knows what their tap will do. One verb. One outcome. No marketing copy.

**Implementation implication:** A single `ConfirmSheet` widget that accepts an `entryId` parameter. Called from notification deep-link, maintenance strip, swipe gesture, and row tap. Single widget = single test surface = single point of update.

---

### PIPE-007: Pending to Received in 2 taps (notification path)

**Statement:** The optimized notification path: notification tap -> biometric -> Confirm Sheet -> tap Confirm. Two taps, two cognitive atoms. Reduced from 6 taps / 4 screens / 7 cognitive atoms in the current design.

**Rationale:** ~70% friction reduction on the most important interaction in the app. If only one screen ships polished, this is the one.

**Implementation implication:** Notification deep-links directly to the Confirm Sheet for that specific entry, not to the pipeline screen or home screen. The home screen renders underneath, blurred, peeking behind the sheet.

---

### PIPE-008: Adding a new entry requires only 2 fields minimum

**Statement:** Optimized entry creation: amount and expected date are the only required fields. Client name and FX rate are recommended but optional (expansion affordance). Minimum path: Home -> tap "+ Expected" -> fill 2 fields -> Save. Four taps total. Reduced from 8 taps / 7 fields.

**Rationale:** Capture friction kills the "log it the moment it happens" behavior. Reducing required fields from 7 to 2 preserves the habit.

**Implementation implication:** Add Entry form has two required fields (amount, expected date) visible by default. Client name, FX rate, project name, notes are in a collapsible "add details" expansion. Entry is valid with just amount + date.

---

### PIPE-009: Duplicate-from-last for retainer clients

**Statement:** Long-press any received entry -> tap "Duplicate as next month." Two taps, zero fields to fill. Duplicate inherits all defaults from the source entry with the date advanced by one month.

**Rationale:** Retainer cohort users have the same client, same amount, same cycle every month. Duplicate eliminates all capture friction for this pattern.

**Implementation implication:** Long-press gesture on received entries opens a context menu with "Duplicate as next month" option. Creates a new `Expected` entry with inherited fields and `expected_date = source.expected_date + 1 month`. This is the ONLY legitimate use of long-press in the pipeline.

---

## 3. Status Change UI Requirements

### PIPE-010: Confirm Sheet layout and content

**Statement:** The Confirm Sheet contains exactly: (1) "You expected $X from [Client]" anchor text, (2) FX rate with inline `[edit]` chevron, (3) Conservative BDT conversion + live rate comparison in small text, (4) Date received defaulting to today with `[edit]` chevron, (5) Primary "Confirm -- adds to liquid" button, (6) "Not yet" and "Cancel" tertiary actions.

**Rationale:** Each element earns its place. The FX rate is the single most-edited field. Surfacing it inline prevents a 6-tap edit path. The conservative + live FX comparison trains the user that Helm is pessimistic.

**Implementation implication:** Sheet layout is fixed. FX edit is inline (chevron, not button). Date defaults to today and only shows a picker on edit tap. Primary button label explicitly states the consequence.

---

### PIPE-011: Post-confirm emotional reward sequence

**Statement:** Precise timing after "Confirm" tap: [0ms] haptic single soft tick + sheet begins dismissing (240ms); [200ms] home screen visible, S2S still showing old number; [400ms] S2S cross-fades old to new (no rolling counter), sage-green underline pulses once (300ms); [700ms] breakdown drawer auto-opens for 1.2s showing delta; [1900ms] drawer auto-closes, home is calm. Total: ~1.9 seconds.

**Rationale:** This is the dopamine moment. The math changing IS the reward. No confetti, no "Great job!" The sequence creates a brief "the world updated" moment that reinforces the behavior.

**Implementation implication:** Animation controller with precise keyframes. Reduce-motion variant: no auto-opening drawer; instead, a one-line settlement toast appears below S2S for 4 seconds. Performance budget: sheet dismiss 240ms, S2S recalculation <50ms, drawer open delay 700ms from confirm tap.

---

### PIPE-012: Confirm Sheet forbidden elements

**Statement:** The Confirm Sheet must NOT contain: (1) Cancel button positioned where Confirm is -- muscle memory is trust, (2) auto-dismiss after delay -- user controls when sheet closes, (3) "Are you sure?" double-confirm -- audit log is the undo not a modal, (4) "Quick mark received" toggle that bypasses FX -- the FX is the entire point.

**Rationale:** Each forbidden element either creates accidental state changes, removes user agency, or bypasses the financial verification that justifies the sheet's existence.

**Implementation implication:** Button positions are fixed by design spec. No timer-based dismiss. No double-confirm dialog. FX field is always visible and editable on the sheet.

---

## 4. Pipeline Card/List Display Rules

### PIPE-013: Pipeline entries sorted by date and state, not user preference

**Statement:** Entries are sorted by expected date and state. Drag-and-drop reordering is an anti-pattern. Overdue entries surface at the top under a "Overdue -- needs attention" header. "Needs decision" entries (30+ days overdue) get their own top header.

**Rationale:** Date-and-state sorting is the truth. Preference-based reorder lets the user lie to themselves about what is actually coming when.

**Implementation implication:** Pipeline list view sorts by: (1) overdue/needs-decision at top, (2) then by expected_date ascending, (3) then by state priority (Pending before Expected). No drag handles, no reorder affordance.

---

### PIPE-014: FAB is labeled "+ Expected" during learning phase

**Statement:** Replace the generic "+" FAB with an extended labeled FAB: "+ Expected" in teal accent. After the user has added 5+ entries (learning threshold), the FAB collapses to icon-only form.

**Rationale:** The current "+" reads as "add an expense" to users trained by bKash or TallyKhata. The label teaches the correct mental model: pipeline entries start as "expected" income, not recorded expenses.

**Implementation implication:** FAB widget checks entry count. If < 5, render extended FAB with "Expected" label. If >= 5, render icon-only FAB. Teal accent color. The label is the tuition; the icon earns meaning through use.

---

### PIPE-015: Pipeline row displays client, platform, amount, state, and expected date

**Statement:** Each pipeline row shows: status icon (color-coded), client name, platform name, USD amount, state badge, and expected date with contextual label (e.g., "today", "9 days overdue").

**Rationale:** The user needs to identify the entry and assess its urgency at a glance without tapping into it.

**Implementation implication:** A list tile widget with fixed layout. Status icon uses state-specific colors and annotations (sage-green for today, clock for day +1-6, amber ring for overdue).

---

### PIPE-016: No inline editing inside list rows

**Statement:** Tapping an amount in the list, editing in place, and tapping away is an anti-pattern. Financial-state changes deserve focused, intentional editing via a sheet with cancel/save.

**Rationale:** Inline edit makes accidental edits trivial. A sheet provides the cognitive moment the data requires.

**Implementation implication:** Row taps open an edit sheet or the Confirm Sheet depending on context. No editable fields directly in the list view.

---

## 5. Optimistic Updates vs Confirmation Requirements

### PIPE-017: Optimistic UI with immediate local audit-log write

**Statement:** When the user taps "Confirm," the UI updates immediately (S2S recalculates, drawer animates). The audit-log event is written to local storage immediately and synced to server within 5 seconds. If sync fails, local event persists and retries on next network.

**Rationale:** The emotional reward sequence (PIPE-011) requires instant visual feedback. Waiting for server confirmation would break the 1.9-second loop.

**Implementation implication:** State update and S2S recalculation happen synchronously on confirm tap. Audit event written to local Hive storage. Background sync job fires within 5 seconds. Retry-on-failure with exponential backoff.

---

### PIPE-018: Event-sourced, not last-write-wins

**Statement:** This is NOT "last-write-wins." It is event-sourced. If two devices edit the same entry, both events are recorded; conflict resolution happens at the event stream level. Last-write-wins is forbidden by Doctrine Section 10.

**Rationale:** Financial data integrity requires every change to be individually recorded and reconcilable.

**Implementation implication:** Each state change writes a discrete event with timestamp, device ID, previous state, new state, and associated data (FX rate, date). Multi-device conflict resolution merges event streams, not states.

---

### PIPE-019: 5-second undo window after Confirm Received

**Statement:** After Confirm Received, a thin row appears at the bottom of home: "Received $X from [Client] . Undo." Visible for 5 seconds. Tapping "Undo" reverses state to Pending and writes a `reverted` event to audit log. After 5 seconds, the only recovery path is delete-and-recreate.

**Rationale:** Long enough to catch misclicks, short enough that "undo" is not a license to swipe carelessly.

**Implementation implication:** A dismissible snackbar-style widget with 5-second auto-dismiss timer. Undo action writes a revert event. After timer expires, widget is removed and undo is no longer available.

---

### PIPE-020: Swipe-to-advance always routes through Confirm Sheet

**Statement:** Swipe right past 60% threshold opens the Confirm Sheet. Swipe alone does NOT commit. The swipe is "open the question," not "answer it."

**Rationale:** (1) Accidental swipes are 100x more likely than accidental taps -- the sheet is the safety gate. (2) FX rate must be edited inline and swipe cannot present it. (3) The audit log needs the human-intentional confirmation data.

**Implementation implication:** Swipe gesture handler at 60% row width threshold triggers sheet opening. Below threshold, row snaps back. Haptic at threshold crossing. No state change occurs from swipe alone.

---

## 6. Batch Operations

### PIPE-021: Bulk actions are explicitly forbidden

**Statement:** Multi-select bulk actions ("Select 5 entries -> mark all received") are an anti-pattern. Each Receive event is a moment of verification, not a checkbox.

**Rationale:** Bulk state changes encourage careless verification. Each entry has its own FX rate, its own date, its own client. Verifying them individually is the feature, not the friction.

**Implementation implication:** No multi-select mode in the pipeline list. No "select all" checkbox. No batch action toolbar. Each entry is processed individually through its own Confirm Sheet.

---

## 7. Pipeline-to-STS Connection Rules

### PIPE-022: Only Received state adds to S2S liquid balance

**Statement:** Expected and Pending entries NEVER count in S2S. They appear in the Hope tier for information only with conservative FX shown. When an entry moves to Received via the Confirm Sheet, its BDT-converted amount is added to liquid balance and S2S recalculates.

**Rationale:** This is the core conservatism of the product. Counting unconfirmed money in S2S would be the single most dangerous lie Helm could tell.

**Implementation implication:** The S2S function sums liquid balance (which includes all Received entries) minus fixed costs minus buffer. Pipeline entries in Expected/Pending states are excluded from this calculation entirely.

---

### PIPE-023: Maintenance Strip connects pipeline state to home screen action

**Statement:** The Maintenance Strip appears directly below the S2S Hero Block when a pipeline-related action is needed. It shows contextual copy and deep-links to the specific action. Only one strip at a time, priority-ordered:

| Priority | Condition | Strip copy |
|---|---|---|
| 1 | Entry expected today AND state is Pending | "1 payment expected today. Confirm received -> updates Safe-to-Spend" |
| 2 | Entry overdue >= 7 days | "1 payment is 9 days overdue. Review" |
| 3 | Pending entry FX rate stale >5% vs current | "1 input needs review. Refresh FX -> restores Safe-to-Spend" |
| 4 | Fixed Cost due <= 48h AND S2S covers it | "[Name] due in 2 days. Covered" (dismiss = read receipt) |
| 5 | Fixed Cost due <= 48h AND S2S does not cover it | Not a strip -- S2S moves to At Risk state |

**Rationale:** The home screen must make the next required financial action inescapable when one exists, and invisible when none does.

**Implementation implication:** The strip is a computed widget: `computeStrip(pipeline, fixedCosts, today, fxRates) -> { id, copy, action } | null`. Same function runs on every home-screen render. No "show strip" flag in state. No "user dismissed" boolean. The strip exists when the math says it must. It disappears when the condition resolves.

---

### PIPE-024: S2S visually updates on Confirm Received

**Statement:** After confirm, the S2S number cross-fades from old to new value. Below S2S, a thin sage-green underline pulses once. The breakdown drawer auto-opens briefly showing the delta: "Liquid BDT [old] + [received] = [new]."

**Rationale:** The visual update is the emotional reward. The user sees their financial truth change in response to their action. The delta display proves the math is working.

**Implementation implication:** S2S widget supports animated value transitions (cross-fade, not counter-roll). Accent line pulse animation (300ms). Breakdown drawer auto-open at 700ms with highlighted line showing the delta.

---

## 8. Empty Pipeline States

### PIPE-025: Empty pipeline on first home screen render

**Statement:** After onboarding, the pipeline is empty. The Hope tier on the home screen shows "(empty)" at 40% opacity. No "Add your first invoice" CTA or prompt.

**Rationale:** The user should discover the FAB in their own time. Forcing a first pipeline entry during or immediately after onboarding violates the organic discovery principle.

**Implementation implication:** The Hope tier section renders with placeholder text at reduced opacity. The labeled FAB ("+ Expected") is the passive discovery affordance. No empty-state illustrations, no prompts, no tutorials.

---

### PIPE-026: Maintenance Strip does not appear with empty pipeline

**Statement:** The Maintenance Strip only appears when its conditions are met. An empty pipeline has no entries to trigger any condition, so no strip appears.

**Rationale:** A strip saying "Add your first entry" would be an engagement prompt, which is banned.

**Implementation implication:** The `computeStrip` function returns null when pipeline is empty. The layout reflows so the Threat block rises into the strip's position.

---

## 9. Anti-Patterns for Pipeline Interaction

### PIPE-027: No auto-marking based on date passing

**Statement:** Auto-marking received when the expected date passes is the worst pattern the product could ship. Helm never moves a state without the user's tap.

**Rationale:** One false positive and the user's S2S lies to them. They spend against phantom money. Trust dies in a single event.

**Implementation implication:** No cron jobs, no date-based triggers, no scheduled state changes. All transitions require explicit user action through the state machine.

---

### PIPE-028: No multi-select bulk actions

**Statement:** "Select 5 -> mark all received" encourages careless state changes on financial entries.

**Rationale:** Each Receive event is a moment of verification, not a checkbox. Bulk = the user is no longer verifying.

**Implementation implication:** No multi-select UI mode. No batch state-change endpoints.

---

### PIPE-029: No long-press as primary path

**Statement:** Long-press is invisible to ~80% of users. Putting financial truth behind a hidden gesture means most users rely on slow paths and the minority who discover it trigger it accidentally. Long-press is reserved exclusively for "Duplicate as next month" on received entries.

**Rationale:** Hidden gestures for financial state changes create a two-class user experience where neither class is well-served.

**Implementation implication:** Long-press gesture handler only on Received entries, only for duplicate action. No long-press on Expected or Pending entries.

---

### PIPE-030: No confetti, streaks, or celebration on state changes

**Statement:** No confetti, "Great job!", streak celebrations, or gamified consistency rewards. The math working IS the reward.

**Rationale:** Patronizing in a financial-precarity context. The user verified a fact, not performed. Treating verification as performance corrupts the relationship.

**Implementation implication:** No celebration animations, no toast messages with praise, no streak counters, no achievement badges anywhere in the pipeline flow.

---

### PIPE-031: No drag-and-drop reordering

**Statement:** Entries sorted by date and state reflect the truth. Preference-based reorder lets the user lie to themselves about timing.

**Rationale:** The pipeline is a belief-maintenance system about future money. The sorting must reflect temporal reality, not user preference.

**Implementation implication:** No `ReorderableListView`. No drag handles. Sort order is computed, not user-controlled.

---

### PIPE-032: No inline editing in list rows

**Statement:** Tap-to-edit-in-place for amounts or dates in the list is forbidden. Financial changes deserve a focused sheet.

**Rationale:** Accidental edits on financial data are unacceptable. The sheet's cancel/save provides the cognitive boundary.

**Implementation implication:** All row taps route to a detail sheet. No `TextField` widgets rendered directly in list tiles.

---

### PIPE-033: No engagement notifications disguised as transactional

**Statement:** "Your pipeline hasn't been updated in 7 days" is engagement copy wearing a transactional mask. Notifications fire only on state changes, never on user absence.

**Rationale:** The trigger is the user's absence, not a state change. The Doctrine reserves notifications for state changes only.

**Implementation implication:** Notification registry rejects any notification type where `requiresUserDataChange` is false. Absence-based triggers are compile-time errors.

---

### PIPE-034: No predictive auto-fill on Add Entry

**Statement:** "We noticed you usually invoice Acme on the 15th" is adjacent to "AI insights." One wrong prediction destroys trust in auto-fill forever.

**Rationale:** The cost of a wrong prediction exceeds the benefit of a correct one. V3+ territory once 6+ months of clean data exist.

**Implementation implication:** No suggestion engines, no auto-complete on client names or dates, no "smart" defaults beyond the income-pattern-driven pipeline defaults set during onboarding.

---

### PIPE-035: No visual urgency on overdue (no red, no pulse)

**Statement:** Red is reserved exclusively for S2S "At Risk" state. Pulsing motion violates the calm contract. Overdue entries use amber 60% opacity with clock annotation.

**Rationale:** If overdue entries used red, the red would lose all signal value when it actually mattered (S2S At Risk). Amber is visible enough to draw attention, quiet enough not to trigger cortisol.

**Implementation implication:** Overdue entry styling uses `AppColors.amber.withValues(alpha: 0.6)`. No `AnimationController` for pulsing on overdue entries. Red (`#9E4A3A`) is used only for S2S At Risk state.

---

### PIPE-036: No calendar view of pipeline entries

**Statement:** Monthly calendar view looks beautiful in mockups but adds zero decision-making value for < 30 entries already sorted by date. It tempts expansion into schedule/year/agenda views.

**Rationale:** The pipeline list sorted by date IS the entire calendar that is needed. Additional views create maintenance burden without decision-making value.

**Implementation implication:** No calendar widget in the pipeline screen. No date-grid views. The list view is the only pipeline visualization.

---

### PIPE-037: No "Predicted S2S in 30 days" overlay

**Statement:** Forward-looking S2S without sufficient data is a wrong-number machine. V3+ territory after 6 months of clean data minimum.

**Rationale:** Wrong-number machines kill the trust contract. Prediction without historical basis is speculation dressed as math.

**Implementation implication:** No forward-projection features. No "what-if" calculators. S2S shows only current state computed from confirmed data.

---

### PIPE-038: Helm does not send follow-up emails

**Statement:** The "polite follow-up" for overdue entries is copy-to-clipboard only. Helm does NOT send messages on behalf of the user.

**Rationale:** Sending implies CRM territory and creates confused responsibility. Was it the freelancer or their app that followed up? Copy-paste keeps the user in control.

**Implementation implication:** Follow-up template generates text and copies to clipboard. No email sending, no WhatsApp integration, no in-app messaging to clients.

---

## 10. Trust Indicators for Pipeline Amounts

### PIPE-039: Conservative FX is always the default

**Statement:** The Confirm Sheet shows a conservative FX rate (pessimistic) as the default conversion, with the live rate shown as a comparison in small text: "(conservative . live: 120.10)."

**Rationale:** Trains the user that Helm is pessimistic. The live rate is the upside, not the baseline. This prevents the scenario where the user sees a generous conversion, confirms, and then finds less BDT in their actual account.

**Implementation implication:** FX rate logic must default to a conservative (below-market) rate. The live rate is displayed for reference but not used as the default. User can manually edit to the live rate if they choose.

---

### PIPE-040: FX rate is always visible and editable per entry

**Statement:** Every pipeline entry stores its own FX rate. The rate is visible on the Confirm Sheet with an inline edit chevron. The per-entry FX value is visible in the entry detail view.

**Rationale:** Global currency toggle without per-entry FX visibility means the first time the BDT-equivalent looks wrong, the user blames Helm instead of the rate they used.

**Implementation implication:** Each pipeline entry model includes an `fxRate` field. The Confirm Sheet displays it prominently with edit affordance. Entry detail view shows the stored rate and its BDT conversion.

---

### PIPE-041: Audit log provides per-entry history

**Statement:** Every pipeline entry has a visible history section (collapsed by default, three most recent events visible, tap to expand). Events shown in past tense, agentless ("marked received," not "you marked received"), with numbers before reasons ("from 118.40 to 119.66").

**Rationale:** When numbers feel wrong, the audit trail provides reconstruction. Without it, trust collapses silently when the user cannot verify how a number changed.

**Implementation implication:** Each entry has an associated event stream. History UI renders events in reverse chronological order. Events include: created, state changed, FX rate changed, expected date moved, amount edited. History cannot be deleted -- not by the user, not by anything.

---

### PIPE-042: Stale FX triggers Maintenance Strip review prompt

**Statement:** When a Pending entry's stored FX deviates >5% from the current rate, the Maintenance Strip shows: "1 input needs review. Refresh FX -> restores Safe-to-Spend."

**Rationale:** Stale FX rates mean the BDT conversion is increasingly wrong. The strip ensures the user is aware without nagging.

**Implementation implication:** A background job compares stored FX rates on Pending entries against current market rates. If deviation exceeds 5%, the condition feeds into the `computeStrip` function. Also triggers a `pipeline_fx_stale` notification (max 1/day).

---

### PIPE-043: Overdue handling escalation timeline

**Statement:** Day 0 = expected date (passive). Day +1 to +6 = late but no escalation (clock annotation on status icon). Day +7 = entry becomes Overdue with active escalation (amber ring, "needs attention" section). Day +30 = entry moves to "Needs decision" state. Never auto-cancelled.

**Rationale:** The escalation is proportional. Days 1-6 are normal payment-system delays. Day 7+ genuinely requires attention. Day 30+ is noise that needs resolution. Auto-cancel would destroy trust permanently.

**Implementation implication:** Overdue logic is computed from `expected_date` vs `today`. Three visual tiers: Day 0 (sage-green dot, "today" label), Day 1-6 (clock annotation, no escalation), Day 7+ (amber ring, sorted to top of pipeline under header). Day 30+ gets a "Decide" button.

---

### PIPE-044: Four actions for overdue entries

**Statement:** Tapping an overdue entry presents four options: (1) Mark received -- confirm date + FX, (2) Push expected date -- pick a new date, (3) Send polite follow-up -- pre-drafted template to copy, (4) Cancel -- removes from pipeline, reversible 30 days.

**Rationale:** Each action addresses a distinct real-world scenario for why a payment is late. The user is never stuck with only "it arrived" or "it didn't."

**Implementation implication:** Overdue entry tap opens an action sheet with four options, each routing to its own interaction: Confirm Sheet, date edit sheet, follow-up template screen, and cancel confirmation.

---

### PIPE-045: Notification restraint as trust signal

**Statement:** Notification rules: (1) Quiet hours 22:00-08:00 by default, (2) Cap: 2 transactional + 1 boundary per day hard ceiling, (3) Two snoozes silences a notification forever for that entry, (4) No re-engagement if user absent 7+ days, (5) Deep-link directly to Confirm Sheet in <2 taps.

**Rationale:** Every notification NOT sent is felt as respect. A wrong notification reverses three weeks of trust-building. The notification surface is the most restrained part of Helm.

**Implementation implication:** Notification registry enforces class (`transactional` | `boundary` only), quiet hours, daily caps, snooze counters, and deep-link targets. "Engagement" class is a compile-time error. No weekly summaries, guilt-pings, feature-education pushes, email digests, re-marketing, or streaks.

---

### PIPE-046: Swipe gesture rules

**Statement:** Swipe right = advance state (opens Confirm Sheet). Swipe left = quick edit menu (Edit FX, Edit date, Exclude, Cancel deal). Swipe threshold is 60% of row width. Haptic at threshold. No swipe on Received rows (terminal). Reduce-motion users see a small chevron instead.

**Rationale:** 60% threshold is calibrated against financial-action stakes -- a 40% threshold (common in mail apps) is too easy to trigger accidentally. Swipe is a power-user shortcut layered on top of the visible tap path, never a replacement.

**Implementation implication:** `Dismissible`-style gesture detector with 60% threshold. Right-reveal shows sage-green with "Confirm received" label. Left-reveal shows muted teal with icon stack. Released-past-threshold opens the sheet. Released-before-threshold snaps back. Accessibility: chevron button on row for reduce-motion users.

---

## 11. Performance and Implementation Constraints

### PIPE-047: Confirm Sheet performance budget

**Statement:** Sheet open animation: 240ms +/- 20ms. FX rate calculation on edit: <16ms (one frame). S2S recalculation after confirm: <50ms. Drawer auto-open delay: 700ms. Drawer auto-close: 1900ms from confirm tap. CI-enforced.

**Rationale:** The emotional reward sequence depends on precise timing. Regression in any of these breaks the confirm-to-calm loop.

**Implementation implication:** Performance tests assert these timing constraints. CI blocks deploy on regression. Animation durations are constants, not magic numbers scattered through the code.

---

### PIPE-048: State machine enforced by type system

**Statement:** The state transitions must be implemented as a typed state machine, not as `if (status === 'pending') status = 'received'`. Illegal transitions are compile-time errors.

**Rationale:** A runtime-only check means a bug can ship an illegal transition. A type-system check means the code cannot compile with one.

**Implementation implication:** Dart class with static `allowed` map. Transition function checks the map before executing. All entry points (Confirm Sheet, swipe, notification, row tap) call the same transition function. There is exactly one path to a state change.

---

### PIPE-049: Localization parity for all pipeline strings

**Statement:** Every pipeline interaction string lives in a single localization file. English and Bangla are equal-priority. Bengali numerals used in Bangla locale with lakh/crore separators. CI fails on missing localization keys.

**Rationale:** A missing Bangla string in a financial confirmation sheet is a trust break for Bangla-mode users.

**Implementation implication:** Localization parity test in CI: every English key must have a Bangla counterpart. Bengali numeral formatting switches based on device locale.

---

### PIPE-050: Minimum required test surfaces

**Statement:** Non-negotiable tests: (1) State machine unit tests -- every legal transition succeeds, every illegal throws, (2) Confirm Sheet integration test -- all 4 entry points open same sheet, (3) Audit log invariant test -- every state change writes exactly one event, (4) Notification cooldown test -- same trigger 10x in 1 minute produces exactly 1 notification, (5) Swipe threshold test -- 59% snaps back, 61% opens sheet, (6) Localization parity test, (7) Reduce-motion compliance test.

**Rationale:** The pipeline interaction layer is the most-used, most-trusted, and most-dangerous part of the product. Untested financial interactions are unshippable.

**Implementation implication:** These 7 test categories are pre-merge gates. PR cannot merge if any test category is absent for code touching pipeline interactions.

---

*End of pipeline interaction requirements extraction. Source: `docs/research/ux/Helm_Pipeline_Interaction_Optimization.md`.*
