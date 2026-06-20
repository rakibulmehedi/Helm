# Experiment 16.1 — Temporal Safe-to-Spend Comparative Falsification Protocol

> **Status:** DRAFT (revision 3) for founder review. Not authorized to run.
> **Parent:** `docs/strategy/HELM_GLOBAL_PRODUCT_EXPERIENCE_AND_UI_MIGRATION_BLUEPRINT.md` §16.1, §15.5, §14.4
> **Type:** Comparative falsification study (3 variants × 3 isomorphic scenarios), low-fidelity, directional discovery.
> **Authorization scope:** This document is the protocol only. It does **not** authorize building prototypes, recruiting participants, running the pilot, or running sessions. Each requires separate founder authorization.

---

## 0. Reading Note — Variant Naming (read first to avoid confusion)

This protocol uses **Variant A/B/C** as the founder specified. The blueprint uses **Future A/B/C/D/E**. They are **not** the same letters. Use this mapping throughout:

| This protocol | What it is | Blueprint future |
|---|---|---|
| **Variant A — Operator's Ledger Baseline** | Durable ledger surface; current leading UI foundation | Future **C** (Operator's Ledger) |
| **Variant B — Money Timeline as Primary** | Temporal canvas is the dominant home | Future **B** (Money Timeline / River) |
| **Variant C — Synthesis** | Operator's Ledger primary + Money Timeline as contextual power surface | Synthesis (A-intelligence × C-rendering) with B as power surface |

The shared substrate under all three variants is the **Reality Ledger** (state × timing × confidence) feeding the **Certainty Engine** (deterministic, explainable Safe-to-Spend). The variants differ only in **how that same truth is surfaced**, not in the underlying numbers. See blueprint §8.

---

## 1. Experiment Thesis

The blueprint's leading hypothesis (the synthesis) renders the Certainty Engine through a durable Operator's Ledger and treats the Money Timeline as a **later, secondary power surface** rather than the primary home. That placement is a **conviction, not evidence** (blueprint §14.4-B, §15.5). The single highest-leverage unknown is therefore not "can users read a timeline?" but:

> **Where does a temporal view of money belong in Helm's experience architecture — backstage power surface, primary home, or removed entirely — when judged by comprehension of forward, day-specific Safe-to-Spend rather than by aesthetic preference?**

This experiment answers that question by putting **equivalent financial realities** in front of users through three different surfacings and measuring which produces correct, confident, low-effort understanding of "what is safe to spend now" and "will I be okay on date X." The result either keeps the timeline secondary, promotes it to primary, removes/defers it, or — if all three fail — challenges the synthesis at the mental-model level (not merely the UI).

---

## 2. Hypotheses

Stated so they can be falsified, not confirmed.

- **H1 (synthesis-favoring):** Variant C improves future-date reasoning over Variant A **while preserving or improving** current-state comprehension, and Variant B adds no meaningful advantage over C. → *Keep timeline secondary.*
- **H2 (challenger):** Variant B outperforms both A and C on future-date reasoning, current-state comprehension, trust, and task efficiency, **without** navigation confusion or cognitive overload. → *Reopen the primary-surface decision.*
- **H3 (null/contrarian):** Neither B nor C reaches the meaningful-improvement threshold over A, or timeline interaction creates confusion disproportionate to its value. → *Defer/remove timeline; strengthen the Certainty Engine through the Operator's Ledger.*
- **H4 (model-level failure):** Users fail to understand the Reality Ledger, certainty states, or the Safe-to-Spend calculation **across all three variants**. → *The product mental model — not the UI direction — requires revision.*

H3 (null) and H4 (model-level failure) are **first-class outcomes**, not failures of the study. A clean H3 or H4 result is high-value evidence.

---

## 3. Falsification Criteria

What would prove the synthesis's current placement of the timeline **wrong** (thresholds operationalized in §13):

- **Falsifies "timeline is secondary" → promote to primary:** Variant B wins on future-date reasoning **and** current-state comprehension **and** trust **and** task efficiency, with no rise in navigation errors / cognitive load, and the advantage appears **across participants** (not one or two outliers).
- **Falsifies "timeline adds value" → remove/defer:** Variant C shows no measurable lift over Variant A on future-date reasoning, **or** the timeline interaction in B/C produces confusion disproportionate to any comprehension gain.
- **Falsifies the synthesis itself → challenge the model:** Across **all three** variants, participants repeatedly fail to distinguish cleared from uncertain/in-transit money, explain why Safe-to-Spend changes, or identify what is safe to spend now — indicating the failure is the **mental model**, not the rendering.

