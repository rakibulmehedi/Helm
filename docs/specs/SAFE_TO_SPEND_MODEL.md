# Safe-to-Spend Model — Phase 8 Candidate

> Status: FUTURE PHASE — NOT IMPLEMENTATION READY
> Depends on: Phase 7 (Income Pipeline) completion
> Phase: 8 (candidate)
> Last Updated: 2026-05-22

---

## 1. Problem Statement

Freelancers in Bangladesh cannot answer "How much can I safely spend right now?" because their bank balance conflates liquid cash, tax obligations, upcoming fixed costs, and pending income into a single misleading number. A freelancer with 50,000 BDT in their account may actually have only 15,000 BDT safe to spend after accounting for rent, taxes, and internet — but they don't know that without running the math in their head every time.

**Research backing:**
- Behavioral Finance Research: "Mental Accounting Fatigue" — the brain constantly runs background simulations ("If I buy this, will my internet bill bounce?")
- User Psychology Research: The primary anxiety is not "What did I spend?" but "Am I okay this month?"
- Cashflow Research: Freelancers need a single guilt-free number, not a budget spreadsheet

---

## 2. Target User Need

The user needs one number — the **Safe-to-Spend** number — that tells them exactly how much they can spend right now without risking bills, taxes, or their personal anxiety buffer. This number must:

- Exclude money reserved for taxes
- Exclude upcoming fixed survival costs (rent, internet, utilities)
- Exclude the user's personal "panic point" buffer
- NEVER include pending/expected income (that money is not liquid yet)
- Update in real-time as income arrives and expenses occur

---

## 3. Required Inputs

### Primary Inputs (From Phase 7 Income Pipeline)

| Input | Source | Notes |
|-------|--------|-------|
| Total Received Income | Phase 7 `IncomeEntry` where status = `received` | Only cleared, liquid money |
| Pending Income | Phase 7 `IncomeEntry` where status = `pending` | Used ONLY for Horizon Number, never for primary Safe-to-Spend |
| Expected Income | Phase 7 `IncomeEntry` where status = `expected` | Used ONLY for Horizon Number with heavy discount |

### Secondary Inputs (User-Provided, Low Friction)

| Input | Type | Notes |
|-------|------|-------|
| Tax Rate | Slider (0% - 40%) | User sets once, applied to all income. Hypothesis: Default 10% for BD freelancers |
| Panic Point / Anxiety Buffer | BDT amount | "I feel stressed if my balance drops below ___" — user sets their personal floor |
| Fixed Survival Costs | List of recurring amounts | Rent, utilities, internet — entered once, applied monthly |

### Future Dependencies (NOT for Phase 8 MVP)

| Input | Why Deferred |
|-------|-------------|
| Auto-detected recurring expenses | Requires Phase 9 Subscription Leakage Radar |
| Bank balance sync | Requires bank API integration (Phase 13+) |
| Client reliability scoring | Requires historical payment data across multiple months |
| Multi-currency balances | Requires multi-currency support (Phase 10) |

---

## 4. Formula Hypothesis

**Hypothesis: These formulas require user testing before committing to implementation.**

### Formula 1: The Guilt-Free Number (Strict Safety)

```
Safe_to_Spend = Total_Liquid_Cash
              - Tax_Reserve
              - Upcoming_Fixed_Survival_Costs
              - Anxiety_Buffer
```

Where:
- `Total_Liquid_Cash` = Sum of all Received income (Phase 7) minus all recorded expenses
- `Tax_Reserve` = `Tax_Rate%` x total income received in current period
- `Upcoming_Fixed_Survival_Costs` = Sum of user-defined recurring costs due within the next 30 days
- `Anxiety_Buffer` = User-defined personal floor ("I don't want to go below X")

**This is the hero number. It appears largest on the dashboard.**

### Formula 2: The Horizon Number (Expected Safety)

```
Expected_Safe = Safe_to_Spend
              + (Pending_Income * 0.8)
              + (Expected_Income * 0.3)
```

Where:
- `Pending_Income` = Sum of income entries with status `pending` (money in transit, high probability)
- `Expected_Income` = Sum of income entries with status `expected` (promised but not initiated, lower probability)
- Discount factors (0.8 and 0.3) are hypothetical — require validation

