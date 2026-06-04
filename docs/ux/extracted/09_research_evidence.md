# 09 -- Research Evidence Extraction

> **Source Document:** `docs/research/ux/Freelancer Finance UX Research.md`
> **Authority Level:** EVIDENCE -- not implementation law. Findings inform and validate (or challenge) product decisions but do not override the Final Product Doctrine.
> **Cross-Reference:** `docs/research/ux/Pocketa_FINAL_Product_Doctrine.md` (canonical authority)
> **Extracted:** 2026-06-04

---

## A. Key User Behavior Findings

### RES-001 -- Mental Accounting: Four Psychological Money States
**Finding:** Bangladeshi freelancers do not treat their total net worth as a fungible pool. Capital exists in four rigidly distinct psychological states: Theoretical Wealth (invoices sent, unacknowledged), Trapped Wealth (cleared by client but held in platform wallets like Upwork/Payoneer/nsave), Transit Wealth (moving through SWIFT/ACH networks), and Liquid Wealth (BDT in local bank or bKash).
**Evidence Strength:** Strong -- grounded in established behavioral economics (Mental Accounting theory) and corroborated by platform-specific Bangladeshi community discourse.
**Implementation Implication:** Pocketa's pipeline model (expected -> pending -> received) directly maps to these states. The doctrine's decision to use a single aggregated balance in MVP is a simplification; the research suggests users will still mentally separate these states. The calculation breakdown drawer must make these distinctions visible even if the balance is aggregated.
**Doctrine Alignment:** VALIDATES Doctrine SS4 (MVP scope, item 4: Income Pipeline with three states) and SS10 (Trust Layer 2: Calculation Transparency).

### RES-002 -- 8.5 Hours/Month Lost to Payment Administration
**Finding:** Freelancers spend an average of 8.5 hours monthly (102 hours/year) on payment-related administrative tasks: chasing late invoices (~3.2h), managing cash flow (~2.8h), researching payment methods (~1.5h), and dealing with platform support (~1.0h). At $50/hr, this represents ~$5,100 in annual opportunity cost.
**Evidence Strength:** Strong -- sourced from the Global Freelance Client Payment Delay Report 2026 (Jobbers).
**Implementation Implication:** Pocketa's core value proposition is reclaiming this time. The "cash flow management" bucket (2.8h/month) is the direct target. MVP must demonstrably reduce time-to-answer on "what can I spend?" to seconds, not minutes.
**Doctrine Alignment:** VALIDATES Doctrine SS11 (Retention Loop 1: Daily Open Habit, <2s to S2S).

### RES-003 -- 85% Late Payment Rate; 21% Chronic Non-Payment
**Finding:** 85% of freelancers experience late payments. Over 21% are subjected to chronic non-payment or delays more than half the time. This is systemic, not anomalous.
**Evidence Strength:** Strong -- sourced from Remote.com late payment culture analysis.
**Implementation Implication:** The pipeline must treat late payment as the default assumption, not an edge case. Conservative S2S calculation (excluding overdue entries) is essential. The doctrine's 7-day overdue flagging and conservative recalculation are directly validated.
**Doctrine Alignment:** VALIDATES Doctrine SS11 (Retention Loop 4: Surprise Avoidance) and SS4 (MVP item 14: "--" fallback).

### RES-004 -- Real-World Consequences of Payment Delays
**Finding:** Due to systemic delays, 42% of freelancers have missed utility/rent payments, 38% have incurred late fees, 31% have been forced to borrow money, and 27% have reduced essential spending on healthcare/food.
**Evidence Strength:** Strong -- sourced from Stanford GSB research via Jobbers report.
**Implementation Implication:** These are the exact failure modes Pocketa exists to prevent. The Safe-to-Spend metric with hard deduction of imminent liabilities (Rule 1 in the research) directly addresses the 42% who miss rent. The doctrine's behavioral failure mode example (freelancer buys phone, then rent is short) mirrors these findings precisely.
**Doctrine Alignment:** VALIDATES Doctrine SS3 (Core Behavioral Problem) and SS4 (MVP item 7: S2S hero metric).