Thresholds are pre-registered in §13 and **not** revised after seeing results.

---

## 4. The Three Variant Definitions

All three render the **same kind** of Reality Ledger and the same Certainty Engine outputs (§5). None may receive stronger copy, visual polish, onboarding, or interaction affordance than the others (§11). Each is a throwaway low-fidelity clickable artifact.

### Variant A — Operator's Ledger Baseline
The durable ledger-based experience representing the current leading UI foundation (extended Warm Ledger). A single stable home surface showing, top to bottom:
- **Current Safe-to-Spend** (the hero number) with its currency.
- **Received & usable money** (cleared).
- **Uncertain / in-transit income** (in-transit vs pending/expected — each visibly distinguished by **state**, not probability).
- **Upcoming obligations** (with due dates).
- **Calculation transparency** — a tap-to-expand "show the math" trace.

No timeline. Future-date questions are answered (if at all) by the user reasoning over the static lists. This is the control.

### Variant B — Money Timeline as Primary
The temporal surface **is** the dominant home. A horizontal time canvas with "now" as anchor; income flows toward now, obligations sit on their due dates, and a scrub control reads the projected Safe-to-Spend for any future date (confidence-banded). Tapping any event inspects it (state, amount, confidence, date). The ledger lists are demoted to a secondary, reachable view. Current Safe-to-Spend is read at the "now" position.

### Variant C — Synthesis
The Operator's Ledger (Variant A) remains the **stable primary surface**, opened first and unchanged in structure. The Money Timeline is available as a **contextual future-view / power surface** invoked when the user asks a forward question — surfaced through entry points phrased as the user's own questions:
- "Will I be okay on this date?"
- "Why will my spendable money fall?"
- "When does this pending money become usable?"
- "Which future obligation creates pressure?"

Invoking any entry point opens the same temporal view used in Variant B, scoped to the question, then returns to the ledger. The timeline is **on demand**, not the home.

---

## 5. Three Isomorphic Scenarios (one per variant per participant)

To eliminate carryover/memory contamination, **a participant never sees the same financial data twice.** Each variant is rendered with a **different** scenario (S1/S2/S3). The three scenarios are **isomorphic**: identical reasoning structure and difficulty, different surface details (currencies, amounts, dates, payment sources, labels).

### 5.1 Shared structure (identical across S1/S2/S3)
Every scenario contains exactly:
- one **cleared/usable** balance (home currency),
- one **in-transit** cross-border payment that clears early (rise driver),
- one **uncertain** payment (pending or expected) that is **excluded** from spendable,
- **two currencies of income** plus the home currency (≥2 currencies total),
- two fixed obligations (a rent-type and a small subscription),
- one **major future outflow** (the largest single obligation),
- one early date where Safe-to-Spend **rises** (in-transit clears),
- one later date where Safe-to-Spend **falls** (the major outflow enters protection),
- an exact deterministic answer key (§5.4).

### 5.2 Shared Certainty Engine rules (constant; stated so numbers are reproducible)
- **States counting toward usable money (deterministic — no probability weighting):** `cleared/usable` counts always. `in-transit` has a **processor-confirmed settlement date**: it contributes **zero** before that date and the **full stated net home-currency amount on/after** it. `pending` and `expected` are **always excluded** from spendable, shown separately as "uncertain — not yet usable." This experiment tests temporal **state** comprehension; confidence-weighted projection is a separate experiment (§5.5).
- **Safe-to-Spend on date D:** `S2S(D) = (income usable by D) − (obligations already paid by D) − (fixed obligations due within 7 days after D, reserved)`.
  - "reserved" = protected, not-yet-paid fixed obligations falling in the window `(D, D+7]`.
  - This is forward-protective and day-specific: it **rises** when income clears and **falls** as a large obligation enters the 7-day protection window.
- **FX:** each scenario fixes its rates **as of Day 0** and holds them constant for the study (FX-timing realism is out of scope here — see §5.5).
- **Trace:** every displayed number has a "show the math" breakdown.

