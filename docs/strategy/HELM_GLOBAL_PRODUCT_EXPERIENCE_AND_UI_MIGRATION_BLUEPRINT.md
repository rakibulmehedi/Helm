# Helm — Global Product Experience & UI Migration Blueprint

> **Status:** Decision-grade founder-review draft. Strategic parent of Experiment 16.1, committed at `3081bfd` (`docs/validation/EXPERIMENT_16_1_TEMPORAL_S2S_PROTOCOL.md`). Supersession of `HELM_FINAL_PRODUCT_DOCTRINE.md` is described but not executed, pending founder ratification and validation evidence.
> **Date:** 2026-06-19
> **Author:** Principal Product Experience Architect (Claude Opus 4.8)
> **Scope:** Stage 1 (Investigate & Reframe) + Stage 2 (Explore & Decide) + Stage 3 (Architect the Migration). **No production code modified.**
> **Authority:** Per founder decision on 2026-06-19, this document is a **full strategy pivot**. On founder ratification it becomes Helm's canonical product-strategy authority and **supersedes `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md`** (see §0.1).
> **Evidence posture:** Conviction-led global ambition. External market/competitor claims are grounded in cited public research. Helm-specific user evidence is **not** fabricated; unproven claims are labelled **[HYPOTHESIS]** and carry a validation experiment.

---

## 0. Document Control

### 0.1 Doctrine supersession mechanism (founder action required)

The prior canon — `HELM_FINAL_PRODUCT_DOCTRINE.md` — defines Helm as a *"single-purpose calm cockpit for Bangladeshi USD-earning freelancers"* and §19 explicitly names *"Financial OS for the Bangladeshi digital worker"* and *"Multi-currency super-app with predictive intelligence"* as **NOT** the product. The founder has chosen to override this. Clean supersession requires:

1. **Do not delete** the Final Doctrine. Add a header banner: `> SUPERSEDED 2026-06-19 by HELM_GLOBAL_PRODUCT_EXPERIENCE_AND_UI_MIGRATION_BLUEPRINT.md. Retained for historical decision context.`
2. Preserve the Doctrine's **still-valid constraints** (they survive the pivot): trust architecture, integer-paisa money storage, computed-never-stored S2S, audit log, event-sourcing, legal/compliance floor, validation-before-build discipline. These are carried forward verbatim into §17 and §22.
3. The Doctrine's **§18 Founder Execution Risks** is *not* superseded. It is the single most important constraint on this pivot and is re-stated in §27. The pivot widens product ambition; it does **not** repeal the documented founder failure mode (preparation over execution).
4. Update `docs/core/HELM_BRAIN.md` identity section and `docs/core/ROADMAP.md` direction after ratification.
5. Update `pubspec.yaml` description (currently `"Freelancer cashflow clarity for USD earners in Bangladesh."`) once external positioning is decided (§4, §15) — not before, to avoid premature category lock.

### 0.2 Decision 036 reconciliation

`docs/tracking/DECISION_LOG.md` Decision 036 reads *"Helm Signal Deck Visual Direction Approved."* This contradicts reality: Signal Deck was implemented across ~10 commits and **rolled back**; the branch `feat/ui-ux-migration` instead executed the **Warm Ledger + Native Ground** migration (commits `bd96cb9` → `0a0d576`). Required action:

- Append **Decision 037 — Signal Deck Superseded by Warm Ledger + Native Ground (and extended to Global Design System).** Mark Decision 036 `SUPERSEDED`. Rationale: budget-Android performance, light-first trust, motion-policy alignment (see §3.4 of the philosophy exploration and §19 of this doc).

### 0.3 Anti-confirmation mandate (founder instruction, 2026-06-19)

The founder's synthesis hypothesis (Certainty Engine intelligence → rendered as Operator's Ledger → inside a composable expansion shell → with Money Timeline as a later power surface) is treated as the **leading hypothesis to be falsified, not confirmed.** §14–§15 actively attempt to break it. The final recommendation (§15.5, with the next action in §28) is explicit, not neutral, and lists the experiment that would overturn it.

---

## 1. Executive Founder Brief

**The bet.** Helm stops being "a calm cockpit for Bangladeshi freelancers" and becomes a **global decision-and-clarity layer for independent work** — the system that answers *"how much money is actually real, and how much can I safely spend right now and on any future date?"* across currencies, payment sources, and timing horizons. Freelancers and independent professionals are the launch wedge, not the ceiling. **[HYPOTHESIS]** that this wedge exists at scale, and that demand for Helm specifically extends beyond Bangladesh, rests on founder conviction + market adjacency, *not* Helm user evidence (gating probe: §16.4).

