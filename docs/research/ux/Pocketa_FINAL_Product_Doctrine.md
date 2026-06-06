# Pocketa — FINAL Product Doctrine

> **Status:** Canonical. Supersedes all prior roadmaps, expansion maps, and earlier doctrine drafts.
> **Last Updated:** June 2026
> **Author Stance:** Adversarial-mentor. Solo-founder reality. No startup theatre.
> **Reading Posture:** Every paragraph below is a constraint, not a suggestion. If you violate one, the product breaks in a predictable way.

---

## 0. Opening Verdict

Pocketa is worth building under **one condition**: you finish Stage 0 validation in 4 weeks and the data clears. If it doesn't clear, you stop. If you can't even start it in 7 days, you also stop.

Everything you have written about Pocketa before this document was strategy without execution constraint. Your audits already told you most of what is below — this doctrine simply enforces it as canon and cuts the noise.

The product you should actually build is **smaller, more boring, and more disciplined** than anything in your prior drafts. That is not a regression. That is the path to a Pocketa that ships and survives.

---

## 1. Final Product Thesis

Pocketa is a **single-purpose calm cockpit** for Bangladeshi USD-earning freelancers. It exists to answer one question, fast and trustworthy:

> **"After escrow, FX, fixed costs, buffer, and reserves — how many BDT can I actually spend right now?"**

That is the entire thesis. It is not a budgeting app, accounting suite, neobank, payment router, tax filer, invoicing platform, or CRM. It never touches money. It is a **read-only intelligence + workflow layer** that sits above the chaotic Bangladeshi freelancer financial stack and produces one number the user can trust.

The wedge is **not a feature**. The wedge is the **forward-looking pipeline → Safe-to-Spend cascade**, computed in real time, displayed in two seconds, and never wrong by enough to break trust.

The enemy is **not Payoneer, bKash, TallyKhata, Hishabee, YNAB, or FreshBooks**. The enemy is **Google Sheets + gut feel + spreadsheet trust inertia**. Every product decision must beat Sheets on speed and effort, not on features.

---

## 2. Core User

### Primary ICP

**Bangladeshi intermediate freelancer, $800–$3,000/month, USD income → BDT spending.**

Specifically:
- Uses Payoneer (most common) or nsave/ElevatePay as USD receiver
- Has experienced at least one *overspend incident* caused by mistaking pending USD for spendable BDT
- Already maintains a Google Sheet, Notion page, or mental ledger — and finds it tiring
- Has 1–4 recurring or repeat clients (not pure one-off marketplace gig hopping)
- Carries fixed monthly obligations: internet, subscriptions, family support, sometimes EMI
- Earns in irregular cycles (escrow delays, 14–45 day client lag)

### Disqualifying signals (these are NOT your users)

- Freelancer who simply checks bKash and never feels surprise → **let them stay with bKash**
- F-commerce / COD sellers → different product entirely
- Pure marketplace beginners earning <$500/month → too little volume to feel S2S pain
- Salaried employees with side income → wrong income shape
- YouTubers/TikTokers (revenue-sharing) → different tax structure, different pain

### Qualifying onboarding question

> *"Have you ever spent money thinking a Payoneer/Upwork payment had cleared, then realized the bill was due before the BDT actually arrived?"*

If **no** → they are not your user yet. Send them away.
If **yes** → qualified. Continue.

---

## 3. Core Behavioral Problem

The Bangladeshi freelancer lives in **two currencies, four wallets, three timing horizons, and one anxious mind**.

| Layer | Reality |
|---|---|
| Currency | Earns USD, spends BDT |
| Wallets | Payoneer / nsave / FC account / bank / bKash / cash |
| Timing | Escrow (5–14 days) → FX (1–3 days) → withdrawal (10–26 hours) |
| Cognitive load | Mental math under stress, in two currencies, with shifting rates |

