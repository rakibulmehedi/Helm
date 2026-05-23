# Safe-to-Spend Scenario Test Matrix

This matrix verifies the robustness of the Safe-to-Spend (STS) calculation engine against various edge cases and normal states.

**Core Rule:** Pending and Expected income MUST NEVER be treated as spendable. `safeToSpend` is clamped to zero; `rawSafeToSpend` can be negative for internal logic.

| Scenario | Setup Data | Expected Engine Behavior | Expected UI State | Risk Mitigated | QA Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **No Income, No Expense** | Empty database | raw: 0, sts: 0 | Displays ৳0 | Baseline calculation | Automated |
| **Received Income Only** | 1 Received Income: 10,000 | raw: 10k, sts: 10,000 | Displays ৳10,000 | Basic inclusion | Automated |
| **Received + Expenses** | Inc: 10k, Exp: 2k | raw: 8k, sts: 8,000 | Displays ৳8,000 | Expense deduction | Automated |
| **Received + Tax Reserve** | Inc: 10k, Tax: 10% | raw: 9k, sts: 9,000 | Displays ৳9,000 | Percentage reserve calc | Automated |
| **Received + Fixed Costs** | Inc: 10k, Fixed due < 30d: 3k | raw: 7k, sts: 7,000 | Displays ৳7,000 | Fixed cost deduction | Automated |
| **Fixed Cost > 30 Days** | Inc: 10k, Fixed due > 30d: 3k | raw: 10k, sts: 10,000 | Displays ৳10,000 | Future cost exclusion | N/A (see note) |
| **Received + Anxiety Buffer** | Inc: 10k, Buffer: 2k flat | raw: 8k, sts: 8,000 | Displays ৳8,000 | Flat buffer deduction | Automated |
| **Pending Income Only** | 1 Pending Income: 10,000 | raw: 0, sts: 0 | Displays ৳0 | Premature spending risk | Automated |
| **Expected Income Only** | 1 Expected Income: 10,000 | raw: 0, sts: 0 | Displays ৳0 | Premature spending risk | Automated |
| **Mixed Income Types** | Exp: 5k, Pen: 5k, Rec: 10k | raw: 10k, sts: 10,000 | Displays ৳10,000 | Incorrect aggregation | Automated |
| **USD Income Excluded** | USD Inc: $100, Settings: Exclude USD | USD is ignored | STS unaffected by USD | Currency risk exclusion | Automated |
| **Negative Raw STS** | Inc: 10k, Exp: 15k | raw: -5k, sts: 0 | Displays ৳0 | Panic induction prevention | Automated |
| **Raw STS Exactly Zero** | Inc: 10k, Exp: 10k | raw: 0, sts: 0 | Displays ৳0 | Edge case clamping | Automated |
| **Delete Income affects STS** | Inc: 10k -> Delete it | raw: 0, sts: 0 | Drops to ৳0 instantly | State staleness | Manual Required |
| **Undo Delete restores STS** | Delete Income -> Undo | raw: 10k, sts: 10,000 | Restores to ৳10,000 | Undo state mismatch | Manual Required |
| **Edit Status Rec -> Pen** | Change 10k from Rec to Pen | raw: 0, sts: 0 | Drops to ৳0 instantly | Status change lag | Manual Required |
| **Edit Amount** | Change 10k Rec to 15k Rec | raw: 15k, sts: 15,000 | Updates to ৳15,000 | Amount edit staleness | Manual Required |

### Phase 8g QA Status Notes

- **Automated**: Calculator logic verified via unit test in `safe_to_spend_calculator_test.dart` (26 tests).
- **Manual Required**: Requires real-device CRUD + UI state verification. Cannot be tested at calculator level alone.
- **N/A (Fixed Cost > 30 Days)**: With `dueDayOfMonth` constrained to 1-28, the maximum distance to next occurrence is ~28 days, which is always within the 30-day window. This scenario is **structurally impossible** under current domain constraints. See Phase 8g discovery notes.

### Additional Automated Scenarios (Phase 8g)

| Scenario | QA Status |
| :--- | :--- |
| TransactionType.income does NOT count as expense | Automated |
| Tax reserve from gross received, NOT net liquid cash | Automated |
| USD-only income results in zero STS | Automated |
| Expenses exceed income — clamped to zero | Automated |
| Fixed cost due today (same day) is within window | Automated |
| Multiple received BDT incomes aggregate correctly | Automated |
| Max tax rate 40% applied correctly | Automated |
| Full formula with all deductions + mixed statuses + USD | Automated |