### RES-005 -- 50-55% Psychological Distress; 28-33% Consider Quitting
**Finding:** 50-55% of gig workers report psychological distress related to payment uncertainty. 28-33% have actively considered abandoning freelancing entirely due to payment instability.
**Evidence Strength:** Strong -- multi-source research data.
**Implementation Implication:** Pocketa is not a convenience tool; it is a psychological harm reduction tool. The product's tone, notification language, and visual design must be calibrated for users under chronic stress. This validates the doctrine's "calm cockpit" framing and "calm > hype" retention philosophy.
**Doctrine Alignment:** VALIDATES Doctrine SS1 (Final Product Thesis: "single-purpose calm cockpit") and SS11 (Retention Loop 5: Calm > Hype).

---

## B. Pain Points Identified

### RES-006 -- FX Fee Opacity ("Ghost Charges")
**Finding:** The primary catalyst for user disenfranchisement with legacy platforms is fee obfuscation. Payoneer implements layered fees: 1.5% transfer fees, 1-4% conversion spreads, $29.95 annual card fee, and a $30 fee for accounts under $2,000. The community term is "ghost charges." The realization that a $1,000 invoice yields only ~$940 in BDT triggers profound anger and feelings of exploitation.
**Evidence Strength:** Strong -- corroborated by community discourse (Reddit), WorldFirst review, and VaultLeap fee analysis.
**Implementation Implication:** Pocketa's calculation breakdown drawer must explicitly model platform-specific fee deductions. If Pocketa shows an optimistic number that does not match reality, it will be immediately classified alongside legacy platforms as untrustworthy.
**Doctrine Alignment:** VALIDATES Doctrine SS10 (Trust Layer 2: Calculation Transparency) and SS4 (MVP item 8: Calculation breakdown drawer). VALIDATES Doctrine SS4 (MVP item 9: Editable inputs including FX rate per entry).

### RES-007 -- Behavioral Migration Away from Payoneer
**Finding:** Bangladeshi freelancer community is actively migrating from Payoneer to newer platforms like Elevate Pay (local US checking accounts via MCB, fee-free ACH) and nsave (USD digital accounts, flat $1 transfer fee). Community sentiment: "Payoneer sucks now!"
**Evidence Strength:** Strong -- multiple Reddit community threads, nsave and Elevate Pay documentation.
**Implementation Implication:** Pocketa must be platform-agnostic and support multiple routing paths. The doctrine's multi-wallet feature (V1, not MVP) aligns, but even in MVP the editable FX rate and fee inputs must accommodate different platform cost structures.
**Doctrine Alignment:** VALIDATES Doctrine SS2 (Core User: "Uses Payoneer (most common) or nsave/ElevatePay as USD receiver") and SS5 (V1 item 1: Multi-wallet).

