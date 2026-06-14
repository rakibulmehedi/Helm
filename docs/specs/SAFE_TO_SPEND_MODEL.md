# Safe-to-Spend Model — Phase 8 Formula Contract

> Status: **IMPLEMENTATION READY — CONTRACT LOCKED**
> Phase: 8 (Formula & Data Contract defined in Phase 8a)
> Depends on: Phase 7 (Income Pipeline) ✅ COMPLETE | Phase 7f (Storage Abstraction) ✅ COMPLETE
> Last Updated: 2026-05-23
> Authored by: Antigravity (Phase 8a)

---

## 1. Problem Statement

Freelancers in Bangladesh cannot answer "How much can I safely spend right now?" because their bank
balance conflates liquid cash, tax obligations, upcoming fixed costs, and pending income into a
single misleading number. A freelancer with ৳50,000 in their account may only have ৳15,000 safe
to spend after accounting for rent, taxes, and internet — but they cannot know that without running
the math in their head every time.

**Research backing:**
- Behavioral Finance: "Mental Accounting Fatigue" — the brain runs constant background simulations
  ("If I buy this, will my internet bill bounce?")
- User Psychology: The primary anxiety is NOT "What did I spend?" — it is "Am I okay this month?"
- Cashflow Research: Freelancers need a single guilt-free number, not a budget spreadsheet

---

## 2. MVP Formula — LOCKED

### Formula: The Safe-to-Spend Number (Primary Hero)

```
Safe_to_Spend = Liquid_Cash - Tax_Reserve - Fixed_Costs_Due - Anxiety_Buffer
```

Where each term is defined as:

```
Liquid_Cash         = Σ(received income, BDT only)
                    - Σ(all recorded expenses)

Tax_Reserve         = Liquid_Cash_From_Income × Tax_Rate
                    (Tax_Rate default: 10%, user-configurable 0%–40%)

Fixed_Costs_Due     = Σ(user-entered recurring costs due within 30-day rolling window)
                    [MANUAL ENTRY in Phase 8 MVP — no auto-detection]

Anxiety_Buffer      = user-defined floor amount (default: ৳0 if not set)
```

### Fully Expanded Formula

```
Safe_to_Spend =   [Σ received_income (BDT only)]
                - [Σ all_expenses]
                - [Σ received_income (BDT only) × tax_rate]
                - [Σ fixed_costs due ≤ 30 days from today]
                - [anxiety_buffer]
```

**This is the ONLY formula that drives the hero number.**
It is deterministic, auditable, and fully reproducible from stored data.

---

## 3. Secondary Formula — Horizon Number (Non-Primary)

```
Horizon_Number = Safe_to_Spend
               + (Pending_Income × 0.8)
               + (Expected_Income × 0.3)
```

**Critical rules for the Horizon Number:**
- NEVER replaces or equals the Safe-to-Spend primary number
- NEVER feeds into any downstream calculation
- Is rendered ONLY on explicit user tap (progressive disclosure)
- The 0.8 and 0.3 discount factors are starting hypotheses — subject to user validation
- Labeled "What could be available" — never "Your balance"

---

## 4. Data Sources

### 4.1 Primary Data Sources (Available Now — Phase 7 Complete)

| Data Input | Source Entity | Source Field | Condition | Liquidity |
|---|---|---|---|---|
| Received Income (BDT) | `IncomeEntryEntity` | `amount` | `status == IncomeStatus.received` AND `currency == 'BDT'` | ✅ LIQUID |
| Received Income Date | `IncomeEntryEntity` | `receivedDate` | Used for period filtering only | — |
| All Expenses | `TransactionEntity` | `amount` | `type == TransactionType.expense` | ✅ REDUCES LIQUID CASH |

### 4.2 User-Provided Inputs (Require Phase 8b Setup Screen)

| Input | Storage | Type | Default | Range |
|---|---|---|---|---|
| Tax Rate (%) | `SharedPreferences` key `stsSettings_taxRate` | `double` | `0.10` (10%) | 0.00 – 0.40 |
| Fixed Costs | `Hive` box `fixedCostsBox` | `List<FixedCostEntry>` | `[]` (empty) | 0–20 entries |
| Anxiety Buffer (BDT) | `SharedPreferences` key `stsSettings_anxietyBuffer` | `double` | `0.0` | ≥ 0 |

### 4.3 Non-Liquid Sources — EXCLUDED FROM SAFE-TO-SPEND