### 5.3 Global framing discipline (no undefined "local currency")
Each scenario explicitly names its **home/operating currency**, its **income currencies**, **fixed FX rates with the as-of date**, which **states count** vs are **excluded**, all **obligation dates**, and the **reserve rule**. Number formatting is held to a single neutral convention (Western grouping) across all scenarios so this experiment isolates **temporal comprehension**, not regional formatting. (Regional formatting — lakh/crore, RTL, symbol placement — is a **separate** localization experiment; see §5.5.)

### 5.4 The three scenarios + date-by-date answer keys
Day 0 = "today." FX as of Day 0, held constant. Income pessimism applied (pending/expected excluded). Answer keys are **facilitator-only**; they must **not** appear in the participant prototype.

---

#### Scenario S1 — Home currency: **USD**
FX as of Day 0: `EUR 1 = USD 1.10`, `GBP 1 = USD 1.25`.

**Income (Reality Ledger):**
| ID | Source | Amount | In home (USD) | State | Usable on | Counted? |
|---|---|---|---|---|---|---|
| I1 | Client A milestone (paid & converted) | USD 4,500 | 4,500 | cleared/usable | now | yes |
| I2 | Client B payout (cross-border) | EUR 1,000 | 1,100 | in-transit | Day +3 (settlement confirmed) | 0 before Day +3, full on/after |
| I3 | Client C invoice (approved) | GBP 800 | 1,000 | pending | Day +9 | **excluded** (not yet usable) |

*Deterministic: I2 has a **processor-confirmed settlement date** of Day +3 — it adds nothing before, the full USD 1,100 on/after. No probability weighting. I3 is excluded by state.*

**Obligations:**
| ID | Item | Amount (USD) | Due | Type |
|---|---|---|---|---|
| O1 | Rent | 1,200 | Day +4 | fixed |
| O2 | Software subscriptions | 90 | Day +12 | fixed |
| O3 | **Quarterly tax (major outflow)** | **2,000** | **Day +14** | fixed/legal |

**Asked future date (Task 2):** Day +10.

**Answer key (USD):**
| Date | Usable by D | Paid by D | Reserved (D,D+7] | **S2S** | Event responsible | Correct next action |
|---|---|---|---|---|---|---|
| Day 0 | 4,500 | 0 | O1 1,200 | **3,300** | baseline | Don't spend to balance; protect tax (O3, Day +14). |
| Day +3 (**rise**) | 5,600 | 0 | O1 1,200 | **4,400** | I2 in-transit EUR cleared (+1,100) | EUR cleared; still protect O1 then O3. |
| Day +10 (asked) | 5,600 | O1 1,200 | O2 90 + O3 2,000 | **2,310** | O3 tax now within protection window (fall onset ~Day +7) | Yes, safe on Day +10 (2,310), lower because tax is coming. |
| Day +14 (tax due) | 5,600 | O1+O2+O3 = 3,290 | 0 | **2,310** | O3 tax paid | I3 (GBP) still uncertain; don't rely on it. |

Distinct money states: cleared = I1; in-transit = I2; pending/uncertain = I3. Largest future pressure = **O3 tax (USD 2,000)**.

---

#### Scenario S2 — Home currency: **EUR**
FX as of Day 0: `USD 1 = EUR 0.90`, `CAD 1 = EUR 0.68`.

**Income:**
| ID | Source | Amount | In home (EUR) | State | Usable on | Counted? |
|---|---|---|---|---|---|---|
| I1 | Retainer (paid & converted) | EUR 3,800 | 3,800 | cleared/usable | now | yes |
| I2 | US client payout (cross-border) | USD 1,200 | 1,080 | in-transit | Day +2 (settlement confirmed) | 0 before Day +2, full on/after |
| I3 | Canadian client fee (forecast) | CAD 1,500 | 1,020 | expected | Day +10 | **excluded** (not yet usable) |

*Deterministic: I2 has a **processor-confirmed settlement date** of Day +2 — nothing before, the full EUR 1,080 on/after. No probability weighting. I3 is excluded by state.*

**Obligations:**
| ID | Item | Amount (EUR) | Due | Type |
|---|---|---|---|---|
| O1 | Rent | 1,050 | Day +5 | fixed |
| O2 | Software subscriptions | 75 | Day +11 | fixed |
| O3 | **Quarterly VAT (major outflow)** | **1,800** | **Day +15** | fixed/legal |

**Asked future date (Task 2):** Day +9.

