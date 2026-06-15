# Phase 7 — Freelancer Income Tracking

> Status: **COMPLETE**
> Phase: 7
> Milestone: v0.2-cashflow-operations
> Last Updated: 2026-05-22
> Implementation: See `lib/features/income_pipeline/`

---

## Payment Status Model

| Status | Meaning | UX Color |
|--------|---------|----------|
| **Expected** | Work done, payment not yet initiated | Soft grey |
| **Pending** | Payment initiated, in transit | Soft blue/amber |
| **Received** | Money in hand, liquid and spendable | Gentle green |

Status transitions: `Expected → Pending → Received` (one-directional happy path; backward allowed; skip-to-Received allowed).

---

## Entity Schema

### IncomeEntryEntity (Domain)

```dart
class IncomeEntryEntity {
  final String id;              // IdGenerator.uniqueId()
  final String clientName;
  final String projectName;
  final double amount;
  final String currency;        // "BDT" or "USD" (display only)
  final IncomeStatus status;    // expected | pending | received
  final DateTime expectedDate;
  final DateTime? receivedDate; // null until received
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum IncomeStatus { expected, pending, received }
```

### IncomeModel (Data — Hive)

```dart
@HiveType(typeId: 2)
class IncomeModel extends HiveObject {
  @HiveField(0)  final String id;
  @HiveField(1)  final String clientName;
  @HiveField(2)  final String projectName;
  @HiveField(3)  final double amount;
  @HiveField(4)  final String currency;
  @HiveField(5)  final int statusIndex;       // IncomeStatus.index
  @HiveField(6)  final DateTime expectedDate;
  @HiveField(7)  final DateTime? receivedDate;
  @HiveField(8)  final String? notes;
  @HiveField(9)  final DateTime createdAt;
  @HiveField(10) final DateTime updatedAt;
}
```

**typeId: 2** (typeId 0 = TransactionModel, 1 = reserved).

---

## Key Business Rules

- Entry defaults to `expected` on creation.
- `receivedDate` auto-set to current date when marking Received (editable).
- Pending income must NEVER be treated as liquid cash in Safe-to-Spend.
- No red color for `expected` or `pending` states.
- Status transition = max 1 tap from list view.
- Delete with undo SnackBar (consistent with transaction pattern).
- Dashboard shows three totals (current month): Expected | Pending | Received.

---

## Out of Scope

Safe-to-Spend (Phase 8), Virtual Wallets, charts, multi-currency, cloud sync, invoice generation, tax filing, bank API, recurring templates.
