# Product Constraints Extracted from Final Product Doctrine

> **Source:** `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md`
> **Authority Level:** HIGHEST. Canonical. Supersedes all prior roadmaps, expansion maps, and earlier doctrine drafts.
> **Extraction Date:** 2026-06-04
> **Purpose:** Machine-readable constraint inventory for all implementation agents and UX design work.

---

## A. Product Identity Constraints

### PC-001 | Single-Purpose Calm Cockpit
Helm is a single-purpose calm cockpit for Bangladeshi USD-earning freelancers. It answers one question: "After escrow, FX, fixed costs, buffer, and reserves -- how many BDT can I actually spend right now?"

### PC-002 | What Helm IS NOT
Helm is not a budgeting app, accounting suite, neobank, payment router, tax filer, invoicing platform (until V2), or CRM. It never touches money.

### PC-003 | Read-Only Intelligence Layer
Helm is a read-only intelligence + workflow layer that sits above the chaotic Bangladeshi freelancer financial stack and produces one trusted number.

### PC-004 | The Wedge Is the Pipeline Cascade
The wedge is the forward-looking pipeline-to-Safe-to-Spend cascade, computed in real time, displayed in two seconds, and never wrong by enough to break trust.

### PC-005 | The Enemy Is Spreadsheets, Not Competitors
The enemy is Google Sheets + gut feel + spreadsheet trust inertia. Every product decision must beat Sheets on speed and effort, not on features.

---

## B. Core User Constraints

### PC-006 | Primary ICP Definition
Bangladeshi intermediate freelancer, $800-$3,000/month, USD income to BDT spending. Uses Payoneer or similar. Has experienced at least one overspend incident. Already maintains a manual ledger.

### PC-007 | Disqualifying User Signals
F-commerce/COD sellers, pure marketplace beginners (<$500/mo), salaried employees with side income, YouTubers/TikTokers, and freelancers who never feel surprise from payment timing are NOT Helm users.

---

## C. MVP Scope Boundaries

### PC-008 | MVP Feature Set (Exhaustive -- Ship NOTHING Outside This)
MVP includes exactly 15 features: (1) Magic Link auth + mandatory PIN/biometric, (2) 3-minute conversational onboarding, (3) Single aggregated balance, (4) Income Pipeline with 3 states, (5) One-tap Pending->Received, (6) Fixed Costs registry, (7) Safe-to-Spend hero metric (computed, never stored), (8) Calculation breakdown drawer, (9) Editable inputs (FX rate, expected date, exclude entry), (10) Audit log on every financial edit, (11) CSV data export, (12) Account deletion with full purge, (13) Default 15% safety buffer (hard floor 5%), (14) "--" fallback on calc failure, (15) Closed-beta instrumentation.

### PC-009 | Single Aggregated Balance in MVP
MVP uses a single aggregated balance -- one number, no wallet partitioning. Multi-wallet is V1.

### PC-010 | Three Pipeline States Only
Pipeline entries exist in exactly three states: Expected, Pending, Received. No sub-states. No "partially received."

---

## D. Feature Kill List (Permanently Killed)

### PC-011 | Generic Expense Categorization -- KILLED
Never build generic expense categorization under the Helm brand.

### PC-012 | Cloud Backup as Marketed Feature -- KILLED
Never market cloud backup as a feature. Cloud sync happens silently.

### PC-013 | Gamification -- KILLED
No points, streaks, badges, levels, leaderboards, or gamification of any kind.

### PC-014 | Generic Charts/Reports Without S2S Context -- KILLED
No charts or reports that lack direct S2S context.

### PC-015 | F-Commerce, COD, Inventory, POS -- KILLED
These features belong to a different product entirely and are permanently excluded.

### PC-016 | Social/Community/Peer Features -- KILLED
No social features, community features, or peer feeds.

### PC-017 | AI Insights/Financial Advice Text -- KILLED
No AI-generated financial insights or advice text.

### PC-018 | Algorithmic Tax Slab Citations -- KILLED
No in-product algorithmic tax slab citations. Tax reserve (V2) is user-declared percentage only.

### PC-019 | Hard Override of S2S Number -- KILLED
Users cannot override the Safe-to-Spend output directly. Users edit inputs; the output field is read-only.

### PC-020 | Stored S2S Values -- KILLED
S2S is always computed, never stored. Display "--" on calculation failure.

### PC-021 | Last-Write-Wins on Financial Entries -- KILLED
Financial entries must be audit-logged and event-sourced. Last-write-wins is forbidden.

### PC-022 | Email-Only Account Recovery -- KILLED
Email compromise must not grant full income visibility. Mandatory PIN/biometric + backup recovery code required.

### PC-023 | Engagement Push Notifications -- KILLED
No "Hey, check your S2S!" or "We miss you!" notifications. Only transactional and boundary notifications.