**Answer key (EUR):**
| Date | Usable by D | Paid by D | Reserved (D,D+7] | **S2S** | Event responsible | Correct next action |
|---|---|---|---|---|---|---|
| Day 0 | 3,800 | 0 | O1 1,050 | **2,750** | baseline | Protect VAT (O3, Day +15); don't spend to balance. |
| Day +2 (**rise**) | 4,880 | 0 | O1 1,050 | **3,830** | I2 in-transit USD cleared (+1,080) | USD cleared; protect O1 then O3. |
| Day +9 (asked) | 4,880 | O1 1,050 | O2 75 + O3 1,800 | **1,955** | O3 VAT within protection window (fall onset ~Day +8) | Yes, safe on Day +9 (1,955), lower because VAT looms. |
| Day +15 (VAT due) | 4,880 | O1+O2+O3 = 2,925 | 0 | **1,955** | O3 VAT paid | I3 (CAD) is low-confidence; exclude from plans. |

Distinct states: cleared = I1; in-transit = I2; expected/uncertain = I3. Largest future pressure = **O3 VAT (EUR 1,800)**.

---

#### Scenario S3 — Home currency: **SGD**
FX as of Day 0: `AUD 1 = SGD 0.88`, `USD 1 = SGD 1.35`.

**Income:**
| ID | Source | Amount | In home (SGD) | State | Usable on | Counted? |
|---|---|---|---|---|---|---|
| I1 | Project payment (paid & converted) | SGD 6,000 | 6,000 | cleared/usable | now | yes |
| I2 | AU client payout (cross-border) | AUD 1,000 | 880 | in-transit | Day +3 (settlement confirmed) | 0 before Day +3, full on/after |
| I3 | US client invoice (approved) | USD 700 | 945 | pending | Day +8 | **excluded** (not yet usable) |

*Deterministic: I2 has a **processor-confirmed settlement date** of Day +3 — nothing before, the full SGD 880 on/after. No probability weighting. I3 is excluded by state.*

**Obligations:**
| ID | Item | Amount (SGD) | Due | Type |
|---|---|---|---|---|
| O1 | Rent | 1,500 | Day +4 | fixed |
| O2 | Software subscriptions | 60 | Day +13 | fixed |
| O3 | **Quarterly tax (major outflow)** | **2,400** | **Day +14** | fixed/legal |

**Asked future date (Task 2):** Day +10.

**Answer key (SGD):**
| Date | Usable by D | Paid by D | Reserved (D,D+7] | **S2S** | Event responsible | Correct next action |
|---|---|---|---|---|---|---|
| Day 0 | 6,000 | 0 | O1 1,500 | **4,500** | baseline | Protect tax (O3, Day +14); don't spend to balance. |
| Day +3 (**rise**) | 6,880 | 0 | O1 1,500 | **5,380** | I2 in-transit AUD cleared (+880) | AUD cleared; protect O1 then O3. |
| Day +10 (asked) | 6,880 | O1 1,500 | O2 60 + O3 2,400 | **2,920** | O3 tax within protection window (fall onset ~Day +7) | Yes, safe on Day +10 (2,920), lower because tax is coming. |
| Day +14 (tax due) | 6,880 | O1+O2+O3 = 3,960 | 0 | **2,920** | O3 tax paid | I3 (USD) still uncertain; don't rely on it. |

Distinct states: cleared = I1; in-transit = I2; pending/uncertain = I3. Largest future pressure = **O3 tax (SGD 2,400)**.

---

### 5.5 Equivalence note & out-of-scope
All three scenarios share the formula `S2S(D) = usable_by_D − paid_by_D − reserved_(D,D+7]`, one cleared + one in-transit + one excluded-uncertain income, two minor obligations + one dominant outflow, an early rise (in-transit clears) and a later fall (major outflow enters the 7-day window). Reasoning operations are identical; only labels/magnitudes/dates differ. **Scenario equivalence is itself a pilot-gate check (§12).**
**Out of scope here (separate experiments):** regional number formatting (lakh/crore, RTL, symbol placement) → a dedicated localization comprehension study; FX-timing/conversion-rate anxiety → a dedicated multi-currency experiment (blueprint §16.3).

---

## 6. Participant-Screening Criteria

Small but diverse first cohort of independent professionals. **Decision cohort = n = 12 completed** sessions (excludes the 2 pilot participants, §12). **n = 9 is an exploratory fallback only** if recruitment fails, and cannot independently authorize architecture changes (§13.8). This is **directional discovery, not market validation**.