**Hypothesis:** Pending income gets 80% weight (high probability of clearing). Expected income gets 30% weight (may be delayed or cancelled). These weights are arbitrary starting points — user research needed.

**Critical rule: Pending and Expected income are NEVER added to the primary Safe-to-Spend number. The Horizon Number is a secondary, aspirational metric only.**

### The Waterline Metaphor

A mental model for the UI:

```
 ☁ The Clouds (Expected/Pending) — hope, not cash
----------------------------------------------- waterline
 🌊 The Surface (Safe-to-Spend) — guilt-free money
-----------------------------------------------
 🧊 The Depths (Protected) — taxes, bills, buffer
```

---

## 5. UX Requirements

### Hero Number Display

- The Safe-to-Spend number must be the largest, most prominent element on the dashboard
- Subtitle: "Taxes, rent, and bills through [date] are already covered."
- Bank balance shown smaller, greyed out below — not the hero metric
- Hypothesis: The hero number framing reduces compulsive balance checking by answering the anxiety question immediately

### No Red Colors for Money States

- Green: Safe to spend (above anxiety buffer)
- Yellow/Amber: "You're dipping into next month's runway" (between zero and anxiety buffer)
- Grey: "Pause — wait for next income" (at or below zero). Never red.
- Hypothesis: Grey signals "neutral/on hold" without triggering shame or panic

### Progressive Disclosure

- Dashboard: Show only the Safe-to-Spend number and subtitle
- Tap to expand: Show breakdown (liquid cash, tax reserve, fixed costs, buffer)
- Deep dive: Show full formula inputs and Horizon Number
- Hypothesis: Most users only need the hero number; power users want the breakdown

### Non-Judgmental Copy

- When Safe-to-Spend drops after a big payment: "You are fully protected! Taxes and bills are covered." (empowerment, not restriction)
- When Safe-to-Spend is low: "Your next expected income arrives [date]. You're covered until then." (reassurance)
- When Safe-to-Spend is zero: "Time to pause non-essential spending. Your next income is expected by [date]." (neutral guidance)
- NEVER: "You overspent!" or "Budget exceeded!" or any scolding language

---

## 6. UX Risks

### Risk 1: Loss Aversion After Big Payment

**Problem:** A freelancer receives 100,000 BDT. After tax reserve (25,000), rent (15,000), and buffer (10,000), Safe-to-Spend shows 50,000. The freelancer feels punished — "I just earned 100k and I can only spend 50k?"

**Mitigation:** Frame as empowerment. "You earned 100,000 BDT. 50,000 is yours to spend freely — taxes, rent, and your safety net are already handled." The word "freely" is key.

### Risk 2: Zero Balance Shock

**Problem:** If Safe-to-Spend reaches zero, displaying a large "0 BDT" is emotionally triggering.

**Mitigation:** Never show a stark zero. Instead: "You're in pause mode until [expected income date]. Your bills are covered." Show the Horizon Number as hope.

### Risk 3: Over-Complexity If Too Many Inputs

**Problem:** If the user has to enter tax rate, anxiety buffer, and 10 recurring bills before seeing any value, they'll abandon the feature.

**Mitigation:** Minimum viable inputs: just tax rate slider and one survival cost (rent). Buffer defaults to 0 if not set. Progressive onboarding — add more inputs over time.

### Risk 4: Multi-Currency Confusion

**Problem:** If a user has USD income and BDT expenses, which currency is the Safe-to-Spend number in?

**Mitigation:** Phase 8 operates in single currency (BDT). Multi-currency is Phase 10. If user has USD income entries, they are excluded from Safe-to-Spend until marked as Received (at which point they are presumably converted to BDT).

---

## 7. Dependencies

### Hard Dependencies

| Dependency | Status | Why Required |
|-----------|--------|-------------|
| Phase 7 Income Pipeline | Spec ready | Safe-to-Spend requires knowing Received vs Pending vs Expected income |
| Transaction expense tracking | Complete (Phase 1-6) | Need total expenses to calculate liquid cash |

### Soft Dependencies

| Dependency | Status | Why Helpful |
|-----------|--------|------------|
| Transaction categorization improvements | Not started | Better categorization helps auto-detect fixed vs discretionary expenses |
| Recurring expense detection | Phase 9 | Auto-populating fixed costs reduces manual entry |
| Virtual Wallets | Future phase | Tax Reserve wallet aligns with Safe-to-Spend tax deduction |

