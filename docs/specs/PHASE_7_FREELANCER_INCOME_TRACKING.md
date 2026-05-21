# Phase 7 — Freelancer Income Tracking

> Status: **SPEC READY — AWAITING IMPLEMENTATION**
> Phase: 7
> Milestone: v0.2-cashflow-operations
> Last Updated: 2026-05-22

---

## 1. Problem Statement

Freelancers in Bangladesh earn irregular income from multiple clients across multiple platforms (Upwork, Fiverr, local contracts). Money moves through several states — invoiced, in escrow, in transit (Payoneer to local bank), and finally cleared — but no consumer finance app tracks this lifecycle. The result is chronic cashflow anxiety: freelancers cannot answer "Am I okay this month?" because they don't know which money is real (cleared) vs. promised (pending).

**Research backing:**
- Behavioral Finance Research: "Schrödinger's Cash" — pending money creates a psychological twilight zone
- User Psychology Research: Freelancers mentally spend pending money before it arrives, causing guilt when transfers are delayed
- Cashflow Research: Velocity and predictability of money dictate stress levels more than absolute volume

---

## 2. Target User

**Primary:** Rafiq — a 26-year-old freelance web developer in Dhaka earning from Upwork in USD, receiving payments to bKash and bank. No accountant, no bookkeeper. Wants to open his phone and instantly know: "Am I doing okay this month?"

**Broader:** Any Bangladeshi freelancer, online earner, or agency operator with irregular multi-source income who needs to track the pending-to-cleared lifecycle of their earnings.

---

## 3. MVP Scope — What We Build

Phase 7 delivers the **Income Pipeline**: a system to track individual income entries through their payment lifecycle.

### Core Deliverables

1. **Income Entry Entity** — A new domain entity separate from general transactions, with payment status tracking
2. **Payment Status Model** — Three states: Expected, Pending, Received
3. **Income Entry CRUD** — Create, read, update, delete income entries
4. **Income List View** — Filterable list of income entries grouped by status
5. **Dashboard Income Summary** — Summary cards showing Expected, Pending, and Received totals
6. **Status Transitions** — Ability to move an income entry between states

### Payment Status Model

| Status | Meaning | UX Color | Example |
|--------|---------|----------|---------|
| **Expected** | Work done, payment not yet initiated | Soft grey | "Upwork milestone approved, withdrawal not started" |
| **Pending** | Payment initiated, in transit | Soft blue/amber | "Payoneer transfer initiated, waiting for bank credit" |
| **Received** | Money is in hand, liquid and spendable | Gentle green | "Bank account credited" |

**Status transitions are one-directional in the happy path:**
```
Expected → Pending → Received
```

**Edge cases:**
- User can move backward (e.g., Pending back to Expected if transfer fails)
- User can mark as Received directly from Expected (e.g., cash payment)
- User can delete at any stage

---

## 4. Out of Scope — What We Do NOT Build

| Excluded | Reason |
|----------|--------|
| Safe-to-Spend calculation | Phase 8 — depends on this pipeline being complete |
| Virtual Wallets | Future phase — depends on income + transaction tagging |
| Subscription tracking | Phase 9 |
| Charts or visualizations | Not needed for MVP pipeline |
| Multi-currency support | Phase 10 (Client ROI) |
| Cloud sync | Phase 13+ |
| AI categorization | Long-term |
| Invoice generation | Not in product scope |
| Tax filing or calculation | Not in product scope |
| Bank API integration | Not in product scope |
| Client reliability scoring | Requires historical data — future phase |
| Escrow/Transit sub-states | Over-engineering for MVP — three states are sufficient |
| Recurring income templates | Nice-to-have, not MVP |
| Push notifications for overdue | Requires notification infrastructure |

---

## 5. Data Model Draft

### IncomeEntry Entity (Domain Layer)

```dart
// domain/entities/income_entry_entity.dart
class IncomeEntryEntity {
  final String id;              // IdGenerator.uniqueId()
  final String clientName;      // "Upwork", "Fiverr", "Client X"
  final String projectName;     // "Website Redesign", "Logo Design"
  final double amount;          // Gross amount
  final String currency;        // "BDT" or "USD" (display only, no conversion)
  final IncomeStatus status;    // expected, pending, received
  final DateTime expectedDate;  // When payment is expected to arrive
  final DateTime? receivedDate; // When payment was actually received (null until received)
  final String? notes;          // Optional free-text notes
  final DateTime createdAt;     // When entry was created
  final DateTime updatedAt;     // Last modification timestamp
}
```

### IncomeStatus Enum

```dart
enum IncomeStatus {
  expected,  // Work done, payment not yet initiated
  pending,   // Payment in transit
  received,  // Money in hand
}
```

### IncomeModel (Data Layer — Hive)

```dart
// data/models/income_model.dart
@HiveType(typeId: 2)  // typeId 0 = TransactionModel, 1 = reserved
class IncomeModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String clientName;
  @HiveField(2) final String projectName;
  @HiveField(3) final double amount;
  @HiveField(4) final String currency;
  @HiveField(5) final int statusIndex;        // IncomeStatus.index
  @HiveField(6) final DateTime expectedDate;
  @HiveField(7) final DateTime? receivedDate;
  @HiveField(8) final String? notes;
  @HiveField(9) final DateTime createdAt;
  @HiveField(10) final DateTime updatedAt;
}
```

---

## 6. UX Rules

Derived from behavioral finance and user psychology research:

### 6.1 Emotional Safety
- **No red for pending money.** Pending = soft blue or neutral grey. Red induces panic.
- **No scolding copy.** Never say "overdue" or "late" — use "still waiting" or "expected by [date]"
- **Non-judgmental neutrality.** The app observes, it does not judge.

