# Product Constraints Extracted from Final Product Doctrine

> **Source:** `docs/strategy/POCKETA_FINAL_PRODUCT_DOCTRINE.md`
> **Authority Level:** HIGHEST. Canonical. Supersedes all prior roadmaps, expansion maps, and earlier doctrine drafts.
> **Extraction Date:** 2026-06-04
> **Purpose:** Machine-readable constraint inventory for all implementation agents and UX design work.

---

## A. Product Identity Constraints

### PC-001 | Single-Purpose Calm Cockpit
- **Statement:** Pocketa is a single-purpose calm cockpit for Bangladeshi USD-earning freelancers. It answers one question: "After escrow, FX, fixed costs, buffer, and reserves -- how many BDT can I actually spend right now?"
- **Rationale:** The entire product thesis collapses if Pocketa tries to be more than this. Every added concern dilutes the one-number trust.
- **Implementation Implication:** Every screen, feature, and data model must serve the Safe-to-Spend number. If a feature does not feed into, explain, or maintain S2S, it does not belong in the product.

### PC-002 | What Pocketa IS NOT
- **Statement:** Pocketa is not a budgeting app, accounting suite, neobank, payment router, tax filer, invoicing platform (until V2), or CRM. It never touches money.
- **Rationale:** Each of these categories carries its own regulatory burden, competitive landscape, and user expectation. Entering any of them destroys focus.
- **Implementation Implication:** No feature may imply that Pocketa moves, holds, lends, or manages real money. All data is record-only. All transfers are record-only annotations.

### PC-003 | Read-Only Intelligence Layer
- **Statement:** Pocketa is a read-only intelligence + workflow layer that sits above the chaotic Bangladeshi freelancer financial stack and produces one trusted number.
- **Rationale:** Touching real money triggers PSP/PSO regulation in Bangladesh. Read-only status keeps Pocketa outside that classification.
- **Implementation Implication:** No payment processing, no fund transfers, no wallet integrations that move money. Every "transfer" feature is explicitly labeled "record-only."

### PC-004 | The Wedge Is the Pipeline Cascade
- **Statement:** The wedge is the forward-looking pipeline-to-Safe-to-Spend cascade, computed in real time, displayed in two seconds, and never wrong by enough to break trust.
- **Rationale:** This is what no existing tool (Sheets, bKash, TallyKhata, YNAB) models for this user. The cascade IS the differentiation.
- **Implementation Implication:** The pipeline (Expected -> Pending -> Received) and its effect on S2S must be the central data model. S2S computation must be a pure function of pipeline state + fixed costs + buffer + FX rates.

### PC-005 | The Enemy Is Spreadsheets, Not Competitors
- **Statement:** The enemy is Google Sheets + gut feel + spreadsheet trust inertia. Every product decision must beat Sheets on speed and effort, not on features.
- **Rationale:** The ICP currently maintains a Google Sheet or mental ledger. Pocketa wins by being faster and less effortful, not by having more columns.
- **Implementation Implication:** Time-to-S2S < 2 seconds. Pipeline update in one tap. If any Pocketa workflow takes longer than the equivalent Sheet operation, the workflow fails.

---

## B. Core User Constraints

### PC-006 | Primary ICP Definition
- **Statement:** Bangladeshi intermediate freelancer, $800-$3,000/month, USD income to BDT spending. Uses Payoneer or similar. Has experienced at least one overspend incident. Already maintains a manual ledger.
- **Rationale:** This is the only user segment where the S2S pain is acute enough to drive adoption and retention.
- **Implementation Implication:** All UX copy, onboarding flows, and default values must be calibrated for this exact profile. No generalization to broader populations.

### PC-007 | Disqualifying User Signals
- **Statement:** F-commerce/COD sellers, pure marketplace beginners (<$500/mo), salaried employees with side income, YouTubers/TikTokers, and freelancers who never feel surprise from payment timing are NOT Pocketa users.
- **Rationale:** Building for these segments dilutes the product and pollutes retention metrics.
- **Implementation Implication:** The qualifying onboarding question ("Have you ever spent money thinking a payment had cleared...") must exist and must gracefully disqualify users who answer "no." No dark-pattern workarounds to retain unqualified users.