---

## 8. Out of Scope

- Bank API integration (no Plaid, no bKash sync)
- Auto-sweeping to sub-accounts (no actual money movement)
- Invoice factoring / cash advances (no lending features)
- AI-driven cashflow forecasting (no ML models)
- Client reliability scoring (requires months of historical data)
- "Can I Buy This?" simulator (high-value but Phase 8+ or Phase 9)
- Simulated paychecks / income smoothing (requires 3+ months of data)
- Amortized lumpy expense detection (annual subs, quarterly taxes — Phase 9+)

---

## 9. Open Questions

1. **Default tax rate for BD freelancers?**
   Hypothesis: 10% as starting default. Bangladesh income tax for freelancers varies, but a conservative low default prevents sticker shock. User can adjust upward.

2. **Should the anxiety buffer be user-configurable or auto-calculated?**
   Hypothesis: User-configurable with a suggested default. Auto-calculation requires income history we don't have yet. Default suggestion: 1 week of average expenses (calculated from existing transaction data if available).

3. **How to handle multi-currency before multi-currency support?**
   Hypothesis: Ignore USD-denominated income entries in Safe-to-Spend calculation. Only include BDT entries. Show a note: "USD income not included until received in BDT." This is imperfect but prevents false precision.

4. **Should the Horizon Number be visible by default or hidden?**
   Hypothesis: Hidden by default, available on tap. Showing it alongside Safe-to-Spend risks users conflating hope with reality. The primary number must be the strict, liquid-only Safe-to-Spend.

5. **Fixed costs: manual entry or auto-detected?**
   Hypothesis: Manual entry for Phase 8 MVP. Auto-detection depends on Phase 9 Subscription Leakage Radar. Start with user entering 2-5 recurring costs manually.

6. **Time horizon for fixed cost deduction?**
   Hypothesis: 30 days rolling. Deduct fixed costs due within the next 30 days. Adjust dynamically if user's average income gap is longer (e.g., if paid every 45 days, extend to 45 days). This dynamic adjustment is a Phase 8+ enhancement — MVP uses fixed 30 days.

---

## 10. Validation Plan

### Before Building Full UI

1. **Paper prototype test:** Show 5 freelancers a mockup with just the Safe-to-Spend number and subtitle. Ask: "Does this answer your primary financial question?" Measure comprehension and emotional response.

2. **Formula validation with real data:** Take 3 freelancers' actual income/expense history from the past 3 months. Apply the formula retrospectively. Ask: "Would this number have been accurate on [date]? Would you have trusted it?"

3. **Input friction test:** Time how long it takes a user to set up tax rate, anxiety buffer, and fixed costs. Target: under 2 minutes for initial setup.

### Test Personas

| Persona | Monthly Income | Pattern | Key Test |
|---------|---------------|---------|----------|
| Steady Rafiq | ~50,000 BDT | Regular Upwork payments | Does the number stay stable? |
| Volatile Ayesha | 20k-150k BDT | Feast/famine cycle | Does the number handle volatility without panic? |
| New Freelancer Karim | ~15,000 BDT | Just starting, few clients | Does the number work with minimal data? |

---

## 11. Success Criteria (Hypothesis)

- [ ] User can see Safe-to-Spend number within 3 seconds of opening app
- [ ] Setup (tax rate + anxiety buffer + 1 fixed cost) takes under 2 minutes
- [ ] 80%+ of test users report the number "makes sense" and "reduces anxiety"
- [ ] Safe-to-Spend number never includes pending/expected income
- [ ] Loss aversion framing ("You are fully protected!") tested and validated
- [ ] Zero-balance state does not trigger app abandonment

---

## 12. References

- `docs/research/SAFE_TO_SPEND_MODEL.md` — Full Waterline model research
- `docs/research/BEHAVIORAL_FINANCE_RESEARCH.md` — Scarcity trap, mental accounting fatigue
- `docs/research/USER_PSYCHOLOGY.md` — "Am I okay?" syndrome, pending money psychology
- `docs/research/FREELANCER_CASHFLOW_RESEARCH.md` — Velocity over volume, institutional helplessness
- `docs/specs/PHASE_7_FREELANCER_INCOME_TRACKING.md` — Hard dependency (income states)