### 6.2 Cognitive Load
- **Dashboard must answer "Am I okay?" in 3 seconds.** Show three numbers: Expected, Pending, Received.
- **Progressive disclosure.** Summary on dashboard, details on tap.
- **No accounting jargon.** Use "Expected", "Pending", "Received" — not "Accounts Receivable", "In Escrow", "Reconciled".

### 6.3 Interaction
- **Fast entry.** Adding an income entry must take < 15 seconds.
- **Status change = one tap.** Moving Expected → Pending or Pending → Received should be a single action.
- **Undo on delete.** Consistent with existing transaction delete pattern (immediate delete + undo SnackBar).

### 6.4 Empty States
- **First-time empty state:** Guide the user — "Add your first expected payment to start tracking your income pipeline."
- **Per-status empty state:** "No pending payments right now. That's a good sign." (Reassuring, not hollow)
- **All-received state:** "All payments received. You're fully covered." (Calm celebration)

### 6.5 Visual Hierarchy
- Received total = most prominent (this is real money)
- Pending total = secondary prominence
- Expected total = tertiary (this is hope, not cash)

---

## 7. Acceptance Criteria

### Functional
- [ ] User can create an income entry with: client name, project name, amount, currency (BDT/USD), expected date, optional notes
- [ ] Income entry defaults to "Expected" status on creation
- [ ] User can transition status: Expected → Pending → Received
- [ ] User can skip states (Expected → Received directly)
- [ ] User can move status backward (Pending → Expected)
- [ ] When marking as Received, receivedDate is auto-set to current date (editable)
- [ ] User can edit all fields of an income entry at any status
- [ ] User can delete an income entry with undo
- [ ] Income list view shows entries grouped or filtered by status
- [ ] Dashboard shows summary: total Expected, total Pending, total Received (current month)
- [ ] All data persists locally via Hive
- [ ] Works fully offline

### Technical
- [ ] Feature follows `features/income/data|domain|presentation` structure
- [ ] State managed via Riverpod (StateNotifierProvider)
- [ ] Hive box declared in `app_box_names.dart`
- [ ] Hive TypeAdapter registered at startup
- [ ] Uses `IdGenerator.uniqueId()` for IDs
- [ ] Uses `AppColors` — no raw hex
- [ ] Uses `withValues(alpha:)` — no `withOpacity`
- [ ] All `setState` and post-async navigation guarded with `mounted`
- [ ] Files under 300 lines
- [ ] GoRouter routes added for income screens
- [ ] `dart analyze` returns 0 issues
- [ ] Existing transaction features not broken

### UX
- [ ] No red color for pending/expected states
- [ ] Empty states are helpful and reassuring
- [ ] Status transition is max 1 tap from the list view
- [ ] Dark mode compatible
- [ ] Amount formatted with NumberFormat

---

## 8. Implementation Phases

Phase 7 is internally broken into sub-phases for controlled delivery:

### Phase 7a — Income Data Layer
- IncomeEntryEntity (domain)
- IncomeModel + TypeAdapter (data)
- IncomeLocalDataSource (Hive CRUD)
- IncomeRepository (abstract + impl)
- IncomeNotifier (StateNotifier)
- Riverpod provider wiring

### Phase 7b — Income Entry UI
- AddIncomeScreen (create + edit mode)
- Form: client name, project name, amount, currency selector, expected date, notes
- Validation rules
- Route: /add-income, /edit-income/:id

### Phase 7c — Income List & Filtering
- IncomeListScreen with status filter tabs (All / Expected / Pending / Received)
- Income entry card with status indicator, amount, client, date
- Swipe-to-delete with undo
- Tap to edit
- Route: /income

### Phase 7d — Dashboard Integration
- Income summary cards on main dashboard
- Total Expected | Total Pending | Total Received
- Tap summary card → navigates to filtered income list
- Integration with existing dashboard without breaking transaction display

### Phase 7e — Status Transitions
- Quick-action button on income card to advance status
- Status change confirmation (lightweight, not modal)
- Auto-set receivedDate when marking as Received
- Status history preserved via updatedAt timestamp

---

## 9. Technical Notes

### Architecture
- New feature module: `lib/features/income/`
- Follows same pattern as `lib/features/transactions/`
- Domain entities must be pure Dart (no Flutter imports)
- Data models handle Hive serialization
- Presentation providers handle state

### Hive Configuration
- New box: `incomeBox` in `app_box_names.dart`
- TypeAdapter: `IncomeModelAdapter` with typeId 2
- Register adapter in `hive_service.dart` init

### Routing
- `/income` — Income list screen
- `/add-income` — Add new income entry
- `/edit-income/:id` — Edit existing income entry
- Add income shortcut accessible from dashboard

### Reuse
- Reuse `AppButton`, `AppColors`, `AppTheme` from `core/`
- Reuse `IdGenerator` for unique IDs
- Reuse `NumberFormat` patterns from transaction display
- Reuse delete + undo SnackBar pattern from transactions

---

## 10. Research Documents Used

| Document | Key Insight Applied |
|----------|-------------------|
| BEHAVIORAL_FINANCE_RESEARCH.md | Zeigarnik Effect → externalize pending payment loops; color theory → no red for pending |
| FREELANCER_CASHFLOW_RESEARCH.md | Schrödinger's Cash → three-state model; velocity over volume → focus on pipeline flow |
| USER_PSYCHOLOGY.md | "Am I okay?" syndrome → dashboard must answer in 3 seconds; pending money psychology → separate Expected from Received |
| PRODUCT_STRATEGY_ANALYSIS.md | Income Pipeline = highest-leverage feature; "OS" positioning requires workflow lock-in |
| SAFE_TO_SPEND_MODEL.md | Pending income must NEVER be treated as liquid cash — validates three-state separation |