---

## C. MVP Scope Boundaries

### PC-008 | MVP Feature Set (Exhaustive -- Ship NOTHING Outside This)
- **Statement:** MVP includes exactly 15 features: (1) Magic Link auth + mandatory PIN/biometric, (2) 3-minute conversational onboarding, (3) Single aggregated balance, (4) Income Pipeline with 3 states, (5) One-tap Pending->Received, (6) Fixed Costs registry, (7) Safe-to-Spend hero metric (computed, never stored), (8) Calculation breakdown drawer, (9) Editable inputs (FX rate, expected date, exclude entry), (10) Audit log on every financial edit, (11) CSV data export, (12) Account deletion with full purge, (13) Default 15% safety buffer (hard floor 5%), (14) "--" fallback on calc failure, (15) Closed-beta instrumentation.
- **Rationale:** MVP goal is to validate that freelancers will trust and maintain a manual pipeline well enough for S2S to become useful. Nothing else.
- **Implementation Implication:** No feature outside this list may be implemented during MVP sprints. Any request for additional features is scope creep and must be rejected or deferred.

### PC-009 | Single Aggregated Balance in MVP
- **Statement:** MVP uses a single aggregated balance -- one number, no wallet partitioning. Multi-wallet is V1.
- **Rationale:** Wallet partitioning doubles complexity before S2S trust is proven.
- **Implementation Implication:** The data model must support a single liquid BDT balance in MVP. The architecture should anticipate multi-wallet (V1), but the UI and business logic expose only one number.

### PC-010 | Three Pipeline States Only
- **Statement:** Pipeline entries exist in exactly three states: Expected, Pending, Received. No sub-states. No "partially received."
- **Rationale:** Additional states introduce ambiguity that undermines trust. Three states map cleanly to the freelancer's mental model.
- **Implementation Implication:** The pipeline state machine is a strict three-state enum. No additional states may be added without Doctrine amendment.

---

## D. Feature Kill List (Permanently Killed)

### PC-011 | Generic Expense Categorization -- KILLED
- **Statement:** Never build generic expense categorization under the Pocketa brand.
- **Rationale:** TallyKhata/Hishabee territory; no Pocketa advantage.
- **Implementation Implication:** No category field on expenses. No spending breakdown by category. No pie charts.

### PC-012 | Cloud Backup as Marketed Feature -- KILLED
- **Statement:** Never market cloud backup as a feature.
- **Rationale:** SaaS implies it; marketing it signals offline-first archaism.
- **Implementation Implication:** Cloud sync happens silently. No "backup" screen, no "your data is backed up" copy.

### PC-013 | Gamification -- KILLED
- **Statement:** No points, streaks, badges, levels, leaderboards, or gamification of any kind.
- **Rationale:** Patronizing; financial clarity is its own reward.
- **Implementation Implication:** No streak counters, no reward animations, no achievement systems, no "you saved X this month!" copy.

### PC-014 | Generic Charts/Reports Without S2S Context -- KILLED
- **Statement:** No charts or reports that lack direct S2S context.
- **Rationale:** Data without the answer is noise.
- **Implementation Implication:** When reports ship (V3), every chart must relate to the S2S narrative, not stand alone as generic analytics.

### PC-015 | F-Commerce, COD, Inventory, POS -- KILLED
- **Statement:** These features belong to a different product entirely and are permanently excluded.
- **Rationale:** Wrong user, wrong product, wrong category.
- **Implementation Implication:** No inventory models, no POS flows, no COD tracking in any version.

### PC-016 | Social/Community/Peer Features -- KILLED
- **Statement:** No social features, community features, or peer feeds.
- **Rationale:** Owned by Facebook groups and Telegram; not a differentiator.
- **Implementation Implication:** No user profiles visible to others, no sharing features, no community feeds.

