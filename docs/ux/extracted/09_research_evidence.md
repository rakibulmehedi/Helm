# 09 -- Research Evidence Extraction

> **Source Document:** `docs/research/ux/Freelancer Finance UX Research.md`
> **Authority Level:** EVIDENCE -- not implementation law. Findings inform and validate (or challenge) product decisions but do not override the Final Product Doctrine.
> **Cross-Reference:** `docs/research/ux/Helm_FINAL_Product_Doctrine.md` (canonical authority)
> **Extracted:** 2026-06-04

---

## A. Key User Behavior Findings

### RES-001 -- Mental Accounting: Four Psychological Money States
- Bangladeshi freelancers treat capital in four rigid psychological states: Theoretical Wealth (invoiced), Trapped Wealth (platform wallets), Transit Wealth (SWIFT/ACH), Liquid Wealth (local bank/bKash).
- Helm's pipeline (expected -> pending -> received) directly maps to these states.
- The calculation breakdown drawer must make these distinctions visible even when the balance is aggregated.
- **Validates:** Doctrine SS4 (Income Pipeline 3 states) and SS10 (Calculation Transparency).

### RES-002 -- 8.5 Hours/Month Lost to Payment Administration
- Freelancers spend ~8.5 hours monthly (102h/year) on payment admin: chasing late invoices (~3.2h), cash flow management (~2.8h), payment method research (~1.5h), platform support (~1.0h).
- At $50/hr: ~$5,100 annual opportunity cost. Source: Global Freelance Client Payment Delay Report 2026 (Jobbers).
- Helm's core value is reclaiming the 2.8h/month "cash flow management" bucket.
- **Validates:** Doctrine SS11 (Retention Loop 1: <2s to S2S).

### RES-003 -- 85% Late Payment Rate; 21% Chronic Non-Payment
- 85% of freelancers experience late payments; 21%+ face chronic non-payment more than half the time. Source: Remote.com.
- Pipeline must treat late payment as the default, not an edge case. Validates the 7-day overdue flagging and conservative recalculation.
- **Validates:** Doctrine SS11 (Retention Loop 4) and SS4 (item 14: "--" fallback).

### RES-004 -- Real-World Consequences of Payment Delays
- 42% have missed utility/rent payments; 38% incurred late fees; 31% forced to borrow; 27% reduced essential spending. Source: Stanford GSB via Jobbers.
- The S2S metric with hard deduction of imminent liabilities directly addresses the 42% who miss rent.
- **Validates:** Doctrine SS3 (Core Behavioral Problem) and SS4 (item 7: S2S hero metric).

### RES-005 -- 50-55% Psychological Distress; 28-33% Consider Quitting
- 50-55% of gig workers report psychological distress from payment uncertainty; 28-33% have considered abandoning freelancing.
- Helm is a psychological harm reduction tool, not a convenience tool. Validates the "calm cockpit" framing.
- **Validates:** Doctrine SS1 (Final Product Thesis) and SS11 (Retention Loop 5: Calm > Hype).

---

## B. Pain Points Identified

### RES-006 -- FX Fee Opacity ("Ghost Charges")
- Payoneer layered fees: 1.5% transfer fee, 1-4% conversion spread, $29.95 annual card fee, $30 fee for accounts under $2,000. Community term: "ghost charges."
- Helm's breakdown drawer must explicitly model platform-specific fee deductions.
- **Validates:** Doctrine SS10 (Calculation Transparency) and SS4 (items 8 and 9).

### RES-007 -- Behavioral Migration Away from Payoneer
- Bangladeshi freelancers actively migrating to Elevate Pay (local US checking, fee-free ACH) and nsave (USD digital, $1 flat transfer fee). Source: Reddit community threads, platform docs.
- Helm must be platform-agnostic. Even in MVP, editable FX rate and fee inputs must accommodate different platform cost structures.
- **Validates:** Doctrine SS2 (Core User profile) and SS5 (V1 Multi-wallet).

### RES-008 -- Manual Data Entry Fatigue (Pipeline Abandonment)
- PFM apps fail because reward-to-effort ratio is catastrophically skewed. Users skip entries, accuracy drops, S2S becomes unreliable, app is abandoned.
- This is Helm's single biggest MVP risk (Doctrine Risk #1: Manual pipeline attrition). The 85% pipeline update compliance threshold is the critical test.
- **Contradiction Flag:** Research strongly advocates for automated updates; doctrine kills these for MVP due to cost and regulatory burden. Deliberate trade-off, not an oversight.