**Must qualify (all required):** earns income independently (freelancer/contractor/consultant/creator/solo service provider); has experienced irregular or multi-timing income in the last 12 months; uses a smartphone as primary device.

**Diversity targets (spread across cohort, not per person):** ≥ 2 countries/regions (≥1 non-BD); mix of single- and multi-currency earners; mix of beginner and experienced financial-tool users; both predictable and irregular earners; spread across spreadsheet / banking-app / budgeting-app users.

**Exclude:** professional accountants/bookkeepers (over-expert); anyone who has seen prior Helm prototypes; anyone who can't complete a session in their fluent language.

**Labeling requirement:** every report states the cohort is **directional discovery**, is **not** statistically representative, and does **not** validate Helm globally.

---

## 7. Task Script (administered identically per variant)

Each participant completes the **same seven tasks** on **each variant × scenario** they see. The future date in Task 2 is the scenario's asked date (S1/S3 = Day +10; S2 = Day +9), read from the scenario card. Tasks are read verbatim; no leading hints.

1. **"How much money is safe for you to spend right now?"** (current Safe-to-Spend)
2. **"Will you be financially safe on [scenario's future date]? How do you know?"** (future-date reasoning)
3. **"Which upcoming obligation puts the most pressure on your money?"** (obligation-pressure identification)
4. **"Point to money that is definitely yours to use, versus money that is uncertain or still on its way."** (cleared vs uncertain/in-transit)
5. **"Why does your safe-to-spend amount change between now and later?"** (calculation explanation; exercises rise + fall)
6. **"What is the single most useful next thing you could do with this information?"** (next meaningful action)
7. **"How confident are you that your answers are correct?"** (confidence self-report, captured per substantive task)

After all three variants: a short **comparative debrief** (§10). Preference is captured **last** and is explicitly subordinate to comprehension (§11, §13).

---

## 8. Facilitator Script

- **Intro (verbatim):** "Thank you for helping. I'm testing some early, rough designs — not your ability. There are no wrong answers and nothing here is finished. Please think aloud: say what you see, what you expect, and what's confusing. I can't help you interpret the screen, because that's exactly what I'm trying to learn."
- **Neutrality rules:** Do not explain any screen. Do not define "Safe-to-Spend," "in-transit," "pending," or "reserve." If asked, respond: "What do *you* think it means here?" No positive/negative reaction. Never use the words "timeline," "ledger," "better," or any variant name. **Never reveal that any variant is Helm's current recommendation** — treat all three as equally provisional.
- **Per task:** read verbatim; let the participant act; capture answer, time, interactions, verbalized confusion; ask the confidence question after each substantive task.
- **On struggle:** allow up to a fixed cap (e.g., 90s); if unresolved, record "not reached" and move on — do not rescue.
- **Between variants:** neutral reset — "Here's a different rough design, with a different financial situation."
- **Close:** comparative debrief (§10); thank and end. No teaching, no reveal of correct answers during the session.

---

## 9. Measurements — Primary vs Secondary

**PRIMARY measures (decision-controlling; outweigh everything else):**
1. **Current Safe-to-Spend accuracy** (Task 1, vs §5.4 key).
2. **Future-date Safe-to-Spend accuracy** (Task 2).
3. **Money-state distinction accuracy** (Task 4 — correctly separating cleared vs uncertain/in-transit).
4. **Explanation accuracy** (Task 5 — why S2S rises and falls; correct event attribution).

**SECONDARY measures (inform, never override primary):**
- Task time (incl. time-to-first-correct on Tasks 1 & 2).
- Navigation errors.
- Unnecessary interactions (taps/scrubs beyond task need).
- Confidence calibration (self-reported confidence vs actual accuracy).
- Perceived control.
- Perceived trust.
- Cognitive-load observations (pauses, re-reads, backtracking, verbalized confusion).
- Repeated-use preference.

**Hard rule:** preference is captured **last** and **cannot overrule a comprehension failure.** A variant that is liked but misunderstood loses to a variant understood but less liked.

---

## 10. Observation Framework