### PC-017 | AI Insights/Financial Advice Text -- KILLED
- **Statement:** No AI-generated financial insights or advice text.
- **Rationale:** Hallucination risk on financial data is unforgivable.
- **Implementation Implication:** No LLM-generated copy anywhere in the product. No "AI suggests..." features. No predictive text about spending.

### PC-018 | Algorithmic Tax Slab Citations -- KILLED
- **Statement:** No in-product algorithmic tax slab citations.
- **Rationale:** Liability surface; NBR rules drift.
- **Implementation Implication:** Tax reserve (V2) is user-declared percentage only. No tax calculation, no slab tables, no "you owe X in tax" copy.

### PC-019 | Hard Override of S2S Number -- KILLED
- **Statement:** Users cannot override the Safe-to-Spend output directly.
- **Rationale:** Trains distrust; one wrong override and the user blames the app forever.
- **Implementation Implication:** No "set my S2S to X" input. Users edit inputs (FX rate, expected date, buffer %, etc.) and the output recomputes. The output field is read-only.

### PC-020 | Stored S2S Values -- KILLED
- **Statement:** S2S is always computed, never stored. Display "--" on calculation failure.
- **Rationale:** A stored S2S can become stale and betray trust. Computation from live inputs is the integrity contract.
- **Implementation Implication:** S2S is a pure computed function. No S2S column in the database. No caching of S2S results except by input hash with instant invalidation.

### PC-021 | Last-Write-Wins on Financial Entries -- KILLED
- **Statement:** Financial entries must be audit-logged and event-sourced. Last-write-wins is forbidden.
- **Rationale:** Without event sourcing, the user cannot verify history and disputes cannot be resolved.
- **Implementation Implication:** Every financial edit writes an immutable event with old_value, new_value, timestamp, source. Multi-device conflict uses event timestamps, not last-write.

### PC-022 | Email-Only Account Recovery -- KILLED
- **Statement:** Email compromise must not grant full income visibility.
- **Rationale:** Magic Link alone is insufficient because email compromise exposes all financial data.
- **Implementation Implication:** Mandatory PIN/biometric gate on every app open. Backup recovery method (recovery code at signup) is required.

### PC-023 | Engagement Push Notifications -- KILLED
- **Statement:** No "Hey, check your S2S!" or "We miss you!" notifications. Only transactional and boundary notifications.
- **Rationale:** Engagement notifications train uninstall.
- **Implementation Implication:** Notification types are restricted to two classes (transactional, boundary) enforced in code. An engagement class does not exist as a type.

### PC-024 | In-Product Spending Recommendations -- KILLED
- **Statement:** No "recommend you spend X" or "maybe skip eating out" copy.
- **Rationale:** Borders on financial advice classification.
- **Implementation Implication:** No recommendation engine. No spending suggestions. Pocketa states facts; it does not advise.

### PC-025 | Ads Monetization -- KILLED
- **Statement:** No ads of any kind.
- **Rationale:** Trust collapse.
- **Implementation Implication:** No ad SDK, no ad surfaces, no sponsored content anywhere in the product.

### PC-026 | Affiliate FX/Banking Routing Revenue -- KILLED
- **Statement:** No affiliate routing to financial products.
- **Rationale:** Conflict with neutrality; possible financial-product solicitation classification.
- **Implementation Implication:** No affiliate links, no referral fees, no "recommended bank" features.

### PC-027 | Creditworthiness Profile / Predictability Index -- KILLED
- **Statement:** No credit scoring or creditworthiness features.
- **Rationale:** Likely places Pocketa under CIB regulation; requires bank partnership + legal opinion + capital.
- **Implementation Implication:** No score calculation, no "creditworthiness" metric, no data sharing with lenders.