### RES-008 -- Manual Data Entry Fatigue (Pipeline Abandonment)
**Finding:** PFM apps fail because they demand continuous manual data entry with zero psychological reward. The reward-to-effort ratio is catastrophically skewed. Users begin skipping entries, the dashboard loses accuracy, the S2S number becomes unreliable, and the app is abandoned.
**Evidence Strength:** Strong -- validated by Reddit community feedback on freelancer finance dashboards and established cognitive load theory.
**Implementation Implication:** This is the single biggest threat to Pocketa's MVP. The doctrine acknowledges this as Risk #1 ("Manual pipeline attrition"). Research prescribes: API data parsing, predictive settlement timelines, and one-tap reconciliations. However, the doctrine explicitly excludes API integrations and email auto-ingestion from MVP. The tension is real.
**Doctrine Alignment:** VALIDATES Doctrine SS17 (Risk #1: Manual pipeline attrition) but CHALLENGES the sufficiency of MVP mitigations. The doctrine relies on one-tap update + transactional notifications. The research suggests this may not be enough -- the 85% pipeline update compliance threshold will be the critical test.
**Contradiction Flag:** The research strongly advocates for automated pipeline updates (API parsing, email ingestion). The doctrine kills these for MVP due to cost and regulatory burden. This is a deliberate, eyes-open trade-off, not an oversight -- but it is the highest-risk bet in the product.

### RES-009 -- Forced Categorization as Gatekeeper
**Finding:** Requiring users to manually categorize all transactions before showing S2S is a "deeply punitive anti-pattern." Categorization must never be a prerequisite to liquidity visibility.
**Evidence Strength:** Moderate -- based on UX anti-pattern analysis and PFM abandonment data.
**Implementation Implication:** MVP correctly avoids expense categorization entirely. The research reinforces that S2S must be available immediately with minimal input.
**Doctrine Alignment:** VALIDATES Doctrine SS8 (Permanent Kill List: "Generic expense categorization").

---

## C. Mental Model Insights

### RES-010 -- "Real vs Hopeful Money" Binary
**Finding:** Freelancers operate with a rigid mental binary: money that is physically in their local account (real) vs. everything else (hopeful). Aggregating these into a single "Total Net Worth" figure generates cognitive dissonance and is "practically useless and actively harmful."
**Evidence Strength:** Strong -- central thesis of the research, grounded in behavioral economics.
**Implementation Implication:** The S2S metric must represent only "real money minus commitments." The doctrine's Rule 2 (Absolute Exclusion of Trapped/Pending Capital from S2S) is the exact implementation of this mental model.
**Doctrine Alignment:** VALIDATES Doctrine SS10 (Trust Layer 2) and SS4 (MVP item 7).

### RES-011 -- Loss Aversion Amplified by FX Anchoring
**Finding:** Freelancers anchor expectations to the mid-market rate (Google/Xe). The gap between this anchor and the actual received amount (after fees and spreads) triggers loss aversion responses roughly 2x the intensity of equivalent gains. This manifests as "FX paranoia."
**Evidence Strength:** Strong -- grounded in Kahneman's Loss Aversion theory, applied to specific BD freelancer FX context.
**Implementation Implication:** Pocketa must use pessimistic financial modeling (lowest plausible conversion rate within recent volatility window). When the actual settlement exceeds the pessimistic estimate, the user experiences micro-relief instead of deficit shock.
**Doctrine Alignment:** VALIDATES Doctrine SS4 (MVP item 13: Default 15% safety buffer) and SS10 (Trust Layer 2). The research provides the psychological rationale for the buffer that the doctrine mandates.

### RES-012 -- The Zeigarnik Effect on Unpaid Invoices
**Finding:** Unpaid invoices function as open cognitive loops. The brain obsessively tracks uncompleted tasks. Combined with chronic late payment, this produces sustained allostatic load (physiological wear from chronic stress).
**Evidence Strength:** Strong -- established cognitive psychology (Zeigarnik Effect) applied to freelancer context.
**Implementation Implication:** The one-tap Pending -> Received gesture (Doctrine MVP item 5) is the "cognitive loop closure" mechanism. The research positions this as the single most important anxiety-reduction interaction.
**Doctrine Alignment:** VALIDATES Doctrine SS4 (MVP item 5: "The single most important UX moment").

### RES-013 -- Forward-Looking Anxiety, Not Backward-Looking Analysis
**Finding:** Freelancer financial anxiety is entirely forward-looking ("Will I survive next month?"), not backward-looking ("Where did my money go last month?"). Historical spending analysis is "largely irrelevant."
**Evidence Strength:** Strong -- directly contradicts assumptions baked into most PFM apps.
**Implementation Implication:** Dashboard must prioritize: present reality (liquid BDT), immediate threats (upcoming bills), then future hope (pending pipeline). Historical charts and reports are correctly deferred to V3.
**Doctrine Alignment:** VALIDATES Doctrine SS8 (Kill List: "Generic charts/reports without S2S context") and SS5 (V1 excludes reports/charts).

---

## D. Bangladesh-Specific Context Findings

### RES-014 -- Multi-Layer Routing Infrastructure
**Finding:** Bangladeshi freelancers navigate a multi-layered routing system: Upwork/Fiverr/Freelancer.com -> Payoneer/nsave/ElevatePay -> SWIFT/ACH -> local Bangladeshi bank -> bKash/cash. Each layer adds fees, delays, and opacity. PayPal is absent. This routing complexity is structurally unique to Bangladesh.
**Evidence Strength:** Strong -- extensively documented across multiple BD-specific sources.
**Implementation Implication:** Pocketa's pipeline model must accommodate this multi-hop reality. Even in MVP's single-wallet mode, the pipeline states (expected -> pending -> received) must map to real routing stages. The editable FX rate per entry accommodates different routing costs.
**Doctrine Alignment:** VALIDATES Doctrine SS2 (Core User profile) and SS12 (Competitive Moat: "Bangladesh context depth").

### RES-015 -- bKash as Final-Mile Liquidity
**Finding:** bKash is the dominant Mobile Financial Service for final-mile BDT liquidity. The Payoneer-bKash partnership is a known routing path. bKash balance is the closest proxy for "real, spendable money" in the freelancer's mental model.
**Evidence Strength:** Strong -- Payoneer/bKash partnership documentation and community behavior.
**Implementation Implication:** In V1 multi-wallet, bKash BDT must be a first-class wallet type. In MVP, the "single aggregated balance" should feel like it represents bKash-equivalent liquidity.
**Doctrine Alignment:** VALIDATES Doctrine SS5 (V1 item 1: Multi-wallet includes bKash BDT).

### RES-016 -- Platform-Specific Fee Structures Are Common Knowledge
**Finding:** Specific fee structures (Payoneer 1.5% + spread, nsave $1 flat, Elevate Pay zero ACH fee) are widely discussed and compared in Bangladeshi freelancer communities. Users are highly fee-literate.
**Evidence Strength:** Strong -- Reddit threads, WorldFirst reviews, community discourse.
**Implementation Implication:** Pocketa's calculation breakdown must be at least as granular as community knowledge. If a user knows nsave charges $1 and Pocketa's math does not reflect this, trust breaks immediately.
**Doctrine Alignment:** VALIDATES Doctrine SS10 (Trust Layer 2: Calculation Transparency) and SS4 (MVP item 9: Editable inputs including FX rate).

---

## E. Device/Connectivity Context

### RES-017 -- Mobile-First, Anxiety-State Interaction
**Finding:** Users interact with financial apps during high-stress moments (at checkout counters, after client defaults, during bill-due anxiety). Cognitive processing bandwidth is severely narrowed during these states.
**Evidence Strength:** Strong -- grounded in stress-cognition research applied to the financial app context.
**Implementation Implication:** UI must be austere, uncluttered, with high-contrast modes, large touch targets, and the most critical data (liquid BDT runway) above all secondary features. Performance target: S2S visible in <2 seconds.
**Doctrine Alignment:** VALIDATES Doctrine SS11 (Retention Loop 1: "<2 seconds even on slow networks").

### RES-018 -- Android-Dominant Market
**Finding:** Bangladesh is overwhelmingly Android-first. Flutter's cross-platform capability is relevant but Android is the primary target. Device diversity (low-end to mid-range) is high.
**Evidence Strength:** Moderate -- implied by the Bangladesh market context (not explicitly stated in the research doc but well-established in market data).
**Implementation Implication:** Performance optimization for mid-range Android devices is critical. Heavy animations, complex widgets, and large asset bundles are risks. The doctrine's Flutter choice is correct, but Android-specific performance testing is essential.
**Doctrine Alignment:** VALIDATES Doctrine SS14 (Architecture: Flutter as mobile app framework).

---

## F. Trust/Credibility Factors

### RES-019 -- Spreadsheet Trust Supremacy ("Show Your Work" Principle)
**Finding:** Freelancers trust spreadsheets over polished apps because spreadsheets offer absolute algorithmic transparency. Users can click any cell, see the formula, and verify the math. No hidden algorithms, no proprietary scores, no unexpected deductions. The user can verify =SUM(A1:A5) * 122.73.
**Evidence Strength:** Strong -- central trust thesis of the research; directly explains the competitive enemy identified in the doctrine.
**Implementation Implication:** The S2S calculation breakdown drawer must replicate spreadsheet-level transparency. Every deduction, every rate, every fee must be visible and verifiable. This is the #1 trust-building mechanism.
**Doctrine Alignment:** VALIDATES Doctrine SS1 ("The enemy is Google Sheets + gut feel + spreadsheet trust inertia") and SS10 (Trust Layer 2: Calculation Transparency). The research provides the psychological mechanism explaining WHY spreadsheets are trusted.

### RES-020 -- Pessimistic Modeling Builds Trust
**Finding:** Trust is rapidly cultivated when an app consistently underestimates and the user receives a small surplus. An overly optimistic FX rate that inflates the dashboard creates betrayal when the actual deposit is lower. The recommended approach: calculate using the lowest plausible rate within the recent volatility window and worst-case fees.
**Evidence Strength:** Strong -- grounded in loss aversion theory and supported by community behavior patterns.
**Implementation Implication:** The default 15% safety buffer in the doctrine implements this principle. The research adds specificity: use 90-day low FX rate, assume worst-case platform fees when routing is undeclared. This micro-surplus effect is a core trust-building loop.
**Doctrine Alignment:** VALIDATES Doctrine SS4 (MVP item 13: Default 15% safety buffer, hard floor at 5%).

### RES-021 -- Contextual Parity with Trusted Platforms
**Finding:** Displaying authentic logos and mirroring UI confirmation patterns of trusted platforms (Upwork, bKash, nsave, Elevate Pay) creates psychological trust transference. If Pocketa can accurately reflect platform-specific status (e.g., "Confirming on network"), it inherits institutional trust.
**Evidence Strength:** Moderate -- logical extension of trust-transference psychology; not yet validated with users.
**Implementation Implication:** V1 multi-wallet should use authentic platform identifiers. MVP pipeline entries should allow platform association (which platform is this income routing through).
**Doctrine Alignment:** Neutral -- doctrine does not explicitly address logo/brand parity but does not contradict it. Low-cost implementation opportunity for trust gains.

### RES-022 -- "Black Box" Metrics Destroy Trust
**Finding:** Abstract metrics like "Financial Health Score: 85/100" are universally interpreted as patronizing marketing gimmicks. Bangladeshi freelancers operating on FX margins need hard, actionable arithmetic, not abstractions.
**Evidence Strength:** Strong -- directly correlated with the "Show Your Work" principle (RES-019).
**Implementation Implication:** Pocketa must never introduce abstract health scores, sentiment indicators, or opaque composite metrics. Every number shown must be traceable to concrete arithmetic.
**Doctrine Alignment:** VALIDATES Doctrine SS8 (Kill List: "Generic charts/reports without S2S context" and "AI insights / financial advice text").

### RES-023 -- Toxic Positivity in Copy is a Trust Breaker
**Finding:** When an invoice is 18 days overdue and the user is calculating whether to borrow from family, cheerful/gamified copy ("Hang in there!") is "deeply offensive" and demonstrates "catastrophic lack of empathy." This permanently breaks the illusion that the app understands the user's reality.
**Evidence Strength:** Strong -- grounded in the 42% missed-rent and 31% borrowing-from-family statistics.
**Implementation Implication:** All Pocketa copy must be factual, objective, and empathetic. No motivational cheerfulness. No gamified encouragement. The doctrine's "calm doctor, not personal trainer" tone is the correct approach.
**Doctrine Alignment:** VALIDATES Doctrine SS8 (Kill List: "Gamification") and SS11 (Retention Loop 5: "Calm > Hype").

---

## G. Competitive Landscape Insights

### RES-024 -- Traditional PFM Apps Fail This User
**Finding:** Traditional PFM apps experience staggering abandonment rates among freelancers because they demand high cognitive load (manual entry, complex reconciliation) while offering minimal anxiety regulation. They digitize accounting rather than digitizing emotional stability.
**Evidence Strength:** Strong -- Reddit community feedback, PFM abandonment data, and the 102-hours-per-year administrative burden figure.
**Implementation Implication:** Pocketa must not be a PFM. It must not position itself as a budgeting app. The doctrine's explicit exclusion of generic expense tracking is validated.
**Doctrine Alignment:** VALIDATES Doctrine SS1 ("It is not a budgeting app, accounting suite...") and SS8 (Kill List: "Generic expense categorization").

### RES-025 -- Elevate Pay and nsave as Emerging Infrastructure
**Finding:** Elevate Pay offers local US-based checking accounts (via MCB) with fee-free ACH. nsave provides USD digital accounts with $1 flat transfer fees and stablecoin yield features. Both are gaining rapid adoption among Bangladeshi freelancers as Payoneer alternatives.
**Evidence Strength:** Strong -- platform documentation and community adoption patterns.
**Implementation Implication:** Pocketa's pipeline model must accommodate these newer platforms alongside legacy Payoneer. Fee calculations must support both percentage-based (Payoneer) and flat-fee (nsave) models.
**Doctrine Alignment:** VALIDATES Doctrine SS2 (Core User: "nsave/ElevatePay as USD receiver") and SS9 (Validate-First: Live FX API).

### RES-026 -- The "Hotel California" Anti-Pattern
**Finding:** International wallets intentionally bury withdrawal functionality to retain capital. For a freelancer who needs USD-to-bKash for groceries, this feels like a "hostage situation." The "Convert to Local/Withdraw" action must be a persistent, unmissable affordance.
**Evidence Strength:** Moderate -- anti-pattern analysis based on dark pattern recognition.
**Implementation Implication:** Pocketa does not move money, but the one-tap Pending -> Received gesture must be prominent and frictionless. The research reinforces that any friction in confirming fund arrival will be perceived as obstruction.
**Doctrine Alignment:** VALIDATES Doctrine SS4 (MVP item 5: one-tap gesture as primary UX moment).

---

## H. Behavioral Finance Findings Relevant to Pocketa

### RES-027 -- The Emotional Monthly Timeline (5 Phases)
**Finding:** The freelancer's financial month follows a predictable emotional cycle: (1) Hustle & Invoice (Days 1-5, anticipation), (2) The Void/Waiting (Days 6-20, escalating anxiety), (3) The Arrival & Routing (Days 21-25, relief then FX stress), (4) The Settlement (Days 26-28, brief security then liability stress), (5) The Trough (Days 29-31, scarcity mindset).
**Evidence Strength:** Moderate -- synthesized from multiple behavioral economics sources applied to the freelancer cycle. Not yet validated with BD-specific user testing.
**Implementation Implication:** The dashboard should ideally adapt its visual emphasis based on where the user is in their cycle. During "The Void," pipeline tracking is paramount. During "The Trough," runway metrics dominate. The doctrine's state colors (Safe / Tight / At Risk) in V1 partially address this.
**Doctrine Alignment:** PARTIALLY VALIDATES Doctrine SS5 (V1 item 6: Dashboard state colors). The research suggests a more dynamic dashboard than the doctrine specifies, but the doctrine's simpler approach is appropriate for MVP/V1 scope.

### RES-028 -- The "Zero State" Panic
**Finding:** When a freelancer has no incoming pipeline (between contracts), a dashboard showing "ZERO INCOME" induces panic. Empty states must shift focus to remaining runway ("Your S2S covers 18 days of average expenses") rather than highlighting absence of income.
**Evidence Strength:** Moderate -- UX principle applied to the freelancer context.
**Implementation Implication:** Empty/error state design is critical. The doctrine correctly identifies "Empty/error states polished" as a V1 item. The research provides the specific pattern: show runway days, not income absence.
**Doctrine Alignment:** VALIDATES Doctrine SS5 (V1 item 8: "Empty/error states polished").

### RES-029 -- Notification Tone Calibration
**Finding:** Push notifications from financial apps trigger cortisol spikes in already-anxious users. Guilt-inducing language ("You are spending too much!") and panic-inducing language ("Your payment is LATE!") are anti-patterns. Correct pattern: objective, mathematical state changes ("S2S updated to 12,000 BDT") and pragmatic tools ("Would you like to generate a follow-up email template?").
**Evidence Strength:** Strong -- grounded in stress-response psychology and the 50-55% baseline anxiety finding.
**Implementation Implication:** Every notification string must be reviewed against the calm-vs-guilt framework. The doctrine's transactional notification examples ("Your $1,500 from Acme is expected today -- tap to confirm") follow the correct pattern.
**Doctrine Alignment:** VALIDATES Doctrine SS11 (Retention Loop 2: Transactional Notification Habit) and SS8 (Kill List: "Engagement push notifications").

### RES-030 -- Passive Value Retention Loops
**Finding:** Effective retention loops are based on "Passive Value Generation," not engagement nagging. Two recommended loops: (1) Runway Reassurance ("Your liquid runway remains stable at 22 days" -- requires no user action) and (2) Yield/Arbitrage alerts (notify when FX rate spikes favorably).
**Evidence Strength:** Moderate -- conceptual framework; not yet tested with BD users.
**Implementation Implication:** The Runway Reassurance loop maps directly to the doctrine's Pre-Bill Anxiety Release (Retention Loop 3). The Yield/Arbitrage loop is V2+ territory (requires live FX API, which is on the Validate-First list).
**Doctrine Alignment:** VALIDATES Doctrine SS11 (Retention Loop 3: Pre-Bill Anxiety Release). The Yield/Arbitrage loop CHALLENGES the doctrine's exclusion of FX API from MVP -- but the doctrine's decision is deliberately conservative.

---

## I. Design Rule Findings

### RES-031 -- Monospaced Typography for Financial Data
**Finding:** Monospaced fonts for all numerical values ensure decimal alignment, facilitate rapid visual scanning, and subconsciously reinforce mathematical precision and systemic stability.
**Evidence Strength:** Moderate -- established financial UI convention; not BD-specific.
**Implementation Implication:** All monetary figures in the Pocketa UI should use a monospaced or tabular-figure font variant.
**Doctrine Alignment:** Neutral -- doctrine does not specify typography rules. This is an additive design recommendation.

### RES-032 -- Color as Semantic Indicator (Not Decoration)
**Finding:** Muted desaturated greens = safety/liquidity/settled. Red = urgent actionable threats only (due tomorrow, insufficient funds). Amber/Yellow = pending/transitive states. Bright high-contrast primary colors artificially increase cognitive load and stress. A calm neutral palette with strategic semantic accents reduces visual anxiety.
**Evidence Strength:** Strong -- established color psychology in financial UX, reinforced by the anxiety-state interaction context.
**Implementation Implication:** Directly maps to the doctrine's V1 dashboard state colors (Safe / Tight / At Risk). The research provides the color semantics: green for Safe, amber for Tight, red for At Risk.
**Doctrine Alignment:** VALIDATES Doctrine SS5 (V1 item 6: Dashboard state colors).

### RES-033 -- Temporal Segregation of Dashboard Information
**Finding:** Dashboard must be organized by time horizon, not by category: Present Reality (top: S2S and liquid BDT), Immediate Threat (middle: upcoming bills), Future Hope (bottom: pending pipeline and estimated arrivals). Most certain data at top; variables at bottom.
**Evidence Strength:** Strong -- directly derived from the forward-looking anxiety finding (RES-013).
**Implementation Implication:** This defines the dashboard information architecture. The doctrine's S2S hero metric at top aligns, but the research provides the complete vertical hierarchy.
**Doctrine Alignment:** VALIDATES Doctrine SS11 (Retention Loop 1: "Home screen is only the S2S number + state color").

### RES-034 -- Progressive Disclosure Over Feature Spam
**Finding:** Dashboards that display all data streams simultaneously (charts, calculators, messaging) induce cognitive paralysis. Top-level dashboard should contain only vital numeric summaries. Deep analytical data (FX volatility charts, granular invoice tracking) should live on secondary layers.
**Evidence Strength:** Strong -- established UX principle applied specifically to the freelancer finance context.
**Implementation Implication:** Reinforces the doctrine's approach of a minimal home screen with drill-down capability (S2S -> breakdown drawer -> per-entry detail).
**Doctrine Alignment:** VALIDATES Doctrine SS11 (Retention Loop 1: minimal home screen) and SS8 (Kill List: "Generic charts/reports without S2S context").

---

## J. Findings That Contradict or Challenge Doctrine Decisions

### RES-035 -- Research Advocates Automation; Doctrine Mandates Manual MVP
**Finding:** The research strongly advocates for API data parsing, predictive settlement timelines, and one-tap reconciliations as the antidote to pipeline fatigue. It frames manual entry as the primary cause of PFM abandonment.
**Doctrine Decision:** MVP explicitly excludes FX live API, Payoneer/bKash API, email/SMS auto-ingestion, and AI insights.
**Tension:** This is the highest-stakes trade-off in the product. The doctrine acknowledges the risk (Risk #1: Manual pipeline attrition) and sets a kill threshold (85% pipeline update compliance). The research evidence strengthens the case that this threshold may be difficult to hit.
**Resolution:** The doctrine's decision is defensible on cost/regulatory/timeline grounds. The research evidence should inform the closed beta monitoring: if pipeline update compliance drops below 85%, the cause is likely the manual-entry fatigue the research predicts. Mitigation: ensure the one-tap gesture and transactional notifications are maximally frictionless.

### RES-036 -- Research Suggests Dynamic Dashboard; Doctrine Specifies Static Layout
**Finding:** The emotional timeline research (RES-027) suggests the dashboard should dynamically adapt its visual hierarchy based on the user's position in their monthly financial cycle ("The Void" vs. "The Arrival" vs. "The Trough").
**Doctrine Decision:** MVP/V1 dashboard is static: S2S hero metric + state color + last update timestamp.
**Tension:** Minor. The doctrine's simpler approach is appropriate for MVP scope. Dynamic adaptation is a V2+ consideration.
**Resolution:** No action needed for MVP. Log as a V2 exploration item if beta feedback suggests users want different views at different cycle points.

### RES-037 -- Research Recommends FX Timing Intelligence; Doctrine Defers
**Finding:** The research recommends live FX API integration with alerts for optimal conversion timing and "Smart Route" modules comparing Payoneer vs. nsave withdrawal costs.
**Doctrine Decision:** Live FX API is on the Validate-First list. MVP uses manual entry with sanity check. Smart routing is not in scope.
**Tension:** Moderate. FX timing is a clear user need, but the doctrine prioritizes trust in the manual pipeline loop before adding complexity.
**Resolution:** The doctrine's approach is correct for MVP. FX intelligence is a strong V1/V2 candidate if manual S2S proves trustworthy. The research provides the specific user need that will justify the feature when the time comes.

---

## K. Validation Questions from the Research (For Closed Beta)

### RES-038 -- Five Validation Frameworks Proposed
The research proposes five specific validation tests that should inform the closed beta design:
1. **Comprehension & Retention Test:** Show S2S + Total Net Worth for 5 seconds; which number does the user recall and what do they say it means?
2. **Trust/Transparency Stress Test:** Show a BDT calculation without fee details; does the user trust it or open a calculator?
3. **Fatigue Simulation:** Have users input 3 historical invoices; at what point do they show frustration or abandon?
4. **Notification Stress Response (A/B):** Test calm vs. urgent notification phrasing on a 15-day overdue payment.
5. **Platform Familiarity Trust Transference:** Does showing bKash/Upwork/nsave logos increase willingness to link accounts?

**Evidence Strength:** Strong as a validation framework; these should inform the closed beta design in Doctrine SS16.
**Doctrine Alignment:** VALIDATES and EXTENDS Doctrine SS16 (Closed Beta Strategy). The doctrine's weekly check-in questions are complementary. These five tests should be integrated into the beta instrumentation plan.