| Data Input | Source | Status | Why Excluded |
|---|---|---|---|
| Pending Income | `IncomeEntryEntity` where `status == pending` | ❌ NON-LIQUID | Payment in transit — not confirmed received |
| Expected Income | `IncomeEntryEntity` where `status == expected` | ❌ NON-LIQUID | Promised but not initiated — may be delayed or cancelled |
| Income in USD | `IncomeEntryEntity` where `currency == 'USD'` | ❌ EXCLUDED (Phase 8 MVP) | No conversion logic in Phase 8. Deferred to Phase 10. |

### 4.4 Future Data Sources (NOT for Phase 8 MVP)

| Input | Why Deferred | When Available |
|---|---|---|
| Auto-detected recurring expenses | Requires Phase 9 Subscription Leakage Radar | Phase 9 |
| Bank balance sync | Requires bank API integration | Phase 13+ |
| Client reliability scoring | Requires multi-month historical data | Phase 10+ |
| Multi-currency BDT conversion | Requires currency conversion logic | Phase 10 |
| Virtual wallet balances | Requires Phase 8+ Virtual Wallets feature | Future |

**Mark in UI:** USD income entries display a note: "USD income excluded from Safe-to-Spend until
received and converted to BDT." This is non-alarming, informational copy.

---

## 5. Liquid vs Non-Liquid Rules — LOCKED

These rules are absolute and cannot be overridden by UI or user preference in Phase 8 MVP.

| Money State | Liquid? | Included in Safe-to-Spend? | Included in Horizon? |
|---|---|---|---|
| Received income (BDT) | ✅ YES | ✅ YES — full amount | ✅ YES |
| Received income (USD) | ⚠️ EXCLUDED | ❌ NO (Phase 8 MVP — no conversion) | ❌ NO |
| Pending income (any currency) | ❌ NO | ❌ NEVER | ✅ YES — at 0.8× discount |
| Expected income (any currency) | ❌ NO | ❌ NEVER | ✅ YES — at 0.3× discount |
| Expense transactions | N/A (outflow) | ✅ YES — reduces Liquid_Cash | ✅ YES |
| Tax reserve | N/A (deduction) | ✅ YES — subtracted from result | ✅ YES |
| Fixed costs (not yet due) | N/A | ❌ NO — only within 30-day window | ❌ NO |

**The single most important product rule:**
> Pending and Expected income are NEVER treated as spendable. The user has not received this
> money. Including it in any primary number would create false confidence and potential overspend.

---

## 6. What Must NOT Be Included in Safe-to-Spend

The following are explicitly excluded and must be enforced at the calculation layer:

| Excluded Item | Reason |
|---|---|
| Pending income (`status == pending`) | Money in transit — not confirmed |
| Expected income (`status == expected`) | Promised — not initiated |
| USD income (any status in Phase 8) | No conversion logic available |
| Future-dated received income (beyond today) | Handled by edge case rule EC-04 below |
| Tax reserve amount | This is subtracted FROM the result, not added |
| Anxiety buffer amount | This is subtracted FROM the result, not added |
| Fixed costs NOT in the 30-day window | Only deduct what is due within 30 days |
| Bank balance (if ever synced in future) | Not available in Phase 8; do not scaffold |
| Investment amounts | Out of scope — Helm is not an investment tracker |
| Loan / credit amounts | Out of scope — no liability tracking in Phase 8 |

---

## 7. Edge Cases — LOCKED

All edge cases are defined as named constants for Phase 8b implementer reference.

### EC-01: No Income Entries Exist

**Condition:** `IncomeEntryEntity` list is empty (no received income ever recorded).
**Result:**
```
Liquid_Cash = 0.0
Safe_to_Spend = 0.0 - 0.0 - Fixed_Costs_Due - Anxiety_Buffer
             ≤ 0.0 (negative if fixed costs or buffer set)
```
**Display:** Show income pipeline empty state callout. Copy: "Add your first received income to
see your Safe-to-Spend." Do not show a raw negative number without context.

### EC-02: No Expense Transactions Exist

**Condition:** `TransactionEntity` list has no `expense` type entries.
**Result:**
```
Liquid_Cash = Σ received_income (BDT only)
Safe_to_Spend = Liquid_Cash - Tax_Reserve - Fixed_Costs_Due - Anxiety_Buffer
```
**Display:** Normal calculation. No special state needed.

### EC-03: Negative Safe-to-Spend Result

