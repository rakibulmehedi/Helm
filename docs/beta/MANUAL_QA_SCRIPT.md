# Manual QA Script

> Step-by-step manual QA procedures for Pocketa closed beta.
> Reference device: Samsung Galaxy A14 (or equivalent mid-range Android)
> Network: Test on both WiFi and 3G/4G (app is offline-first, but verify no network-dependent crashes)

---

## Pre-QA Setup

1. Uninstall any previous Pocketa build
2. Clear app data if reinstalling over existing
3. Ensure device has no prior Hive/SharedPreferences data
4. Have stopwatch ready for timing measurements

---

## QA-01: Fresh Install + Splash

| Step | Action | Expected | Pass? |
|------|--------|----------|-------|
| 1 | Install APK and launch | Splash screen appears | |
| 2 | Wait | Auto-navigates to Welcome screen | |
| 3 | Verify timing | Splash to Welcome < 3 seconds | |

---

## QA-02: Onboarding Flow

| Step | Action | Expected | Pass? |
|------|--------|----------|-------|
| 1 | On Welcome screen, tap "Get Started" | Onboarding screen 1 (qualifier) appears | |
| 2 | Verify no back button in AppBar | No AppBar back button visible | |
| 3 | Verify progress indicator | 2pt progress line, no step numbers | |
| 4 | Select "Yes" on qualifier | Advances to liquid balance screen | |
| 5 | Enter liquid balance (e.g., 50000) | Input accepted, BDT formatting shown | |
| 6 | Tap continue | Advances to fixed costs screen | |
| 7 | Add a fixed cost: "Rent", 15000, day 5 | Fixed cost appears in list | |
| 8 | Add another: "Internet", 2000, day 10 | Second cost appears | |
| 9 | Tap continue | Advances to income pattern screen | |
| 10 | Select "Monthly" | Card selected, highlighted | |
| 11 | Tap continue | Advances to buffer comfort screen | |
| 12 | Adjust slider to 20% | Live BDT preview updates | |
| 13 | Tap finish | Navigates to PIN setup screen | |
| 14 | Verify no celebration screen | No confetti, no "Welcome!", no tour | |

**Timing target**: Complete onboarding in under 3 minutes.

---

## QA-03: PIN Setup

| Step | Action | Expected | Pass? |
|------|--------|----------|-------|
| 1 | On PIN setup screen | 4 empty dot indicators visible | |
| 2 | Enter 4 digits (e.g., 1234) | Dots fill, advances to confirm step | |
| 3 | Enter same 4 digits | PIN accepted, navigates to /home | |
| 4 | Force-close app | App closes | |
| 5 | Re-open app | PIN entry screen appears (not splash/welcome) | |
| 6 | Enter wrong PIN | "Incorrect PIN" message, dots clear | |
| 7 | Enter wrong PIN 4 more times | Lockout message: "Restart the app" | |
| 8 | Force-close and re-open | PIN entry screen again, attempts reset | |
| 9 | Enter correct PIN | Dashboard appears | |

---

## QA-04: Dashboard / Safe-to-Spend

| Step | Action | Expected | Pass? |
|------|--------|----------|-------|
| 1 | Verify S2S hero visible | "Safe to spend" label + BDT amount | |
| 2 | Verify S2S value | Should reflect: liquid balance - fixed costs due - buffer | |
| 3 | Verify trust timestamp | "Updated [time]" visible near top | |
| 4 | Verify Ledger Rail | Colored rail (3pt) below S2S amount | |
| 5 | Verify committed section | Fixed costs total shown | |
| 6 | Verify reserve section | Buffer amount shown | |
| 7 | Verify "Not counted yet" | Shows pipeline entries not in S2S | |
| 8 | Tap S2S hero | Breakdown drawer opens | |
| 9 | Verify breakdown math | Line items: received, minus fixed, minus tax, minus buffer = S2S | |
| 10 | Verify S2S loads < 2 seconds | Instant on local data | |

---

## QA-05: Add Expected Payment (Pipeline Entry)

| Step | Action | Expected | Pass? |
|------|--------|----------|-------|
| 1 | Tap FAB on dashboard | Navigate to Add Income screen | |
| 2 | Enter client name: "Acme Corp" | Text accepted | |
| 3 | Enter amount: 1500 | Amount accepted | |
| 4 | Select currency: USD | Currency switches to USD | |
| 5 | Set status: Expected | Status selected | |
| 6 | Set expected date: 2 weeks from now | Date picker works | |
| 7 | Tap save | Returns to previous screen | |
| 8 | Navigate to Pipeline screen | Entry appears under "Expected" group | |
| 9 | Verify S2S unchanged | Expected income does NOT affect S2S | |

---

## QA-06: Confirm Received

| Step | Action | Expected | Pass? |
|------|--------|----------|-------|
| 1 | On Pipeline screen, find expected entry | Entry visible | |
| 2 | Trigger status transition to Pending | Status changes to Pending | |
| 3 | Trigger status transition to Received | Confirm-received sheet appears | |
| 4 | Enter FX rate (e.g., 119.66) | Rate accepted | |
| 5 | Enter BDT amount received | Amount field populated | |
| 6 | Tap "Confirm Received" | Entry moves to Received state | |
| 7 | Return to Dashboard | S2S increases by received BDT amount (minus deductions) | |
| 8 | Tap S2S breakdown | Received income now in calculation trace | |