### PC-028 | Bank Lending Partnerships in MVP/V1/V2/V3 -- KILLED
- **Statement:** Bank lending partnerships are a different company; future exploration only.
- **Rationale:** Regulatory burden incompatible with a solo-founder product.
- **Implementation Implication:** No API integrations with banks for lending. No "apply for a loan" flows.

### PC-029 | Direct NBR Integration / Automated Tax Filing -- KILLED
- **Statement:** No direct integration with Bangladesh tax authority.
- **Rationale:** State infrastructure; regulatory + liability burden.
- **Implementation Implication:** No tax filing features, no NBR API calls, no "file your taxes" flows.

### PC-030 | Dual-Stack Architecture -- KILLED
- **Statement:** No Node + Python dual stack in production.
- **Rationale:** Operational suicide for a solo founder.
- **Implementation Implication:** One backend language, one runtime. Enforced at architecture review.

### PC-031 | bKash Consumer Transaction API Integration -- KILLED
- **Statement:** No integration with bKash consumer transaction API.
- **Rationale:** No public developer path exists; planning on it is fantasy.
- **Implementation Implication:** No bKash API calls, no automatic bKash balance reads. All bKash data is manual entry.

### PC-032 | OCR Receipts, Payroll, Inventory, Full Accounting -- KILLED
- **Statement:** These are different product categories and are permanently excluded.
- **Rationale:** Scope poison.
- **Implementation Implication:** No OCR SDK, no receipt scanning, no payroll features, no general ledger.

---

## E. Feature Deferral List

### PC-033 | Multi-Wallet -- Deferred to V1
- **Statement:** Multi-wallet support (Payoneer USD, bKash BDT, Bank BDT, Cash, Custom) ships in V1, not MVP.
- **Rationale:** Doubles complexity before S2S trust is proven.
- **Implementation Implication:** MVP data model may anticipate multi-wallet internally, but the UI exposes only a single aggregated balance.

### PC-034 | Tax Reserve -- Deferred to V2
- **Statement:** User-declared tax reserve percentage ships in V2. Never algorithmic.
- **Rationale:** Tax ambiguity is a trust bomb. Must not ship until S2S trust is established and the formula is validated by a tax practitioner.
- **Implementation Implication:** The S2S formula should have a tax_reserve parameter stubbed to 0 in MVP/V1. The actual UI and user-facing feature ship in V2 only.

### PC-035 | Invoice-Lite -- Deferred to V2 (3-Sprint Allocation)
- **Statement:** Invoice-Lite is a V2 feature requiring exactly 3 sprints: (1) form + numbering + TIN + BDT-equivalent, (2) PDF generation + email + audit log, (3) pipeline cascade + client profile + list/status.
- **Rationale:** Compressing this ships it broken. It is the workflow moat and must be done correctly.
- **Implementation Implication:** No invoice features in MVP or V1. V2 sprint planning must allocate 3 full sprints.

### PC-036 | FX Live API -- Deferred (Validate-First)
- **Statement:** Manual FX entry with sanity check ships first. Live API requires validation that users prefer API estimates over manual entry and that the API does not mislead.
- **Rationale:** If API rate misleads even 5% of users, it damages S2S trust.
- **Implementation Implication:** MVP/V1 uses manual FX entry per pipeline entry with a sanity-check warning if rate deviates >20% from 90-day average.

### PC-037 | Push Notifications (Engagement) -- NEVER
- **Statement:** Engagement-class push notifications are permanently excluded. Only transactional notifications ship in V1.
- **Rationale:** Engagement notifications become noise and train uninstall.
- **Implementation Implication:** Notification system must enforce two-class taxonomy (transactional, boundary) at the type level.

### PC-038 | Charts, Reports, Analytics -- Deferred to V3
- **Statement:** Reports and charts ship in V3 only, after 6+ months of clean V2 data.
- **Rationale:** Noise before the S2S loop works.
- **Implementation Implication:** No chart libraries, no analytics dashboards in MVP/V1/V2.