**Condition:** Deductions (tax + fixed costs + buffer) exceed liquid cash.
**Result:** `Safe_to_Spend < 0`
**Display rule:**
- NEVER show a negative number with a minus sign as the hero
- Show ৳0 as the hero with a subtitle: "Your protective reserves exceed current income."
- Show a calming secondary message: "Your next income is expected by [earliest expectedDate of
  a pending or expected entry]." If no upcoming income, show: "Add income to your pipeline."
- Color state: Grey/neutral — NEVER red
- The Horizon Number CAN be shown (positive, reflecting expected future income)

### EC-04: Future-Dated Received Income

**Condition:** An `IncomeEntryEntity` has `status == received` but `receivedDate` is in the future
(e.g., user marked it received in advance, or set a future date).
**Rule:** Include it in `Liquid_Cash` regardless of `receivedDate` future dating.
**Reason:** If the user explicitly marked it `received`, they have confirmed the money is in hand.
Trust the user's explicit status action — do not second-guess by date. Log a note in the UI
breakdown: "Marked received on [date]."
**Validation note:** The UI should gently warn when marking received with a future date:
"Setting received date to [future date] — are you sure?" — a soft confirm, not a hard block.

### EC-05: Edited Income Status (Status Changed After Marking Received)

**Condition:** An entry previously marked `received` is changed back to `pending` or `expected`
via the edit screen.
**Rule:** Recalculate immediately. Remove that entry's `amount` from `Liquid_Cash`. The Riverpod
provider must listen to `incomeNotifierProvider` reactively.
**Display:** Safe-to-Spend number updates on the next frame after save. No stale state.

### EC-06: Deleted Income Entry

**Condition:** A `received` income entry is deleted.
**Rule:** Recalculate immediately. Remove that entry's `amount` from `Liquid_Cash`. Undo restores
the entry AND restores the Safe-to-Spend number to its prior value (reactive via Riverpod).
**Display:** Safe-to-Spend updates reactively. Undo SnackBar shows amount for identification.

### EC-07: All Fixed Costs Fall Outside 30-Day Window

**Condition:** User has entered fixed costs, but none are due within the next 30 days.
**Result:** `Fixed_Costs_Due = 0.0`
**Display:** Normal calculation. No deduction for fixed costs. Do NOT warn the user that no fixed
costs are due — this is an expected and good state.

### EC-08: Tax Rate Set to 0%

**Condition:** User sets tax rate slider to 0%.
**Result:** `Tax_Reserve = 0.0`
**Display:** Normal calculation. No deduction for tax. This is user choice — no warning.

### EC-09: Anxiety Buffer Not Set

**Condition:** User has never set an anxiety buffer (first-time user, or deliberately cleared).
**Result:** `Anxiety_Buffer = 0.0` (default)
**Display:** Normal calculation. Buffer row shows ৳0 in breakdown.

### EC-10: Multiple Currency Entries — USD + BDT Mixed

**Condition:** User has some received income in BDT and some in USD.
**Rule (Phase 8 MVP):** Only include BDT-denominated received income in `Liquid_Cash`.
USD entries are excluded. Show a non-alarming note in the transparency breakdown:
"USD income (৳X USD) not included — enter in BDT when converted."
**Future resolution:** Phase 10 multi-currency support will add conversion and include USD entries.

---

## 8. Transparency Requirements

The user MUST be able to see how the Safe-to-Spend number was calculated. This is non-negotiable.
A black-box number breeds distrust. A transparent number breeds confidence.

### 8.1 Required Breakdown (Accessible on Tap)

The UI must provide an expandable breakdown showing:

```
Safe-to-Spend Breakdown
═══════════════════════════════════════════

Received Income (BDT)          +৳XX,XXX
Recorded Expenses               -৳XX,XXX
                               ──────────
Liquid Cash                    =৳XX,XXX

Tax Reserve (10%)               -৳X,XXX
Fixed Costs (due in 30 days)    -৳X,XXX
Anxiety Buffer                  -৳X,XXX
                               ──────────
Safe to Spend                  =৳XX,XXX

═══════════════════════════════════════════

📌 Pending income (৳XX,XXX) is not counted
   until you mark it received.
```

### 8.2 Transparency Rules

