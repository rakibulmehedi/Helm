# Safe-to-Spend Scenario Test Matrix

This matrix verifies the robustness of the Safe-to-Spend (STS) calculation engine against various edge cases and normal states.

**Core Rule:** Pending and Expected income MUST NEVER be treated as spendable. `safeToSpend` is clamped to zero; `rawSafeToSpend` can be negative for internal logic.

| Scenario | Setup Data | Expected Engine Behavior | Expected UI State | Risk Mitigated |
| :--- | :--- | :--- | :--- | :--- |
| **No Income, No Expense** | Empty database | raw: 0, sts: 0 | Displays ৳0 | Baseline calculation |
| **Received Income Only** | 1 Received Income: 10,000 | raw: 10k, sts: 10,000 | Displays ৳10,000 | Basic inclusion |
| **Received + Expenses** | Inc: 10k, Exp: 2k | raw: 8k, sts: 8,000 | Displays ৳8,000 | Expense deduction |
| **Received + Tax Reserve** | Inc: 10k, Tax: 10% | raw: 9k, sts: 9,000 | Displays ৳9,000 | Percentage reserve calc |
| **Received + Fixed Costs** | Inc: 10k, Fixed due < 30d: 3k | raw: 7k, sts: 7,000 | Displays ৳7,000 | Fixed cost deduction |
| **Fixed Cost > 30 Days** | Inc: 10k, Fixed due > 30d: 3k | raw: 10k, sts: 10,000 | Displays ৳10,000 | Future cost exclusion |
| **Received + Anxiety Buffer** | Inc: 10k, Buffer: 2k flat | raw: 8k, sts: 8,000 | Displays ৳8,000 | Flat buffer deduction |
| **Pending Income Only** | 1 Pending Income: 10,000 | raw: 0, sts: 0 | Displays ৳0 | Premature spending risk |
| **Expected Income Only** | 1 Expected Income: 10,000 | raw: 0, sts: 0 | Displays ৳0 | Premature spending risk |
| **Mixed Income Types** | Exp: 5k, Pen: 5k, Rec: 10k | raw: 10k, sts: 10,000 | Displays ৳10,000 | Incorrect aggregation |
| **USD Income Excluded** | USD Inc: $100, Settings: Exclude USD | USD is ignored | STS unaffected by USD | Currency risk exclusion |
| **Negative Raw STS** | Inc: 10k, Exp: 15k | raw: -5k, sts: 0 | Displays ৳0 | Panic induction prevention |
| **Raw STS Exactly Zero** | Inc: 10k, Exp: 10k | raw: 0, sts: 0 | Displays ৳0 | Edge case clamping |
| **Delete Income affects STS** | Inc: 10k -> Delete it | raw: 0, sts: 0 | Drops to ৳0 instantly | State staleness |
| **Undo Delete restores STS** | Delete Income -> Undo | raw: 10k, sts: 10,000 | Restores to ৳10,000 | Undo state mismatch |
| **Edit Status Rec -> Pen** | Change 10k from Rec to Pen | raw: 0, sts: 0 | Drops to ৳0 instantly | Status change lag |
| **Edit Amount** | Change 10k Rec to 15k Rec | raw: 15k, sts: 15,000 | Updates to ৳15,000 | Amount edit staleness |