### PC-039 | Email/SMS Auto-Ingestion -- Deferred to V4+ (If Ever)
- **Statement:** Email auto-ingestion requires CASA Tier 2/3 audit ($15k-$75k), PDPO 2026 compliance, parser-monitoring infra, and 500+ paid users to fund it.
- **Rationale:** Regulatory and financial burden is too high for early stages.
- **Implementation Implication:** No email parsing, no SMS reading, no notification scraping in MVP through V3.

### PC-040 | Sheets/CSV Import -- Deferred to V3 (Conditional)
- **Statement:** One-time Sheets/CSV import ships in V3 only if spreadsheet migration is the #1 adoption blocker.
- **Rationale:** Must be evidence-driven, not assumed.
- **Implementation Implication:** No import wizards in MVP/V1/V2.

---

## F. Safe-to-Spend Formula Constraints

### PC-041 | S2S Is Always Computed, Never Stored
- **Statement:** S2S = f(liquid_BDT, pipeline, fixed_costs, buffer, tax_reserve, fx_rates, today). Pure function. Deterministic. Cached only by input hash.
- **Rationale:** A stored value can become stale. The computation IS the trust contract.
- **Implementation Implication:** No S2S column in any database table. The function must be identical on client and server (shared module). Returns null on failure; UI maps null to "--".

### PC-042 | Default 15% Safety Buffer, Hard Floor 5%
- **Statement:** Default safety buffer is 15% of liquid balance. User-editable within 5%-30% range. Hard floor at 5%.
- **Rationale:** The buffer protects the user from their own optimism. Below 5% is too risky to allow.
- **Implementation Implication:** Buffer slider in onboarding and settings. Validation enforces 5%-30% range. Default is 15%.

### PC-043 | Pessimistic FX by Default
- **Statement:** S2S uses conservative FX rate: min(user_declared_rate, 90_day_lower_bound). Optimistic rate shown as secondary.
- **Rationale:** Surplus is the only acceptable surprise. If the actual settlement exceeds the estimate, the user feels relief. If it falls short, the user feels betrayed.
- **Implementation Implication:** Two FX values per pending entry: user_declared_rate and conservative_rate. S2S uses conservative_rate. Display shows both.

### PC-044 | "--" Fallback on Calculation Failure
- **Statement:** If S2S calculation fails or has stale inputs, display "--" + "tap to refresh." Never show a wrong number.
- **Rationale:** A wrong number shown for one second is worse than no number shown for an hour.
- **Implementation Implication:** The compute function returns a tagged result type. The UI must handle the failure case explicitly with specific copy per failure reason.

### PC-045 | Pending Income Never Counts Toward S2S
- **Statement:** Expected and Pending pipeline entries count toward the "Hope" tier only. They never feed into S2S until marked Received.
- **Rationale:** Counting unconfirmed money as spendable is exactly the behavioral failure Pocketa exists to prevent.
- **Implementation Implication:** The S2S function only includes entries with state === Received in its liquid balance. Pending entries appear in the Hope tier with conservative FX labeling.

### PC-046 | Overdue Entries Treated Conservatively
- **Statement:** If a pipeline entry passes its expected date without confirmation, S2S recalculates conservatively (treats as pending, not received). After 7 days overdue, the entry is flagged.
- **Rationale:** Prevents the user from spending against an evaporated promise.
- **Implementation Implication:** An overdue detection job (or check on app open) must compare expected dates against today and flag entries. S2S never auto-promotes overdue entries to Received.

---

## G. Pipeline Model Constraints

### PC-047 | Three States, No More
- **Statement:** Expected -> Pending -> Received. No sub-states, no "partially received," no custom states.
- **Rationale:** Simplicity preserves trust. Additional states create ambiguity.
- **Implementation Implication:** Pipeline state is a strict 3-value enum. State transitions follow a defined order. Backward transitions require explicit user action.