| Rule | Requirement |
|---|---|
| Hero number shown first | Safe-to-Spend is the large, primary display |
| Breakdown on tap | One tap reveals the full breakdown above |
| Each line item labeled | Every addend/deduction labeled clearly |
| Excluded items noted | Pending income exclusion explicitly stated |
| No black-box calculation | Every number must be traceable to a data source |
| USD exclusion noted | If user has USD income, note it in the breakdown |
| Negative result explained | Never show bare negative — always explain context |

### 8.3 What Must NOT Be Transparent (Anti-Patterns)

| Anti-Pattern | Why Forbidden |
|---|---|
| Showing raw formula string to user | Too technical — replace with labeled rows |
| Showing multiple conflicting numbers at once | Breeds confusion — Safe-to-Spend is the hero |
| Showing Horizon Number without clear label | Risks conflating hope with confirmed cash |
| Showing percentage breakdowns as pie charts | Out of scope — avoid chart complexity in Phase 8 |

---

## 9. UX Contract (Binding for Phase 8b)

### 9.1 Color Rules

| State | Color | Trigger |
|---|---|---|
| Safe to spend freely | Green (gentle, from AppColors) | `Safe_to_Spend > Anxiety_Buffer` |
| Dipping into runway | Amber/Yellow (from AppColors) | `0 < Safe_to_Spend ≤ Anxiety_Buffer` |
| Pause mode | Grey/Neutral (from AppColors) | `Safe_to_Spend ≤ 0` |
| Any state | ❌ NEVER RED | Helm rule: red is forbidden for money states |

### 9.2 Copy Rules

| Scenario | Required Copy Pattern |
|---|---|
| Income received, positive balance | "৳XX,XXX available to spend freely. Taxes and bills are covered." |
| Balance positive but below buffer | "You're in your safety zone. Your bills are covered." |
| Balance at or below zero | "Pause mode — your reserves are protecting you. Next income expected [date]." |
| No income yet | "Add received income to see your Safe-to-Spend." |
| USD income excluded | "USD income not included until converted to BDT." |

**Forbidden copy:**
- "You overspent!"
- "Budget exceeded"
- "Warning: low balance"
- Any scolding or shame-inducing language

### 9.3 Display Architecture

```
DASHBOARD
├── [HERO] Safe-to-Spend Number (largest element)
│     └── Subtitle: "Taxes, rent, and bills through [30 days from today] are covered."
├── [TAP EXPAND] Breakdown rows (EC rules applied)
└── [TAP AGAIN] Horizon Number (labelled clearly as "What could be available")

SEPARATE SCREEN: Safe-to-Spend Settings
├── Tax rate slider (0%–40%)
├── Anxiety buffer (BDT amount input)
└── Fixed Costs list (add/edit/delete recurring costs)
```

---

## 10. FixedCostEntry — New Domain Entity Required for Phase 8b

Phase 8b requires a new minimal domain entity to store recurring fixed costs.

### Proposed Entity Contract

```dart
// CONTRACTUAL DEFINITION — implementation target for Phase 8b

class FixedCostEntry {
  final String id;          // IdGenerator.uniqueId()
  final String label;       // e.g., "Rent", "Internet", "Electricity"
  final double amount;      // BDT amount per cycle
  final int dueDayOfMonth;  // 1–28 (safe range — avoids 29/30/31 edge cases)
  final DateTime createdAt;

  // NO currency field — Phase 8 fixed costs are BDT only
  // NO recurrence enum — Phase 8 MVP assumes monthly
  // NO end date — assumed ongoing until deleted
}
```

**Hive TypeId:** `typeId: 3` (incomeBox = 2, transactionBox = 0/1 — never reuse)
**Storage box name:** `AppBoxNames.fixedCostsBox` (add to `app_box_names.dart`)
**30-day window filter:** Due within 30 days = `today.day ≤ dueDayOfMonth ≤ (today + 30d).day`
(Handle month rollover: if `today.day > dueDayOfMonth`, the cost is due in the NEXT month cycle.)

---

## 11. SafeToSpendResult — Calculation Output Contract

Phase 8b must expose a value object (not a raw double) that the UI can display with full transparency.

