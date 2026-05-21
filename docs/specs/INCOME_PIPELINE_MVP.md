# Income Pipeline MVP Spec

> Status: **SPEC READY — AWAITING IMPLEMENTATION**
> Parent Spec: PHASE_7_FREELANCER_INCOME_TRACKING.md
> Phase: 7
> Last Updated: 2026-05-22

This is the focused MVP data and interaction spec for the Income Pipeline feature. It defines exactly what the implementation agent needs to build.

---

## 1. Payment Status Model

### States

| Status | Internal Value | Display Label | Color | Semantics |
|--------|---------------|---------------|-------|-----------|
| Expected | `IncomeStatus.expected` | "Expected" | `AppColors` — soft grey | Work done, awaiting payment initiation |
| Pending | `IncomeStatus.pending` | "Pending" | `AppColors` — soft blue | Payment in transit, not yet liquid |
| Received | `IncomeStatus.received` | "Received" | `AppColors` — gentle green | Money in hand, spendable |

### Transitions

```
Expected ──→ Pending ──→ Received
    │                        ▲
    └────────────────────────┘
         (direct receive)

Pending ──→ Expected  (reverse if transfer fails)
```

- Forward transitions: always allowed
- Skip transitions: Expected → Received allowed (e.g., cash payment)
- Backward transitions: Pending → Expected allowed (transfer failed/cancelled)
- Received → backward: not allowed (money received cannot be un-received via status change; delete and re-create if needed)

---

## 2. Data Model

### IncomeEntry Fields

| Field | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `id` | String | Yes | `IdGenerator.uniqueId()` | Auto-generated |
| `clientName` | String | Yes | — | Client or income source (e.g., "Upwork", "Client X") |
| `projectName` | String | Yes | — | Project or task name (e.g., "Website Redesign") |
| `amount` | double | Yes | — | Gross payment amount |
| `currency` | String | Yes | "BDT" | "BDT" or "USD" — display only, no conversion logic |
| `status` | IncomeStatus | Yes | `expected` | Current payment state |
| `expectedDate` | DateTime | Yes | — | When payment is expected to arrive |
| `receivedDate` | DateTime? | No | null | Auto-set when status → Received; editable |
| `notes` | String? | No | null | Free-text notes |
| `createdAt` | DateTime | Yes | `DateTime.now()` | Auto-set on creation |
| `updatedAt` | DateTime | Yes | `DateTime.now()` | Auto-updated on any change |

### Validation Rules

| Field | Rule |
|-------|------|
| `clientName` | Non-empty, max 100 chars |
| `projectName` | Non-empty, max 100 chars |
| `amount` | > 0 |
| `currency` | Must be "BDT" or "USD" |
| `expectedDate` | Any valid date (past dates allowed for overdue tracking) |
| `notes` | Optional, max 500 chars |

---

## 3. Dashboard Summary Requirements

### Income Summary Section

The dashboard must display an **Income Pipeline Summary** section with three cards:

| Card | Label | Calculation | Tap Action |
|------|-------|-------------|------------|
| Expected | "Expected" | Sum of `amount` where `status == expected` (current month by `expectedDate`) | Navigate to income list filtered by Expected |
| Pending | "Pending" | Sum of `amount` where `status == pending` (current month by `expectedDate`) | Navigate to income list filtered by Pending |
| Received | "Received" | Sum of `amount` where `status == received` (current month by `receivedDate`) | Navigate to income list filtered by Received |

**Display rules:**
- Amounts formatted with `NumberFormat` and currency symbol
- Received card is visually most prominent (real money)
- Expected card is visually least prominent (hope, not cash)
- Cards must work in both light and dark mode
- If all values are zero, show the income pipeline empty state instead

### Placement
- Income summary appears below existing transaction summary cards
- Does NOT replace or modify existing transaction summary cards

---

## 4. CRUD Requirements

