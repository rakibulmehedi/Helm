# POCKETA — Product Brain

> The single source of truth for what Pocketa is, who it serves, and how it should feel.
> Every AI agent and human contributor must read this before writing a single line of code.

---

## Identity

Pocketa is **NOT** a backward-looking expense tracker.

Pocketa is a:
> **Freelancer Finance OS for emerging Bangladeshi earners.**
> Category: Cashflow Operations & Financial Mental Health

The app shifts focus from backward-looking expense categorization to forward-looking cashflow clarity, helping freelancers, creators, online earners, and small operators reduce financial chaos.

---

## Core Problems We Solve

Our users struggle with:

| Problem | Impact |
|---|---|
| Irregular income | Can't predict monthly budget |
| Financial anxiety | Stress from unclear money picture |
| Mixed personal/business spending | Tax confusion, lifestyle creep |
| Lack of savings discipline | No emergency buffer |
| Poor cashflow awareness | Surprised by month-end shortfall |
| Subscription leakage | Forgotten recurring charges |
| Pending client payments | Cash crunch from delayed invoices |
| Fragmented wallets | Cash, bKash, Nagad, bank — no unified view |

Pocketa exists to reduce this chaos.

---

## Product Philosophy

Pocketa should feel:
- ✅ Calm — no information overload
- ✅ Reassuring — the app should reduce stress, not add it
- ✅ Operational — focused on what happens next, not just what happened before
- ✅ Low-cognitive-load — easy to understand at a glance
- ✅ Non-judgmental — tracking without scolding
- ✅ Fast — instant transaction entry, no loading walls
- ✅ Premium — feels like a $10/month app, even if free

Pocketa must **avoid**:
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

### Primary
- Bangladeshi freelancers (Upwork, Fiverr, local contracts)
- Online earners (YouTube, affiliate, digital products)
- Agency owners (1–10 person teams)
- F-commerce operators (Facebook/Instagram sellers)
- Creators (content, design, development)

### Secondary
- Students earning online
- Young professionals with side income
- Anyone with irregular multi-source income

### User Persona: Rafiq
> Rafiq is a 26-year-old freelance web developer in Dhaka. He earns from Upwork in USD, receives payments to bKash and bank. He has no accountant, no bookkeeper, and no time to manually track finances. He wants to open his phone and instantly know: "Am I doing okay this month?"

---

## Current Product Direction

### Active Focus (v0.1 — MVP Foundation)
- Transaction CRUD (create, read, update, delete)
- Income + expense tracking
- Dashboard with summary cards
- Date grouping and filtering
- Offline-first local persistence

### Near-Future Modules (v0.2 — Cashflow Clarity)
- Income Pipeline (Pending to Cleared)
- Safe-to-Spend Balance calculation
- Virtual Wallets (separating business, personal, tax)
- Subscription Leakage Radar
- Client/Project Profitability tracking

### Monetization & AI Strategy (Long-Term)
- **Monetization:** Freemium core. Potential Pro tier offers multi-currency, unlimited clients/projects, reports/export, subscription leakage detection, and advanced cashflow insights.
- **AI Integration:** Useful AI later to reduce friction (smart categorization, receipt parsing, cashflow forecasting). No conversational AI chatbots.

---

## NOT Priority — Scope Guardrails

Do **NOT** turn Pocketa into:
- ❌ ERP software
- ❌ Enterprise accounting software
- ❌ Crypto trading platform
- ❌ Stock market app
- ❌ Social network
- ❌ Feature-heavy bookkeeping system
- ❌ Invoice generator (initially)
- ❌ POS system

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