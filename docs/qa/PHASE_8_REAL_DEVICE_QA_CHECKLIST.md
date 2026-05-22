# Phase 8 Real Device QA Checklist

This checklist is designed for real-device testing of Pocketa after completing Phase 8 (Safe-to-Spend flow). Perform these tests on both a high-end device and a low-end device if possible, to verify smoothness and memory efficiency.

## 1. Installation & Onboarding Flow
- [ ] **Fresh Install Flow:** App starts cleanly, default settings applied, empty states shown for dashboard and transactions.
- [ ] **Returning User Flow:** Kill the app and restart. State is preserved. Safe-to-Spend calculates correctly upon immediate launch.

## 2. Core Entities CRUD
- [ ] **Income CRUD Test:** Create, Read, Update, Delete an income item. Verify changes instantly reflect on lists and Safe-to-Spend.
- [ ] **Transaction CRUD Test:** Create, Read, Update, Delete an expense transaction. Verify changes instantly reflect.
- [ ] **Fixed Cost CRUD Test:** Add, edit, delete a fixed cost item. Verify settings update and Safe-to-Spend recalculates based on 30-day proximity.

## 3. Safe-to-Spend Logic & Engine
- [ ] **Income Status Transition:** Change an income from Expected -> Pending -> Received. Verify Safe-to-Spend only includes it when Received.
- [ ] **Pending/Expected Exclusion:** Add massive pending/expected income. Verify Safe-to-Spend does not increase.
- [ ] **USD Exclusion State:** Add received USD income. Verify Safe-to-Spend does not include it and the breakdown clearly explains USD exclusion.
- [ ] **Tax Reserve Test:** Change tax rate and verify tax reserve updates based on gross received BDT income.
- [ ] **Anxiety Buffer Test:** Change anxiety buffer amount and verify it is deducted from Safe-to-Spend.
- [ ] **Fixed Cost Due Window:** Add a fixed cost due within 30 days and verify it is deducted. Add one outside the window and verify it is not deducted.
- [ ] **Reserve Mode Test:** Ensure when rawSafeToSpend < 0, the UI shows reserve-mode copy while displaying ৳0 as the user-facing amount.
- [ ] **Fully Allocated Test:** Ensure when rawSafeToSpend == 0, the UI shows fully allocated copy.
- [ ] **No-Income State Test:** App gracefully handles zero received income and shows a calm empty state.

## 4. UI & Aesthetics
- [ ] **Safe-to-Spend Hero Test:** Verify the big number animation/display looks crisp.
- [ ] **Breakdown Sheet Test:** Tap the Safe-to-Spend hero to reveal the breakdown sheet. Check that all deductions (Tax, Buffer, Fixed Costs) are itemized correctly.
- [ ] **Dark/Light Mode:** If applicable/supported, verify color contrast and legibility.
- [ ] **Keyboard/Input Behavior:** Ensure keyboards do not obscure input fields when adding income/expenses. Numeric pads should show for amounts.
- [ ] **Orientation/Resume Test:** Rotate device (if allowed) and minimize/resume app. Verify UI doesn't break and state doesn't crash.

## 5. Performance & Reliability
- [ ] **Low-End Device Smoothness:** Scroll lists and open bottom sheets on an older device to check for jank.
- [ ] **App Restart Persistence:** Force close app and reopen. Data and STS calculation must load accurately without manual refresh.
- [ ] **Analyzer/Test Verification:** Ensure `dart analyze` passes cleanly with no warnings or errors, and `flutter test` completes successfully.

## 6. Financial Trust Checks
- [ ] Safe-to-Spend never increases from Expected income.
- [ ] Safe-to-Spend never increases from Pending income.
- [ ] TransactionType.income entries do not count as received income.
- [ ] Expenses reduce Liquid Cash.
- [ ] Tax Reserve is calculated from gross received BDT income, not net cash.
- [ ] rawSafeToSpend is used for state detection.
- [ ] safeToSpend is displayed as clamped >= 0.
- [ ] Breakdown explains every deduction.
- [ ] No aggressive red color is used for low/zero Safe-to-Spend state.
- [ ] No tax/legal certainty claim appears in UI copy.