### Create
- **Entry point:** FAB or "+" button on income list screen; shortcut from dashboard
- **Form fields:** clientName, projectName, amount, currency (toggle BDT/USD), expectedDate (date picker), notes (optional)
- **Defaults:** status = Expected, currency = BDT, expectedDate = today
- **On save:** Navigate back, show success SnackBar
- **Double-submit prevention:** Disable button after first tap until operation completes

### Read
- **Income List Screen:** Shows all income entries
- **Filtering:** Tab bar — All | Expected | Pending | Received
- **Sorting:** By expectedDate (newest first within each status group)
- **Card display:** Client name, project name, amount + currency, status badge, expected/received date
- **Grouping:** Hypothesis: group by month if list grows long (defer to Phase 7c decision)

### Update
- **Entry point:** Tap income card → navigate to edit screen
- **Editable fields:** All fields including status
- **Status quick-action:** Single-tap button on card to advance to next status (Expected → Pending, Pending → Received)
- **On status → Received:** Auto-populate receivedDate with today; user can override
- **On save:** Navigate back, show success SnackBar
- **Mounted guard:** All post-async navigation guarded

### Delete
- **Mechanism:** Swipe-to-delete on income card (consistent with transaction pattern)
- **Immediate delete + Undo SnackBar** (consistent with Phase 6 UX hardening pattern)
- **SnackBar copy:** "Income entry deleted" with "Undo" action

---

## 5. Empty States

| Context | Display |
|---------|---------|
| **First time (no income entries exist)** | Illustration + "Track your income pipeline" + "Add your first expected payment to see when money is coming in." + Primary action button "Add Income" |
| **Filter: Expected (empty)** | "No expected payments. Add one when you start a new project." |
| **Filter: Pending (empty)** | "No payments in transit right now." |
| **Filter: Received (empty)** | "No payments received this month yet." |
| **All received (no expected/pending)** | "All payments received. You're fully covered." |
| **Dashboard summary all zero** | "Start tracking your income pipeline" with action to add first entry |

**Rules:**
- Empty states must be reassuring, not hollow
- Always include a clear next action
- No alarmist language

---

## 6. Error States

| Error | Handling |
|-------|---------|
| **Save fails (Hive write error)** | Show SnackBar: "Could not save. Please try again." Keep form data intact. |
| **Delete fails** | Show SnackBar: "Could not delete. Please try again." Restore entry in list. |
| **Income entry not found (edit route with invalid ID)** | Show error state with back navigation: "Income entry not found." (Same pattern as transaction edit) |
| **Undo after SnackBar dismissed** | No action needed — entry already deleted. Consistent with transaction behavior. |
| **Amount parse error** | Form validation: "Enter a valid amount" |
| **Empty required field** | Form validation: per-field error messages |

---

## 7. Screen Inventory

| Screen | Route | Purpose |
|--------|-------|---------|
| IncomeListScreen | `/income` | List + filter income entries |
| AddIncomeScreen | `/add-income` | Create new income entry |
| EditIncomeScreen | `/edit-income/:id` | Edit existing income entry |

**Note:** AddIncomeScreen and EditIncomeScreen may be the same screen in create/edit mode (same pattern as AddTransactionScreen).

---

## 8. Integration Points

| System | Integration |
|--------|-------------|
| Dashboard | Add Income Pipeline Summary section |
| Router | Add 3 new routes |
| Hive | New box: `incomeBox`, new TypeAdapter |
| Riverpod | New providers: `incomeDataSourceProvider`, `incomeRepositoryProvider`, `incomeNotifierProvider` |
| Core | Reuse `IdGenerator`, `AppColors`, `AppButton`, `NumberFormat` patterns |

---

## 9. What This Spec Does NOT Cover

- Currency conversion logic (USD amounts stored as-is, display only)
- Income analytics or trends
- Client management (clientName is free text, not a separate entity)
- Recurring income templates
- Push notifications
- Integration with existing transaction system (income entries are separate from expense transactions)
- Safe-to-Spend calculation (Phase 8 — will consume this data)
