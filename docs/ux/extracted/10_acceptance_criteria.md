# 10 -- Acceptance Criteria (Synthesized from Research Evidence)

> **Source Document:** `docs/research/ux/Freelancer Finance UX Research.md`
> **Authority Level:** EVIDENCE-DERIVED -- these criteria synthesize research findings into testable standards. They do not override the Final Product Doctrine but provide measurable benchmarks for validating doctrine requirements.
> **Cross-Reference:** `docs/research/ux/Helm_FINAL_Product_Doctrine.md` (canonical authority)
> **Companion File:** `docs/ux/extracted/09_research_evidence.md` (underlying evidence)
> **Extracted:** 2026-06-04

---

## A. "Real vs Hopeful Money" Test Criteria

### ACC-001 -- S2S Excludes All Non-Liquid Capital
**Criterion:** The Safe-to-Spend number MUST exclude: (a) invoices sent but not acknowledged, (b) funds held in international platform wallets (Payoneer, nsave, Elevate Pay), (c) funds in SWIFT/ACH transit, and (d) any capital not yet converted to BDT and settled in a local account.
**Test Method:** Create a test scenario with BDT 50,000 liquid, $1,200 pending in Upwork escrow, and $800 in Payoneer. Verify S2S reflects only the BDT 50,000 minus committed expenses, not an aggregated total.
**Evidence Source:** RES-001, RES-010
**Evidence Strength:** Strong
**Pass/Fail:** Binary -- any inclusion of non-liquid capital in S2S is a critical trust failure.

### ACC-002 -- S2S Hard-Deducts Imminent Liabilities
**Criterion:** S2S MUST subtract all known upcoming bills and scheduled transfers with due dates within the current pipeline window. If liquid BDT = 50,000 and rent of 20,000 is due in 4 days, S2S MUST display 30,000 (minus buffer), not 50,000.
**Test Method:** Add a fixed cost with a due date 1-7 days out. Verify S2S deducts it automatically without user action.
**Evidence Source:** RES-004 (42% miss rent payments), RES-010
**Evidence Strength:** Strong
**Pass/Fail:** Binary -- displaying gross balance without liability deduction directly causes the failure mode Helm exists to prevent.

### ACC-003 -- Users Correctly Identify S2S Meaning (Comprehension)
**Criterion:** When shown the dashboard for 5 seconds, at least 80% of test users must correctly articulate that S2S represents "money I can actually spend right now after all commitments," NOT "total money I have" or "total money I am owed."
**Test Method:** Doctrine Validation Framework #1 (RES-038). Show prototype for 5 seconds, remove it, ask user what the number means.
**Evidence Source:** RES-010, RES-019, RES-038
**Evidence Strength:** Strong
**Pass/Fail:** Threshold -- 80% comprehension minimum (matches doctrine SS4 MVP success criteria).
**Doctrine Reference:** Doctrine SS4 MVP Success Criteria: "S2S comprehension: >=80% can articulate what the number means without training."

### ACC-004 -- Total Net Worth Is Visually Demoted
**Criterion:** If any "total" or "net worth" figure is displayed alongside S2S, it MUST be rendered in a significantly smaller font size or lighter typographic weight. S2S must be the largest, most visually dominant numeric element on the primary dashboard.
**Test Method:** Eye-tracking or recall test. After 5-second exposure, users should recall S2S, not total.
**Evidence Source:** RES-010, RES-033
**Evidence Strength:** Strong
**Pass/Fail:** Binary -- if users recall the total over S2S, the visual hierarchy has failed.

---

## B. Trust Perception Criteria

### ACC-005 -- Calculation Breakdown Is Fully Transparent
**Criterion:** Tapping the S2S number MUST open a breakdown drawer showing the complete arithmetic chain: Liquid BDT - Fixed Costs (itemized with due dates) - Safety Buffer (%) = S2S. Every deduction must be traceable. No hidden steps.
**Test Method:** Present a dashboard with S2S = 30,000. Ask user to explain how that number was derived. User must be able to tap and see the full chain. If they cannot explain the math after viewing the breakdown, the drawer is insufficient.
**Evidence Source:** RES-019 (spreadsheet trust), RES-006 (ghost charges)
**Evidence Strength:** Strong
**Pass/Fail:** Binary -- any opaque step in the calculation triggers the "black box" distrust response.
**Doctrine Reference:** Doctrine SS4 MVP item 8, Doctrine SS10 Trust Layer 2.