### PC-024 | In-Product Spending Recommendations -- KILLED
No "recommend you spend X" or "maybe skip eating out" copy. Helm states facts; it does not advise.

### PC-025 | Ads Monetization -- KILLED
No ads of any kind.

### PC-026 | Affiliate FX/Banking Routing Revenue -- KILLED
No affiliate routing to financial products.

### PC-027 | Creditworthiness Profile / Predictability Index -- KILLED
No credit scoring or creditworthiness features.

### PC-028 | Bank Lending Partnerships in MVP/V1/V2/V3 -- KILLED
Bank lending partnerships are a different company; future exploration only.

### PC-029 | Direct NBR Integration / Automated Tax Filing -- KILLED
No direct integration with Bangladesh tax authority.

### PC-030 | Dual-Stack Architecture -- KILLED
No Node + Python dual stack in production. One backend language, one runtime.

### PC-031 | bKash Consumer Transaction API Integration -- KILLED
No integration with bKash consumer transaction API. All bKash data is manual entry.

### PC-032 | OCR Receipts, Payroll, Inventory, Full Accounting -- KILLED
These are different product categories and are permanently excluded.

---

## E. Feature Deferral List

### PC-033 | Multi-Wallet -- Deferred to V1
Multi-wallet support (Payoneer USD, bKash BDT, Bank BDT, Cash, Custom) ships in V1, not MVP.

### PC-034 | Tax Reserve -- Deferred to V2
User-declared tax reserve percentage ships in V2. Never algorithmic.

### PC-035 | Invoice-Lite -- Deferred to V2 (3-Sprint Allocation)
Invoice-Lite is a V2 feature requiring exactly 3 sprints: (1) form + numbering + TIN + BDT-equivalent, (2) PDF generation + email + audit log, (3) pipeline cascade + client profile + list/status.

### PC-036 | FX Live API -- Deferred (Validate-First)
Manual FX entry with sanity check ships first. Live API requires validation that users prefer API estimates over manual entry.

### PC-037 | Push Notifications (Engagement) -- NEVER
Engagement-class push notifications are permanently excluded. Only transactional notifications ship in V1.

### PC-038 | Charts, Reports, Analytics -- Deferred to V3
Reports and charts ship in V3 only, after 6+ months of clean V2 data.

### PC-039 | Email/SMS Auto-Ingestion -- Deferred to V4+ (If Ever)
Requires CASA Tier 2/3 audit ($15k-$75k), PDPO 2026 compliance, parser-monitoring infra, and 500+ paid users.

### PC-040 | Sheets/CSV Import -- Deferred to V3 (Conditional)
One-time Sheets/CSV import ships in V3 only if spreadsheet migration is the #1 adoption blocker.

---

## F. Safe-to-Spend Formula Constraints

### PC-041 | S2S Is Always Computed, Never Stored
S2S = f(liquid_BDT, pipeline, fixed_costs, buffer, tax_reserve, fx_rates, today). Pure function. Deterministic. Cached only by input hash. Returns null on failure; UI maps null to "--".

### PC-042 | Default 15% Safety Buffer, Hard Floor 5%
Default safety buffer is 15% of liquid balance. User-editable within 5%-30% range. Hard floor at 5%.

### PC-043 | Pessimistic FX by Default
S2S uses conservative FX rate: min(user_declared_rate, 90_day_lower_bound). Optimistic rate shown as secondary.

### PC-044 | "--" Fallback on Calculation Failure
If S2S calculation fails or has stale inputs, display "--" + "tap to refresh." Never show a wrong number.

### PC-045 | Pending Income Never Counts Toward S2S
Expected and Pending pipeline entries count toward the "Hope" tier only. They never feed into S2S until marked Received.

### PC-046 | Overdue Entries Treated Conservatively
If a pipeline entry passes its expected date without confirmation, S2S recalculates conservatively. After 7 days overdue, the entry is flagged.

---

## G. Pipeline Model Constraints

### PC-047 | Three States, No More
Expected -> Pending -> Received. No sub-states, no "partially received," no custom states.

### PC-048 | One-Tap Pending to Received Is the Key UX Moment
The swipe/tap gesture to confirm Pending -> Received is the single most important UX interaction in the entire product.

### PC-049 | Editable Inputs, Not Editable Outputs
Users can edit FX rate, expected date, fixed cost amount, buffer %, exclusion flag. Users cannot edit the S2S number or the calculated BDT-equivalent.

### PC-050 | Exclusion Flag Per Pipeline Entry
Users can flag individual pipeline entries as "don't count this in my pipeline."

---

## H. Trust Layer Requirements

### PC-051 | Mandatory PIN/Biometric on Every App Open
PIN or biometric gate fires on every app open. Non-negotiable. No "skip for now" option.