### RES-009 -- Forced Categorization as Gatekeeper
- Requiring manual categorization before showing S2S is a "deeply punitive anti-pattern." Categorization must never be a prerequisite to liquidity visibility.
- **Validates:** Doctrine SS8 (Kill List: Generic expense categorization).

---

## C. Mental Model Insights

### RES-010 -- "Real vs Hopeful Money" Binary
- Freelancers operate with a rigid mental binary: money physically in their local account (real) vs. everything else (hopeful). Aggregating into "Total Net Worth" is "practically useless and actively harmful."
- S2S must represent only "real money minus commitments."
- **Validates:** Doctrine SS10 (Trust Layer 2) and SS4 (item 7).

### RES-011 -- Loss Aversion Amplified by FX Anchoring
- Freelancers anchor to the mid-market rate (Google/Xe). The gap between anchor and actual received amount triggers loss aversion ~2x the intensity of equivalent gains. Community term: "FX paranoia."
- Helm must use pessimistic modeling (lowest plausible rate within recent volatility window). Surplus creates micro-relief instead of deficit shock.
- **Validates:** Doctrine SS4 (item 13: 15% safety buffer) and SS10.

### RES-012 -- The Zeigarnik Effect on Unpaid Invoices
- Unpaid invoices function as open cognitive loops producing sustained allostatic load (physiological wear from chronic stress).
- The one-tap Pending -> Received gesture is the "cognitive loop closure" mechanism -- the single most important anxiety-reduction interaction.
- **Validates:** Doctrine SS4 (item 5: one-tap as the most important UX moment).

### RES-013 -- Forward-Looking Anxiety, Not Backward-Looking Analysis
- Freelancer financial anxiety is entirely forward-looking ("Will I survive next month?"), not backward-looking. Historical spending analysis is "largely irrelevant."
- Dashboard must prioritize: present reality (liquid BDT), immediate threats (upcoming bills), future hope (pending pipeline). Charts correctly deferred to V3.
- **Validates:** Doctrine SS8 (Kill List: generic charts) and SS5 (V1 excludes reports).

---

## D. Bangladesh-Specific Context Findings

### RES-014 -- Multi-Layer Routing Infrastructure
- Routing: Upwork/Fiverr/Freelancer.com -> Payoneer/nsave/ElevatePay -> SWIFT/ACH -> local bank -> bKash/cash. Each layer adds fees, delays, opacity. PayPal absent. Structurally unique to Bangladesh.
- Pipeline states must map to real routing stages. Editable FX rate per entry accommodates different routing costs.
- **Validates:** Doctrine SS2 (Core User profile) and SS12 (Competitive Moat).

### RES-015 -- bKash as Final-Mile Liquidity
- bKash is the dominant Mobile Financial Service for final-mile BDT. The Payoneer-bKash partnership is a known routing path.
- In V1 multi-wallet, bKash BDT must be a first-class wallet type.
- **Validates:** Doctrine SS5 (V1 Multi-wallet includes bKash BDT).

### RES-016 -- Platform-Specific Fee Structures Are Common Knowledge
- Specific fees (Payoneer 1.5% + spread, nsave $1 flat, Elevate Pay zero ACH) widely discussed and compared in freelancer communities. Users are highly fee-literate.
- Helm's calculation breakdown must be at least as granular as community knowledge.
- **Validates:** Doctrine SS10 (Calculation Transparency) and SS4 (item 9: Editable inputs).

---

## E. Device/Connectivity Context

### RES-017 -- Mobile-First, Anxiety-State Interaction
- Users interact with financial apps during high-stress moments (checkout counters, after client defaults, during bill-due anxiety). Cognitive bandwidth is severely narrowed.
- UI must be austere, uncluttered, high-contrast, large touch targets. S2S visible in <2 seconds.
- **Validates:** Doctrine SS11 (Retention Loop 1).

