# Onboarding Requirements Extraction

> **Source:** `docs/research/ux/Helm_Onboarding_Redesign.md`
> **Authority level:** Operational specification. Subordinate to UX Doctrine and Final Product Doctrine. If conflict, Doctrine wins.
> **Extracted:** 2026-06-04

---

## 1. Onboarding Flow Steps and Sequence

### ONB-001: Seven-screen linear sequence

**Statement:** Onboarding consists of exactly 7 user-facing screens plus the S2S reveal (Screen 8, which is the home screen first-load). The sequence is strictly linear with no branching except the disqualification exit on Screen 1.

**Screens in order:**
1. Qualifying Question (memory probe + disqualification gate)
2. Account Creation via Magic Link (email only)
3. Liquid Balance Entry (single BDT figure)
4. Fixed Costs Capture (guided checklist with inline expansion)
5. Income Pattern Declaration (single-select picture cards)
6. Buffer Comfort (slider with live BDT preview)
7. PIN / Biometric Setup + Recovery Phrase
8. S2S Reveal (home screen first render -- not a separate onboarding screen)

**Rationale:** The doctrine specifies "5 steps" but operationally qualification, account creation, and PIN setup are real screens even though they do not feel like questions. Numbering reflects user-facing surfaces.

**Implementation implication:** Router must enforce strict linear progression. No skipping, no reordering, no deep-linking to mid-flow screens. Back navigation is not offered during onboarding (no back button, no top navigation bar).

---

### ONB-002: No back button or top navigation during onboarding

**Statement:** All onboarding screens are full-canvas. No top navigation bar, no "Back" button, no logo, no header.

**Rationale:** The screens are a commitment funnel. Back navigation invites re-deliberation on already-committed inputs, which increases cognitive load and time-on-task.

**Implementation implication:** GoRouter onboarding routes must suppress AppBar entirely. Progress is indicated only by a thin 2pt horizontal line at the top that fills left-to-right.

---

### ONB-003: Progress indicator is a thin line only

**Statement:** A single thin horizontal line at the top of the screen, 2pt tall, in interactive teal. Fills left-to-right as steps complete. No percentage text. No step numbers ("Step 3 of 7"). Just the line.

**Rationale:** The bar itself is enough; percentage labels add anxiety. Step numbers invite counting and create the "almost there" impatience problem.

**Implementation implication:** A custom linear progress widget. Progress values are approximately: Screen 1 = empty, Screen 2 = 12%, Screen 3 = 25%, Screen 4 = 38%, Screen 5 = 50%, Screen 6 = 63%, Screen 7a = 75%, Screen 7b = 88%.

---

## 2. Required Data Collection Points

### ONB-004: Eight required inputs, only four require content entry

**Statement:** Total required inputs: 8. Of these, only 4 require numeric or content entry (balance, fixed costs, buffer, PIN). The rest are taps or selections.

| Input | Screen | Used for | Editable later? |
|---|---|---|---|
| Qualification answer | 1 | Eligibility gate | No -- one-time |
| Email address | 2 | Authentication via Magic Link | Yes -- Settings |
| Liquid BDT balance | 3 | S2S base addend | Yes -- Home tap |
| Fixed costs (0+ items) | 4 | S2S subtraction; threat-tier | Yes -- Settings |
| Income pattern | 5 | Pipeline UX defaults | Yes -- Settings |
| Buffer percentage | 6 | S2S subtraction; buffer-tier | Yes -- Settings |
| 6-digit PIN | 7 | App-open gate | Yes -- Settings |
| Recovery phrase acknowledged | 7 | Account recovery | Regenerable on request |

**Rationale:** Every field asked must directly feed the first S2S calculation. If a field is not needed to render Screen 8 correctly, it is not an onboarding field.

**Implementation implication:** Onboarding data model has exactly these 8 fields. The S2S computation function takes liquid balance, fixed costs array, and buffer percentage as inputs.

---

### ONB-005: Liquid balance is a single combined BDT number

**Statement:** Screen 3 asks "Roughly how much do you have right now in bKash, bank, and cash -- combined?" as a single numeric input. No wallet partitioning.

**Rationale:** Multi-wallet is V1, not MVP. Separating wallets adds 3+ fields and decision burden without improving the first S2S.