### PC-048 | One-Tap Pending to Received Is the Key UX Moment
- **Statement:** The swipe/tap gesture to confirm Pending -> Received is the single most important UX interaction in the entire product.
- **Rationale:** This is where the pipeline becomes real. If this interaction is clumsy, the entire retention loop breaks.
- **Implementation Implication:** This interaction must be flawless, tested extensively, and optimized for speed. The notification-to-confirm flow must be seamless.

### PC-049 | Editable Inputs, Not Editable Outputs
- **Statement:** Users can edit FX rate, expected date, fixed cost amount, buffer %, exclusion flag. Users cannot edit the S2S number or the calculated BDT-equivalent.
- **Rationale:** The middle path between paternalism and danger. Users own the math inputs; the math itself is inviolable.
- **Implementation Implication:** All derived/computed fields are read-only in the UI. All input fields are editable with audit logging.

### PC-050 | Exclusion Flag Per Pipeline Entry
- **Statement:** Users can flag individual pipeline entries as "don't count this in my pipeline."
- **Rationale:** Gives users control over which entries affect S2S without allowing them to override the output.
- **Implementation Implication:** Boolean exclusion flag on each pipeline entry. When set, the entry is labeled "Excluded" and removed from S2S calculation.

---

## H. Trust Layer Requirements

### PC-051 | Mandatory PIN/Biometric on Every App Open
- **Statement:** PIN or biometric gate fires on every app open. Non-negotiable.
- **Rationale:** Finance trust floor. Email compromise without this gate exposes full income visibility.
- **Implementation Implication:** App lifecycle must include an auth gate before any content renders. No "skip for now" option.

### PC-052 | Backup Recovery Method Required
- **Statement:** Recovery code at signup or equivalent. Email-only recovery is killed.
- **Rationale:** Single point of failure (email) is unacceptable for financial data access.
- **Implementation Implication:** Onboarding must generate and display a recovery code. User must acknowledge it.

### PC-053 | Audit Log on Every Financial Edit
- **Statement:** Every edit on income, fixed cost, FX rate, buffer, reserve writes an immutable event: {user_id, entity_id, field, old_value, new_value, timestamp, source}.
- **Rationale:** Required for dispute defense, reconciliation, and user-visible per-entry history.
- **Implementation Implication:** Append-only event table. No updates or deletes on audit records. Visible to user in per-entry history view.

### PC-054 | CSV Export -- No Friction, No Email Gate
- **Statement:** Full data CSV export available on demand. No friction barriers.
- **Rationale:** Trust hygiene and data portability.
- **Implementation Implication:** Export button in settings. Generates complete CSV of all user data. No email verification step, no "reason for export" form.

### PC-055 | Account Deletion in MVP
- **Statement:** Full data purge with confirmation available from Day 1.
- **Rationale:** Trust hygiene; PDPO 2026 requirement.
- **Implementation Implication:** Single screen with confirmation. Purges all user data. Available in MVP, not deferred.

### PC-056 | No Third-Party Data Sharing
- **Statement:** No data sharing with third parties without explicit opt-in. Bank/lender partnerships are not shipped until post-V3.
- **Rationale:** Trust and regulatory compliance.
- **Implementation Implication:** No analytics SDKs that share data externally (unless anonymized and disclosed). No partner integrations that transmit user financial data.

### PC-057 | Event-Sourced Financial Operations
- **Statement:** All financial operations must be event-sourced from Day 1.
- **Rationale:** Enables audit log, multi-device conflict resolution, daily snapshots (V3), and per-entry history.
- **Implementation Implication:** Current state is derived from left-fold over event stream. No direct mutation of financial entity state.

### PC-058 | Integer Paisa Storage
- **Statement:** All money stored as bigint paisa. No floats. No exceptions. Document the ceiling.
- **Rationale:** Floating-point rounding errors destroy trust when the user verifies with a calculator.
- **Implementation Implication:** Database uses bigint. All arithmetic uses integer operations. Conversion to display format (2 decimal places) happens only at the rendering layer.