### PC-052 | Backup Recovery Method Required
Recovery code at signup or equivalent. Email-only recovery is killed. User must acknowledge it.

### PC-053 | Audit Log on Every Financial Edit
Every edit on income, fixed cost, FX rate, buffer, reserve writes an immutable event: {user_id, entity_id, field, old_value, new_value, timestamp, source}.

### PC-054 | CSV Export -- No Friction, No Email Gate
Full data CSV export available on demand. No email verification step, no "reason for export" form.

### PC-055 | Account Deletion in MVP
Full data purge with confirmation available from Day 1. Available in MVP, not deferred.

### PC-056 | No Third-Party Data Sharing
No data sharing with third parties without explicit opt-in. Bank/lender partnerships not shipped until post-V3.

### PC-057 | Event-Sourced Financial Operations
All financial operations must be event-sourced from Day 1. Current state is derived from left-fold over event stream.

### PC-058 | Integer Paisa Storage
All money stored as bigint paisa. No floats. No exceptions.

### PC-059 | Daily Snapshot Job Stubbed in MVP
A daily S2S snapshot job must be designed and stubbed in MVP, even though it ships in V3.

### PC-060 | Database Residency-Aware from Day 1
Cloud hosting must be Bangladesh-residency-aware from Day 1. No "migrate later."

---

## I. Closed Beta Validation Gates

### PC-061 | Pipeline Update Compliance >= 85%
At least 85% of notifications-opened-within-24-hours must result in a pipeline status update.

### PC-062 | Override-Equivalent Rate < 5%
Fewer than 5% of S2S views should be followed by an input edit causing >20% S2S delta.

### PC-063 | 30-Day Retention >= 60%
At least 60% of beta users must still be active in week 4.

### PC-064 | Onboarding Completion >= 70%
At least 70% of users must finish onboarding unaided.

### PC-065 | S2S Comprehension >= 80%
At least 80% of users must be able to articulate what the S2S number means without training.

### PC-066 | 2+ Threshold Misses = KILL
If 2 or more of the above thresholds are missed, the product is killed. No "iterate forever."

---

## J. Behavioral Retention Constraints

### PC-067 | Home Screen = S2S Number + State Color + Timestamp Only
The home screen shows only the S2S number, state color (Safe/Tight/At Risk), and last-update timestamp. No navigation required.

### PC-068 | Loads in < 2 Seconds
S2S must be visible in under 2 seconds even on slow networks. Skeleton states hold position. Performance budget is a CI gate.

### PC-069 | Transactional Notifications Only
Notifications are triggered only by state changes in user data or mathematical proximity to financial harm.

### PC-070 | Behavioral Kill Switches
If beta shows notification open rate <40%, 7-day retention <50%, median sessions/week <2, or pipeline staleness >5 days for >30% of users, the retention model is broken.

---

## K. Anti-Patterns and "Never Do" Rules

### PC-071 | Never Show a Wrong Number
Display "--" rather than show an incorrect or stale S2S value.

### PC-072 | Never Auto-Mark Received
Helm never silently marks a pipeline entry as Received based on date passing or any automated signal.

### PC-073 | Never Aggregate USD + BDT in One Number
Liquid BDT and pending USD are visually severed. They never appear in the same number.

### PC-074 | Never Use Floats for Money
All monetary arithmetic uses integer paisa. No floating point. No exceptions.

### PC-075 | No Microservices Until 500+ Paying Users
Single monolith architecture. No microservices in MVP/V1/V2. One deployable unit. One database. One runtime.

### PC-076 | Legal Floor Before Code
Legal opinions L1-L7 (PDPO 2026, PSP classification, marketing copy, tax disclaimer, invoice compliance, cloud residency, platform ToS) must be obtained before Sprint 1.

---

## L. Pricing Constraints

### PC-077 | S2S Stays Free Forever
The core Safe-to-Spend feature is never paywalled. Free tier always includes S2S + pipeline + fixed costs + single wallet.

### PC-078 | No Paywalls During Reserve Mode
A user in financial duress is never shown an "Upgrade to Pro" prompt. All upgrade prompts suppressed when Reserve Mode is active.

---

## M. Conflict Notes

### PC-079 | Potential Conflict: Snapshot Job Stub vs. "Never Store S2S"
PC-020 says S2S is never stored. PC-059 says daily S2S snapshots must be stubbed in MVP and exposed in V3.
**Resolution:** The daily snapshot is a point-in-time archival record computed at snapshot time. The "never stored" rule applies to the live/current S2S -- always recomputed from live inputs. Historical snapshots are read-only archival records. Live S2S is a function call; snapshot S2S is a cron job writing to a history table.

---

*End of product constraint extraction. 79 constraints identified.*