**Implementation implication:** Single numeric field. Accept any positive integer up to 10 crore. Reject 0 with correction copy. Format with lakh/crore separators in real time as user types.

---

### ONB-006: Fixed costs capture uses pre-named categories with inline expansion

**Statement:** Seven pre-named categories: Rent/housing, Internet, Mobile/phone, Subscriptions, Family support/parents, Loan EMI, Other recurring expense. Tapping a checkbox expands an inline mini-form for amount (BDT) and day-of-month (1-31). No modals.

**Rationale:** Pre-named categories remove "what counts as a fixed cost?" decision burden. Inline expansion avoids modal-stacking on the highest-friction screen. The 7 defaults cover 80% of cases.

**Implementation implication:** A list of category rows with expandable inline forms. Each expanded row has: amount field (BDT), day-of-month selector, remove affordance. Default day-of-month pre-fills from common patterns (rent = 1st, internet = 5th). Monthly frequency only in MVP.

---

### ONB-007: Income pattern is single-select from three options

**Statement:** Three large picture cards stacked vertically. Single-select only: Marketplace escrow (Upwork, Fiverr), Direct client invoicing, Retainer or recurring.

**Rationale:** This drives pipeline UX defaults downstream. "I do all three" is not offered -- pick the dominant pattern. Edge cases handled in pipeline UX, not onboarding.

**Implementation implication:** Three radio-style card widgets. Selection drives pipeline default configuration: Marketplace = 5-14 day lag + FX entry; Direct = net-30 lag + FX entry; Retainer = 30-day cycle + "duplicate last" gesture prominence.

---

### ONB-008: Buffer is a slider with four anchor stops and live preview

**Statement:** Horizontal slider with four anchor stops (5%, 15%, 25%, 30%). Default at 15%. Below slider: live BDT preview showing exact held-aside amount and resulting S2S, computed from Screen 3's liquid balance, updating with no lag as user drags.

**Rationale:** The live preview is the pedagogical payoff. The user sees in real numbers what the abstract percentage means. No "skip -- use default" button needed because the slider IS the default; touching it is optional.

**Implementation implication:** Slider widget with snapping behavior at 5/15/25/30. Reactive computation: `heldAside = liquidBalance * bufferPct` and `s2sAfterBuffer = liquidBalance - heldAside - totalFixedCosts`. Both values update in real time.

---

### ONB-009: PIN is 6-digit with biometric alternative and recovery phrase

**Statement:** 6-dot PIN entry with auto-advancing input. "Use biometric instead" option surfaced only if device supports it. After PIN confirmation, a 12-word BIP-39 recovery phrase is presented with copy button. User must acknowledge "I've saved it" to proceed.

**Rationale:** The friction is the trust signal. The recovery phrase manual-save is a deliberate UX choice demanded by Trust Layer L1. PIN is hashed with Argon2id.

**Implementation implication:** PIN entry screen, confirmation re-entry screen, recovery phrase screen (Screen 7a, 7b sequence). Biometric check via local_auth. Recovery phrase generation via BIP-39 standard. "Continue" button disabled until PIN confirmed and phrase acknowledged.

---

## 3. Optional / Skippable Steps

### ONB-010: There are NO optional inputs during onboarding

**Statement:** Every screen either captures a required input or moves the user toward one. There is no "skip" button that leads to a half-populated S2S. There is no "add later" affordance for things needed now.

**Rationale:** Optional inputs create three failure modes: (1) cognitive overhead from deciding whether each applies, (2) S2S degradation if skipped input was needed, (3) future "complete your profile" nags which are banned.

**Implementation implication:** No skip buttons on any screen. No "later" links. The only screen where zero entries is allowed is Screen 4 (fixed costs), and even that gets one inline re-ask before proceeding.

---

### ONB-011: Fixed costs zero-state gets exactly one re-ask

**Statement:** If the user taps Continue on Screen 4 with zero costs selected, present a single inline confirmation: "No fixed monthly costs? That's unusual. You can add them later if any come up." with [Continue anyway] and [Let me add some]. One re-ask, no second.

**Rationale:** Zero fixed costs is genuinely uncommon for the target user and more likely an "I'll do it later" abandonment than a true zero state. But it is NOT a nag-lock -- one re-ask respects the user.