### PC-059 | Daily Snapshot Job Stubbed in MVP
- **Statement:** A daily S2S snapshot job must be designed and stubbed in MVP, even though it ships in V3.
- **Rationale:** Retrofitting reporting on historical S2S will eat a full sprint of regret. Event-source from Day 1.
- **Implementation Implication:** The stub exists in code. The infrastructure is designed. The actual exposure to users happens in V3.

### PC-060 | Database Residency-Aware from Day 1
- **Statement:** Cloud hosting must be Bangladesh-residency-aware from Day 1. No "migrate later."
- **Rationale:** PDPO 2026 mandates this for restricted data. Migration is a 4-6 month senior infra project.
- **Implementation Implication:** Hosting decision (Oracle Cloud Dhaka or equivalent) is made before Sprint 1.

---

## I. Closed Beta Validation Gates

### PC-061 | Pipeline Update Compliance >= 85%
- **Statement:** At least 85% of notifications-opened-within-24-hours must result in a pipeline status update.
- **Rationale:** If users do not update the pipeline, S2S becomes fiction and the product dies.
- **Implementation Implication:** Instrumentation must track notification_opened and pipeline_status_updated events with timestamps. This is the most important metric.

### PC-062 | Override-Equivalent Rate < 5%
- **Statement:** Fewer than 5% of S2S views should be followed by an input edit causing >20% S2S delta.
- **Rationale:** If users constantly override the formula's output by editing inputs, the formula is wrong.
- **Implementation Implication:** Instrumentation must track input_edit events with before/after S2S values and compute the delta.

### PC-063 | 30-Day Retention >= 60%
- **Statement:** At least 60% of beta users must still be active in week 4.
- **Rationale:** Below this, the product premise is too weak to sustain.
- **Implementation Implication:** Track daily active users across the full 4-week beta period.

### PC-064 | Onboarding Completion >= 70%
- **Statement:** At least 70% of users must finish onboarding unaided.
- **Rationale:** If onboarding fails, no user ever reaches S2S.
- **Implementation Implication:** Track per-step completion rates in onboarding. Identify exact drop-off points.

### PC-065 | S2S Comprehension >= 80%
- **Statement:** At least 80% of users must be able to articulate what the S2S number means without training.
- **Rationale:** If users do not understand the number, they cannot trust it.
- **Implementation Implication:** Measured via weekly check-in interviews, not in-app. Qualitative metric.

### PC-066 | 2+ Threshold Misses = KILL
- **Statement:** If 2 or more of the above thresholds are missed, the product is killed. No "iterate forever."
- **Rationale:** Prevents sunk-cost-driven continuation of a broken product.
- **Implementation Implication:** The go/no-go decision is binary and documented before beta begins.

---

## J. Behavioral Retention Constraints

### PC-067 | Home Screen = S2S Number + State Color + Timestamp Only
- **Statement:** The home screen shows only the S2S number, state color (Safe/Tight/At Risk), and last-update timestamp. No navigation required.
- **Rationale:** If the user must navigate to find the answer, the product has failed.
- **Implementation Implication:** Home screen layout is fixed. No widgets, no carousels, no tabs above the fold beyond S2S.

### PC-068 | Loads in < 2 Seconds
- **Statement:** S2S must be visible in under 2 seconds even on slow networks.
- **Rationale:** Speed-to-S2S is the primary competitive advantage over Sheets.
- **Implementation Implication:** Defer all non-S2S rendering. Skeleton states hold position. Performance budget is a CI gate.

### PC-069 | Transactional Notifications Only
- **Statement:** Notifications are triggered only by state changes in user data or mathematical proximity to financial harm.
- **Rationale:** Every other notification type is engagement theater that erodes trust.
- **Implementation Implication:** Notification triggers are defined in a single registry. Adding a new type requires code change with Doctrine reference.