### RES-018 -- Android-Dominant Market
- Bangladesh is overwhelmingly Android-first. Device diversity (low-end to mid-range) is high.
- Android-specific performance testing on mid-range devices is essential. Flutter choice is correct.
- **Validates:** Doctrine SS14 (Architecture: Flutter).

---

## F. Trust/Credibility Factors

### RES-019 -- Spreadsheet Trust Supremacy ("Show Your Work" Principle)
- Freelancers trust spreadsheets because every cell, formula, and math step is visible and verifiable. No hidden algorithms.
- The S2S breakdown drawer must replicate spreadsheet-level transparency. This is the #1 trust-building mechanism.
- **Validates:** Doctrine SS1 ("The enemy is Google Sheets") and SS10 (Calculation Transparency).

### RES-020 -- Pessimistic Modeling Builds Trust
- Trust is rapidly cultivated when an app consistently underestimates and the user receives a small surplus. An overly optimistic rate that inflates the dashboard creates betrayal.
- Use 90-day low FX rate, assume worst-case platform fees. The micro-surplus effect is a core trust-building loop.
- **Validates:** Doctrine SS4 (item 13: Default 15% safety buffer, hard floor 5%).

### RES-021 -- Contextual Parity with Trusted Platforms
- Displaying authentic logos and mirroring UI confirmation patterns of trusted platforms (Upwork, bKash, nsave) creates psychological trust transference.
- V1 multi-wallet should use authentic platform identifiers. MVP pipeline entries should allow platform association.
- **Doctrine Alignment:** Neutral -- doctrine does not contradict; low-cost trust opportunity.

### RES-022 -- "Black Box" Metrics Destroy Trust
- Abstract metrics like "Financial Health Score: 85/100" are universally interpreted as patronizing marketing gimmicks. Bangladeshi freelancers need hard arithmetic, not abstractions.
- Every number shown must be traceable to concrete arithmetic.
- **Validates:** Doctrine SS8 (Kill List: generic charts, AI insights).

### RES-023 -- Toxic Positivity in Copy is a Trust Breaker
- Cheerful/gamified copy ("Hang in there!") when an invoice is 18 days overdue is "deeply offensive" and "catastrophic lack of empathy." Breaks the illusion that the app understands user reality.
- All Helm copy must be factual, objective. "Calm doctor, not personal trainer" tone is correct.
- **Validates:** Doctrine SS8 (Kill List: Gamification) and SS11 (Calm > Hype).

---

## G. Competitive Landscape Insights

### RES-024 -- Traditional PFM Apps Fail This User
- PFM apps experience staggering abandonment because they demand high cognitive load while offering minimal anxiety regulation. They digitize accounting rather than emotional stability.
- **Validates:** Doctrine SS1 ("not a budgeting app") and SS8 (Kill List: generic expense categorization).

### RES-025 -- Elevate Pay and nsave as Emerging Infrastructure
- Elevate Pay: local US checking (via MCB), fee-free ACH. nsave: USD digital accounts, $1 flat transfer, stablecoin yield. Both gaining rapid Bangladeshi adoption.
- Helm's pipeline must accommodate these platforms. Fee calculations must support both percentage-based and flat-fee models.
- **Validates:** Doctrine SS2 (Core User) and SS9 (Validate-First: Live FX API).

### RES-026 -- The "Hotel California" Anti-Pattern
- International wallets intentionally bury withdrawal functionality to retain capital -- feels like a "hostage situation."
- The one-tap Pending -> Received gesture must be prominent and frictionless. Any friction will be perceived as obstruction.
- **Validates:** Doctrine SS4 (item 5: one-tap gesture as primary UX moment).

---

## H. Behavioral Finance Findings Relevant to Helm

### RES-027 -- The Emotional Monthly Timeline (5 Phases)
- (1) Hustle & Invoice (Days 1-5), (2) The Void/Waiting (Days 6-20), (3) The Arrival & Routing (Days 21-25), (4) The Settlement (Days 26-28), (5) The Trough (Days 29-31).
- Doctrine's state colors (Safe/Tight/At Risk) partially address this. Full dynamic dashboard adaptation is V2+ scope.
- **Partially validates:** Doctrine SS5 (V1 dashboard state colors).

### RES-028 -- The "Zero State" Panic
- Dashboard showing "ZERO INCOME" when no pipeline exists induces panic. Empty states must show remaining runway ("Your S2S covers 18 days") not income absence.
- **Validates:** Doctrine SS5 (V1: empty/error states polished).