**Implementation implication:** Conditional dialog/inline confirmation widget. After re-ask is shown once, the "Continue anyway" path proceeds without further gates. Track this cohort separately -- likely marketplace beginners for whom S2S has reduced value.

---

## 4. First-Run Experience Rules

### ONB-012: S2S reveal is the home screen, not a separate celebration screen

**Statement:** Screen 8 is not a screen -- it is the home screen loaded for the first time with all 9 lines populated. After Screen 7, the app transitions over 320ms (slightly slower than standard 200-280ms) to the home screen.

**Rationale:** The number itself is the celebration. Adding celebration on top of celebration breaks both. The S2S figure earned through ~2:45 of honest input is more powerful than any banner.

**Implementation implication:** No OnboardingComplete screen. GoRouter navigates directly from PIN/recovery to home. The home screen detects first-run and shows the one-time hint. Transition duration = 320ms.

---

### ONB-013: Only one in-product hint in MVP

**Statement:** Below the S2S number on first render, a one-time inline hint appears: "Tap the number to see the math." It vanishes on first scroll or tap and never returns. This is the ONLY in-product hint in MVP.

**Rationale:** Over-tutorializing the home screen interferes with organic discovery. The transparency contract (tap to see math) is the only thing worth pointing to.

**Implementation implication:** A shared preference flag `has_seen_s2s_hint`. Hint widget conditionally rendered. Dismissed on any user action (scroll, tap anywhere). Once dismissed, flag is set and hint never renders again.

---

### ONB-014: No tour, no carousels, no feature demo, no welcome banner

**Statement:** Screen 8 must NOT contain: "Welcome to Helm!" celebration banner, "Onboarding complete!" toast, confetti, haptic burst, sound, tour overlay, or "Add your first invoice" CTA.

**Rationale:** The user's internal monologue at Screen 8, if onboarding succeeded, should be: "Oh. So that's actually what I can spend. Huh." That "Huh" is worth more than 10,000 confetti animations.

**Implementation implication:** Code review must reject any celebration/tour/welcome additions to the first home screen render. The post-onboarding home screen is identical to every subsequent home screen except for the one-time hint (ONB-013).

---

### ONB-015: Post-onboarding discovery is organic

**Statement:** After S2S reveal, the user can: (1) tap S2S number to see breakdown, (2) scroll to see threats and pipeline, (3) tap the floating "+" to add their first pipeline entry. None of these is forced. The user can close the app.

**Rationale:** Daily-active is a retention metric, not an onboarding metric. The user will return when they need to check S2S again, which is the entire product loop. Onboarding must not interfere with the second value moment.

**Implementation implication:** No forced first-action flow after onboarding. The home screen renders normally. The FAB is present. Pipeline is empty. Discovery is the user's prerogative.

---

## 5. Progressive Disclosure Requirements

### ONB-016: Onboarding collects nothing beyond S2S computation needs

**Statement:** Onboarding never asks income amount, USD pending, or client list. Those are pipeline-entry actions that happen post-onboarding when the user has skin in the game.

**Rationale:** The time to ask for pipeline data is after the user has seen and trusted their S2S number, not before.

**Implementation implication:** No pipeline, income, or client fields in the onboarding data model. Pipeline entry is a separate feature discovered post-onboarding via the FAB.

---

### ONB-017: Features that LOOK optional are actually post-onboarding

**Statement:** The following are NOT onboarding screens -- they surface organically after onboarding: first pipeline entry (FAB), wallet partitioning (V1), tax reserve (V2), Invoice-Lite (V2), Bangla toggle (Settings), notification preferences (Settings), custom fixed cost categories (inline in Fixed Costs registry).

**Rationale:** If a field is not needed to render Screen 8 correctly, it is not an onboarding field. Full stop.

**Implementation implication:** None of these features should be gated behind or prompted during onboarding. Settings defaults are sensible from Day 1.

---

## 6. Minimum Viable Onboarding

### ONB-018: Absolute minimum to compute S2S

**Statement:** The hard floor of data for a meaningful S2S on Screen 8 is: liquid BDT balance (Screen 3), fixed costs or acknowledged zero-state (Screen 4), and buffer percentage (Screen 6). Without these three, S2S cannot render.

**Rationale:** S2S = Liquid Balance - Fixed Costs - Buffer. All three subtraction/addition components must have values.

