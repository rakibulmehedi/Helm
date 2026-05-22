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
- [ ] **Income Status Transition:** Change an income from Expected -> Pending -> Received. Verify Safe-to-Spend only includes it when 'Received'.
- [ ] **Pending/Expected Exclusion:** Add massive pending/expected income. Verify Safe-to-Spend does not increase.
- [ ] **USD Exclusion State:** Toggle 'Exclude USD Income' in settings. Ensure USD-denominated received income is added/removed from the STS calculation immediately.
- [ ] **Reserve Mode Test:** Toggle 'Reserve Mode' (percentage vs fixed). Update amounts/percentages and verify the Anxiety Buffer/Tax Reserve deductions.
- [ ] **Fully Allocated Test:** Ensure that if reserves + fixed costs > received income, Safe-to-Spend clamps exactly to 0 (no negative values displayed to user, though raw may be negative).
- [ ] **No-Income State Test:** App gracefully handles zero received income (STS = 0).

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