### RES-029 -- Notification Tone Calibration
- Push notifications trigger cortisol spikes in already-anxious users. Guilt-inducing ("You are spending too much!") and panic-inducing ("Your payment is LATE!") are anti-patterns.
- Correct pattern: objective mathematical state changes ("S2S updated to 12,000 BDT") and pragmatic tools.
- **Validates:** Doctrine SS11 (Retention Loop 2) and SS8 (Kill List: engagement push notifications).

### RES-030 -- Passive Value Retention Loops
- Effective loops: (1) Runway Reassurance ("Your liquid runway remains stable at 22 days" -- no user action required), (2) Yield/Arbitrage alerts (FX rate spikes favorably) -- V2+ territory requiring live FX API.
- **Validates:** Doctrine SS11 (Retention Loop 3: Pre-Bill Anxiety Release).

---

## I. Design Rule Findings

### RES-031 -- Monospaced Typography for Financial Data
- Monospaced fonts for all numerical values ensure decimal alignment, rapid visual scanning, and subconsciously reinforce mathematical precision.
- All monetary figures should use a monospaced or tabular-figure font variant.

### RES-032 -- Color as Semantic Indicator (Not Decoration)
- Muted desaturated green = safety/liquidity/settled. Red = urgent actionable threats only. Amber = pending/transitive states. Bright high-contrast colors increase cognitive load and stress.
- **Validates:** Doctrine SS5 (V1 dashboard state colors).

### RES-033 -- Temporal Segregation of Dashboard Information
- Dashboard organized by time horizon: Present Reality (S2S + liquid BDT, top), Immediate Threat (upcoming bills, middle), Future Hope (pending pipeline, bottom). Most certain data at top.
- **Validates:** Doctrine SS11 (Retention Loop 1: minimal home screen).

### RES-034 -- Progressive Disclosure Over Feature Spam
- Dashboards displaying all data streams simultaneously induce cognitive paralysis. Top-level should contain only vital numeric summaries; deep analytical data lives on secondary layers.
- **Validates:** Doctrine SS11 (minimal home screen) and SS8 (Kill List: generic charts).

---

## J. Findings That Contradict or Challenge Doctrine Decisions

### RES-035 -- Research Advocates Automation; Doctrine Mandates Manual MVP
- Research strongly advocates for API data parsing and auto-ingestion as the antidote to pipeline fatigue. MVP explicitly excludes all of these.
- **Resolution:** Doctrine's decision is defensible on cost/regulatory/timeline grounds. If pipeline compliance drops below 85% in beta, the cause is likely manual-entry fatigue. Ensure one-tap gesture and transactional notifications are maximally frictionless.

### RES-036 -- Research Suggests Dynamic Dashboard; Doctrine Specifies Static Layout
- Emotional timeline research suggests dynamic dashboard adapting to monthly cycle position. MVP/V1 dashboard is static.
- **Resolution:** Simpler approach appropriate for MVP. Log as V2 exploration if beta feedback indicates need.

### RES-037 -- Research Recommends FX Timing Intelligence; Doctrine Defers
- Research recommends live FX API with optimal conversion timing alerts and "Smart Route" modules. MVP uses manual entry with sanity check.
- **Resolution:** Doctrine's approach is correct for MVP. FX intelligence is a strong V1/V2 candidate after manual S2S proves trustworthy.

---

## K. Validation Questions from the Research (For Closed Beta)

### RES-038 -- Five Validation Frameworks Proposed
1. **Comprehension & Retention Test:** Show S2S + Total Net Worth for 5 seconds; which number does the user recall?
2. **Trust/Transparency Stress Test:** Show a BDT calculation without fee details; does the user trust it or open a calculator?
3. **Fatigue Simulation:** Have users input 3 historical invoices; at what point do they show frustration or abandon?
4. **Notification Stress Response (A/B):** Test calm vs. urgent notification phrasing on a 15-day overdue payment.
5. **Platform Familiarity Trust Transference:** Does showing bKash/Upwork/nsave logos increase willingness to link accounts?

These five tests should be integrated into the closed beta instrumentation plan alongside Doctrine SS16 weekly check-in questions.