**Implementation implication:** The S2S computation function requires these three inputs. Email and PIN are authentication/security requirements, not S2S computation requirements. Income pattern drives pipeline defaults but does not affect the initial S2S number.

---

### ONB-019: Nice-to-have inputs are banned from onboarding

**Statement:** The following are explicitly forbidden as onboarding requirements: name, age, gender, profession label, phone number, address, national ID, tax ID, bank account number, bKash number, profile picture, client names, income amount, currency preference, language selection, marketing consent.

**Rationale:** Each violates the friction budget. If any surfaces in a future design review with a "wouldn't it be useful?" rationale, the answer is NO.

**Implementation implication:** Code review must reject any PR that adds fields from this list to the onboarding flow.

---

## 7. Emotional Tone During Onboarding

### ONB-020: Onboarding is an emotional arc, not a funnel

**Statement:** The user starts in one psychological state and must end in a different one. The arc is mapped per screen:

| Screen | Entering state | Designed shift | Exiting state |
|---|---|---|---|
| 1. Qualifier | Skeptical curiosity | Recognition (memory retrieval) | Relief: "Someone gets it" |
| 2. Email | Mild guard ("spam?") | Inline disclosure neutralizes in <2s | Neutral, willing |
| 3. Balance | First commitment anxiety | "Rough is fine" disarms | Cooperative |
| 4. Fixed costs | Friction peak | Guided checklist removes decision burden | Mildly fatigued, engaged |
| 5. Income pattern | Re-engagement | Picture cards feel light after form | Curious about payoff |
| 6. Buffer | Educational moment | Live preview teaches | Pedagogical satisfaction |
| 7. PIN | Friction (right kind) | Read as "this is real, this protects me" | Trust deepens |
| 8. S2S reveal | Anticipation | Number arrives, math visible on tap | Recognition + ownership |

**Rationale:** If emotional pacing is not deliberately designed, the user hits two danger zones (Screens 4 and 7) without mitigation, and abandonment spikes.

**Implementation implication:** Copy, layout density, and interaction pattern must vary by screen to match the emotional arc. Screen 4 must be the most carefully designed (highest friction). Screen 8 must be the calmest (deliberate emotional silence).

---

### ONB-021: Helm's voice is a chronometer, not a person

**Statement:** Helm is not trying to be friendly. Onboarding is the moment the user picks up the instrument, not meets a person. The tone is factual, matter-of-fact, never performative.

**Rationale:** UX Doctrine Section 2.6 defines Helm as a chronometer. Warmth is signaled through accuracy and honesty, not through conversational copy.

**Implementation implication:** All onboarding copy must pass the "chronometer test" -- would this sentence make sense on the face of a precision instrument? If not, rewrite.

---

### ONB-022: Deliberate emotional silence at Screen 8

**Statement:** The temptation to add confetti, "Welcome!", a tour, or a celebration toast is enormous. The doctrine forbids all of it. The number itself is the celebration.

**Rationale:** Adding a celebration on top of a celebration breaks both. The "Huh" moment of seeing an honest S2S number is more powerful than any animation.

**Implementation implication:** Any PR that adds celebratory elements to the post-onboarding home screen must be rejected. The S2S number fades in last, over 200ms, monospaced, ~64pt, sage-green accent line. That is the entire reveal.

---

## 8. Error / Recovery States

### ONB-023: Screen 1 inactivity triggers plain-language rephrase

**Statement:** If the user shows >12 seconds of inactivity on Screen 1, interpret this as "What does that mean?" and offer a plain-Bangla rephrase. One re-ask. If still unclear, soft disqualify.

**Rationale:** The qualifying question is a memory probe. Confusion is itself a disqualifying signal, but one rephrase attempt is respectful.

**Implementation implication:** Timer starts on Screen 1 mount. At 12s without tap, show rephrase variant. Track this path in analytics as a separate cohort.

---

### ONB-024: Screen 3 rejects zero balance with honest copy

**Statement:** Entering 0 on Screen 3 triggers: "Helm needs at least a small liquid balance to compute S2S. If you have nothing right now, come back when you do." No account deletion -- they can return.

**Rationale:** S2S cannot be computed from zero. Rather than showing a meaningless "0" S2S, be honest that the tool requires at least some balance.

**Implementation implication:** Input validation rejects 0. Shows inline error copy. Does not advance. Does not destroy account state.

