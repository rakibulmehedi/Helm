# Virtual Wallets — DEFERRED TO V1

> **Status: DEFERRED TO V1**
> **Per:** `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md` S5 (2026-06-04)
> **Blocked:** After MVP beta clears validation thresholds + multi-wallet phase approved. Per Decision 019.
> Last Updated: 2026-05-22

---

## Feature Definition

Virtual Wallets are a mental separation layer built on top of a single bank account — no banking integration. Users manage one real account but see money divided into logical buckets (Business, Personal, Tax Reserve, Emergency Buffer). Solves the "One Big Bucket Fallacy": all income in one pool creates tax blindness, financial burnout, and lifestyle creep. Transactions are tagged to a wallet in Helm's ledger only.

---

## Data Model

### Wallet Entity

```
Wallet {
  id:                    String (IdGenerator.uniqueId())
  name:                  String
  type:                  Enum (BUSINESS | PERSONAL | TAX_RESERVE | BUFFER)
  allocationMode:        Enum (PERCENTAGE | FIXED_AMOUNT)
  allocationValue:       Double
  isHiddenFromMainBalance: Boolean (default true for TAX_RESERVE)
  currentBalance:        Double (calculated from tagged transactions)
  targetBalance:         Double?
  createdAt:             DateTime
  updatedAt:             DateTime
}
```

### Transaction Extension

```
Transaction {
  // ... existing fields ...
  walletId: String?  // nullable — existing transactions unaffected
}
```

---

## Gating Condition

**Blocked:** after MVP beta + multi-wallet phase gate. Hard dependencies: Phase 7 Income Pipeline (complete), existing transaction tagging. Do not implement until doctrine gate cleared.