### ACC-006 -- No Calculator Verification Impulse
**Criterion:** After viewing a projected BDT amount derived from a USD income entry, fewer than 20% of test users should feel compelled to open a separate calculator or Xe.com to verify the math.
**Test Method:** Doctrine Validation Framework #2 (RES-038). Present a calculation, observe whether the user attempts external verification.
**Evidence Source:** RES-019, RES-022, RES-038
**Evidence Strength:** Strong
**Pass/Fail:** Threshold -- <20% external verification attempts. Higher indicates insufficient transparency.

### ACC-007 -- Pessimistic Estimates Generate Micro-Surplus
**Criterion:** The S2S calculation MUST use conservative assumptions (lower FX rate, higher fees) such that when actual settlement occurs, the real amount is equal to or slightly higher than the estimate. The app must NEVER overestimate.
**Test Method:** Track across 10+ settlement events in beta. Count instances where actual BDT < estimated BDT. Target: 0% overestimates.
**Evidence Source:** RES-020 (pessimistic modeling builds trust), RES-011 (loss aversion)
**Evidence Strength:** Strong
**Pass/Fail:** Binary -- any overestimate that causes a user to be short on a bill is a critical trust failure.
**Doctrine Reference:** Doctrine SS4 MVP item 13 (15% safety buffer) and SS4 item 14 ("--" fallback).

### ACC-008 -- No Abstract Health Scores or Sentiment Metrics
**Criterion:** The app MUST NOT display any abstract composite metric (e.g., "Financial Health: 85/100", "Stress Level: Medium", "Money Mood"). All displayed numbers must be concrete BDT or USD amounts, dates, or percentages with explicit denominators.
**Test Method:** UI audit. Scan all screens for any non-arithmetic metric.
**Evidence Source:** RES-022 (black box metrics destroy trust)
**Evidence Strength:** Strong
**Pass/Fail:** Binary -- presence of any abstract score is a violation.
**Doctrine Reference:** Doctrine SS8 (Kill List).

### ACC-009 -- Audit Trail Accessible Per Entry
**Criterion:** Every financial entry (income, fixed cost) MUST have an accessible edit history showing: what changed, from what value, to what value, and when. The user must be able to verify that no ghost edits occurred.
**Test Method:** Edit an income entry's FX rate. Navigate to that entry's history. Verify the old and new values are displayed with timestamps.
**Evidence Source:** RES-006 (ghost charges), RES-019 (show your work)
**Evidence Strength:** Strong
**Pass/Fail:** Binary -- missing or incomplete audit trail violates the trust architecture.
**Doctrine Reference:** Doctrine SS4 MVP item 10, Doctrine SS10 Trust Layer 4.

---

## C. Time-to-Value Benchmarks

### ACC-010 -- S2S Visible in Under 2 Seconds
**Criterion:** From app open (after PIN/biometric unlock) to S2S number fully rendered and visible, the elapsed time MUST be under 2 seconds on a mid-range Android device (e.g., Samsung Galaxy A series) on a 4G connection.
**Test Method:** Instrumented timing (`app_open` to `time_to_s2s_visible`). Measure across 50+ app opens during beta.
**Evidence Source:** RES-002 (8.5 hours reclaimed), RES-017 (anxiety-state interaction)
**Evidence Strength:** Strong
**Pass/Fail:** Threshold -- >=95% of opens must complete in <2s. Median must be <1.5s.
**Doctrine Reference:** Doctrine SS11 Retention Loop 1: "Loads in <2 seconds even on slow networks."

### ACC-011 -- Onboarding Completion in Under 3 Minutes
**Criterion:** The conversational onboarding flow (capturing fixed costs, default buffer %, single income pattern) MUST be completable in under 3 minutes by a first-time user without external guidance.
**Test Method:** Timed user test. Start timer at first onboarding screen, stop at dashboard first-view. Measure across 10+ test users.
**Evidence Source:** RES-008 (pipeline fatigue), RES-009 (forced categorization)
**Evidence Strength:** Moderate
**Pass/Fail:** Threshold -- median completion time <3 minutes; 70% complete unaided.
**Doctrine Reference:** Doctrine SS4 MVP item 2 ("3-minute conversational onboarding") and MVP success criteria ("Onboarding completion: >=70% finish onboarding unaided").