---

### ONB-025: Screen 2 Magic Link delivery handling

**Statement:** Send-link button has zero-latency visual confirmation. Resend available at 30 seconds. Magic Link tokens expire in 15 minutes, one-time use, bound to device ID. After link tap in email, app opens directly to Screen 3 -- no "verified!" celebration screen.

**Rationale:** Email-typing friction and inbox-switching are real drop-off risks. The mitigation is fast visual feedback and quick resend. The absence of a celebration screen maintains momentum.

**Implementation implication:** Immediate optimistic UI on send tap. 30s cooldown timer for resend. Deep link handler routes to Screen 3. Token validation is atomic with account creation.

---

### ONB-026: Onboarding state is server-side and resumable

**Statement:** If user switches devices mid-onboarding, they resume at the exact step. If they abandon and reopen on the same device, they resume at the exact step.

**Rationale:** Client-side-only state means device switch = restart. Restart = abandonment for users who already invested effort.

**Implementation implication:** Each step's input writes to server-side state on "Continue" tap. Resume logic checks server state on app open and routes to the correct screen.

---

### ONB-027: PIN mismatch handling

**Statement:** Screen 7 requires PIN confirmation re-entry. Mismatches must be handled gracefully without losing the first entry context.

**Rationale:** PIN re-entry mistypes are the second-highest-risk friction point.

**Implementation implication:** On mismatch, clear the confirmation field and show inline error. Do not clear the original PIN. Track mismatch rate in analytics.

---

## 9. Success Criteria

### ONB-028: Overall completion rate gate

**Statement:** MVP closed-beta gating threshold: at least 70% onboarding completion unaided (qualified users). Below this, onboarding fails and is redesigned.

**Rationale:** Final Doctrine Section 4 headline target.

**Implementation implication:** Analytics must track qualified-user-to-Screen-8 conversion rate. This is a go/no-go gate for public launch.

---

### ONB-029: Per-screen abandonment caps

**Statement:**

| Screen | Max abandonment |
|---|---|
| 1. Qualifier | n/a (qualification, not abandonment) |
| 2. Email | 15% |
| 3. Balance | 8% |
| 4. Fixed costs | 15% (highest priority redesign target if exceeded) |
| 5. Income pattern | 5% |
| 6. Buffer | 8% |
| 7. PIN + recovery | 10% |

**Rationale:** Each screen has a distinct risk profile. Exceeding these caps triggers specific redesign actions.

**Implementation implication:** Per-screen `onboarding_step_abandoned` events must be tracked. Dashboard must show per-screen abandonment rates.

---

### ONB-030: Time constraints

**Statement:** Target median onboarding time (Q1 Yes to Screen 8 load): 180 seconds or less. Hard ceiling P95: 300 seconds. Design gives 15s of buffer for slower users with 2:45 target median.

**Rationale:** Doctrine-defined hard targets. Beyond 5 minutes, the friction-to-promise ratio breaks.

**Implementation implication:** `onboarding_completed` event tracks `total_duration_ms`. Monitor median and P95. Per-screen time budgets: Screen 1 = 15s, Screen 2 = 30s, Screen 3 = 25s, Screen 4 = 60s, Screen 5 = 15s, Screen 6 = 20s, Screen 7 = 35s.

---

### ONB-031: S2S comprehension is the sufficient success condition

**Statement:** In a 5-minute beta interview, the user must be able to explain: (1) what the S2S number represents in their own words, (2) how it was calculated (additions and subtractions), (3) why it differs from their bKash balance. At least 80% of beta users must achieve all three.

**Rationale:** Quantitative completion rates are necessary but not sufficient. Comprehension is the real measure of onboarding success.

**Implementation implication:** This is a qualitative metric measured through beta interviews, not instrumentation. However, the "tap to see the math" hint (ONB-013) and the breakdown drawer directly support this goal.

---

### ONB-032: Three psychological events define true success

**Statement:** Onboarding succeeds when three events occur in sequence: (1) Recognition -- user nods at qualifying question, (2) Compliance without resistance -- user enters data without abandoning or seeking "later" buttons, (3) Comprehension of S2S -- user can articulate what the number means without help.

**Rationale:** Funnel completion is necessary but not sufficient. These three events are the sufficient condition.