---

## QA-07: Undo Confirm (if implemented)

| Step | Action | Expected | Pass? |
|------|--------|----------|-------|
| 1 | After confirming, check for undo option | Snackbar or undo button appears | |
| 2 | Tap undo within timeout | Entry reverts to previous state | |
| 3 | Verify S2S recalculates | S2S drops back to pre-confirm value | |

**Note**: If undo not implemented, mark as KNOWN LIMITATION.

---

## QA-08: Add Expense

| Step | Action | Expected | Pass? |
|------|--------|----------|-------|
| 1 | Navigate to Add Transaction | Expense entry form appears | |
| 2 | Enter title: "Lunch" | Text accepted | |
| 3 | Enter amount: 500 | Amount accepted | |
| 4 | Select category: Food | Category selected | |
| 5 | Tap save | Returns to previous screen | |
| 6 | Return to Dashboard | S2S decreased by 500 | |
| 7 | Verify breakdown | Expenses row reflects new total | |

---

## QA-09: Fixed Costs / Settings

| Step | Action | Expected | Pass? |
|------|--------|----------|-------|
| 1 | Navigate to Settings | Settings screen appears | |
| 2 | Tap STS Settings | STS settings screen appears | |
| 3 | Verify tax rate slider | Shows current tax % | |
| 4 | Adjust tax rate to 10% | Slider moves, label updates | |
| 5 | Return to Dashboard | S2S recalculated with new tax rate | |
| 6 | Go back to STS Settings | Tax rate persisted at 10% | |
| 7 | Verify buffer slider | Shows buffer % (5-30%) | |
| 8 | Verify fixed costs list | Previously added costs visible | |
| 9 | Swipe-delete a fixed cost | Undo snackbar appears | |
| 10 | Let undo expire | Fixed cost removed | |
| 11 | Verify Dashboard updates | S2S recalculated without deleted cost | |

---

## QA-10: Export Data

| Step | Action | Expected | Pass? |
|------|--------|----------|-------|
| 1 | Navigate to Settings | Settings screen appears | |
| 2 | Tap "Export my data" | Export screen appears | |
| 3 | Tap "Export all data" | Loading indicator shows | |
| 4 | Wait for completion | Native share sheet opens automatically | |
| 5 | Choose "Save to Files" or share | Files saved/shared successfully | |
| 6 | Open exported CSV | Contains income, transactions, costs, settings, audit data | |
| 7 | Verify CSV is readable | Columns and data match app state | |

---

## QA-11: Audit Log

| Step | Action | Expected | Pass? |
|------|--------|----------|-------|
| 1 | Navigate to Settings > Audit Log | Audit log screen appears | |
| 2 | Verify entries exist | Timeline of all financial changes visible | |
| 3 | Verify entry types | Created, updated, deleted events with icons | |
| 4 | Verify timestamps | Each entry has formatted date/time | |
| 5 | Verify entity types | Income, transaction, fixedCost, stsSettings entries present | |
| 6 | Add a new expense | Return to audit log | |
| 7 | Verify new entry appears | "created" event for new transaction at top | |

---

## QA-12: Account Deletion

**WARNING: This is a destructive test. Perform last or on a separate test device.**

| Step | Action | Expected | Pass? |
|------|--------|----------|-------|
| 1 | Navigate to Settings > Delete Account | Warning screen appears | |
| 2 | Read warning text | "This cannot be undone" clearly stated | |
| 3 | Verify deletion items listed | Income, transactions, fixed costs, settings, history | |
| 4 | Tap "Continue to delete" | PIN confirmation dialog appears | |
| 5 | Enter correct PIN | All data wiped, redirects to /welcome | |
| 6 | Verify Welcome screen | Fresh state, no prior data | |
| 7 | Complete onboarding again | All steps work from scratch | |
| 8 | Verify no residual data | Dashboard shows zero/default values | |

---

## QA-13: Edge Cases

| Step | Action | Expected | Pass? |
|------|--------|----------|-------|
| 1 | Kill app mid-transaction | On re-open, no data corruption | |
| 2 | Rotate device | Layout adapts, no crashes | |
| 3 | Toggle dark mode (system) | Theme switches appropriately | |
| 4 | Enter very large amount (99999999) | Lakh/crore formatting works | |
| 5 | Enter 0 as expense amount | Validation prevents or handles | |
| 6 | Rapid-tap save button | Double-submit guard prevents duplicates | |
| 7 | Navigate back during async op | No crash, mounted checks hold | |

---

## QA Summary Template

| Section | Result | Blockers Found |
|---------|--------|----------------|
| QA-01 Fresh Install | | |
| QA-02 Onboarding | | |
| QA-03 PIN Setup | | |
| QA-04 Dashboard | | |
| QA-05 Add Expected | | |
| QA-06 Confirm Received | | |
| QA-07 Undo Confirm | | |
| QA-08 Add Expense | | |
| QA-09 Settings | | |
| QA-10 Export | | |
| QA-11 Audit Log | | |
| QA-12 Account Deletion | | |
| QA-13 Edge Cases | | |
| **Overall** | | |