### ACC-012 -- One-Tap Pipeline Update Under 3 Seconds
**Criterion:** The gesture to move a pipeline entry from Pending to Received (the "single most important UX moment") MUST complete in a single tap or swipe and take under 3 seconds from notification open to S2S recalculation visible.
**Test Method:** Instrumented timing (`notification_opened` to `pending_to_received_tapped` to `s2s_recalculated`). Measure during beta.
**Evidence Source:** RES-008 (pipeline fatigue), RES-012 (Zeigarnik loop closure)
**Evidence Strength:** Strong
**Pass/Fail:** Threshold -- median <3s. Any flow requiring >1 tap for the basic confirmation is a design failure.
**Doctrine Reference:** Doctrine SS4 MVP item 5.

### ACC-013 -- Manual Invoice Entry Under 60 Seconds
**Criterion:** A user adding a new pipeline entry (client name, USD amount, expected date) MUST be able to complete the entry in under 60 seconds. If the form requires more than 60 seconds, fatigue risk is elevated.
**Test Method:** Timed user test across 10+ entries. Measure frustration onset per Doctrine Validation Framework #3 (RES-038).
**Evidence Source:** RES-008 (102 hours/year lost; pipeline fatigue)
**Evidence Strength:** Strong
**Pass/Fail:** Threshold -- median <60s. Visible frustration or abandonment before completion indicates form is too complex.

---

## D. Cognitive Load Thresholds

### ACC-014 -- Dashboard Information Density Limit
**Criterion:** The primary dashboard (above the fold / first viewport) MUST contain no more than 3 primary data elements: (1) S2S number, (2) state indicator (Safe/Tight/At Risk), and (3) last update timestamp. All other data (pipeline, bills, settings) must be below fold or on secondary screens.
**Test Method:** UI audit. Count distinct data elements visible without scrolling.
**Evidence Source:** RES-033 (temporal segregation), RES-034 (progressive disclosure)
**Evidence Strength:** Strong
**Pass/Fail:** Binary -- more than 3 primary elements above fold violates cognitive load research.
**Doctrine Reference:** Doctrine SS11 Retention Loop 1: "Home screen is only the S2S number + state color + last update timestamp."

### ACC-015 -- No Mandatory Categorization Before S2S
**Criterion:** The user MUST be able to see their S2S number without having categorized any transactions. Categorization (if ever added) must be entirely optional and must never gate access to the S2S metric.
**Test Method:** Fresh onboarding test. After completing onboarding (fixed costs + first income entry), S2S must be visible without any categorization step.
**Evidence Source:** RES-009 (forced categorization anti-pattern)
**Evidence Strength:** Strong
**Pass/Fail:** Binary -- any categorization gate is a critical UX failure.
**Doctrine Reference:** Doctrine SS8 (Kill List: "Generic expense categorization").

### ACC-016 -- Fatigue Threshold: 3 Manual Entries Before Frustration
**Criterion:** Users must be able to input at least 3 pipeline entries in sequence before showing signs of frustration or abandonment. If frustration onset occurs before 3 entries, the input flow is too heavy.
**Test Method:** Doctrine Validation Framework #3 (RES-038). Observe users inputting 3 historical invoices. Note the exact point of visible frustration.
**Evidence Source:** RES-008 (pipeline fatigue), RES-038
**Evidence Strength:** Moderate -- threshold is approximate; the 3-entry mark comes from the validation framework.
**Pass/Fail:** Threshold -- >=80% of users complete 3 entries without visible frustration. Below this, the input flow needs simplification.

### ACC-017 -- Notification Copy Is Objective, Not Emotional
**Criterion:** All push notifications and in-app banners MUST use factual, mathematical language. They MUST NOT contain: exclamation marks conveying urgency/panic, motivational encouragement, guilt-inducing spending judgments, or emojis in financial state communications.
**Test Method:** Copy audit against the calm-vs-guilt framework (RES-029). A/B test per Doctrine Validation Framework #4 (RES-038).
**Evidence Source:** RES-023 (toxic positivity), RES-029 (notification tone)
**Evidence Strength:** Strong
**Pass/Fail:** Binary per string. Each notification must pass the "would this add stress to a freelancer who just missed rent?" test.
**Doctrine Reference:** Doctrine SS11 Retention Loop 5: "No streaks, no leaderboards, no points... Tone is the financial equivalent of a calm doctor, not a personal trainer."

---

## E. Bangladesh Android-First Acceptance Standards