**Implementation implication:** Event (1) is proxied by Q1 dwell time and "Yes" tap confidence. Event (2) is proxied by absence of back-seeking behavior and per-screen completion rates. Event (3) is measured qualitatively in beta interviews.

---

### ONB-033: First S2S calculation must succeed 99%+ of the time

**Statement:** Screen 8 must render a non-null S2S for at least 99% of users who complete onboarding.

**Rationale:** If below 99%, the compute path is broken or input validation is failing silently.

**Implementation implication:** S2S calculation must handle all edge cases: zero buffer, max balance, no fixed costs, all fixed costs, all income patterns. Requires 40+ unit test cases.

---

## 10. Anti-Patterns (What Onboarding Must NOT Do)

### ONB-034: Must not maximize signups

**Statement:** Disqualifying the wrong user is a feature, not a leak. Onboarding must not be optimized for conversion of all visitors.

**Rationale:** Wrong users churn, inflate support costs, dilute beta data, and write reviews from a perspective Helm was never built for.

**Implementation implication:** No A/B tests aimed at increasing Q1 "Yes" rate. The qualifying question can be A/B tested for clarity, but not for conversion.

---

### ONB-035: Must not collect data for analytics

**Statement:** Every field asked must directly feed the first S2S calculation. No data collection for its own sake.

**Rationale:** Analytics-motivated fields add friction without user value. They violate the trust contract.

**Implementation implication:** Any field that does not appear in the S2S computation function must be rejected from onboarding.

---

### ONB-036: Must not demo features

**Statement:** No carousels, no "here's what Helm can do," no value-prop slides, no feature tour.

**Rationale:** The qualifying question is the only selling needed. If it does not resonate, no feature demo will convert the user.

**Implementation implication:** No carousel widgets, slideshow components, or tooltip tours in the onboarding flow.

---

### ONB-037: Must not use banned copy patterns

**Statement:** The following copy is explicitly banned: "Let's get started!", "Almost there!", "One more step!", "Just X more questions", "Welcome to Helm!", "Tell us about yourself", "We need this to give you the best experience", "Your data is safe with us", "Welcome aboard!", "Awesome! Just one more thing...", progress bar percentage labels.

**Rationale:** Each violates the chronometer tone. Performative copy signals a marketing mindset, not a trust mindset.

**Implementation implication:** String review in `i18n/onboarding.en.json` and `i18n/onboarding.bn.json` must reject any string matching these patterns.

---

### ONB-038: Must not add "connect your bank/platform" affordances

**Statement:** No "Connect Upwork" or "connect your bank" on any onboarding screen. No such integration exists in MVP.

**Rationale:** Pretending an integration exists when it does not is the first trust break. The promise of future connection is itself a trust risk.

**Implementation implication:** No OAuth flows, API connection buttons, or "coming soon" placeholders in onboarding.

---

### ONB-039: Must not schedule notifications during onboarding

**Statement:** Any `notification.schedule()` call during onboarding is forbidden. Engagement notifications are banned by Doctrine.

**Rationale:** The user has not yet established the trust contract. Scheduling notifications before S2S is delivered is presumptuous.

**Implementation implication:** Code review must reject notification scheduling in any onboarding-flow code path.

---

### ONB-040: Must not use fake delays for performance theater

**Statement:** No `setTimeout` or artificial delays to simulate loading or processing. Helm does not stage performance theater.

**Rationale:** Fake delays disrespect the user's time and signal dishonesty about what the app is doing.

**Implementation implication:** No `Future.delayed()` for cosmetic purposes in onboarding. The only deliberate timing is the 320ms transition to Screen 8 and skeleton states (800ms) on first home render.

---

## 11. Bangladesh-Specific Considerations

### ONB-041: BDT is the only display currency in MVP

**Statement:** No currency picker on any onboarding screen. BDT is implicit and unambiguous.

**Rationale:** Helm's target user earns in USD but lives in BDT. The S2S is always in BDT. Currency selection adds complexity without value in MVP.

**Implementation implication:** All monetary displays use the taka symbol. No currency selector widget in onboarding.

---

### ONB-042: Lakh/crore formatting in real time

**Statement:** Format numeric input with lakh/crore separators as the user types (e.g., 1,79,490 not 179,490).

