# Phase 8g Simulated QA Report

> Date: 2026-05-23
> Phase: 8g — Simulated QA Before Human Verification
> Status: COMPLETE

---

## 1. Summary

Phase 8g validates the Safe-to-Spend calculation engine through comprehensive unit testing before real-device human verification begins. 15 new tests were added, bringing the total to 26. Two pre-existing test expectations were corrected (wrong expected values, not calculator bugs). One structural discovery was made regarding the fixed cost 30-day window.

---

## 2. Documentation Used

| Document | Purpose |
|---|---|
| `docs/specs/SAFE_TO_SPEND_MODEL.md` | Formula contract verification |
| `docs/qa/SAFE_TO_SPEND_SCENARIO_MATRIX.md` | Scenario coverage mapping |
| `docs/qa/PHASE_8_REAL_DEVICE_QA_CHECKLIST.md` | Manual QA items identification |
| `lib/features/safe_to_spend/domain/safe_to_spend_calculator.dart` | Implementation under test |
| `lib/features/safe_to_spend/domain/entities/*.dart` | Domain entity review |
| `lib/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart` | Provider architecture assessment |
| `lib/features/transactions/domain/entities/transaction_type.dart` | TransactionType.income verification |

---

## 3. Existing Test Coverage Audit

11 tests existed prior to Phase 8g:
- EC-01 (no income), EC-02 (no expenses), EC-03 (negative STS), EC-04 (future-dated received)
- EC-07 (fixed costs outside window), Fixed costs inside window
- EC-08 (tax=0%), EC-09 (buffer=0), EC-10 (USD+BDT mixed)
- Pending/Expected excluded + Horizon, Expenses reduce liquid

**Issues found in existing tests:**
1. EC-03: Expected `rawSafeToSpend = -200` but correct value is `-100` (arithmetic error in test expectation)
2. EC-07: Expected fixed cost with `dueDayOfMonth=25` to be outside 30-day window on May 23, but it resolves to May 25 (2 days away, within window)

Both were test expectation bugs, NOT calculator bugs.

---

## 4. Tests Added (15 new)

| # | Test Name | Scenario |
|---|---|---|
| 1 | True baseline: no income, no expense, zero settings | All fields zero |
| 2 | Received income only, zero deductions | Pure income, no tax/buffer/costs |
| 3 | Received + anxiety buffer only | Buffer-only deduction |
| 4 | Pending income only — STS must be zero | Pending exclusion (isolated) |
| 5 | Expected income only — STS must be zero | Expected exclusion (isolated) |
| 6 | rawSafeToSpend exactly zero | Edge case: income = expenses |
| 7 | TransactionType.income does NOT count as expense | Trust check: income tx ignored |
| 8 | All fixed costs within window | Multiple fixed costs, all included |
| 9 | Full formula: all deductions combined | Comprehensive multi-source test |
| 10 | Tax reserve from gross received, NOT net liquid | Tax base verification |
| 11 | Received USD income excluded | USD-only, zero STS |
| 12 | Expenses exceed income | Negative raw, clamped to zero |
| 13 | Fixed cost due today (same day) | Boundary: 0 days = within window |
| 14 | Multiple received BDT incomes aggregate | Multi-entry aggregation |
| 15 | Max tax rate 40% applied correctly | Upper bound tax rate |

---

## 5. Scenarios Automated (21 total)

All calculator-level scenarios from the scenario matrix are automated:
- No income/no expense, Received only, Received+Expenses, Received+Tax, Received+Fixed Costs, Received+Buffer
- Pending only, Expected only, Mixed income types, USD excluded
- Negative raw STS, Exactly zero raw STS
- TransactionType.income exclusion, Tax from gross, Max tax rate
- Multiple incomes, Fixed cost due today, Full formula combined

---

## 6. Scenarios Still Manual (4)

These require real-device CRUD operations and UI state observation:

| Scenario | Why Manual |
|---|---|
| Delete Income affects STS | Requires provider/UI state change verification |
| Undo Delete restores STS | Requires undo mechanism + UI verification |
| Edit Status Rec -> Pen | Requires status change through UI + STS recalc |
| Edit Amount | Requires amount edit through UI + STS recalc |

**Additional manual-only checks from QA checklist:**
- Hero animation/display quality
- Breakdown sheet tap interaction
- Dark/Light mode contrast
- Keyboard behavior on input screens
- App restart persistence
- Low-end device smoothness
- Reserve mode UI copy
- Fully allocated UI copy

---

## 7. Bugs Found (2)

| Bug | Severity | Type |
|---|---|---|
| EC-03 test expected `rawSafeToSpend = -200`, correct is `-100` | Low | Test expectation error |
| EC-07 test expected `fixedCostsDue = 0` for `dueDayOfMonth=25`, correct is `500` | Low | Test expectation error |

Both were test-side bugs. The calculator was correct all along.

---

## 8. Bugs Fixed (2)

Both test expectations corrected. No calculator or production code changes needed.

---

## 9. Formula/Spec Mismatches Found

**No formula mismatches.** Calculator matches the locked spec exactly:
- `Safe_to_Spend = Liquid_Cash - Tax_Reserve - Fixed_Costs_Due - Anxiety_Buffer`
- `Tax_Reserve = totalReceivedIncomeBdt * taxRate` (gross-based, per spec)
- `safeToSpend = max(0, rawSafeToSpend)` (clamped)
- `Horizon = safeToSpend + (pending * 0.8) + (expected * 0.3)`

**One structural discovery (not a mismatch):**
- EC-07 ("Fixed costs outside 30-day window") is structurally impossible with `dueDayOfMonth` constrained to 1-28. The maximum possible distance is ~28 days, always within 30. This means ALL user-entered fixed costs are ALWAYS deducted. The 30-day window logic exists but is never triggered under current domain constraints. This is not a bug — it's a design consequence. If future phases allow `dueDayOfMonth > 28` or add frequency-based scheduling, the 30-day window will activate.

---

## 10. Analyzer Result

```
Analyzing Helm...
No issues found!
```

---

## 11. Flutter Test Result

```
26 STS tests: ALL PASSED
1 widget_test.dart: FAILED (pre-existing stale default Flutter counter test, unrelated to Phase 8)
```

---

## 12. Confidence Level

**HIGH** for calculator correctness. 26 tests cover:
- Every formula term in isolation and combination
- All income status exclusion rules
- Currency filtering
- Clamping behavior
- Boundary conditions

**MEDIUM** for end-to-end flow. Provider layer is thin glue (5 lines of wiring), but requires Hive/SharedPreferences for integration tests. Manual device testing will cover this.

---

## 13. Provider-Level Tests Assessment

Skipped. Rationale:
- `safeToSpendProvider` is a 5-line computed provider that calls `SafeToSpendCalculator.calculate`
- Testing it requires mocking Hive boxes, SharedPreferences, and all data sources
- The calculator is pure and fully tested — the provider adds no logic
- Integration testing during real-device QA is sufficient
- Adding mock infrastructure would be over-engineering for Phase 8g scope

---

## 14. Remaining Human Verification Tasks

From `PHASE_8_REAL_DEVICE_QA_CHECKLIST.md`:
1. Fresh install flow
2. Returning user flow (state persistence)
3. Income CRUD + STS recalculation
4. Transaction CRUD + STS recalculation
5. Fixed Cost CRUD + STS recalculation
6. Income status transitions (Expected -> Pending -> Received)
7. Reserve mode UI copy verification
8. Fully allocated UI copy verification
9. No-income empty state
10. Hero display quality
11. Breakdown sheet interaction
12. Dark/light mode
13. Keyboard behavior
14. App restart persistence
15. Low-end device smoothness
16. Financial trust checks (no red colors, no legal claims)