- **Per-task capture sheet:** one row per (participant × variant × scenario × task): primary-accuracy code (correct/partial/incorrect/not-reached), time, interaction count, navigation errors, verbatim confusion note.
- **Think-aloud log:** verbatim quotes, especially at the moment understanding forms or fails.
- **State-discrimination matrix:** Task 4 — record which of I1/I2/I3 each participant classified correctly.
- **Comparative debrief (after all variants):** "Which made it easiest to know what's safe now? Easiest about a future date? Which would you trust? Which would you open daily?" — captured separately from per-task comprehension so preference can't contaminate accuracy data.
- **Facilitator post-session note:** one paragraph, written immediately, on where understanding broke and which variant caused it.

---

## 11. Bias Controls

- **No data reuse:** each participant sees S1/S2/S3 once each, one per variant — never the same numbers twice.
- **Scenario equivalence:** isomorphic by construction (§5); equivalence is verified in the pilot (§12) before main recruiting.
- **Variant-order counterbalancing:** within-participant comparative design with full order rotation (see §11.1). **The Operator's Ledger baseline is NOT fixed first.**
- **Variant × scenario counterbalancing:** scenarios are assigned by session **position** (1st-seen = S1, 2nd = S2, 3rd = S3) while variant order rotates fully — so across the order set each variant is paired with each scenario equally and **no variant consistently receives the easiest scenario** (they are equal anyway).
- **Parity of fidelity:** all variants share copy, type scale, color tokens, iconography, and finish. No variant gets onboarding, tooltips, animation, or affordances the others lack. A neutral reviewer signs off on parity **before** any session.
- **Facilitator neutrality:** scripted wording (§8); no variant names; no interpretation; no reveal of the current recommendation.
- **Preference firewall:** comprehension measured per task during use; preference captured only at debrief and weighted below comprehension (§13).
- **No leading language:** tasks use the user's own framing ("safe to spend," "on its way"), never Helm's internal terms ("Reality Ledger," "Certainty Engine," "Operator's Ledger").
- **Pre-registered thresholds:** all §13 heuristics fixed before sessions; not revised post-hoc.
- **Blind-ish coding:** where feasible, accuracy coding of recordings is done without the coder knowing which variant produced which clip.

### 11.1 Order-allocation method
Six within-participant orders: **ABC, ACB, BAC, BCA, CAB, CBA.**
- **n = 12 (decision cohort — required for any architecture decision):** use **all six orders twice** → each variant appears in each position (1st/2nd/3rd) exactly **4 times**; each variant pairs with each position-fixed scenario exactly 4 times. Fully balanced for order and variant×scenario.
- **n = 9 (exploratory fallback only):** balanced **3×3 Latin square** — **ABC, BCA, CAB**, each run **3 times** → each variant in each position 3 times. **Documented imbalance:** reverse orders (ACB, BAC, CBA) unobserved, so asymmetric adjacency effects are uncontrolled. An n = 9 run is exploratory and bound by §13.8.
- Allocation is assigned **before** recruiting and recorded per participant ID.

---

## 12. Pilot Gate

Before the full 9–12 cohort, run a **2-person pilot.** Its only purpose is to validate the instrument:
- task clarity (no leading or confusing wording),
- **scenario equivalence** (do S1/S2/S3 actually feel equally hard?),
- prototype operability (all three variants click through cleanly),
- facilitator neutrality (script holds under live pressure),
- measurement capture (every primary/secondary field is recordable),
- **session-position effect** — whether fatigue or learning makes the **third-position scenario** systematically easier or harder (the scenario × session-position confound, §15),
- session duration (fits the planned window).

**Rules:**
- Pilot results are **diagnostic only** and **must NOT be merged into the main evidence set** or any decision-gate evaluation.
- If the pilot exposes **unequal scenario difficulty**, **leading language**, or capture gaps → **revise the artifact/protocol and re-pilot** before recruiting the main cohort.
- If the pilot shows a **session-position effect** on the third scenario, **redesign the allocation** (e.g., rotate scenario-by-position) **before** the main study.
- The pilot uses 2 participants who are otherwise screen-eligible but are **excluded** from the main n.

---

## 13. Pre-registered Decision Heuristics

**Decision cohort = n = 12.** No statistical-significance claims — each participant moves a rate by ≈ **8.3 pp**, so thresholds are stated in **participant counts** (with pp equivalents). These are **directional decision heuristics**, fixed before any session and not softened after results. n = 9 is bound by §13.8.