### ACC-018 -- Primary Target: Mid-Range Android (Screen 5.5"-6.7")
**Criterion:** All layouts MUST be tested and functional on screen sizes from 5.5" to 6.7" (typical Samsung Galaxy A / Xiaomi Redmi range). The S2S number must be fully visible without scrolling on a 5.5" screen at default system font size.
**Test Method:** Test on physical devices or emulators at 360dp-width minimum. Verify S2S visibility.
**Evidence Source:** RES-017 (mobile-first), RES-018 (Android-dominant BD market)
**Evidence Strength:** Moderate (device distribution implied, not surveyed in this research)
**Pass/Fail:** Binary -- S2S not visible at 5.5" without scroll is a layout failure.

### ACC-019 -- High Contrast for Anxiety-State Readability
**Criterion:** All financial numbers (S2S, amounts, dates) MUST meet WCAG AA contrast ratio (4.5:1 minimum for normal text, 3:1 for large text) against their background. State colors (Safe green, Tight amber, At Risk red) must be distinguishable under outdoor/bright-light conditions.
**Test Method:** Contrast ratio check with automated tools. Manual verification under simulated bright-light conditions.
**Evidence Source:** RES-017 (anxiety-state interaction, narrowed cognitive bandwidth), RES-032 (color semantics)
**Evidence Strength:** Strong
**Pass/Fail:** Threshold -- WCAG AA minimum. Financial data should target AAA (7:1) where possible.

### ACC-020 -- Large Touch Targets for Critical Actions
**Criterion:** The one-tap Pending -> Received gesture and the S2S breakdown tap target MUST have a minimum touch target of 48x48dp (Material Design recommendation). During high-anxiety interactions, small targets increase error rates.
**Test Method:** Measure tap target dimensions in the layout inspector. User test for mis-tap rate.
**Evidence Source:** RES-017 (anxiety-state interaction, "excessively large touch targets for critical actions")
**Evidence Strength:** Strong
**Pass/Fail:** Binary -- below 48x48dp for critical financial actions is a violation.

### ACC-021 -- Offline Resilience for S2S Display
**Criterion:** The S2S number MUST be displayable from local cache even when the device has no network connectivity. The app must clearly indicate "Last updated: [timestamp]" when showing cached data, but MUST NOT show a blank screen or error page in place of the S2S.
**Test Method:** Enable airplane mode after at least one successful data load. Open app. Verify S2S is displayed with staleness indicator.
**Evidence Source:** RES-017 (connectivity context), RES-002 (time-to-value)
**Evidence Strength:** Moderate (connectivity issues in BD are real but not deeply explored in this specific research doc)
**Pass/Fail:** Binary -- blank screen on offline is unacceptable for a financial app.
**Doctrine Reference:** Doctrine SS14 (Architecture: Flutter + Hive local storage supports this).

### ACC-022 -- Bangla Script Rendering Support
**Criterion:** While the primary interface language may be English, any user-entered Bangla text (client names, notes) MUST render correctly. If Bangla UI localization is added, all financial numbers must remain in Western Arabic numerals (0-9) for calculation clarity, not Bangla numerals.
**Test Method:** Enter Bangla text in client name field. Verify correct rendering. If localized, verify numeral consistency.
**Evidence Source:** RES-014 (Bangladesh-specific context), Doctrine SS12 (BD context depth)
**Evidence Strength:** Moderate
**Pass/Fail:** Binary for rendering correctness. Numeral convention is a design decision.

---

## F. Criteria for Closed Beta Validation Gates