```dart
// CONTRACTUAL DEFINITION — implementation target for Phase 8b

class SafeToSpendResult {
  final double liquidCash;             // receivedIncomeBdt - totalExpenses
  final double totalReceivedIncomeBdt; // Σ received BDT income
  final double totalExpenses;          // Σ expense transactions
  final double taxReserve;             // liquidCash from income × taxRate
  final double fixedCostsDue;          // Σ fixed costs due within 30 days
  final double anxietyBuffer;          // user-set floor
  final double safeToSpend;            // display-safe result: max(0, rawSafeToSpend) — NEVER use for state detection
  final double rawSafeToSpend;         // actual computed value (can be negative) — USE THIS for "In reserve mode" / state logic
  final double pendingIncome;          // for Horizon Number calculation only
  final double expectedIncome;         // for Horizon Number calculation only
  final double horizonNumber;          // Safe_to_Spend + (pending×0.8) + (expected×0.3)
  final double excludedUsdIncome;      // USD received entries (not counted, but shown)
  final int excludedUsdEntryCount;     // how many USD entries were excluded
}
```

This value object feeds both the hero number AND the transparency breakdown rows with zero
additional computation in the UI layer.

---

## 12. Edge Case Matrix (Quick Reference for Phase 8b Implementer)

| # | Condition | Liquid_Cash | Safe_to_Spend | Display |
|---|---|---|---|---|
| EC-01 | No income | 0.0 | ≤ 0 | Empty income callout |
| EC-02 | No expenses | received_income | Normal calc | Normal display |
| EC-03 | Negative result | Any | Show ৳0 hero | Grey + "reserve mode" copy |
| EC-04 | Future receivedDate | Included | Normal calc | Soft warn on marking |
| EC-05 | Status edited (un-received) | Reduced | Recalculate reactively | Live update |
| EC-06 | Received entry deleted | Reduced | Recalculate reactively | Live update + undo |
| EC-07 | No fixed costs due in window | No deduction | Normal calc | Normal display |
| EC-08 | Tax rate = 0% | No deduction | Normal calc | Normal display |
| EC-09 | No anxiety buffer set | No deduction | Normal calc | Buffer row = ৳0 |
| EC-10 | USD + BDT mixed | BDT only | BDT-only calc | Note USD exclusion |

---

## 13. Out of Scope for Phase 8 MVP

| Item | Why Out of Scope |
|---|---|
| Bank balance sync | Phase 13+ |
| Auto-detected recurring expenses | Phase 9 (Subscription Leakage Radar) |
| Multi-currency conversion | Phase 10 |
| Client reliability scoring | Requires months of historical data |
| "Can I buy this?" simulator | Phase 8+ / Phase 9 |
| Income smoothing / simulated paychecks | Requires 3+ months data |
| Amortized lumpy expenses (annual subs) | Phase 9+ |
| AI cashflow forecasting | No ML in Phase 8 |
| Virtual wallet separation | Future phase |
| Push notifications for upcoming fixed costs | Future |
| PDF export of breakdown | Phase 11 |

---

## 14. Dependencies

### Hard Dependencies (All Complete ✅)

| Dependency | Status | Why Required |
|---|---|---|
| Phase 7 Income Pipeline | ✅ COMPLETE | Provides `IncomeEntryEntity` with `status` and `amount` fields |
| Phase 7f Storage Abstraction | ✅ COMPLETE | `TransactionEntity` and `IncomeEntryEntity` both use domain purity |
| Transaction expense tracking (Phases 1–6) | ✅ COMPLETE | Provides `TransactionEntity` with `type == expense` and `amount` |

### Soft Dependencies

| Dependency | Status | Why Helpful |
|---|---|---|
| Transaction categorization improvements | Not started | Better fixed vs discretionary separation |
| Phase 9 Subscription Leakage Radar | Future | Auto-populates fixed costs |
| Virtual Wallets | Future | Tax Reserve wallet aligns with this deduction |

---

## 15. References

- `docs/research/SAFE_TO_SPEND_MODEL.md` — Full Waterline model research (original)
- `docs/research/BEHAVIORAL_FINANCE_RESEARCH.md` — Scarcity trap, mental accounting fatigue
- `docs/research/USER_PSYCHOLOGY.md` — "Am I okay?" syndrome, pending money psychology
- `docs/research/FREELANCER_CASHFLOW_RESEARCH.md` — Velocity over volume, institutional helplessness
- `docs/specs/INCOME_PIPELINE_MVP.md` — `IncomeEntryEntity` fields and status model
- `docs/tracking/DECISION_LOG.md` — Decision 014 (formula finalized in Phase 8a)
- `docs/implementation/PHASE_8_SAFE_TO_SPEND_EXECUTION_PLAN.md` — Phase 8b implementation plan
- `docs/implementation/PHASE_8_ACCEPTANCE_CHECKLIST.md` — Phase 8b acceptance criteria