### 13.1 Comprehension Floor (a candidate cannot be primary if it fails any of these)
A candidate experience **cannot become the primary** if:
- fewer than **9 of 12** participants (75%) correctly identify **current Safe-to-Spend** (Task 1), **or**
- fewer than **9 of 12** (75%) correctly **distinguish usable money from excluded uncertain money** (Task 4), **or**
- it causes **more than one additional participant** to fail a current-state comprehension task vs the Operator's Ledger baseline (Variant A).

### 13.2 Meaningful Temporal Improvement (when a timeline "earns" value)
Treat a timeline-enabled experience (B or C) as providing meaningful temporal value when it achieves **either**:
- **≥ 2 additional participants** answering the future-date task (Task 2) correctly vs the relevant baseline (≈ 16.7 pp), **or**
- **≥ 20% reduction** in **paired** median completion time for future-date tasks,

**while**:
- causing **no more than one additional** current-state comprehension failure (Task 1),
- preserving explanation accuracy (Task 5),
- creating no meaningful trust or confidence-calibration loss,
- and **not** concentrating the benefit in only one or two extreme outliers.

### 13.3 Keep Timeline Secondary (synthesis preferred)
Prefer Variant C when:
- it gains meaningful temporal comprehension over Variant A (clears §13.2),
- preserves the stable current-state comprehension of the ledger (passes §13.1),
- and Variant B does not provide enough additional benefit to justify making temporal interaction the primary surface.

### 13.4 Promote Timeline to Primary (reopen the decision)
Variant B may reopen the primary-surface decision only when it:
- gains **≥ 2 correct future-date answers over both** Variant A **and** Variant C, **or** an equivalently strong paired-time advantage,
- remains **within one participant** of the best variant on current-state comprehension,
- preserves money-state distinction (Task 4) and explanation accuracy (Task 5),
- does not materially increase navigation errors or cognitive load,
- and shows benefit **across the cohort**, not through isolated outliers.

### 13.5 Remove or Delay Timeline
Delay the timeline when:
- neither B nor C reaches the §13.2 meaningful-improvement threshold,
- participants misread **temporal position as money certainty**,
- the interaction produces disproportionate navigation errors,
- or the same reasoning is achieved more clearly through the Operator's Ledger.

### 13.6 Challenge the Product Model
Challenge the Reality Ledger and Certainty Engine themselves when participants **repeatedly fail across all three variants** to understand:
- why uncertain money is excluded,
- when money becomes usable,
- why Safe-to-Spend changes,
- or which future obligation creates pressure.

**Before recommending irreversible replacement** of the Reality Ledger or Certainty Engine, require **either**: (a) repeated failure across all variants in the **full 12-person cohort**, **or** (b) a **follow-up validation study** confirming the same failure pattern. **Do not reinterpret a model-comprehension failure as merely a visual-design problem.**

### 13.7 Tie / mixed-result rule
If results are split (e.g., B wins future-date but loses current-state, or an effect rides on outliers), the default is **§13.3 (keep secondary)** — the burden of proof is on **overturning** the synthesis, not confirming it.

### 13.8 n = 9 exploratory fallback (recruitment-failure only)
If recruitment yields only 9 completed sessions, the result is **exploratory** and **must NOT independently authorize**:
- promoting Money Timeline to the primary surface,
- replacing the synthesis,
- challenging or replacing the Certainty Engine / Reality Ledger model,
- any irreversible production decision.

An n = 9 result may only justify **another iteration or a larger follow-up study.** All heuristics in §13.1–§13.7 assume the **n = 12** decision cohort.

---

## 14. Evidence-Report Template

In order:
1. **One-paragraph verdict** — which heuristic (§13.3 / 13.4 / 13.5 / 13.6) the evidence triggers, stated before any narrative.
2. **Cohort description** — n, geography, currency exposure, tool familiarity, income regularity (with the directional-discovery disclaimer); pilot noted separately and excluded.
3. **Primary-measure table** — per variant: Task 1 accuracy, Task 2 accuracy, Task 4 state-distinction accuracy, Task 5 explanation accuracy.
4. **Secondary-measure table** — per variant: time-to-first-correct (T1, T2), navigation errors, unnecessary interactions, cognitive-load incidents, confidence calibration, perceived control, perceived trust.
5. **Preference results** — debrief preferences, **explicitly flagged as subordinate** to primary comprehension.
6. **Heuristic evaluation** — each §13 heuristic checked against pre-registered thresholds, with the data that triggered (or failed to trigger) it.
7. **Falsification statement** — did the evidence falsify the synthesis's placement of the timeline? Yes/no, with the specific primary measure.
8. **Verbatim evidence** — 3–5 representative quotes per outcome, including where understanding broke.
9. **Scenario-equivalence check** — observed difficulty across S1/S2/S3, confirming no scenario skewed results.
10. **Limitations** (§15) restated against what actually happened.
11. **Exact founder decision now enabled** (§16).
12. **Raw data appendix** — capture sheets, think-aloud logs, parity sign-off, order allocation, pilot notes (clearly fenced off).