### PC-070 | Behavioral Kill Switches
- **Statement:** If beta shows notification open rate <40%, 7-day retention <50%, median sessions/week <2, or pipeline staleness >5 days for >30% of users, the retention model is broken.
- **Rationale:** These are leading indicators that the core loop has failed.
- **Implementation Implication:** These metrics must be tracked from Day 1 of beta with automated alerting.

---

## K. Anti-Patterns and "Never Do" Rules

### PC-071 | Never Show a Wrong Number
- **Statement:** Display "--" rather than show an incorrect or stale S2S value.
- **Rationale:** A wrong number destroys trust permanently.
- **Implementation Implication:** Every code path that renders S2S must handle the null/failure case.

### PC-072 | Never Auto-Mark Received
- **Statement:** Pocketa never silently marks a pipeline entry as Received based on date passing or any automated signal.
- **Rationale:** If a client cancels and the entry was silently confirmed, trust is catastrophically broken.
- **Implementation Implication:** All state transitions to Received require explicit one-tap user confirmation.

### PC-073 | Never Aggregate USD + BDT in One Number
- **Statement:** Liquid BDT and pending USD are visually severed. They never appear in the same number.
- **Rationale:** Aggregating violates the freelancer's mental accounting model and creates false confidence.
- **Implementation Implication:** No "total net worth" or "total balance" that combines currencies. Each currency appears in its own visual context.

### PC-074 | Never Use Floats for Money
- **Statement:** All monetary arithmetic uses integer paisa. No floating point. No exceptions.
- **Rationale:** A single rounding error visible on a calculator destroys trust.
- **Implementation Implication:** Linting rules or code review checks must catch any float usage in financial calculations.

### PC-075 | No Microservices Until 500+ Paying Users
- **Statement:** Single monolith architecture. No microservices in MVP/V1/V2.
- **Rationale:** Operational discipline for a solo founder. Microservices are organizational complexity, not technical necessity at this scale.
- **Implementation Implication:** One deployable unit. One database. One runtime.

### PC-076 | Legal Floor Before Code
- **Statement:** Legal opinions L1-L7 (PDPO 2026, PSP classification, marketing copy, tax disclaimer, invoice compliance, cloud residency, platform ToS) must be obtained before Sprint 1.
- **Rationale:** Building without legal clearance risks building a product that cannot legally operate.
- **Implementation Implication:** Hard gate. No code until legal opinions are documented. Budget 50,000-200,000 BDT.

---

## L. Pricing Constraints

### PC-077 | S2S Stays Free Forever
- **Statement:** The core Safe-to-Spend feature is never paywalled.
- **Rationale:** Monetizes workflow value (Invoice-Lite, multi-wallet, tax reserve), not basic trust.
- **Implementation Implication:** Free tier always includes S2S + pipeline + fixed costs + single wallet. Paywall gates workflow features only.

### PC-078 | No Paywalls During Reserve Mode
- **Statement:** A user in financial duress is never shown an "Upgrade to Pro" prompt.
- **Rationale:** Monetizing distress is a trust collapse event.
- **Implementation Implication:** All upgrade prompts, upsell surfaces, and plan comparison screens are suppressed when Reserve Mode is active. (Cross-referenced with UX Doctrine.)

---

## M. Conflict Notes

### PC-079 | Potential Conflict: Snapshot Job Stub vs. "Never Store S2S"
- **Statement:** PC-020 says S2S is never stored. PC-059 says daily S2S snapshots must be stubbed in MVP and exposed in V3.
- **Resolution:** The daily snapshot is a point-in-time archival record for reporting purposes, computed at snapshot time and stored as historical data. The "never stored" rule applies to the live/current S2S -- it is always recomputed from live inputs. Historical snapshots are clearly labeled with their computation timestamp and are read-only archival records.
- **Implementation Implication:** The live S2S is always computed. The snapshot job computes and stores a dated historical record. These are architecturally distinct: live S2S is a function call; snapshot S2S is a cron job writing to a history table.

---

*End of product constraint extraction. 79 constraints identified.*