**Rationale:** UX Doctrine Section 8 typography rule. Bangladeshi users read numbers in lakh/crore, not millions/billions.

**Implementation implication:** Custom `TextInputFormatter` that applies South Asian number grouping (last group of 3, then groups of 2). Works for both Latin and Bengali numeral inputs.

---

### ONB-043: Bangla mode voice is formal-modern register

**Statement:** Bangla translations must use formal-modern register -- the same as a respected newspaper or a doctor's prescription pad. Not conversational Banglish, not textbook-formal government language.

**Rationale:** Register calibration is non-trivial and is itself a v1 design artifact. The wrong register breaks trust with the target demographic.

**Implementation implication:** Bangla strings require native-speaker copywriter review. Cannot be machine-translated. Every English onboarding string must have a Bangla counterpart verified by a native speaker.

---

### ONB-044: Bengali numeral support in Bangla locale

**Statement:** If user has Bangla locale, numeric displays must use Bengali numerals with lakh/crore separators (e.g., lakh comma pattern).

**Rationale:** Numeric formatting is part of the trust contract. Mixing Latin numerals with Bangla text breaks visual coherence.

**Implementation implication:** Number formatting must check device locale and switch between Latin and Bengali numeral rendering. The lakh/crore separator pattern is non-negotiable in both.

---

### ONB-045: Qualifying question uses Bangladesh-specific financial references

**Statement:** The qualifying question names Payoneer, Upwork, and BDT specifically. The soft-disqualify exit references "BDT thinking USD has arrived."

**Rationale:** These are the exact platforms and currency pair that define the target user's pain. Generic "payment platform" language would fail the memory probe.

**Implementation implication:** The qualifying question copy is not genericized for international expansion. It is hard-coded for the Bangladesh freelancer context.

---

### ONB-046: Pre-named fixed cost categories reflect Bangladeshi norms

**Statement:** The seven fixed cost categories include "Family support / parents" and "Loan EMI" alongside universal categories like Rent and Internet.

**Rationale:** Family support is a near-universal fixed cost for Bangladeshi earners. EMI (Equated Monthly Installment) is the local term for loan payments. These categories reduce the need for "Other."

**Implementation implication:** Category labels and default day-of-month values must reflect Bangladeshi payment norms (rent typically 1st, internet often 5th).

---

## 12. Time-to-Value Constraints

### ONB-047: Under 180 seconds to S2S reveal (median)

**Statement:** The user must reach the S2S number in under 180 seconds median, with a hard P95 ceiling of 300 seconds. The design budgets 165 seconds (2:45) to leave 15 seconds of buffer.

**Rationale:** Doctrine-defined. Beyond this threshold, the friction-to-promise ratio breaks and the user concludes the app is not worth the setup cost.

**Implementation implication:** Every screen has a time budget. Screen 4 (fixed costs) gets the largest allocation at 60 seconds. Performance gates are CI-enforced: Screen 1 to Screen 3 cold-start P95 < 2.5s, Screen 8 first paint P95 < 800ms, S2S calculation P95 < 50ms.

---

### ONB-048: S2S number renders with specific timing choreography

**Statement:** After Screen 7 "I've saved it" tap: (1) 320ms transition to home, (2) home renders with skeleton states for 800ms, (3) S2S number fades in last over 200ms, monospaced ~64pt, sage-green accent line (or amber if buffer-tight), (4) one-time hint appears below.

**Rationale:** The slightly slower transition (320ms vs standard 200-280ms) is the one place a transition is allowed to feel "arrived." The number fading in last creates the reveal moment.

**Implementation implication:** Custom page transition with 320ms duration. Skeleton shimmer widgets for 800ms. S2S number has a 200ms fade-in animation applied after skeleton resolves. State color (sage/amber/red) computed from S2S value relative to obligations.

---

### ONB-049: S2S calculation must complete in under 50ms

**Statement:** The S2S calculation on Screen 8 must complete in under 50ms (P95). CI-enforced performance gate.

**Rationale:** If calculation takes longer on first render, perceived trust collapses before the user reads the number.

**Implementation implication:** S2S computation is a pure function with no async dependencies on first render. All inputs are already in local state from onboarding. Performance test must cover the full input matrix.

---

*End of onboarding requirements extraction. Source: `docs/research/ux/Helm_Onboarding_Redesign.md`.*