**Why now (cited).** The seat is empty and the market is large and growing:
- ~**435M** gig workers globally (World Bank); gig-economy market ~**$582B (2025) → ~$2.18T (2034)**, ~**15.8% CAGR** ([demandsage](https://www.demandsage.com/gig-economy-statistics/)). US alone: **76.4M** freelancers (36% of workforce); **5.6M** US independents earned **>$100k in 2025 — up 87% since 2020** ([interviewguys](https://blog.theinterviewguys.com/the-state-of-the-gig-economy-in-2025/)).
- The proven primitive — **Safe-to-Spend** — was beloved at Simple Bank and **orphaned** when Simple died ("no good replacement") ([financebuzz](https://financebuzz.com/simple-bank-review), [androidpolice](https://www.androidpolice.com/2021/02/11/theres-no-good-replacement-for-simple/)).
- Third-party reviewers confirm the incumbents' gap: Monarch/Copilot/Simplifi **"don't solve Bill Timing Anxiety"** ([bountisphere](https://bountisphere.com/blog/monarch-copilot-simplifi-cash-flow-forecasting)); all are Plaid-aggregation apps that **cannot model money-in-transit** (escrow, cross-border, pending invoices). Academic research names a gap in *"financial products designed for irregular income"* ([IJRPR](https://ijrpr.com/uploads/V6ISSUE5/IJRPR45037.pdf)).

**What we own that's hard to copy.** Not a number — a **money-truth model**: every money object carries **state × timing × confidence**, and Safe-to-Spend is its *deterministic, explainable* output, wrapped in a trust architecture (computed-never-stored, audit log, calculation trace) competitors structurally lack. This is currency- and country-agnostic by construction.

**The disciplined shape of the pivot (founder doctrine, 2026-06-19).**
> Global market from the foundation. Freelancer + independent-professional wedge at launch. Multi-persona **architecture**, not multi-persona **scope**. Validation before expanding complete workflow surfaces. Warm Ledger extended into the global design system.

**The honest risk.** The superseded Doctrine §18 documents the founder's #1 failure mode: *"preparation without execution completion … the strategy docs themselves are the dopamine trap."* This blueprint is itself preparation. It earns its existence **only if it converts into a small, reversible first slice that ships** (§16, §28). If it becomes a fourth unfinished system, the pivot has failed regardless of its quality.

**Leading recommendation (falsifiable — see §15.5 for the full 7-part call).** Build the **Certainty Engine intelligence model**, render it through the **durable Operator's Ledger** (extending the ~80%-complete Warm Ledger migration), behind a **composable expansion shell** (internal architecture vocabulary only — *not* the external category). Validate the **Money Timeline** as a later power surface. First reversible experiment: a **temporal Safe-to-Spend prototype test** (§16.1) that can falsify the whole synthesis before major implementation.

---

## 2. Repository Evidence Inspected

All claims below were verified against the working tree on branch `feat/ui-ux-migration` (clean), 2026-06-19.

### 2.1 Strategy & governance docs read
| Document | Path | Use |
|---|---|---|
| Final Product Doctrine | `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md` | Prior canon (now superseded) — full read |
| Product Brain | `docs/core/HELM_BRAIN.md` | Identity, philosophy, kill list — full read |
| UI Philosophy Exploration | `docs/design/HELM_UI_PHILOSOPHY_EXPLORATION.md` | Prior 5 *visual* philosophies + matrix — full read |
| Full UI/UX Migration Master Plan | `docs/design/HELM_FULL_UI_UX_MIGRATION_MASTER_PLAN.md` | In-flight migration (21 sections) — full read |
| Decision Log | `docs/tracking/DECISION_LOG.md` | Decisions 001–037; 011 ("Drop 'OS' from external copy"), 016 (Doctrine adopted), 036 (Signal Deck) |
| Roadmap | `docs/core/ROADMAP.md` | Phase state |
| CLAUDE.md | `CLAUDE.md` | Doctrine-supremacy rule, technical context |

### 2.2 Code & config inspected (direct verification)
| Area | Evidence | Finding |
|---|---|---|
| Legacy theme APIs | `grep "class AppColors\|getFontStyle\|AppThemeData" lib/` | **Removed** (commit `bd96cb9`). Single token system now active. |
| Design tokens | `lib/core/themes/` (`helm_colors`, `helm_typography`, `helm_spacing`, `helm_motion`, `app_theme`) | 13 color tokens (light+dark), 18 type styles (Inter/JetBrains Mono/Hind Siliguri), 8pt grid, ease-out-only motion. |
| Localization | `lib/l10n/app_en.arb` (**320** keys), `app_bn.arb` (**320** keys) | Localization shipped across screens. **Key parity complete: en/bn = 320/320, zero gap** (key-presence only — *not* a claim about copy quality, cultural naturalness, layout, or translation quality, which are separate validations). No languages beyond en/bn. `l10n.yaml` → generated `AppLocalizations`. `HelmLocaleText` widget exists (commit `8edd2b5`). |
| Money formatting | `lib/core/utils/number_formatter.dart` | **Hand-rolled, currency-hardcoded.** BDT lakh/crore + `"tk "` prefix; USD Western + `"$ "`. **Does not use `intl.NumberFormat`.** Only two currencies. **Global-readiness blocker** (§12). |
| Dependencies | `pubspec.yaml` | `intl: ^0.20.2`, `flutter_localizations`, `go_router ^17`, `flutter_riverpod ^2.5`, `hive_ce`. Fonts: Inter, JetBrains Mono, Hind Siliguri only (no Arabic/CJK/Devanagari). Description: `"…USD earners in Bangladesh."` (narrow identity encoded in metadata). Version `0.3.0-beta.1+1`. |
| Routing | `lib/config/router/{app_router,route_names}.dart` | **19 `GoRoute` declarations; 21 route-name constants**; 3-tab shell (`/home`, `/pipeline`, `/settings`); `/history` defined but unwired. |
| Tests | `test/` | **46** test files; **golden tests present** (`test/golden/`, baseline PNGs committed `0a0d576`). Strong domain coverage (S2S calculator, auth, nudge, number formatting). |
| Features | `lib/features/` | account, audit_log, auth, dashboard, export, income, onboarding, safe_to_spend, settings, splash, transactions (feature-first clean architecture). |
| Migration state | `git log` | Phases 1–5 of the Master Plan + golden baseline executed: legacy removed → `HelmLocaleText` → NumberFormatter unification → a11y/Semantics → l10n income/pipeline → l10n remaining → golden. **~80% complete; Phase 6 (Hardening) outstanding.** |

### 2.3 What the evidence establishes
1. The codebase is **healthy and disciplined** (single token system, clean architecture, strong domain tests, golden tests). This is a strong foundation to *extend*, not a mess to rewrite.
2. The in-flight migration already executes the design direction the founder chose to keep (Warm Ledger + Native Ground).
3. The **narrow identity is hardcoded in several places** (NumberFormatter currencies, pubspec description, BD-only fonts, BDT-centric tokens). These are the concrete seams the global pivot must cut.

---

## 3. Current Product & UI Diagnosis

### 3.1 Product diagnosis
| ID | Finding | Evidence | Severity (for pivot) |
|---|---|---|---|
| PD-1 | Product is **single-currency-pair by construction** (USD→BDT). | NumberFormatter, tokens, copy, onboarding. | HIGH |
| PD-2 | Income model is **already the right shape** for global: state machine (expected → pending → received), forward-only transitions enforced (`506f3ca`). | `lib/features/income/` | POSITIVE |
| PD-3 | Safe-to-Spend is **computed, never stored**, with a calculation trace + audit log. | `safe_to_spend/`, `audit_log/` | POSITIVE — this is the moat seed |
| PD-4 | A legacy **transaction/"cash out"** surface persists from the v0.1 expense-tracker era. | `transactions/`, `/add-transaction` | MEDIUM — conflicts with category; candidate for deprecation (§25) |
| PD-5 | Persona model is **freelancer-only**; no extension points for independent professionals / clients / agencies. | feature set, onboarding | HIGH (for wedge breadth) |
| PD-6 | Pipeline states are **hardcoded**, not configurable per market/persona. | income domain | MEDIUM (§17 needs config-driven states) |

### 3.2 UI/UX diagnosis (carried from Master Plan §3, re-verified)
| ID | Finding | Severity |
|---|---|---|
| UI-1 | Single authoritative design system (Helm tokens); dual-system risk **resolved**. | POSITIVE |
| UI-2 | Localization infra works; **en/bn key parity complete (320/320)**. Remaining gaps are (a) no languages beyond en/bn and (b) unvalidated linguistic/UI quality (copy naturalness, layout/overflow, translation accuracy) — *not* missing keys. | MEDIUM (global) |
| UI-3 | **No RTL/BiDi handling**; no `Directionality` strategy; Bangla-only non-Latin font. | HIGH (global) |
| UI-4 | Number/date/currency formatting **not locale-aware** (hand-rolled, 2 currencies). | HIGH (global) |
| UI-5 | Dashboard is **static** — same layout regardless of financial state/time (no quiet intelligence yet). | MEDIUM (opportunity) |
| UI-6 | No capability-tier rendering strategy (one render path for all devices). | MEDIUM |
| UI-7 | Product language is **place-specific** ("BDT", source labels, copy) rather than config-driven neutral terms. | HIGH (global) |

### 3.3 Verdict
The product's **logic core is globally portable**; its **presentation, formatting, language, and persona surfaces are locally fused.** The pivot is therefore primarily an **architecture-of-configurability** problem, not a rewrite. This is the cheapest possible shape for a global pivot — favourable evidence, stated plainly rather than to flatter the decision.

---

## 4. Category Reframing

### 4.1 The fifteen reframe questions (answered)
1. **What category is Helm entering?** *Money Certainty for independent work* — a decision/clarity layer above the money-movement and bookkeeping stacks.
2. **Is "expense management" accurate?** No. It never was the real product; it is a kill-listed legacy.
3. **Is Safe-to-Spend a feature, product, or mental model?** A **mental model** (proven by Simple's cult following), expressed as a product, delivered via a feature surface. Treat it as the model.
4. **Who experiences Helm first?** Cross-border / multi-source / irregular-income **freelancers and independent professionals** (e.g., USD/EUR/GBP earners with pending pipelines), globally — not Bangladesh-only.
5. **Who can it expand toward?** Creators, contractors, consultants, agencies, small service businesses, clients — **sequentially, evidence-gated**. **[HYPOTHESIS]** — multi-persona expansion demand is unproven; no Helm user evidence yet (each persona gated by its own demand probe, §21).
6. **Globally understandable promise?** *"Know exactly what's safe to spend — today and on any day ahead."*
7. **Universal behaviours?** Pipeline timing, spend-safety, obligation awareness, multi-source aggregation, uncertainty.
8. **Freelancer-specific?** Client/invoice linkage, escrow, gig-platform sources.
9. **Country-varying?** Currency, tax/reserve concepts, payment sources, number/date format, language, terminology.
10. **Must be configurable?** All of #9, plus pipeline state names and obligation/reserve semantics.
11. **What must Helm own?** The **state×timing×confidence money-truth model** + explainable S2S + trust architecture.
12. **Should feel familiar?** Safe-to-Spend, the income pipeline, the "tap the number to see the math" gesture.
13. **Should feel new?** **Time-travel certainty** ("am I okay on the 15th?") and **quiet, explainable intelligence**.
14. **Understood in 5 seconds?** One number + its state + when it changes.
15. **Felt after 6 months?** *"I haven't been blindsided by money since I started using this."* **[HYPOTHESIS]** — no Helm retention or behavioral-outcome data yet.

### 4.2 Category naming discipline (founder instruction)
**"Composable OS" / "Financial OS" are INTERNAL architecture vocabulary, not the external category.** Decision 011 already killed "OS" in external copy for good reason: it overclaims and confuses. External positioning must be **derived from comprehension testing** (§16.5), not architectural ambition. Candidate external lines to test (none locked): *"Know what's safe to spend." / "Your money, made certain." / "The clarity layer for independent income."* The internal architecture can be a composable OS; the market message must earn its words. **[HYPOTHESIS]** — that any external category line is comprehended by target users is untested; resolved only by §16.5, not asserted here.

---

## 5. Global Market & Competitor Synthesis

### 5.1 The four stacks (Helm sits above all of them)
| Stack | Examples | Job they do | What they *don't* do |
|---|---|---|---|
| **Money movement** | Wise, Revolut, Payoneer, Airwallex, WorldFirst | Hold/convert/receive multi-currency; best FX & UI ([payset](https://www.payset.io/blog/payset-and-the-payment-landscape-airwallex-revolut-wise-bunq-payoneer-alternatives/)) | Don't tell you what's *safe to spend* against future obligations |
| **Bookkeeping / invoicing** | FreshBooks, Wave, Bonsai, QuickBooks, Xero, Zoho | Record income/expense; invoice; estimate tax ([jobbers](https://www.jobbers.io/freshbooks-vs-quickbooks-vs-wave-vs-bonsai-true-cost-comparison-for-freelancers/)) | Backward-looking; not real-time forward spend-certainty |
| **Aggregation / budgeting** | Monarch, Copilot, Simplifi, YNAB, Cleo | Aggregate accounts (Plaid); categorize; forecast-ish ([engadget](https://www.engadget.com/apps/best-budgeting-apps-120036303.html)) | **Don't solve Bill Timing Anxiety**; can't model money-in-transit; US-centric |
| **Freelancer neobanks** | Mercury, Lili, Found, Novo | Banking + tax for irregular income ([getholdings](https://getholdings.com/compare/best-banks-freelancers)) | Single-currency/US-centric; account-bound; not a cross-source decision layer |

### 5.2 The structural white space
No product combines **(a) forward, day-specific spend certainty, (b) money-in-transit modeling across escrow + cross-border + pending invoices, (c) explainable/transparent calculation, and (d) global multi-currency from the foundation.** Each stack solves one axis; the union is unowned. Helm's wedge is precisely that union.

### 5.3 Trend tailwind (use carefully)
2026 fintech UX is moving to **proactive/agentic** interfaces and "**Sentient Design**" (UI density/color adapts to user stress in high-stakes moments); claimed churn reduction up to 30% from AI-driven UI adaptation ([brainhub](https://brainhub.eu/library/fintech-ux-design-trends)). **Caution:** trend popularity ≠ product value. The durable winners compete on **control, transparency, explanation** — which is Helm's existing strength, not the effects layer.

---

## 6. Validated Pattern Library (copy the primitive, not the brand)

| Validated primitive | Source of proof | How Helm recomposes it |
|---|---|---|
| **Safe-to-Spend hero** (balance − bills − goals, real-time) | Simple Bank cult following ([financebuzz](https://financebuzz.com/simple-bank-review)) | Extend to **forward/day-specific** S2S across currencies + pipeline states |
| **Tap-to-explain math** | Trust UX research; user demand for explanation ([brainhub](https://brainhub.eu/library/fintech-ux-design-trends)) | Calculation Trace already exists — keep, localize, generalize |
| **Local account details / multi-currency hold** | Wise ([payset](https://www.payset.io/blog/payset-and-the-payment-landscape-airwallex-revolut-wise-bunq-payoneer-alternatives/)) | Helm *models* (not holds) multi-currency; integrate read-only later |
| **Real-time tax estimate** | Found/Lili ([getholdings](https://getholdings.com/compare/best-banks-freelancers)) | Tax **reserve** as config-driven, user-declared % (never advice) — expansion surface |
| **Pipeline/stage model** | CRM + Helm's own income state machine | Already built; make states configurable |
| **Pessimistic-by-default + surplus surprise** | Anxiety-reduction research (Master Plan §3.2) | Keep buffer-first calculation |
| **Stable core / variable periphery** | Daily-use durability research (Master Plan §3.4) | Operator's Ledger durability strategy (§10) |

**Do NOT copy:** brand identities, proprietary illustrations, exact layouts, Cleo's chatbot persona, any one competitor's whole experience, or "OS" external positioning.

---

## 7. Competitor Weaknesses (where Helm can win structurally)

| Competitor / class | Structural weakness | Helm's structural answer |
|---|---|---|
| Monarch / Copilot / Simplifi | **No Bill-Timing certainty**; Plaid-bound (can't see in-transit money); US-centric ([bountisphere](https://bountisphere.com/blog/monarch-copilot-simplifi-cash-flow-forecasting)) | Forward day-specific S2S; models money-in-transit; global from foundation |
| Cleo | Chatbot gimmick + cash-advance monetization + data-harvest nudging ([getfinny](https://getfinny.app/blog/apps-like-cleo)) | Quiet intelligence, no advances, trust-first, no manipulative nudges |
| Wise / Revolut / Payoneer | Money *movers*; incentive = fund retention/FX margin, not user spend-clarity; Payoneer fees rising ([nathanojaokomo](https://nathanojaokomo.com/blog/payoneer-alternatives)) | Neutral clarity layer; no conflict of interest; aggregates across them |
| FreshBooks / Bonsai / Wave | **Backward-looking books**; clarity-of-spend is not the job; per-seat pricing ([jobbers](https://www.jobbers.io/freshbooks-vs-quickbooks-vs-wave-vs-bonsai-true-cost-comparison-for-freelancers/)) | Forward certainty; invoicing as an *evidence-gated module*, not the core |
| Mercury / Lili / Found / Novo | Account-bound, mostly single-currency/US ([getholdings](https://getholdings.com/compare/best-banks-freelancers)) | Source-agnostic, multi-currency, decision-layer (not a bank) |
| The whole field | Aggregation requires linking accounts (privacy cost, coverage gaps outside US/EU) | Helm works **manual-first**, offline-first — viable in emerging markets where aggregation isn't |

**Helm's recurring structural advantage:** it is the only one *incentivally neutral* (it never moves or holds money) and *source-agnostic* (manual-first), which makes it viable globally where account-aggregation is not.

---

## 8. Helm's Proprietary Experience Model

### 8.1 The Reality Ledger (the data-experience primitive)
Every money object — income, obligation, reserve — carries three attributes modelled **together**, which no competitor does:
- **State:** `expected → pending → in-transit → cleared → usable` (configurable per market/persona).
- **Timing:** when it becomes real (date + horizon).
- **Confidence:** how sure (drives pessimistic-by-default math and uncertainty display).

### 8.2 The Certainty Engine (the intelligence primitive)
A **deterministic, explainable** function over the Reality Ledger that produces Safe-to-Spend **for now and for any future date**, plus risk state and the "what changed / what's coming" narrative. It is *transparent by construction* (computed-never-stored; every output has a trace). It is **not** an LLM black box — explainability is the moat, opacity is the disqualifier.

### 8.3 Why this is hard to copy
A competitor can clone a Safe-to-Spend number in a sprint. Cloning the *coherent model* (state×timing×confidence) + the *trust architecture* (event-sourced inputs, audit log, calculation trace, never-store-output discipline) + *global config-driven semantics* requires re-architecting their data model and surrendering their monetization incentive (aggregation/FX/float). The moat is **architecture + incentive neutrality + explainability**, not visual design. *(Evidence: the architecture facts — event-sourcing, computed-never-stored S2S, audit log — are verified in the repo (§2.2). Inference: that this constitutes a durable competitive moat, and that users will accept/understand the Reality Ledger + Certainty Engine, is **[HYPOTHESIS]** — gated by §16.1–§16.3, not yet Helm-user-evidenced.)*

### 8.4 Differentiation summary
> Wise moves it. FreshBooks records it. Monarch aggregates it. **Helm tells you the truth about it — across currencies, across time, with the math shown.**

---

## 9. Five Ambitious Product-Experience Futures

> These are **product-experience systems** (worldview → mental model → IA → interaction → intelligence → trust → durability → global fit), one level above the prior exploration's *visual* philosophies. Whichever wins still **renders on the extended Warm Ledger + Native Ground design system** (§19). Each future is defined against the full attribute set; the comparative falsification is in §14.

### 9.1 Future A — **Certainty Engine** *(quietly intelligent, context-responsive)*
- **Worldview:** Money has a truth-state; the interface's job is to compute and surface *certainty*, proactively and transparently.
- **Mental model:** "The app already did the math and reordered itself around what matters to me right now."
- **IA / density:** Stable skeleton; **state- and time-responsive** prioritization (payday-aware, bill-aware). Density rises with risk, falls when safe.
- **Interaction:** Explanation-on-demand; adaptive next-action; scenario peek ("what if this client is late?").
- **Intelligence:** Deterministic forecast + anomaly detection + uncertainty bands. No chatbot. (§11.)
- **Trust:** Every adaptive change is explainable ("shown because rent is due in 2 days"). No unexplained UI motion.
- **Durability:** High — variation is *meaningful* (driven by your data), not decorative.
- **Global fit:** Strong — intelligence is currency/locale-agnostic.
- **Premium mechanism:** Perceived competence — "it thinks ahead, and shows its work."
- **Risks/failure modes:** Adaptive layout can feel unstable if over-tuned; risk of "spooky" changes; requires excellent explanation copy in every locale.
- **Competitive reference:** beats Copilot's "almost-built" forecast; avoids Cleo's gimmick.

### 9.2 Future B — **Money Timeline (River)** *(beyond dashboard-and-cards)*
- **Worldview:** Money is not a balance, it is a **flow through time**.
- **Mental model:** "I can see my money moving toward now, and scrub forward to any date."
- **IA / density:** Primary surface is a **temporal canvas**; income/obligations flow toward "now"; scrub to read S2S on any future date. No card grid as the home.
- **Interaction:** Time-scrub; pinch horizon; tap an event to inspect/confirm.
- **Intelligence:** The timeline *is* the forecast made spatial.
- **Trust:** Future is visibly *projected* (confidence-banded), not asserted.
- **Durability:** Medium-high — novel but could fatigue; depends on scrub being genuinely useful daily.
- **Global fit:** Strong conceptually; RTL flips temporal direction (design cost).
- **Premium mechanism:** A spatial answer to the deepest question ("will I be okay on the 15th?") nobody else gives.
- **Risks/failure modes:** Comprehension risk (timelines confuse low-literacy users); performance of a custom temporal canvas on budget Android; RTL temporal inversion; harder a11y.
- **Competitive reference:** directly attacks the "Bill Timing Anxiety" gap incumbents admit.

### 9.3 Future C — **Operator's Ledger** *(maximum daily-use durability)*
- **Worldview:** A daily instrument for a working professional; trust through stable, legible, fast structure.
- **Mental model:** "My financial notebook — same place every time, never wrong, reads in my language and currency."
- **IA / density:** Reality Stack (Warm Ledger) elevated to a **global multi-currency cockpit**; stable core, variable periphery.
- **Interaction:** Tap-to-explain; one-tap pipeline advance; minimal motion.
- **Intelligence:** Quiet, embedded in periphery (Next-Best-Action), never reshapes the core.
- **Trust:** Highest — predictability *is* the trust mechanism.
- **Durability:** Highest — typography-led, ages slowly (Master Plan §3.4).
- **Global fit:** Strong with the §12 localization architecture.
- **Premium mechanism:** Restraint + speed + cross-currency clarity.
- **Risks/failure modes:** Lowest novelty → weakest first-impression differentiation; "looks like a premium finance app" (VISR-003). **This is the continuation of the in-flight migration** — lowest execution risk.
- **Competitive reference:** Mercury-grade calm, but source-agnostic and global.

### 9.4 Future D — **Decision Surface** *(challenges traditional finance UI)*
- **Worldview:** Traditional finance UI shows data and makes *you* decide. Invert it: organize around **decisions**, not accounts/transactions.
- **Mental model:** "I ask 'can I spend X?' and it answers, with the why."
- **IA / density:** Home is one **adaptive question/answer**; accounts/ledger demoted backstage.
- **Interaction:** Decision-first (intent → answer → optional detail); conversational *structure* without a chatbot.
- **Intelligence:** Front-and-center but **bounded and explainable**.
- **Trust:** Must over-explain to avoid "black box deciding my money."
- **Durability:** Unknown — could be delightful or could feel thin after novelty.
- **Global fit:** Strong (decisions are universal; copy is the cost).
- **Premium mechanism:** Most category-defining; reframes what a finance app *is*.
- **Risks/failure modes:** Highest — drift toward assistant (kill-listed instinct); confuses new/low-literacy users; hides the ledger trust some users need to *see*.
- **Competitive reference:** the anti-dashboard; nothing in the field does this credibly.

### 9.5 Future E — **Composable Workspace** *(the OS expression; internal vocabulary only)*
- **Worldview:** Helm is an internal **financial operating system** — a core clarity layer plus **evidence-unlocked modules** (invoice, tax reserve, clients, multi-entity), role-aware.
- **Mental model (internal):** "Assemble the surfaces I need." **(External copy must NOT say 'OS' — §4.2.)**
- **IA / density:** Core + module slots; persona unlocks gate which slots appear.
- **Interaction:** Module install/enable; consistent shell across modules.
- **Intelligence:** Per-module, sharing the Certainty Engine.
- **Trust:** Coherent shell prevents "collection of capabilities" feel.
- **Durability:** High for power users; risk of sprawl for casual users.
- **Global fit:** This is the structure that lets §12's persona/market extension happen without scope explosion.
- **Premium mechanism:** Grows with the user; the expansion architecture itself.
- **Risks/failure modes:** Highest scope/complexity risk; can become the §18 trap (building modules before validating demand); external over-claim risk.
- **Competitive reference:** Bonsai's all-in-one, but clarity-core-first and evidence-gated.

### 9.6 Required-archetype coverage check
- Quietly intelligent / context-responsive → **A** ✓
- Beyond dashboard-and-cards → **B** ✓
- Maximum daily-use durability → **C** ✓
- Challenges traditional finance UI → **D** ✓
- (Bonus) OS-scale / expansion architecture → **E** ✓

---

## 10. Premium & Anti-Boredom Mechanisms

**Premium (mechanism, not adjective):**
1. **Time-to-trusted-number < 1s** — speed as the dominant premium signal (Master Plan §3.1). *(Design target; not yet measured against global users.)*
2. **Typographic authority** — 64pt mono hero, deliberate scale contrast; restraint signals confidence. **[HYPOTHESIS]** that non-BD users read typographic restraint as authority rather than austerity (untested outside BD).
3. **Show-the-work** — calculation trace = "spreadsheet trust" transfer.
4. **Explainable adaptivity** — the app anticipates and *says why*. **[HYPOTHESIS]** that adaptivity builds rather than erodes trust (gated: §16.2).
5. **Cross-currency exactness** — correct lakh/crore *and* Western grouping, correct symbols, no rounding lies.

**Anti-boredom (durability over 500+ sessions):**
1. **Stable core, variable periphery** — home layout fixed; Next-Best-Action + timeline content change with data.
2. **State-responsive, not timer-responsive** — UI changes when *your money* changes, never on a loop.
3. **Meaningful variation** — different financial states surface different (explained) guidance.
4. **Progressive disclosure earned** — depth on interaction, never imposed.
5. **No gamification** — financial clarity is its own reward (carried constraint).

---

## 11. Quiet-Intelligence Model

**Principle:** intelligence must *improve decisions*, never *destabilize control*.

| Quiet-intelligence capability | Mechanism | Guardrail |
|---|---|---|
| Contextual prioritization | Reorder periphery by current risk + nearest due date | Core layout never moves; change is explained |
| Time-aware focus | Surface "due in 2 days, covered" / "due in 2 days, short" | Deterministic, from Reality Ledger |
| Risk-aware surface | Density/emphasis shift in tight/at-risk states ("Sentient Design", used minimally) | Never color-only; never alarmist; reversible in settings |
| Adaptive next action | One Next-Best-Action card, context-chosen | Max one; dismissible; never a nag |
| Explanation-on-demand | Tap any number/insight → trace/why | Always available; never hidden |
| Scenario awareness | "What if this is late?" peek | User-initiated; clearly hypothetical |
| Uncertainty communication | Confidence bands on projected money | Pessimistic-by-default |
| Anomaly detection | Flag unusual entry/duplicate | Suggest, never auto-change financial data |

**Explicitly forbidden** (carried from kill list + founder mandate): chatbot-first UX, opaque AI calculations, unexplained recommendations, manipulative nudges, random UI changes, loss of user control, AI "financial advice" copy.

---

## 12. Global Localization Architecture

### 12.1 The seams to cut (from §2/§3 evidence)
1. **Currency:** `NumberFormatter` is BDT/USD-hardcoded. → Introduce a **currency-agnostic money/format layer** backed by `intl.NumberFormat` (already a dependency), with a **currency registry** (symbol, decimal places, grouping style: Western vs South-Asian) and **per-locale** formatting. Preserve lakh/crore for relevant locales; add Western grouping; make it data-driven, not branched-by-currency.
2. **Language:** ARB infra exists; en/bn key parity complete (320/320); no languages beyond en/bn. → Structure ARB for **N languages**; validate bn linguistic/layout quality (separate from key presence); enforce "no hardcoded strings in `build()`" lint (already begun).
3. **RTL:** none today. → Adopt `Directionality`/logical insets everywhere; **Money Timeline (B) must define temporal inversion for RTL**; audit every custom widget for directionality.
4. **Fonts/scripts:** Inter/JetBrains Mono/Hind Siliguri only. → Define a **script→font strategy** (Latin, Bengali now; Arabic/Devanagari/CJK as markets unlock) with bundle-size tiers.
5. **Terminology:** place-specific copy. → **Config-driven product vocabulary** (e.g., source labels, tax/reserve terms) per market; globally-neutral defaults.
6. **Pipeline / tax / reserve concepts:** hardcoded. → **Configurable income states + obligation/reserve models** per market/persona (§17).
7. **Dates/numbers:** → locale-aware via `intl`.

### 12.2 Architecture principle
**One screen architecture, many configurations.** No per-country screen forks. A market = a **configuration bundle** (locale + currency rules + terminology + pipeline states + reserve model + font set + capability defaults). The core experience and design system are constant; the *configuration* varies. This is the only way to scale countries without duplicating UI.

### 12.3 Identity discipline
Helm's identity comes from the **financial model + experience intelligence**, not any one country's decoration. Bangladesh becomes **one configuration**, not the product identity — and is **not erased** (it remains a first-class, fully-supported market).

---

## 13. Constraint-Defeating Strategies

For each constraint: classify and engineer around it.

| Constraint | Classification | Strategy |
|---|---|---|
| Budget Android (Samsung A14-class) GPU | **Feasible now** | Keep zero-BackdropFilter, solid-color, ease-out discipline (already enforced). Capability tiers (§23): flagship gets subtle motion; budget gets instant. |
| Money Timeline custom canvas perf | **Risky / feasible with architecture** | Prototype on-device first; rasterize; virtualize time windows; provide a **list fallback** on low tier. **Falsification gate** (§16.1). |
| RTL + temporal UI | **Feasible with architecture** | Logical directionality from day one; timeline defines mirrored mode. |
| Multi-script fonts vs bundle size | **Feasible now** | Per-market font bundles; lazy script loading; CDN later. |
| Quiet intelligence without instability | **Feasible with architecture** | Stable-core/variable-periphery rule; every change explained; user toggle. |
| Multi-currency complexity for new users | **Feasible now** | Progressive disclosure; default to user's primary currency; advanced multi-currency opt-in. |
| Persona breadth vs scope | **Feasible with architecture** | Composable shell (E) + evidence-gated module unlock (§21). |
| Offline-first vs global sync | **Feasible later** | Keep offline-first core; background sync stays deferred (carried constraint). |
| Solo-founder bandwidth | **The real binding constraint** | §27/§28 — wedge discipline + reversible slices + no module before demand. |

**Honest "not now" list:** account aggregation (Plaid-style) outside US/EU = *feasible later, not now*; live FX API = *validate-first*; full per-persona workflows = *evidence-gated*; CJK/Arabic markets = *feasible later* once Latin+Bengali global core ships.

---

## 14. Comparative Decision Framework (falsification-first)

### 14.1 Criteria, re-weighted for the global pivot
Weights shifted from the prior (BD-only) matrix to reflect global ambition + execution reality.

| # | Criterion | Weight | Why |
|---|---|---|---|
| 1 | Proprietary-model strength (defensibility) | 14% | The moat is the model |
| 2 | Financial trust / explainability | 13% | Category-table-stakes + our edge |
| 3 | Daily-use durability | 12% | 500+ session survival |
| 4 | Execution feasibility (reuses in-flight work / solo founder) | 12% | §18 risk is binding |
| 5 | Global/multi-market scalability | 11% | The whole thesis |
| 6 | User comprehension (incl. low-literacy) | 9% | Adoption gate |
| 7 | Differentiation / category-defining potential | 8% | Avoid "another finance app" |
| 8 | Emotional safety (anxiety reduction) | 7% | Core promise |
| 9 | Performance on budget devices | 6% | Emerging-market reach |
| 10 | Quiet-intelligence fit | 4% | Future-aligned, not trend-chasing |
| 11 | Accessibility | 2% | Floor, not differentiator |
| 12 | Trend-expiration risk | 2% | 12–24 mo relevance |

### 14.2 Scoring (1–10), with anti-confirmation discipline
Scores assigned **before** summing, then sums reported without adjustment. The synthesis is *not* a column — it is evaluated separately in §15 precisely so it cannot be smuggled to victory here.

| Criterion (wt) | A Certainty Engine | B Money Timeline | C Operator's Ledger | D Decision Surface | E Composable Workspace |
|---|---|---|---|---|---|
| Proprietary model (14) | 9 | 8 | 6 | 8 | 7 |
| Trust/explainability (13) | 8 | 7 | 9 | 6 | 7 |
| Durability (12) | 7 | 6 | 9 | 5 | 7 |
| Execution feasibility (12) | 6 | 4 | 9 | 5 | 5 |
| Global scalability (11) | 8 | 7 | 8 | 8 | 8 |
| Comprehension (9) | 7 | 5 | 9 | 6 | 6 |
| Differentiation (8) | 7 | 9 | 4 | 10 | 7 |
| Emotional safety (7) | 8 | 6 | 9 | 5 | 6 |
| Budget perf (6) | 7 | 3 | 9 | 7 | 7 |
| Quiet-intel fit (4) | 10 | 7 | 6 | 8 | 7 |
| Accessibility (2) | 7 | 4 | 9 | 5 | 7 |
| Trend risk (2) | 7 | 6 | 9 | 5 | 7 |

### 14.3 Weighted totals
*(Computed from the §14.2 matrix; verify by re-summing — the numbers are deliberately auditable.)*

| Future | Weighted score | Rank |
|---|---|---|
| **C — Operator's Ledger** | **7.95** | 1 |
| **A — Certainty Engine** | **7.59** | 2 |
| **E — Composable Workspace** | **6.71** | 3 |
| **D — Decision Surface** | **6.61** | 4 |
| **B — Money Timeline** | **6.25** | 5 |

*(C leads A by 0.36 — close, not decisive; do not over-trust the decimal. The interesting result is that the two execution-safe, durability-strong options (C, A) top the table, while the two boldest reframes (D, B) trail on feasibility/comprehension/perf — which is exactly why the synthesis pairs A+C as core and defers B, and why §16 tests whether that caution is wrong.)*

### 14.4 Falsification analysis (per future)
For each: **conditions to outperform the synthesis · required assumptions · missing evidence · invalidating risks · switch-trigger.**

**A — Certainty Engine**
- *Outperforms synthesis if:* adaptive intelligence tests as *trust-building* (not spooky) AND explanation copy scales across locales cheaply.
- *Assumes:* users want anticipation; deterministic forecast is accurate enough to trust.
- *Missing evidence:* do users trust an app that reorders itself? (untested)
- *Invalidating risk:* adaptivity feels unstable → trust loss.
- *Switch-trigger:* if comprehension test shows adaptive layout *reduces* trust vs static, demote A's adaptivity to periphery-only (which *is* the synthesis).

**B — Money Timeline**
- *Outperforms synthesis if:* time-scrub tests as the single most valuable feature AND budget-device perf clears 60fps with a usable fallback.
- *Assumes:* users think temporally; timelines are comprehensible to the mass wedge.
- *Missing evidence:* comprehension among low-literacy / mobile-first users; on-device perf.
- *Invalidating risk:* confusion + perf failure + RTL cost.
- *Switch-trigger:* if scrub prototype delights ≥ target in comprehension test, **promote B from "later power surface" to core** (overturns synthesis).

**C — Operator's Ledger**
- *Outperforms synthesis if:* differentiation turns out not to matter (trust+speed win) AND intelligence adds little measured value.
- *Assumes:* "premium finance app" is enough; the moat is logic not experience.
- *Missing evidence:* whether a static ledger retains as well as an intelligent one.
- *Invalidating risk:* indistinguishable from competitors → no pull.
- *Switch-trigger:* if intelligence (A) shows no retention lift in beta, collapse synthesis → pure C (cheaper).

**D — Decision Surface**
- *Outperforms synthesis if:* a decision-first home tests dramatically higher on comprehension AND avoids assistant-drift.
- *Assumes:* users prefer answers to ledgers; trust survives data being backstage.
- *Missing evidence:* whether hiding the ledger destroys or builds trust.
- *Invalidating risk:* black-box feeling; low-literacy confusion; kill-listed assistant drift.
- *Switch-trigger:* if decision-first wins comprehension *and* trust head-to-head vs ledger, adopt D's home as the synthesis's primary surface.

**E — Composable Workspace**
- *Outperforms synthesis if:* early users demand multiple personas/modules at once (validated), making modularity core not deferred.
- *Assumes:* persona demand arrives fast; modularity doesn't bloat the core.
- *Missing evidence:* real multi-persona demand (none yet — conviction only).
- *Invalidating risk:* scope explosion / §18 trap; external over-claim.
- *Switch-trigger:* keep E as *internal architecture* regardless; only elevate modules when a specific module clears its demand gate (§21).

---

## 15. Strongest Candidate · Challenger · Contrarian

### 15.1 Strongest candidate (leading hypothesis — to be falsified, not assumed)
**The synthesis:** **Certainty Engine (A)** intelligence + proprietary model, **rendered through the Operator's Ledger (C)** for durability and execution reuse, behind a **Composable Workspace (E) internal architecture** for evidence-gated expansion, with **Money Timeline (B)** evaluated as a later power surface.
- *Why it leads:* it tops the two highest-weighted clusters (model + trust + durability via C; defensibility + quiet-intelligence via A), reuses ~80% of in-flight work, and is the only option that operationalizes the founder's "architecture-not-scope" doctrine.
- *It is NOT pre-confirmed:* §14.4 lists exactly what would overturn it.

### 15.2 Strongest challenger
**Money Timeline as core (B).** It most boldly attacks the admitted incumbent gap ("will I be okay on date X"). It wins if the scrub prototype proves both *delightful* and *performant* on budget devices. It loses on execution feasibility, comprehension, and perf risk — all *testable now* before commitment.

### 15.3 Bold contrarian
**Decision Surface (D).** Most category-defining; could make "what a finance app is" obsolete. Highest risk (assistant drift, hidden-ledger trust loss). Worth a *cheap comprehension probe* even if not chosen — the upside is asymmetric. **D is not an arm of Experiment 16.1**; it is deferred to the separate §16.7 candidate.

### 15.4 Conditions under which each wins (summary)
- **Synthesis** wins if intelligence tests as trust-building *and* timeline isn't decisively better as core.
- **B** wins if time-scrub is the killer feature and perf clears.
- **D** wins if decision-first beats ledger on comprehension *and* trust.
- **C-only** wins if intelligence shows no retention lift (cheapest fallback).
- **E** never wins as external category; it wins *internally* as the expansion chassis.

### 15.5 Explicit recommendation (the 7-part call the founder required)
1. **Recommended primary experience system:** the **synthesis** (A-intelligence × C-rendering × E-architecture), with B deferred.
2. **Strongest challenger:** **Money Timeline (B)** as core.
3. **Decisive reasons:** highest defensibility+trust+durability, maximal reuse of the in-flight migration (lowest execution risk under §18), and the only option that turns global ambition into configurable architecture rather than scope.
4. **Assumptions it depends on — all [HYPOTHESIS], none yet Helm-user-evidenced:** (a) quiet adaptivity builds rather than erodes trust (gated: §16.2); (b) the existing money-truth model generalizes cleanly to multi-currency (gated: §16.3); (c) the wedge persona (cross-border/irregular-income independents) exists at scale outside BD (gated: §16.4).
5. **Evidence still required:** comprehension of adaptive vs static UI; multi-currency S2S comprehension; real non-BD demand; on-device perf of any temporal surface.
6. **Founder decision that must be made:** ratify the synthesis as leading direction **and** authorize the first reversible experiment **without** authorizing module/persona expansion yet.
7. **First reversible experiment:** the **Temporal Safe-to-Spend comparative falsification** (§16.1; committed protocol `3081bfd`, `docs/validation/EXPERIMENT_16_1_TEMPORAL_S2S_PROTOCOL.md`) — throwaway low-fi, no production code — comparing **Variant A (Operator's Ledger Baseline) · Variant B (Money Timeline as Primary) · Variant C (Synthesis)** across 3 isomorphic scenarios with **12 completed participants** (9 = exploratory fallback only). It can *falsify the synthesis* (promote the timeline to primary, keep it secondary, remove it, or surface a model-level failure) before any major build. Decision Surface (D) is **not** in this experiment — it is deferred to §16.7.

---

## 16. Validation Experiments (reversible, evidence-gating)

All are cheap, reversible, and **gate** the corresponding build. None requires production changes.

| # | Experiment | Tests / could falsify | Method | Pass signal |
|---|---|---|---|---|
| 16.1 | **Temporal S2S comparative falsification** (committed protocol `3081bfd`, `docs/validation/EXPERIMENT_16_1_TEMPORAL_S2S_PROTOCOL.md`) | Where the Money Timeline belongs: secondary (synthesis) / primary / removed / model-level failure | **3 arms — Variant A Operator's Ledger Baseline · Variant B Money Timeline as Primary · Variant C Synthesis (ledger primary + timeline contextual power surface)**; 3 isomorphic scenarios; **12 completed participants** (decision cohort; **9 = exploratory fallback only, cannot authorize primary-surface promotion or irreversible model replacement**) | Per committed protocol's directional heuristics (§13): 9/12 current-S2S floor; 9/12 money-state-distinction floor; ≥2-participant temporal improvement (or ~20% paired median time) with ≤1 added current-state failure; preference subordinate to comprehension/explanation/trust |
| 16.2 | **Adaptive-vs-static trust test** | A's core assumption (adaptivity builds trust) | A/B two prototypes; measure trust + "did it feel in control" | Adaptive ≥ static on trust, no control loss |
| 16.3 | **Multi-currency S2S comprehension** | Assumption (b): model generalizes | Prototype with USD+EUR+local pending entries | ≥80% understand cross-currency S2S |
| 16.4 | **Non-BD demand probe** | Assumption (c): global wedge exists | Landing test + interviews in 2 non-BD markets | Qualified pain confirmed in ≥2 markets |
| 16.5 | **External category/copy comprehension** | §4.2 positioning | 5-second test of 3 taglines (no "OS") | One line ≥80% "I get what this is" |
| 16.6 | **Budget-device temporal perf spike** | B/C-feasibility | On-device Flutter spike of timeline canvas | 60fps or acceptable list fallback |

**Rule:** no major implementation of B, D, or any persona module before its gating experiment passes.

### 16.7 Deferred candidate — Decision Surface First-Understanding Probe

> **Numbering note:** the founder's provisional name for this candidate was "Experiment 16.2." It is filed here as **§16.7** to avoid colliding with the already-defined §16.2 (adaptive-vs-static) and §16.3 (multi-currency), which the **committed** protocol `3081bfd` cross-references. Renumbering those would break the committed child.

Decision Surface (Future **D**) was **removed from Experiment 16.1** — that study compares Variants A/B/C only (Operator's Ledger / Money Timeline primary / Synthesis) and does not test a decision-first home. D is **deferred** to this separate, later candidate. This section documents the candidate only; **it is not a protocol.**

- **Question it would test:** does organizing the home around a **decision** ("can I spend X?" → answer → why) improve *immediate* first-understanding of what is safe to spend, versus a conventional financial-overview home — without assistant-drift or loss of the ledger trust some users need to see?
- **Why still strategically relevant:** D is the most category-defining reframe (§9.4, §15.3); its upside is asymmetric and worth a cheap probe even though it is not the leading direction. **[HYPOTHESIS]** — rests on conviction and competitor-adjacency, not Helm user evidence.
- **Evidence needed before promoting it:** Experiment 16.1 must conclude first; then a standalone first-understanding probe must show decision-first **beats** a conventional overview on immediate comprehension **and** trust, with no assistant-drift and no hidden-ledger trust loss.
- **Sequencing:** **deferred until after Experiment 16.1.** Runs only if 16.1's outcome leaves the primary-surface question open in a way a decision-first home could resolve.
- **Authorization:** **none.** No protocol, prototype, recruitment, pilot, or execution is authorized by this blueprint. Writing the full §16.7 protocol is itself a separate, later founder authorization.

---

## 17. Future-State Experience Architecture

```
                    ┌─────────────────────────────────────────────┐
                    │            CONFIGURATION BUNDLE              │
                    │  locale · currency rules · terminology ·     │
                    │  pipeline states · reserve model · fonts ·   │
                    │  capability defaults   (per market/persona)  │
                    └───────────────────────┬─────────────────────┘
                                            │ configures
  ┌──────────────┐   ┌──────────────────────▼──────────────────────┐
  │ REALITY      │   │            EXPERIENCE SHELL                  │
  │ LEDGER       │──▶│  Operator's Ledger core (durable, global)    │
  │ state×timing │   │  + quiet-intelligence periphery (Certainty)  │
  │ ×confidence  │   │  + [later] Money Timeline power surface       │
  └──────┬───────┘   │  + composable module slots (evidence-gated)  │
         │           └───────────────────────┬──────────────────────┘
         ▼                                    │ renders on
  ┌──────────────┐                ┌───────────▼───────────┐
  │ CERTAINTY    │  computes S2S  │  GLOBAL DESIGN SYSTEM  │
  │ ENGINE       │───────────────▶│  (extended Warm Ledger │
  │ (explainable)│  (never stored)│   + Native Ground)     │
  └──────────────┘                └───────────────────────┘
```

- **Persona extension points** are *stubbed now, unlocked by evidence*: client view, invoice module, tax-reserve module, multi-entity, agency roles. None ship complete workflows in the next release.
- **Configurable pipeline states** replace hardcoded `expected/pending/received`.
- **Configurable obligation/reserve concepts** replace BD-specific tax framing.

---

## 18. Complete UI/UX Migration Strategy

**Principle:** extend, don't rewrite. Keep the app releasable and financially correct at every boundary. No big-bang. No two visual systems alive (already resolved). Never touch domain/data/calculation layers during UI work (carried R1 mitigation).

**Three migration streams, sequenced:**
1. **Finish in-flight (Phase 6 Hardening)** — complete the Warm Ledger + Native Ground migration as-is (dark mode, a11y, Bangla overflow, golden suite, perf profile). *Releasable wedge stays on track.*
2. **Global foundation slices** — introduce configurability where it *materially affects the core experience* (currency-agnostic money/format, locale-aware dates/numbers, neutral terminology, RTL-readiness, configurable pipeline states, capability tiers, language-expansion readiness). *No new personas, no module workflows.*
3. **Evidence-gated expansion** — only after §16 gates: persona surfaces / modules / new markets, one at a time.

---

## 19. Design-System Migration Architecture

Extend the existing token system (`HelmColors`/`HelmTypography`/`HelmSpacing`/`HelmMotion`) into a **global design system**:

| Layer | Today | Extension |
|---|---|---|
| Color | 13 tokens, light+dark | Keep; add per-market theme overrides via config (warmth, state hues tuned per display gamut). No new architecture. |
| Typography | Inter/JetBrains Mono/Hind Siliguri | Add **script→font registry**; promote per-locale type selection (begun via `HelmLocaleText`). |
| Money format | hand-rolled BDT/USD | Replace with **currency registry + `intl`-backed locale-aware formatter** (currency-agnostic). |
| Direction | LTR-only | Logical insets + `Directionality`; RTL audit of every custom widget. |
| Motion | ease-out only | Keep; add **capability tiers** (flagship subtle / budget instant). |
| Spacing | 8pt grid | Keep; allow Bangla/long-language vertical buffers. |

**Decision 037 captured here:** Signal Deck (dark-first/glass/spring) stays rejected for budget-Android + light-first trust + motion policy; Warm Ledger + Native Ground **extended to global** is the system of record.

---

## 20. Component-System Plan

| Action | Components | Rationale |
|---|---|---|
| **Retain (well-built)** | HelmAmount, HelmLedgerRail, HelmRealityStack, HelmCalculationTrace, HelmTrustStrip, HelmLedgerCard, HelmAuditCard, AppButton, NextBestActionCard | Verified solid; the moat surfaces |
| **Generalize for global** | HelmAmount (currency-agnostic), HelmTrustStrip (locale labels), HelmMoneySourceLabel (config sources), NumberFormatter→currency registry | Cut the BD seams |
| **Add (foundation)** | CurrencyRegistry, LocaleFormatService, MarketConfig, ScriptFontResolver, CapabilityTier provider | Configurability backbone |
| **Add (gated)** | TimelineCanvas (after 16.1/16.6), DecisionSurfaceHome (after 16.1), ModuleSlot host (after demand gate) | Evidence-first |
| **Deprecate** | legacy transaction "cash out" surface | Conflicts with category (§25) |
| **Do NOT abstract** | section widgets' ~200 LOC duplication | Carried decision: distinct semantics; premature abstraction couples concerns |

---

## 21. Phased Roadmap

| Phase | Name | Scope | Gate to enter | Releasable? |
|---|---|---|---|---|
| **P6** | Hardening (finish in-flight) | dark mode, a11y to 100%, Bangla overflow/layout validation, golden suite, perf profile (bn keys already at parity — no key work) | none (in progress) | Yes |
| **G0** | Global Foundation — Money | currency registry + `intl` formatter; HelmAmount currency-agnostic; locale dates/numbers | P6 done | Yes |
| **G1** | Global Foundation — Language & Direction | ARB for N languages; neutral terminology config; RTL-readiness; script→font registry | G0 | Yes |
| **G2** | Global Foundation — Model Config | configurable pipeline states; obligation/reserve config; capability tiers; persona extension points stubbed | G1 | Yes |
| **V1** | Intelligence Core | Certainty Engine periphery (quiet intelligence, explainable), Next-Best-Action upgrade | G2 + 16.2 pass | Yes |
| **EXP** | Evidence-gated expansion | Timeline (16.1/16.6), or Decision Surface (§16.7), or first module (demand gate), or new market (16.4) — **one at a time** | per-experiment | Yes |

**Hard rule (anti-§18):** no EXP item starts until its gating experiment passes **and** the prior shipped.

---

## 22. Verification Architecture

Carried + extended from Master Plan §14:
- **Domain integrity (R1):** never modify `domain/`/`data/`/S2S providers during UI work; S2S calculator tests must pass unchanged; calculation trace asserted input→output.
- **Golden tests:** extend the existing suite to multi-currency, multi-locale, RTL, each financial state.
- **Localization tests:** every ARB key renders in every supported language; no overflow; locale-aware number/date.
- **Currency tests:** currency registry round-trips; grouping correct per locale (lakh/crore AND Western); symbol/decimal correctness.
- **A11y tests:** Semantics on every interactive element; no color-only state; reduced-motion respected.
- **Perf tests:** on-device frame budget (esp. any temporal surface) — gating for B/C.
- **Financial-state scenario matrix:** safe/tight/at-risk/no-data × locales × currencies.

---

## 23. Performance Strategy

- **Maintain the existing advantage:** zero BackdropFilter, solid colors, ease-out-only — verified clean.
- **Capability tiers:** detect device class → flagship (subtle motion, richer surfaces) / standard / budget (instant, list fallbacks). Budget Android (Samsung A14-class) is the reference floor.
- **Temporal surface (if B):** prototype on-device first; virtualize time windows; rasterize; **mandatory list fallback** on budget tier. Perf failure here falsifies B-as-core (§16.6).
- **Time-to-trusted-number < 1s / S2S-visible < 2s** as a tracked budget (existing analytics).
- **Offline-first preserved;** global sync stays deferred.

---

## 24. Accessibility Strategy

- WCAG AA contrast (already met by tokens); verify per market theme.
- Semantics on 100% of interactive elements (Phase 6 closes the last gaps).
- No color-only state (Ledger Rail always carries a text label).
- Reduced-motion honored everywhere (incl. any new adaptive/temporal motion).
- **Global a11y:** RTL screen-reader order; Bangla/other-script labels; numerals readable on low-color TFT; touch targets ≥44pt with longer-language labels.
- Adaptive intelligence must be **a11y-equivalent** — explanations available to screen readers, not just visually.

---

## 25. Legacy Deprecation Strategy

| Legacy | Status | Action |
|---|---|---|
| `AppColors`/`getFontStyle`/`AppThemeData` | Already removed | Done |
| Signal Deck direction | Rolled back | Decision 037 marks superseded |
| Transaction "cash out" surface | Active legacy | Deprecate after confirming no S2S dependency; replace with pipeline-native flows; remove route once unreferenced |
| BD-only NumberFormatter | Active | Replace with currency registry (G0); keep BDT behavior as one config |
| pubspec description / narrow metadata | Active | Update after external category decided (§4.2/§16.5) |
| Final Product Doctrine | Superseded | Banner + retain for history (§0.1) |

**Rule:** never leave two systems alive indefinitely; deprecate on a dated plan, not "someday."

---

## 26. Release & Rollback Strategy

- **Releasable at every phase boundary** (P6, G0–G2, V1, each EXP).
- **Per-commit/per-screen reverts;** each global-foundation slice is independent.
- **Feature flags** for V1 intelligence and any EXP surface → instant disable without revert.
- **No DB schema changes** for foundation phases (config is additive); any later schema change is event-sourced + migration-tested.
- **Beta-gated EXP:** new surfaces ship behind beta cohort before general release.
- **Rollback never touches financial data** (UI/config only).

---

## 27. Unresolved Founder Decisions

| # | Decision | Why it matters | Default if unanswered |
|---|---|---|---|
| FD-1 | Ratify the synthesis as **leading** direction (not locked)? | Gates everything | Treat as leading; proceed to 16.1 |
| FD-2 | Which markets for the **non-BD demand probe** (16.4)? | Shapes wedge | Pick 2 high-freelancer, multi-currency markets |
| FD-3 | External **category/positioning** — run 16.5 before any copy change? | Avoid premature lock | Yes; keep "OS" internal-only |
| FD-4 | **§18 bandwidth:** which parallel project pauses to fund this? | The real binding risk | Unresolved — founder must answer before V1 |
| FD-5 | Bangla copy completion + future-language authoring ownership | bn gap + N-language plan | Founder/native author + review |
| FD-6 | Deprecate the transaction "cash out" surface now or post-foundation? | Category coherence | Post-foundation, dated |
| FD-7 | Does Bangladesh remain a **first-class supported market** post-pivot? (Recommend: yes) | Don't erase BD | Yes — BD = one config, fully supported |

---

## 28. Recommended Next Authorised Action

**The path to falsifying the synthesis runs through Experiment 16.1, but the authorizations are staged and separate.** The committed protocol (`3081bfd`, `docs/validation/EXPERIMENT_16_1_TEMPORAL_S2S_PROTOCOL.md`) compares **Variant A (Operator's Ledger Baseline) · Variant B (Money Timeline as Primary) · Variant C (Synthesis)** across 3 isomorphic scenarios with **12 completed participants** (9 = exploratory fallback only, incapable of authorizing primary-surface promotion or irreversible model replacement). Decision Surface (D) is **not** an arm — it is deferred to §16.7.

**Staged authorizations (each is separate; this blueprint commit authorizes NONE of them):**
1. prototype specification
2. disposable prototype creation
3. two-person pilot
4. protocol revision if required
5. main 12-person study
6. evidence review
7. founder product-direction decision
8. controlled implementation planning

**Why staged, nothing bigger:**
- Experiment 16.1 directly tests the leading hypothesis (synthesis) against the strongest challenger (Money Timeline as primary, Variant B) — comprehension-first, preference subordinate.
- Each stage is cheap and reversible and produces evidence before the next is authorized.
- It honors the superseded Doctrine's surviving discipline (validate before build) and the §18 warning (this blueprint must become a small shipped thing, not a fourth unfinished system).

**Explicitly NOT authorized by this blueprint:** any of the eight staged steps above, production redesign, persona modules, new-market builds, external copy changes, or pausing Phase 6 — until their gating authorizations/experiments pass.

**In parallel, zero-risk now:** finish **Phase 6 Hardening** (already in flight) — dark mode, a11y, Bangla overflow/layout validation, golden suite, perf profile. (bn keys are already at parity; no key-completion work remains.)

---

## Appendix A — Source Citations
- Gig market size & growth: [demandsage](https://www.demandsage.com/gig-economy-statistics/), [interviewguys](https://blog.theinterviewguys.com/the-state-of-the-gig-economy-in-2025/), [Upwork](https://www.upwork.com/resources/gig-economy-statistics)
- Irregular-income pain (academic + survey): [IJRPR](https://ijrpr.com/uploads/V6ISSUE5/IJRPR45037.pdf), [freelancermap](https://www.freelancermap.com/blog/major-challenges-survey/)
- Safe-to-Spend / Simple Bank: [financebuzz](https://financebuzz.com/simple-bank-review), [androidpolice](https://www.androidpolice.com/2021/02/11/theres-no-good-replacement-for-simple/)
- Bill-Timing-Anxiety gap: [bountisphere](https://bountisphere.com/blog/monarch-copilot-simplifi-cash-flow-forecasting)
- Budgeting/forecasting apps: [engadget](https://www.engadget.com/apps/best-budgeting-apps-120036303.html), [moneywithkatie](https://moneywithkatie.com/copilot-review-a-budgeting-app-that-finally-gets-it-right/)
- Multi-currency / cross-border: [payset](https://www.payset.io/blog/payset-and-the-payment-landscape-airwallex-revolut-wise-bunq-payoneer-alternatives/), [nathanojaokomo](https://nathanojaokomo.com/blog/payoneer-alternatives)
- Freelancer banking: [getholdings](https://getholdings.com/compare/best-banks-freelancers), [northone (Lili)](https://www.northone.com/blog/business-banking/lili-business-banking-review)
- Invoicing/accounting: [jobbers](https://www.jobbers.io/freshbooks-vs-quickbooks-vs-wave-vs-bonsai-true-cost-comparison-for-freelancers/)
- AI-native / ambient fintech UX: [brainhub](https://brainhub.eu/library/fintech-ux-design-trends), [fuselabcreative](https://fuselabcreative.com/fintech-ux-design-guide-2026-user-experience/)

## Appendix B — Internal Evidence Index
- Superseded canon: `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md`
- Prior visual exploration (5 *visual* philosophies): `docs/design/HELM_UI_PHILOSOPHY_EXPLORATION.md`
- In-flight migration (Phases 1–5 + golden done; P6 outstanding): `docs/design/HELM_FULL_UI_UX_MIGRATION_MASTER_PLAN.md`
- Decision log (011 "drop OS", 016 doctrine, 036 Signal Deck): `docs/tracking/DECISION_LOG.md`
- Code seams: `lib/core/utils/number_formatter.dart` (BDT/USD hardcoded), `pubspec.yaml` (`intl` present; BD description), `lib/l10n/*.arb` (320 en / 320 bn — key parity complete), `lib/config/router/*` (19 GoRoute / 21 route-name constants, 3-tab shell)

---

*End of blueprint. Stage 1–3 complete. Stage 4 (implementation) requires separate per-slice authorization, starting with Experiment 16.1.*