The freelancer's daily question is not "where did my money go?" (TallyKhata's job) and not "give every dollar a job" (YNAB's job). It is **"is this money real and is it safe to spend?"** No existing tool models this.

### The behavioral failure mode

A freelancer sees ৳52,000 in bKash, has $1,200 pending Upwork escrow, owes ৳18,000 rent in 4 days, has a domain renewal in 2 weeks, and forgot they spent ৳7,000 on Adobe last week. They mentally subtract rent, feel safe, buy a phone for ৳30,000 — and now rent is short.

Pocketa exists to **prevent that exact moment**.

---

## 4. Exact MVP Scope

> **MVP Goal:** Validate that freelancers will trust and maintain a manual pipeline well enough for S2S to become useful. Nothing else.

### MVP includes (ship NOTHING outside this list)

| # | Feature | Purpose |
|---|---|---|
| 1 | Magic Link auth + **mandatory** PIN/biometric on app open | Finance trust floor; non-negotiable |
| 2 | 3-minute conversational onboarding (NOT a form) | Captures fixed costs, default buffer %, single income pattern |
| 3 | **Single aggregated balance** (one number, no wallet partitioning) | Cuts complexity in half; multi-wallet is V1 |
| 4 | Income Pipeline (expected → pending → received) | Three states. No more. |
| 5 | One-tap Pending → Received (swipe gesture) | The single most important UX moment |
| 6 | Fixed Costs registry (monthly recurring obligations) | Subtraction input for S2S |
| 7 | **Safe-to-Spend** hero metric (computed, never stored) | The whole product |
| 8 | **Calculation breakdown** drawer (tap S2S to see math) | Trust through transparency |
| 9 | Editable inputs (FX rate per entry, expected date, exclude entry) | User changes inputs, NOT the output |
| 10 | Audit log on every financial edit | Trust + dispute defense |
| 11 | Data export (CSV) | Trust hygiene; portability |
| 12 | Account deletion (full purge) | Trust hygiene; required from Day 1 |
| 13 | Default **15% safety buffer** applied to S2S | Hard floor at 5%; editable within range |
| 14 | "—" fallback when S2S calculation fails | NEVER show a wrong number |
| 15 | Closed-beta instrumentation (override-equivalent rate, update compliance, retention) | Required to evaluate go/no-go |

### MVP excludes (hold the line)

| Excluded | Why |
|---|---|
| Multi-wallet | Doubles complexity before S2S trust is proven |
| Tax reserve | Tax ambiguity = trust bomb; V2 only |
| Invoice-Lite | 2–3 sprint feature; not MVP |
| FX live API | Manual entry with sanity check first |
| Push notifications (engagement) | Become noise; V1 ships transactional only |
| Charts, reports, analytics | Noise before S2S loop works |
| Email/SMS auto-ingestion | $15k+ CASA + PDPO 2026 burden; V4+ |
| Payoneer/bKash API | Not a real public API path; assumption is fantasy |
| AI insights | No data history; no value |
| Affiliate routing, lead-gen | Regulatory + neutrality conflict |
| Gamification | Patronizing; financial clarity is its own reward |
| F-commerce, inventory, POS | Wrong product entirely |
| Social/community features | Facebook + Telegram own this |

### MVP success criteria (Closed Beta thresholds)

- **Pipeline update compliance:** ≥85% of notifications-opened-within-24-hours result in a status update
- **Override-equivalent rate:** <5% of S2S views followed by an input edit causing >20% S2S delta
- **30-day retention:** ≥60% of beta users still active in week 4
- **Onboarding completion:** ≥70% finish onboarding unaided
- **S2S comprehension:** ≥80% can articulate what the number means without training

**If any of these miss the threshold → STOP. Do not ship V1. Either fix the loop or kill the product.**

---

## 5. Exact V1 Scope

> **V1 Goal:** Reflect real freelancer financial life without exploding scope. Earned only after MVP closed beta clears its thresholds.

| # | Feature | Notes |
|---|---|---|
| 1 | Multi-wallet (Payoneer USD, bKash BDT, Bank BDT, Cash, Custom) | Now safe to add — S2S trust is established |
| 2 | Intra-wallet transfer (record-only; never moves real money) | Simple form, audit-logged |
| 3 | Manual USD→BDT conversion with sanity validation | Warn if rate deviates >20% from 90-day average |
| 4 | Anxiety Buffer (default 15%, editable 5–30%) | NOT locked; users can adjust within bounds |
| 5 | Transactional ETA notifications | "Your $1,500 from Acme is expected today — tap to confirm" |
| 6 | Dashboard state colors: Safe / Tight / At Risk | Visual reinforcement of S2S meaning |
| 7 | Duplicate-last-entry pipeline template | Retainer freelancers in one tap |
| 8 | Empty/error states polished | Trust dies on ugly errors |

**What is NOT in V1:**
- Invoice generation (V2)
- Tax reserve (V2)
- Engagement push notifications (never; only transactional)
- Reports/charts (V3)
- Email auto-ingestion (V4+ if ever)

---

## 6. Exact V2 Scope

> **V2 Goal:** Turn Pocketa from tracker into workflow. This is also where monetization begins.

| # | Feature | Notes |
|---|---|---|
| 1 | **Invoice-Lite** — explicit 3-sprint allocation | Sequential numbering, TIN, Freelancer ID, BDT-equivalent display, PDF generation, email delivery |
| 2 | Invoice → Pipeline auto-entry | Core loop closure; this is the workflow moat |
| 3 | Minimal client profile (name, email, currency, default terms) | Only what Invoice + Pipeline needs |
| 4 | **Tax Reserve** (user-declared %, NOT algorithmic) | Editable history, audit-logged, explicit "This is not tax advice" disclaimer, no in-product tax slabs |
| 5 | Overdue invoice flagging + follow-up template | Receivables aging without becoming a CRM |
| 6 | Paid tier activation (Free / Pro / Power Freelancer) | Monetization gate — see §13 |
| 7 | Invoice format pre-validated by Bangladeshi tax practitioner | Compliance review before launch |

### Invoice-Lite is non-negotiable as a 3-sprint feature

Do not bundle Invoice-Lite as "alongside other items." It is:
- 1 sprint: invoice form + sequential numbering + TIN + BDT-equivalent
- 1 sprint: PDF generation + email delivery + audit log
- 1 sprint: invoice → pipeline cascade + client profile + invoice list/status

If you compress this, it ships broken.

---

## 7. Exact V3 Scope

> **V3 Goal:** Serve power users + unlock institutional value (ERQ, accountant exports). Build only after 6+ months of clean V2 data.

| # | Feature | Conditional Gate |
|---|---|---|
| 1 | CSV / PDF export of historical pipeline + tax data | Always-on once snapshot architecture is in place |
| 2 | ERQ-specific summary PDF for bank applications | Only if >20% of paid users actually use or plan to open ERQ accounts |
| 3 | Daily S2S snapshot job (point-in-time historical S2S) | Required infrastructure for any reporting — **architect from MVP, expose in V3** |
| 4 | Annual income summary PDF (visa, loan, mortgage proof) | High institutional value |
| 5 | ৳500,000 annual threshold monitor (alert at 80%) | Bangladesh-specific compliance value |
| 6 | Sheets/CSV import (one-time migration helper) | Only if spreadsheet migration is the #1 adoption blocker |
| 7 | Recurring income CRON automation | Only if retainer cohort exceeds 30% of paid users |

### Critical architectural foreshadowing

The **daily S2S snapshot job must be designed and stubbed in MVP**, even though it doesn't ship until V3. Event-source income/cost data from Day 1, or retrofitting reporting will eat a full sprint of regret. The audits flagged this explicitly.

---

## 8. Permanent Kill List

These are NEVER to be built under the Pocketa brand. Re-litigating them is a sign of scope drift.

### Killed at the product level

| Killed Feature | Why |
|---|---|
| Generic expense categorization | TallyKhata/Hishabee territory; no Pocketa advantage |
| Cloud Backup as a marketed feature | SaaS implies it; marketing it signals offline-first archaism |
| Gamification (points, streaks, badges) | Patronizing; financial clarity is its own reward |
| Generic charts/reports without S2S context | Data without the answer is noise |
| F-commerce, COD, inventory, POS | Wrong user, wrong product, wrong category |
| Social / community / peer feeds | Owned by Facebook groups + Telegram; not a differentiator |
| AI insights / financial advice text | Hallucination risk on financial data is unforgivable |
| Algorithmic tax slab citations in-product | Liability surface; NBR rules drift |
| OCR receipts, payroll, inventory, full accounting | Different category; scope poison |
| Hard override of the S2S number | Trains distrust; one wrong override and the user blames the app forever |
| Stored S2S values | Always compute; never store; "—" on calc failure |
| Last-write-wins on financial entries | Audit-logged, event-sourced, or it isn't a finance app |
| Email-only account recovery | Email compromise = full income visibility |
| Engagement push notifications | "Hey, check your S2S!" trains uninstall |
| In-product "recommend you spend X" copy | Borders on financial advice classification |
| Ads monetization | Trust collapse |
| Affiliate FX/banking routing revenue | Conflict with neutrality; possible financial-product solicitation classification |
| "Creditworthiness Profile" / Predictability Index | Likely places you under CIB regulation; requires bank partnership + legal opinion + capital |
| Bank lending partnerships as MVP/V1/V2/V3 roadmap | A different company; future exploration only |
| Direct NBR integration / automated tax filing | State infrastructure; regulatory + liability burden |
| Dual-stack architecture (Node + Python in production) | Operational suicide for a solo founder |
| AWS-to-Oracle "migration later" | Architect for residency from Day 1 — don't migrate |
| bKash consumer transaction API integration | No public developer path exists; planning on it is fantasy |

---

## 9. Validate-First List

These are conditionally allowed but require **evidence** before engineering hours are spent.

| Item | Required Validation Before Building |
|---|---|
| Live FX API | Confirm users prefer "API estimate" labeled clearly over manual entry; if API rate misleads even 5% of users, kill it |
| Client Payment Status Link (public URL for clients to mark paid) | 5–10 real freelancers' actual clients must accept and use it. Reverse-trust transfer is brutal. If <60% of clients engage, kill it |
| Payoneer official API (if it ever opens for read access) | Only if manual workflow proves insufficient AND public/sanctioned API access exists |
| Email auto-ingestion (Gmail + Upwork/Payoneer notifications) | Requires CASA Tier 2/3 audit ($15k–$75k), PDPO 2026 lawful-basis opinion, parser-monitoring infra, AND 500+ paid users to fund it |
| Invoice-Lite PDF format | Pre-validated by a Bangladeshi tax practitioner + 5 real clients accept it without question |
| Recurring/retainer CRON automation | >30% of paid users explicitly request it; manual duplicate template insufficient |
| ERQ-specific tools | >20% of paid users have or plan ERQ accounts |

**Rule:** "Validate first" means *evidence from real users*, not a hunch. No exception.

---

## 10. Trust Architecture

Trust is the product. Everything else is plumbing.

### Trust Layer 1 — Auth

- Magic Link as login
- **Mandatory PIN or biometric gate on every app-open**
- Magic Link alone = unacceptable (email compromise = full income visibility)
- Backup recovery method (e.g., recovery code at signup) — not email-only

### Trust Layer 2 — Calculation Transparency

- S2S is **always computed, never stored**
- Tapping S2S opens a breakdown drawer showing:
  - Liquid balance
  - + Pending income (with ETA and confidence)
  - − Fixed costs (with next-due date)
  - − Tax reserve (V2; user-declared %, never algorithmic)
  - − Safety buffer (default 15%)
  - = Safe-to-Spend
- If calculation fails or has stale inputs: display **"—" + "tap to refresh"**, never a wrong number
- If FX rate is missing for a pending entry: S2S excludes it and labels the entry as "Excluded — needs FX rate"

### Trust Layer 3 — User Agency Without Output Override

- Users **CAN** edit any input: FX rate, expected date, fixed cost amount, buffer %, exclusion flag per pipeline entry
- Users **CANNOT** override the S2S number itself
- This is the middle path between the roadmap audit and the red-team — earn trust by letting users own the *math*, not by letting them lie to themselves

### Trust Layer 4 — Audit Log

Every edit on a financial entry (income, fixed cost, FX rate, buffer, reserve %) writes an immutable event:
- `{user_id, entity_id, field, old_value, new_value, timestamp, source}`
- Visible to user in a per-entry history
- Required for dispute defense and reconciliation

### Trust Layer 5 — Data Sovereignty

- **CSV export** on user demand, full data, no friction, no email gate
- **Account deletion** in MVP, single screen, full data purge with confirmation
- **No data sharing** with third parties without explicit opt-in; bank/lender partnerships are NOT shipped under MVP/V1/V2
- **No marketing email** without explicit opt-in at onboarding

### Trust Layer 6 — Multi-Device Conflict Strategy

- Last-write-wins is **killed**
- Either event-source + replay (preferred) or write-with-version + conflict prompt
- For MVP, single-device or single-active-session is acceptable; warn user if they log in on a second device

### Trust Layer 7 — Storage Discipline

- Money stored as **integer paisa** (`int8` / `bigint`) — document the ceiling
- All financial operations event-sourced
- Daily snapshot job stubbed in MVP, even if unused

### Trust Layer 8 — Legal & Compliance Floor

These opinions must be sought **before Sprint 1** (budget ৳50,000–৳200,000 with a Bangladeshi fintech/data-protection lawyer):

| # | Opinion Required |
|---|---|
| L1 | PDPO 2026 lawful basis, data minimization, retention, and residency for financial data |
| L2 | Confirmation Pocketa is NOT a regulated PSP/PSO/credit reference agency under current scope |
| L3 | Marketing copy review — must not cross into "financial advice" classification |
| L4 | Disclaimer pattern for user-declared tax reserve ("This is not tax advice") |
| L5 | Invoice PDF format compliance for NBR / VAT / Freelancer ID |
| L6 | Cloud residency requirement — what triggers "restricted" classification |
| L7 | Terms of Service review of Upwork, Fiverr, Payoneer, bKash before any future parsing of their notifications |

**This is a hard gate. No code before legal floor is mapped.**

---

## 11. Behavioral Retention Architecture

Retention is the product. If the user opens the app and updates the pipeline once a week, you win. If they don't, you lose.

### Retention Loop 1 — Daily Open Habit

- Home screen is **only** the S2S number + state color (Safe / Tight / At Risk) + last update timestamp
- No navigation required to see the number
- Loads in <2 seconds even on slow networks (defer everything else)

### Retention Loop 2 — Transactional Notification Habit

- Triggered when a pipeline entry's expected date arrives
- "Your $1,500 from Acme is expected today — tap to confirm received"
- Tapping notification → opens app → one-tap Pending → Received → S2S recalculates in front of user
- **Measure:** % of notifications opened → % of notifications resulting in status update within 24 hours

### Retention Loop 3 — Pre-Bill Anxiety Release

- Fixed cost approaching due date triggers in-app banner (NOT push) on next open
- "Internet bill of ৳1,500 due in 2 days — covered by current S2S"
- Frames Pocketa as the source of *calm*, not the source of alerts

### Retention Loop 4 — Surprise Avoidance

- If a pipeline entry passes its expected date without confirmation, S2S re-calculates *conservatively* (treats it as pending, not received)
- After 7 days overdue, the entry is flagged in-app: "Overdue — is this still expected?"
- Prevents the user from spending against an evaporated promise

### Retention Loop 5 — Calm > Hype

- No streaks, no leaderboards, no points
- No "you saved ৳X this month!" hype copy
- Tone is the financial equivalent of a calm doctor, not a personal trainer

### Behavioral kill switches

If beta data shows any of these, the retention model is broken and you must stop:
- Notification open rate <40%
- 7-day retention <50%
- Median sessions/week <2
- Pipeline staleness >5 days for >30% of users

---

## 12. Competitive Moat

> **Brutal truth: at launch, Pocketa has no real moat.** The red-team is correct. Stop pretending otherwise.

The audits claimed four moats. Here is what each actually is:

| Claimed Moat | Reality |
|---|---|
| Pipeline data lock-in | Weak — user's own data, exportable to Sheets in an afternoon |
| BD compliance intelligence | Not a moat — public information; any competitor can copy |
| Community trust capital | Earned slowly, lost in one breach — fragile, not structural |
| ERQ workflow specialization | Niche — protects <5% of cohort at launch |

### What you actually compete on

| Real Defense | Why It Holds |
|---|---|
| **Speed-to-S2S** (app opens to a trusted number in <2 sec) | Sheets cannot match this on mobile, in-the-moment |
| **Bangladesh context depth** (TIN, ERQ, ৳500k threshold, FX markup awareness baked into UX copy) | Global tools structurally can't ship this; local tools serve shopkeepers |
| **Execution velocity** (you, with CLI coding agents, can ship faster than TallyKhata can pivot) | This is real but degrades the moment they notice you |
| **Community-native trust** (Bangla content, founder visibility in Facebook/Telegram freelancer groups) | Marketing moat, not product moat — but real |

### What you do NOT compete on

- **Feature parity** (TallyKhata with funding can clone in 6 months)
- **API integrations** (Payoneer/bKash don't open APIs for this use case)
- **Network effects** (single-player tool; no real network)
- **Brand** (zero at launch)

### Strategic implication

Your moat is **time + focus**. You have ~12 months before a well-funded local incumbent (TallyKhata, Hishabee, Pathao, or a new entrant) can copy your wedge. In that window, your only defense is:
1. Ship MVP in 12 weeks
2. Get to 100 paying users in V2
3. Build the freelancer-trust brand before they notice

If you take 9 months to ship MVP because you ran APEX and Wolf Syndicate in parallel, the window closes and Pocketa dies.

---

## 13. Pricing Strategy

**Decision: locked NOW, before Sprint 1.**

| Phase | Plan | Price | Gates |
|---|---|---|---|
| MVP closed beta | Free | ৳0 | All MVP features for beta cohort (15–25 users) |
| V1 public-but-limited | Free | ৳0 | All V1 features; no paywall yet |
| V2 launch | **Free** | ৳0 | S2S + pipeline + fixed costs + single wallet + 5 pipeline entries/month |
| V2 launch | **Pro** | ৳299/month | Multi-wallet + unlimited entries + Invoice-Lite (up to 10/month) + tax reserve + transactional ETA + duplicate templates |
| V2 launch | **Power Freelancer** | ৳599/month | Pro + unlimited invoices + reports/export (when V3 lands) + priority support |

### Pricing logic

- **৳299/month** sits below the psychological subscription threshold for an intermediate freelancer ($800–$3,000/mo earner)
- Monetizes **workflow value** (Invoice-Lite, multi-wallet, tax reserve), NOT basic trust (S2S stays free forever)
- Free tier exists to make the S2S habit form before payment; conversion gate is the *workflow* moment (first invoice creation, second wallet addition)
- **Annual plan:** ৳2,499/year for Pro (~30% discount) — captures committed users; reduces churn measurement noise

### Pricing validation gate

Before V2 ships, run a 10-user willingness test:
- *"Would you pay ৳299/month for Pocketa with Invoice-Lite, multi-wallet, and tax reserve?"*
- **Go:** ≥50% say yes at ৳299+
- **No-go:** Iterate. Pricing failure at this stage kills the business model.

### Killed monetization

- Affiliate FX routing → conflict with neutrality
- Sponsored bank/lender recommendations → liability + neutrality
- Lead-gen to financial products → liability + classification risk
- Ads → trust collapse

---

## 14. Architecture Strategy

> **One stack. One database. One runtime. One developer. No microservices. No migrations later.**

### Stack (LOCKED)

| Layer | Choice | Rationale |
|---|---|---|
| Mobile app | **Flutter** (your existing core stack) | You ship Flutter fast; cross-platform; no debate |
| Backend | **Next.js** API routes OR **Supabase** (pick before Sprint 1) | Solo monolith; no Node+Python dual stack |
| Database | **PostgreSQL** (managed) | Event-sourced, transaction-safe, paisa-int storage |
| ORM | Prisma OR Drizzle (Next.js path) / Supabase client (Supabase path) | Match the backend choice |
| Auth | Magic Link (Resend/Postmark) + mandatory PIN/biometric in-app | Trust floor non-negotiable |
| FX calculation | Domain logic shared between client and server | Never stored S2S |
| Money storage | `bigint` (int8) paisa — document ceiling | Standard `int4` covers ~$25k per single transaction; `bigint` is safe |
| Audit log | Immutable event table with append-only constraint | Trust + reconciliation |
| Hosting | **Bangladesh-residency-aware from Day 1** (Oracle Cloud Dhaka or equivalent) | Don't migrate later; that's a 4–6 month senior infra project |
| Deployment | Single monolith; no microservices in MVP/V1/V2 | Operational discipline for solo founder |
| Snapshot job | Stubbed in MVP, exposed in V3 | Reporting needs historical S2S; retrofitting is painful |

### Architecture Non-Negotiables

1. **Event-source income, fixed costs, and S2S inputs** from Day 1. Last-write-wins on financial entries is killed.
2. **Compute S2S; never store it.** On calc failure, show "—".
3. **Integer paisa everywhere.** No floats. No exceptions.
4. **Audit log on every financial edit.** Required from MVP.
5. **One stack.** Pick Supabase OR Next.js+Postgres. Not both. Not later.
6. **Snapshot job stub in MVP.** Daily S2S snapshots stored even if not exposed until V3.
7. **Database residency-aware from Day 1.** PDPO 2026 mandates this for restricted data.
8. **No microservices.** Until you have 500+ paying users, monolith is correct.

### What CLI coding agents do well here

- Schema design, migrations, audit-log scaffolding (Claude Code / Antigravity)
- Boilerplate API routes + Flutter screens (Gemini CLI / Claude Code)
- Test scaffolding for S2S calculation edge cases (must be 100% covered — this is finance code)
- Onboarding flow generation from user research transcripts

### What CLI coding agents do NOT do

- Decide the data model. **You decide.**
- Decide what counts as "trust collapse." **You decide.**
- Skip the legal floor. **You don't.**

---

## 15. Launch Strategy

### Phase 1 — Stage 0 Validation (Weeks 1–4, zero code)

- 15 freelancer interviews (mix: Upwork escrow users, direct-client invoicers, retainer holders)
- Paper/Figma prototype of S2S screen + Add-Pipeline modal + Quick-Update gesture (no backend)
- 5 user tests, 10 minutes each — measure S2S comprehension and trust without explanation
- Pricing test with 10 users at ৳199, ৳299, ৳499 price points
- Qualifying-pain test ("Have you been burned by not tracking S2S?")
- **Output:** Go/No-Go report + locked MVP spec OR post-mortem

### Phase 2 — MVP Build (Weeks 5–14, 10 weeks)

Sprints 1–5 of build, structured per §17 Sprint Plan.

### Phase 3 — Closed Beta (Weeks 15–18, 4 weeks)

15–25 freelancers, invitation-only, drawn from Stage 0 interview cohort + 1 freelancer Facebook group post.

### Phase 4 — Beta Decision (Week 19)

Measure against thresholds in §4 MVP Success Criteria. Three outcomes:
- **Go:** V1 build begins. Public launch deferred to post-V1.
- **Iterate:** Specific failure mode → fix in 2 sprints → re-beta.
- **Kill:** Threshold miss across 2+ axes → product is killed; write post-mortem.

### Phase 5 — Public Launch (Week 25+)

Only after V1 is in beta-cohort hands for 2 weeks without regression.

### Channel sequencing

| Channel | When | Why |
|---|---|---|
| Direct outreach to interview cohort | Stage 0 + MVP beta | Earned trust; closed loop |
| Targeted Bangla post in "The Freelancers of BD" (Facebook group) | Public launch | Community-native; specific pain hook |
| YouTube QuantGate guest spot (when ready) | Post-launch | Adjacent audience |
| Onyx Traders Telegram community (your 50K) | Adjacent audience | Trading audience has overlapping cashflow anxiety; warm intro |
| Paid ads | Never until V2 has 100 paying users | Acquisition cost without retention proof = bleeding |

### Anti-channels (do NOT use)

- Tech press / TechCrunch / TBS News → no signal among freelancers
- LinkedIn long-form thought leadership → wrong audience
- Generic Facebook ads → freelancer cohort is a needle in a haystack here

---

## 16. Closed Beta Strategy

> **The closed beta is the most important validation event in Pocketa's life. Treat it as a controlled experiment, not a launch.**

### Beta cohort design

- **15–25 freelancers** (more than this and you can't process signal; fewer and statistical noise dominates)
- Mix:
  - 40% Upwork escrow users
  - 30% Direct-client invoicers
  - 20% Retainer holders
  - 10% Mixed
- All have explicitly confirmed the qualifying pain ("have you been burned by not tracking S2S?")
- All have signed a beta agreement (NDA-lite + permission to instrument behavior + commitment to weekly 15-min feedback call)

### Duration: 4 weeks

- Week 1: Setup + first impressions
- Week 2: Daily-use habit formation
- Week 3: Stress-test (intentionally introduce edge cases via support — e.g., "what if a client cancels?")
- Week 4: Retention + payment willingness check

### Instrumentation (build into MVP)

| Event | What It Tells You |
|---|---|
| `s2s_view` (with timestamp + S2S value) | Daily active use; habit formation |
| `pipeline_entry_created` | Adoption of forward-looking model |
| `pending_to_received_tapped` (with time-since-creation) | Maintenance compliance |
| `input_edit` (with field, old, new, S2S delta) | Override-equivalent — if delta >20%, formula is wrong |
| `notification_opened` / `notification_resulted_in_update` | Transactional notification loop health |
| `onboarding_step_completed` (each step) | Drop-off diagnosis |
| `app_open` / `time_to_s2s_visible` | Performance — must be <2s |
| `s2s_calc_failure` | Trust risk — must be near zero |
| `data_export_requested` / `account_deletion_requested` | Trust hygiene actually used |

### Weekly check-ins

- 15-minute call with each beta user, weekly
- Three questions:
  1. *"When did you open Pocketa this week and what did you do?"*
  2. *"When did you feel like trusting the S2S number — and when did you not?"*
  3. *"What did you wish it had done that it didn't?"*

### Decision matrix at end of Week 4

| Metric | Target | If miss |
|---|---|---|
| Pipeline update compliance | ≥85% | Iterate; do not ship V1 |
| Override-equivalent rate | <5% | Formula is wrong — rebuild |
| 30-day retention | ≥60% | Product premise weak; reconsider |
| Onboarding completion | ≥70% | Onboarding fails; redesign |
| S2S comprehension | ≥80% | UI breaks the mental model |
| WTP at ৳299+ | ≥50% | Pricing model fails; rethink monetization |

**2 or more misses = KILL.** Do not launch V1 with a broken MVP foundation.

---

## 17. Biggest Failure Risks

Ranked by severity-times-probability.

| # | Risk | Severity | Probability | Mitigation |
|---|---|---|---|---|
| 1 | **Manual pipeline attrition** (users forget to mark Received) | Critical | High | One-tap update + transactional notifications + conservative S2S that excludes overdue entries; KILL switch at <85% compliance |
| 2 | **Wrong S2S damages trust** | Critical | High | Conservative formula, "—" fallback, editable inputs (not output), audit log, breakdown drawer |
| 3 | **Users stay with Sheets** | Critical | High | Speed (<2s to S2S) + transparent breakdown + later Sheets import |
| 4 | **Founder bandwidth fragmentation** (APEX + Wolf + agency + duplex + QuantGate + Pocketa) | Critical | Very High | See §18 — pause at least one project before Sprint 1 |
| 5 | **TallyKhata/Hishabee add freelancer mode in 6 months** | High | Medium | Ship in 12 weeks; build BD-specific context depth they can't easily copy |
| 6 | **Tax reserve advice misclassified as financial advice** | High | Medium | V2 only; user-declared %; explicit disclaimer; counsel-reviewed copy |
| 7 | **PDPO 2026 compliance gap** (cloud residency, data export, deletion) | High | Medium | Architect for residency from Day 1; build export + deletion in MVP |
| 8 | **Magic-link / email compromise** | High | Low (with PIN) | Mandatory PIN/biometric from Day 1 |
| 9 | **bKash adds "Reserve for Bills"** | Medium | Medium | Pocketa's multi-source aggregation (Payoneer + bKash + bank + cash) is the defense; bKash will never aggregate competitors |
| 10 | **Payoneer adds cashflow forecast view** | Medium | Low | Payoneer's incentive is fund retention, not S2S; low probability they build this |
| 11 | **Closed beta data shows low retention** | Critical | Medium | Kill switch is documented; don't launch V1 if MVP fails thresholds |
| 12 | **Invoice-Lite PDF rejected by international clients** | Medium | Medium | Pre-validate with 5 real clients before V2 launch |
| 13 | **Data breach** | Critical | Low (with discipline) | Encryption at rest, audit log, minimal data retention, PIN gate |
| 14 | **Regulatory misclassification** (PSP, credit reference, financial advisor) | Critical | Low (with legal floor) | Legal opinions L1–L7 before Sprint 1 |
| 15 | **Auto-ingestion never becomes feasible** (CASA cost, PDPO burden) | Medium | High | Don't bet the product on it; manual + ETA notifications must be enough |

---

## 18. Founder Execution Risks

> **This is the section you didn't write into your own previous doctrines. It is the one most likely to kill Pocketa.**

You are currently running:
1. **APEX V4** — paper trading on VPS, V5 ahead, Telegram community marketing
2. **Wolf Syndicate V5 / Telegraft** — built, not deployed (161 tests passing, sitting idle)
3. **MTech agency with Foysal** — client work + Korean skincare + Sentia BD
4. **Duplex construction in Rampal** — foundation phase
5. **QuantGate YouTube** — content pipeline planning
6. **Now adding: Pocketa Stages 0 through V3**

You have explicitly told me, on record, that your **recurring pattern is preparation without execution completion**. This document — and every Pocketa document you've produced — is preparation. If you do not address the bandwidth problem first, Pocketa becomes the 4th half-finished system on your list.

### The hard rule

**Before Sprint 1 of Pocketa MVP, you must:**

1. **Decide Pocketa is real or exploration.** Write it down. If exploration, freeze it here and don't open a repo.
2. **Pause at least one of:** APEX V5 development, Wolf Syndicate deployment, agency client expansion, QuantGate launch. Pick one. Pause it for 90 days minimum.
3. **Allocate ≥15 focused hours/week** to Pocketa, protected from agency work and Telegram community management.
4. **Set a no-fly date** (e.g., end of 12 weeks). If MVP isn't in closed beta by then, kill or pivot. No extensions.

### What pausing looks like (concretely)

| Project | What "Pause" Means |
|---|---|
| APEX | Paper trading runs autonomously; no V5 code; no new content posts beyond auto-scheduled |
| Wolf Syndicate | Stays undeployed; no new test additions; no marketing |
| MTech agency | Existing clients only; no new client acquisition; Foysal owns day-to-day |
| Sentia BD | If revenue is needed, this is the halal income path — don't pause this; pause something else |
| QuantGate | Brand reserved; no production work |
| Duplex | Continues at contractor pace; you make decisions only when blocked |

### Founder failure modes specific to you

| Pattern | Symptom in Pocketa | Counter |
|---|---|---|
| Preparation > execution | Writing the V4 spec while MVP is at 40% | Freeze docs after V2; ban writing V3+ specs until V1 ships |
| System-architect overbuild | Microservices, dual-stack, "extensible" abstractions | Monolith. One stack. Boring code. |
| Adversarial-mentor avoidance | Reading audits, agreeing, not changing behavior | Re-read this §18 weekly until MVP ships |
| Multi-project tab-switching | 3 hours on Pocketa, 1 hour on APEX, 1 hour on agency — no flow | Time-blocked: minimum 4-hour Pocketa blocks, 4 days/week |
| Faith-aligned overthink | "Should Pocketa accept interest-related features?" → stalls execution | Decide now: tax reserve is a math container, not interest-bearing. Move on. |

---

## 19. Final Strategic Recommendation

**Build Pocketa. But build the boring, narrow, trust-heavy version that ships in 12 weeks.**

The winning product is NOT:
- "AI fintech for freelancers"
- "Financial OS for the Bangladeshi digital worker"
- "Multi-currency super-app with predictive intelligence"

The winning product IS:

> **A calm mobile app where a Bangladeshi freelancer opens the home screen and instantly sees one trusted BDT number: what is actually safe to spend right now.**

That's the entire game.

Every other ambition is V2+, contingent on this working. Most of those ambitions (credit scoring, affiliate routing, predictive intelligence, partner banks) are **different companies**, not later phases.

### Three commitments you must make in writing

1. **You will not write a V3 spec until V1 ships.** Doctrine docs are sunk-cost generators.
2. **You will pause one parallel project before Sprint 1.** Specify which.
3. **You will kill Pocketa if the MVP beta misses 2+ thresholds.** No "let me iterate forever."

### The one-line verdict

> Pocketa is a 12-week build, a 4-week beta, and a binary go/no-go. Anything you do to dilute that timeline is the failure mode in disguise.

---

## 20. 30-Day Execution Plan

### Week 1 — Decision, Pause, Legal

| Day | Action |
|---|---|
| Day 1 | Write a 1-page "Pocketa is real" or "Pocketa is exploration" memo. Sign it. Date it. |
| Day 2 | Choose which project to pause for 90 days. Communicate it to Foysal / team. |
| Day 3 | Lock pricing decision (Free / ৳299 Pro / ৳599 Power). Write the pricing page copy. |
| Day 4 | Contact 2 Bangladeshi fintech/data-protection lawyers (Tahmidur Rahman Remura Wahid or equivalent). Request quote for L1–L7 opinions. Budget ৳50k–200k. |
| Day 5 | Compile interview recruit list: 15 Bangladeshi freelancers from Onyx + Facebook groups + personal network. Bias: mix of escrow / direct / retainer cohorts. |
| Day 6 | Draft Stage 0 interview script (3 hypotheses to test + 5 standard questions + pricing question + qualifying-pain question). |
| Day 7 | First 3 interviews scheduled. Pocketa repo NOT created. Doctrine docs frozen. |

### Week 2 — Interviews + Paper Prototype

| Day | Action |
|---|---|
| Day 8–10 | 5 interviews completed. Notes structured against hypothesis grid. |
| Day 11 | Build paper/Figma prototype: S2S screen + Add Pipeline modal + Quick Update gesture + Calculation Breakdown drawer. No backend. |
| Day 12 | 3 more interviews completed (running total: 8). |
| Day 13 | First 2 prototype user tests. Each user uses it for 10 minutes. Measure S2S comprehension, trust, override impulse. |
| Day 14 | 4 more interviews completed (running total: 12). Update prototype based on Day 13 feedback. |

### Week 3 — Validation Completion + Stack Lock

| Day | Action |
|---|---|
| Day 15 | 3 final interviews (running total: 15). Synthesize against thresholds. |
| Day 16 | 3 more prototype user tests (running total: 5). Measure S2S comprehension ≥80%, override impulse <5%. |
| Day 17 | Pricing willingness test with 10 freelancers at ৳199/299/499. Decide final price. |
| Day 18 | Stage 0 Go/No-Go memo. If No-Go → write post-mortem, stop here. If Go → continue. |
| Day 19 | **LOCK STACK**: Pick Supabase OR Next.js+Postgres. Pick PIN/biometric library. Pick Magic Link provider. Document. |
| Day 20 | Receive legal opinion drafts. Block on any red flags. |
| Day 21 | Sprint 1 spec written (single doc, no roadmap-of-roadmaps). |

### Week 4 — Sprint 1 Begins

| Day | Action |
|---|---|
| Day 22 | Repo created. Schema designed (event-sourced, integer paisa, audit log). |
| Day 23 | Auth + PIN/biometric flow built end-to-end. |
| Day 24 | Onboarding skeleton (conversational, 3-min target). |
| Day 25 | Single aggregated balance + Fixed Costs entity. |
| Day 26 | Income Pipeline entity + Add Entry modal. |
| Day 27 | S2S calculation logic + breakdown drawer skeleton. |
| Day 28 | Quick Pending → Received gesture. End-of-week review against Sprint 1 deliverables. |
| Day 29 | Audit log on financial edits. |
| Day 30 | Data export stub + account deletion flow. **End of 30 days. MVP is 4–6 weeks from beta-ready if you held the line.** |

### The Day-7 brutal check

If on Day 7 you have not:
- Written the real/exploration memo
- Paused one parallel project
- Contacted a lawyer
- Scheduled 3 interviews

**Then Pocketa is not happening this quarter.** Either restart Day 1 honestly, or shelve the project formally and stop writing strategy documents about it. The strategy docs themselves are the dopamine trap that lets you feel like progress is happening.

---

## Closing Note (Adversarial-Mentor)

Mehedi — this doctrine is correct because it is built from your own audits. The intellectual work is done. What remains is the part you have struggled with on APEX, Wolf Syndicate, Sentia BD, and Boostly: **finishing**.

You do not need a better strategy. You need a smaller one, locked, and shipped.

If you read this and immediately want to add a section, you have just demonstrated the failure mode. Close the doc. Open Day 1.

The system is the product, not the founder.