### ACC-023 -- Pipeline Update Compliance >= 85%
**Criterion:** Of all transactional notifications opened within 24 hours, at least 85% must result in a pipeline status update (Pending -> Received or other state change).
**Test Method:** Instrumented event tracking: `notification_opened` -> `pipeline_status_updated` within 24-hour window.
**Evidence Source:** RES-008 (pipeline fatigue is the #1 abandonment risk), RES-003 (85% late payment rate means frequent update opportunities)
**Evidence Strength:** Strong
**Pass/Fail:** Hard threshold. Below 85% = the manual pipeline model is failing. Do not ship V1.
**Doctrine Reference:** Doctrine SS4 MVP Success Criteria.
**Research Risk Flag:** RES-035 warns this may be the hardest threshold to hit given the research's strong evidence that manual entry causes fatigue. If this metric fails, the cause is likely the manual-entry burden, not the notification system.

### ACC-024 -- Override-Equivalent Rate < 5%
**Criterion:** Fewer than 5% of S2S views should be followed by an input edit that causes a >20% change in the S2S value. High override rates indicate the formula produces numbers users do not trust.
**Test Method:** Instrumented event tracking: `s2s_view` -> `input_edit` (within session) -> measure S2S delta.
**Evidence Source:** RES-019 (trust requires deterministic math), RES-020 (pessimistic modeling)
**Evidence Strength:** Strong
**Pass/Fail:** Hard threshold. Above 5% = the S2S formula is misaligned with user reality. Rebuild calculation logic.
**Doctrine Reference:** Doctrine SS4 MVP Success Criteria and SS16 Closed Beta instrumentation.

### ACC-025 -- 30-Day Retention >= 60%
**Criterion:** At least 60% of closed beta users must still be active (defined as: opened the app at least once in week 4) after 30 days.
**Test Method:** Track `app_open` events. Active = at least 1 open in days 22-30.
**Evidence Source:** RES-005 (50-55% distress rate means the need is real; if they still abandon, the product is failing), RES-024 (PFM abandonment patterns)
**Evidence Strength:** Strong
**Pass/Fail:** Hard threshold. Below 60% = product premise is weak.
**Doctrine Reference:** Doctrine SS4 MVP Success Criteria.

### ACC-026 -- Onboarding Completion >= 70%
**Criterion:** At least 70% of users who begin onboarding must complete it without external assistance (no help chat, no phone call, no tutorial video).
**Test Method:** Instrumented event tracking: `onboarding_step_completed` for each step. Completion = reached dashboard.
**Evidence Source:** RES-008 (cognitive load sensitivity), RES-009 (no forced categorization)
**Evidence Strength:** Strong
**Pass/Fail:** Hard threshold. Below 70% = onboarding is too complex or confusing. Redesign.
**Doctrine Reference:** Doctrine SS4 MVP Success Criteria.

### ACC-027 -- S2S Comprehension >= 80%
**Criterion:** At least 80% of beta users must correctly explain what the S2S number represents ("money safe to spend after all commitments") when asked during weekly check-in, WITHOUT having received prior training or explanation.
**Test Method:** Weekly check-in question #2 from Doctrine SS16: "When did you feel like trusting the S2S number -- and when did you not?" Combined with direct comprehension prompt.
**Evidence Source:** RES-010 (real vs hopeful binary), RES-019 (show your work), RES-038 (validation framework #1)
**Evidence Strength:** Strong
**Pass/Fail:** Hard threshold. Below 80% = the UI breaks the mental model. S2S presentation must be redesigned.
**Doctrine Reference:** Doctrine SS4 MVP Success Criteria.

### ACC-028 -- Willingness to Pay >= 50% at BDT 299+
**Criterion:** At least 50% of beta users must express willingness to pay BDT 299/month or more for the Pro tier when asked at the end of week 4.
**Test Method:** Direct pricing question during week-4 check-in. Present tier structure. Record stated WTP.
**Evidence Source:** Research does not directly address pricing willingness. This criterion is doctrine-driven.
**Evidence Strength:** N/A (doctrine-mandated, not research-derived)
**Pass/Fail:** Hard threshold. Below 50% = pricing model fails.
**Doctrine Reference:** Doctrine SS13 Pricing Validation Gate and SS16 Decision Matrix.

### ACC-029 -- Notification Open Rate >= 40%
**Criterion:** At least 40% of transactional push notifications must be opened (not just received).
**Test Method:** Push notification analytics: delivered vs. opened.
**Evidence Source:** RES-029 (notification tone calibration), RES-030 (passive value loops)
**Evidence Strength:** Moderate
**Pass/Fail:** Behavioral kill switch threshold. Below 40% = notifications are being ignored or suppressed. The retention model is broken.
**Doctrine Reference:** Doctrine SS11 Behavioral Kill Switches.

### ACC-030 -- Median Sessions per Week >= 2
**Criterion:** The median number of app opens per week across the beta cohort must be at least 2.
**Test Method:** `app_open` event count per user per week, median across cohort.
**Evidence Source:** RES-002 (8.5 hours/month administrative burden implies multiple weekly touchpoints)
**Evidence Strength:** Moderate
**Pass/Fail:** Behavioral kill switch threshold. Below 2 = the app is not integrated into the user's workflow.
**Doctrine Reference:** Doctrine SS11 Behavioral Kill Switches.

### ACC-031 -- Pipeline Staleness < 5 Days for 70%+ of Users
**Criterion:** For at least 70% of beta users, the most recent pipeline update must be within the last 5 days. "Staleness" = days since last pipeline state change.
**Test Method:** Track `pending_to_received_tapped` and `pipeline_entry_created` events. Compute staleness per user.
**Evidence Source:** RES-008 (pipeline fatigue), RES-003 (late payments create frequent update opportunities)
**Evidence Strength:** Strong
**Pass/Fail:** Behavioral kill switch threshold. If >30% of users have pipeline staleness >5 days, the manual model is failing.
**Doctrine Reference:** Doctrine SS11 Behavioral Kill Switches: "Pipeline staleness >5 days for >30% of users."

### ACC-032 -- S2S Calculation Failure Rate Near Zero
**Criterion:** The `s2s_calc_failure` event must fire in fewer than 1% of S2S view attempts. When it does fire, the display MUST show "--" and "tap to refresh," never a wrong number.
**Test Method:** Instrumented event tracking: `s2s_calc_failure` / `s2s_view` ratio.
**Evidence Source:** RES-019 (deterministic truth), RES-020 (never overestimate)
**Evidence Strength:** Strong
**Pass/Fail:** Hard threshold. >1% failure rate = trust risk.
**Doctrine Reference:** Doctrine SS4 MVP item 14 and SS16 instrumentation.

### ACC-033 -- 7-Day Retention >= 50%
**Criterion:** At least 50% of beta users must open the app at least once in days 2-7 after first use.
**Test Method:** `app_open` event tracking per user.
**Evidence Source:** RES-024 (PFM abandonment patterns -- most abandonment happens in week 1)
**Evidence Strength:** Moderate
**Pass/Fail:** Behavioral kill switch threshold.
**Doctrine Reference:** Doctrine SS11 Behavioral Kill Switches.

---

## G. Cross-Reference Summary: Research Evidence vs Doctrine Alignment

| Criterion ID | Doctrine Validates | Doctrine Challenges | Notes |
|---|---|---|---|
| ACC-001 | SS4 item 7, SS10 | -- | Core S2S definition |
| ACC-002 | SS3, SS4 item 7 | -- | Liability deduction |
| ACC-003 | SS4 success criteria | -- | 80% comprehension gate |
| ACC-004 | SS11 RL1 | -- | Visual hierarchy |
| ACC-005 | SS4 item 8, SS10 | -- | Transparency drawer |
| ACC-006 | SS10 | -- | Trust verification |
| ACC-007 | SS4 item 13 | -- | Pessimistic modeling |
| ACC-008 | SS8 kill list | -- | No abstract scores |
| ACC-009 | SS4 item 10, SS10 | -- | Audit trail |
| ACC-010 | SS11 RL1 | -- | Performance gate |
| ACC-011 | SS4 item 2, success criteria | -- | Onboarding speed |
| ACC-012 | SS4 item 5 | -- | One-tap UX |
| ACC-013 | -- | SS4 manual pipeline | Fatigue risk |
| ACC-014 | SS11 RL1 | -- | Cognitive load |
| ACC-015 | SS8 kill list | -- | No categorization gate |
| ACC-016 | -- | SS4 manual pipeline | Research predicts difficulty |
| ACC-017 | SS11 RL5 | -- | Notification tone |
| ACC-018 | SS14 Flutter | -- | BD device context |
| ACC-019 | -- | -- | Additive; not in doctrine |
| ACC-020 | -- | -- | Additive; not in doctrine |
| ACC-021 | SS14 Hive local storage | -- | Offline resilience |
| ACC-022 | SS12 BD context | -- | Bangla rendering |
| ACC-023 | SS4 success criteria | RES-035 flags risk | Hardest threshold |
| ACC-024 | SS4 success criteria | -- | Formula trust |
| ACC-025 | SS4 success criteria | -- | Retention gate |
| ACC-026 | SS4 success criteria | -- | Onboarding gate |
| ACC-027 | SS4 success criteria | -- | Comprehension gate |
| ACC-028 | SS13 pricing | -- | Monetization gate |
| ACC-029 | SS11 kill switches | -- | Notification health |
| ACC-030 | SS11 kill switches | -- | Session frequency |
| ACC-031 | SS11 kill switches | RES-035 flags risk | Pipeline staleness |
| ACC-032 | SS4 item 14 | -- | Calc reliability |
| ACC-033 | SS11 kill switches | -- | Week-1 retention |