**No-softening clause:** the report states failed or unfavorable results plainly. It may not reframe a comprehension failure as a preference win, and may not protect the synthesis by omission.

---

## 15. Limitations

- **Directional, not validating.** n = 9–12 is discovery-grade; cannot establish market demand or global readiness (blueprint §16.4, separate).
- **Low-fidelity artifact.** Findings concern comprehension of a *concept rendering*, not the shipped product.
- **No real intelligence or live data.** Certainty Engine outputs are pre-computed per scenario; this tests *surfacing*, not engine accuracy.
- **Three scenarios, one shape.** Isomorphic by design; results generalize only to this income/obligation shape.
- **Residual order effects.** Counterbalancing mitigates but does not eliminate adjacency effects (worse at n = 9, §11.1).
- **Scenario × session-position confound.** Scenario identity is fixed to session position (S1→S2→S3); every variant still receives every scenario equally across the cohort, but a position (fatigue/learning) effect cannot be separated from scenario identity. The pilot checks for this and triggers re-design if present (§12).
- **Facilitator effect.** Live think-aloud can bias behavior despite scripting.
- **Self-report limits.** Trust/control/preference are self-reported and weakly correlated with real-money behavior.
- **FX, formatting & probability abstracted.** Fixed Day-0 FX, neutral formatting, and **deterministic in-transit settlement (no probability weighting)** deliberately remove conversion-timing, regional-format, and confidence-forecasting variables (separate experiments, §5.5).

---

## 16. Exact Founder Decision Enabled by the Experiment

This experiment enables **one** decision and no more:

> **Where does the Money Timeline belong in Helm's experience architecture — secondary power surface (keep synthesis), primary home (reopen primary-surface decision), removed/deferred (strengthen Operator's Ledger), or is the failure at the mental-model level (revise the Reality Ledger / Certainty Engine)?**

It does **not** decide: the global build, persona modules, multi-currency engine design, external positioning/copy, or whether to pause Phase 6. Those remain gated by their own experiments (blueprint §16.2–§16.6, §21).

---

## 17. Estimated Time & Resources

Directional estimate for planning (not a commitment):
- **Prototype build** (3 throwaway low-fi variants × 3 scenarios = the variant shells reused across scenarios with swapped data): ~4–6 working days for one designer, gated by parity sign-off.
- **Protocol finalization & threshold ratification:** ~0.5 day (founder + facilitator).
- **Pilot (2 participants):** ~0.5–1 day incl. revise-and-re-pilot buffer.
- **Recruiting (12 qualified independents — decision cohort; 9 exploratory fallback — ≥2 markets):** ~1–2 weeks elapsed, partly parallel to build.
- **Sessions:** ~45–60 min each; 12 sessions (9 fallback) over ~1 week.
- **Analysis & report:** ~2–3 days.
- **People:** 1 designer (prototypes), 1 facilitator (neutrality maintained), 1 analyst/coder.
- **Cost drivers:** incentives × (2 pilot + 12 main; 9 fallback); optional recruiting-panel fee for non-BD reach.

---

## 18. What Remains Unauthorized

This protocol is a **draft for review.** Even once approved, the following remain **separately** unauthorized without explicit founder sign-off:
- building the prototypes or any test artifact,
- recruiting or contacting participants,
- **running the pilot,**
- running any main session,
- modifying production Flutter code, the migration branch, or any persisted data,
- creating final design tokens or a production timeline engine,
- introducing real AI, databases, or APIs,
- treating prototype polish as product progress,
- changing authoritative strategy documents, retiring canon, or altering external positioning,
- **committing this file** (founder has not authorized commit).

**Next step:** founder reviews this revision and either (a) requests changes, or (b) authorizes prototype build → pilot → main study as discrete, separately-scoped steps.

---

*End of protocol draft (revision 3). Stage = experiment design only. No prototype, no pilot, no recruiting, no sessions authorized.*
