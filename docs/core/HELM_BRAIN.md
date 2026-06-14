# HELM — Product Brain

> The single source of truth for what Helm is, who it serves, and how it should feel.
> Every AI agent and human contributor must read this before writing a single line of code.

---

## Identity

Helm is **NOT** a backward-looking expense tracker.

Helm is a:
> **A single-purpose calm cockpit for Bangladeshi USD-earning freelancers.**
> Category: Freelancer Cashflow Clarity

Helm answers one question: 'After escrow, FX, fixed costs, buffer, and reserves — how many BDT can I actually spend right now?' It is a read-only intelligence + workflow layer that sits above the chaotic Bangladeshi freelancer financial stack and produces one trusted number.

---

## Core Problems We Solve

Our users struggle with:

| Problem | Impact |
|---|---|
| Two currencies (USD earn, BDT spend) | Mental math under stress with shifting FX rates |
| Pipeline timing uncertainty | Escrow (5-14 days) → FX (1-3 days) → withdrawal delays |
| Mistaking pending for spendable | Overspend incidents from treating hope as cash |
| Fixed cost surprise | Forgot obligations, rent comes due, account is short |
| Fragmented wallets | Payoneer + bKash + bank + cash — no single view |

---

## Product Philosophy

Helm should feel:
- ✅ Calm — no information overload
- ✅ Reassuring — the app should reduce stress, not add it
- ✅ Operational — focused on what happens next, not just what happened before
- ✅ Low-cognitive-load — easy to understand at a glance
- ✅ Non-judgmental — tracking without scolding
- ✅ Fast — instant transaction entry, no loading walls
- ✅ Premium — feels like a $10/month app, even if free

Helm must **avoid**:
- ❌ AI chatbots (no scolding the user)
- ❌ Enterprise accounting complexity
- ❌ Complex invoicing systems
- ❌ Tax filing engines
- ❌ Deep budgeting/envelope systems
- ❌ Chart-heavy analytics

---

## UX Philosophy

Prioritize:
- Low cognitive load
- Fast transaction entry (< 5 seconds for a quick expense)
- Clear summaries at a glance
- Operational clarity over data density
- Smooth offline-first experience

Every screen should answer:
> "Does this reduce user stress?"

Every new feature must pass:
> "Would a freelancer in Dhaka use this daily?"

---

## Target Users

### Primary ICP (per Final Doctrine)
- Bangladeshi intermediate freelancer, $800–$3,000/month, USD income → BDT spending
- Uses Payoneer, nsave, or ElevatePay as USD receiver
- Has experienced at least one overspend incident from mistaking pending USD for spendable BDT
- Already maintains a Google Sheet or mental ledger and finds it tiring
- Has 1–4 recurring or repeat clients
- Carries fixed monthly obligations (internet, subscriptions, family support)

### Disqualifying Signals (NOT our users)
- Freelancer who checks bKash and never feels surprise
- F-commerce / COD sellers (different product entirely)
- Pure marketplace beginners earning <$500/month
- Salaried employees with side income
- YouTubers/TikTokers (revenue-sharing model)

### User Persona: Rafiq
> Rafiq is a 28-year-old freelance web developer in Dhaka earning $1,500/month from Upwork. He receives payments to Payoneer, converts to BDT via bank transfer. He has experienced overspend incidents from mistaking escrow money as available BDT. He maintains a Google Sheet but finds it tiring. He wants to open his phone and instantly see one trusted BDT number: what is actually safe to spend right now.

---

## Current Product Direction (per Final Doctrine)

### MVP (Current Build — Validate S2S Trust)
- Magic Link auth + mandatory PIN/biometric
- 3-minute conversational onboarding
- Single aggregated balance (no wallet partitioning)
- Income Pipeline (Expected → Pending → Received)
- One-tap Pending → Received gesture
- Fixed Costs registry
- Safe-to-Spend hero metric (computed, never stored)
- Calculation breakdown drawer
- Editable inputs (FX rate, expected date, exclude entry)
- Audit log on financial edits
- CSV data export
- Account deletion (full purge)
- Default 15% safety buffer (editable 5–30%)
- "—" fallback on calc failure
- Closed-beta instrumentation

### V1 (After MVP beta clears thresholds)
- Multi-wallet (Payoneer USD, bKash BDT, Bank BDT, Cash, Custom)
- Intra-wallet transfer (record-only)
- Manual USD→BDT conversion with sanity validation
- Transactional ETA notifications
- Dashboard state colors (Safe / Tight / At Risk)

### V2 (Monetization begins)
- Invoice-Lite (3-sprint allocation, non-negotiable)
- Invoice → Pipeline auto-entry
- Tax Reserve (user-declared %, not algorithmic)
- Paid tier activation (Free / Pro ৳299 / Power ৳599)

---

## Permanent Kill List (per Final Doctrine §8)

NEVER build under Helm brand:
- Generic expense categorization (TallyKhata territory)
- F-commerce, COD, inventory, POS (wrong product entirely)
- Gamification (points, streaks, badges — patronizing)
- AI insights / financial advice (hallucination risk on financial data)
- Social / community features (Facebook/Telegram own this)
- Charts/reports without S2S context (noise)
- Hard override of S2S number (trains distrust)
- Stored S2S values (always compute, never store)
- Last-write-wins on financial entries (must be event-sourced)
- Email-only account recovery (email compromise = full income visibility)
- Engagement push notifications (trains uninstall)
- Ads monetization (trust collapse)
- Affiliate FX/banking routing (conflict with neutrality)
- Enterprise accounting / ERP
- Crypto / stock market features

---

## Technical Philosophy

- **Offline-first** — Double down on this. The app must be fast and work without internet.
- **Fast local persistence** — Hive for structured data, SharedPreferences for flags.
- **Minimal dependencies** — every package must justify its existence.
- **Feature-first clean architecture** — domain/data/presentation per feature.
- **Riverpod state management** — predictable, testable, no provider spaghetti.
- **GoRouter navigation** — declarative, typed routes.
- **Cloud Sync** — Keep cloud sync delayed and background-oriented later. Do not break offline-first.

---

## Engineering Philosophy

**Avoid:**
- Premature abstraction
- Over-engineering
- Unnecessary packages
- Feature bloat
- Random refactors without approval
- God-files (keep files < 300 lines where possible)

**Prioritize:**
- Maintainability over cleverness
- Clarity over abstraction
- Stability over velocity
- Analyzer cleanliness (0 errors, 0 warnings, 0 infos)
- UX smoothness over feature count
- Incremental delivery over big-bang releases

---

## Decision Authority

The **Chief Architect** (human operator) has final say on:
- Phase scope and boundaries
- Architectural decisions
- Package additions
- Feature prioritization
- When to proceed to the next phase

No AI agent may unilaterally expand scope, add packages, or refactor architecture.

---

## Doctrine Alignment

> This document was updated on 2026-06-04 to align with `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md`, the highest strategic authority.
> Prior versions included F-commerce operators, generic expense tracking focus, broader target user definitions, and Subscription Leakage Radar — all now killed or narrowed by the Final Doctrine.