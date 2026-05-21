# Virtual Wallets — Future Phase Spec

> Status: FUTURE PHASE — NOT IMPLEMENTATION READY
> Depends on: Phase 7 (Income Pipeline), Transaction Tagging
> Phase: TBD (post Phase 8)
> Last Updated: 2026-05-22

---

## 1. Problem Statement

**The One Big Bucket Fallacy:** Most freelancers in Bangladesh deposit all income into a single bank account, then pay for servers, groceries, rent, and tax obligations from the same pool. This creates three critical problems:

1. **Tax/Buffer Blindness:** Users perceive whatever sits in their bank account as 100% liquid and available for spending, even when it must be reserved for quarterly taxes or operating expenses.

2. **Financial Burnout:** The absence of a clear boundary between personal and business finances creates cognitive overhead. Every personal purchase feels like stealing from the business, and every business purchase feels like stealing from personal survival.

3. **Lifestyle Creep:** Without mental separation, freelancers unconsciously fund lifestyle upgrades from business cash, eroding profitability without awareness.

Virtual Wallets solve this at the UI/mental layer without requiring users to open multiple bank accounts.

**Research backing:**
- User Psychology Research: "The One Big Bucket Fallacy" — all money in one pool
- Behavioral Finance Research: "Buffer Obfuscation" — out of sight, out of mind prevents impulse spending
- Cashflow Research: Financial burnout from no clear personal/business boundary

---

## 2. Concept

Virtual Wallets are a **mental separation and obfuscation layer** built on top of a single bank account. They have no actual banking integration — transactions tagged to a wallet exist only in Pocketa's ledger.

**Core principle:** Users manage one real bank account, but see their money divided into logical buckets in Pocketa. This creates psychological clarity and prevents mixing of concerns.

### Default Wallet Types

| Wallet | Purpose | Hidden from Main Balance? |
|--------|---------|--------------------------|
| **Business** | Revenue from freelance work, business operating expenses | No |
| **Personal** | Household spending, personal discretionary budget | No |
| **Tax Reserve** | Automatic allocation for tax obligations | Yes (by default) |
| **Emergency Buffer** (optional) | Rainy-day reserve for slow months | Yes (by default) |

### Retention Mechanism

Once a user has established virtual wallets and allocated income/spending across them, switching to another app requires rebuilding the entire wallet structure and history. This creates high switching cost and strong retention.

---

## 3. User Stories

**As a freelancer earning variable income:**
- I want to automatically reserve a percentage of each income for taxes so I don't accidentally spend it
- I want to hide my tax reserve from my main balance view so I'm not tempted to touch it
- I want to see how much of my income is truly for personal use vs. business reinvestment

**As a freelancer with cash flow anxiety:**
- I want to see a "Personal Available" balance that excludes tax and buffer reserves
- I want to occasionally borrow from my tax wallet without shame or judgment
- I want the app to track what I owe back to the tax wallet transparently

**As a freelancer managing seasonal work:**
- I want to build an emergency buffer during high-income months
- I want allocation rules that automatically funnel portions of income into this buffer

---

## 4. Data Model Draft

### Wallet Entity

```
Wallet {
  id: String (IdGenerator.uniqueId())
  name: String (e.g., "Tax Reserve", "Personal")
  type: Enum (BUSINESS, PERSONAL, TAX_RESERVE, BUFFER)
  description: String? (optional user-defined purpose)
  allocationMode: Enum (PERCENTAGE, FIXED_AMOUNT)
  allocationValue: Double (e.g., 0.25 for 25%, or 5000 for fixed)
  isHiddenFromMainBalance: Boolean (default true for TAX_RESERVE)
  currentBalance: Double (calculated from tagged transactions)
  targetBalance: Double? (optional goal amount)
  createdAt: DateTime
  updatedAt: DateTime
}
```

### Transaction-Wallet Association

Extend existing Transaction model with:

```
Transaction {
  // ... existing fields ...
  walletId: String? (nullable, references Wallet.id)
}
```

**Hypothesis:** A simple nullable walletId on the transaction is sufficient for MVP. More complex multi-wallet splits (e.g., "50% Business, 50% Personal") can be added later if user demand validates it.

---

## 5. UX Requirements

### Wallet Dashboard View

- Primary display: Balance excluding hidden reserves (effectively "Safe to Spend" when Phase 8 is complete)
- Secondary display: Expandable breakdown of all wallets with current balances
- Tax reserve shown only when user explicitly expands details

**Hypothesis:** Hiding tax reserve from the main view reduces the psychological urge to spend it ("out of sight, out of mind").

### Income Allocation Flow

When income is recorded (Phase 7 Income Pipeline):
1. Show simple allocation UI: "This income will be split: 25% Tax, 75% Personal"
2. User can override allocation for this specific transaction
3. User can set default allocation rule going forward

### Non-Judgmental Borrowing

When user needs to spend from a low/empty wallet:
- No error message or shame-inducing language
- Transaction records the overdraft transparently: "Personal: -2,000 BDT (covered from Tax Reserve)"
- Optional gentle note: "Your Tax Reserve is below target. Plan to rebuild when income arrives."
- NEVER: "You violated your tax budget!" or any scolding language

**Hypothesis:** Transparent tracking without judgment encourages responsible behavior over denial and app abandonment.

---

## 6. Dependencies

### Hard Dependencies

| Dependency | Status | Why Required |
|-----------|--------|-------------|
| Phase 7 — Income Pipeline | Spec ready | Income must be trackable to allocate across wallets |
| Transaction tagging/categorization | Existing (basic) | Every transaction must be associable with a wallet |

### Soft Dependencies

| Dependency | Status | Why Helpful |
|-----------|--------|------------|
| Phase 8 — Safe-to-Spend Model | Spec ready | Virtual wallets feed into Safe-to-Spend calculation |
| Phase 9 — Subscription Leakage Radar | Spec ready | Auto-detected subscriptions can be auto-tagged to Business wallet |

---

## 7. Out of Scope

- **Actual bank account creation** — No API to bKash, Nagad, or banks
- **bKash/Nagad integration** — No mobile financial service connections
- **Automated money movement** — No scheduled transfers or auto-sweeping
- **Multi-currency wallets** — Separate feature (Phase 10+)
- **Wallet hierarchy/nesting** — No sub-wallets (e.g., no "Business > Servers")
- **Shared/family wallets** — Single-user only
- **Hard spending limits** — Soft alerts only, user can always override
- **Wallet-to-wallet transfer UI** — MVP tracks overdrafts, not explicit transfers

---

## 8. Open Questions

### 1. Should wallets have hard or soft limits?

**Hypothesis:** Soft limits only. Hard limits create friction and force users outside the app. Non-judgmental design requires giving users autonomy. Exception: user can optionally enable a "confirmation prompt" on Tax Reserve spending.

### 2. How to handle "I need to borrow from my tax wallet" without shame?

**Hypothesis:** Transparent overdraft with tracking. Show negative balance on Tax Reserve. Optional gentle reminder to rebuild. Frame as a normal part of freelancer cash flow, not a failure. Copy example: "You used 2,000 BDT from Tax Reserve. It happens. Rebuild it when your next payment arrives."

### 3. Should wallet allocation be percentage-based or fixed amount?

**Hypothesis:** Support both, default to percentage. Percentage is more flexible for variable income (25% of 20k is different from 25% of 100k). Fixed amount useful for users with stable recurring obligations.

### 4. How many wallets should be the default?

**Hypothesis:** Three defaults (Business, Personal, Tax Reserve). Emergency Buffer offered during onboarding but optional. Project-specific wallets available but not promoted initially. More than 5 wallets risks cognitive overload.

### 5. Should wallet balances be visible on the main dashboard?

**Hypothesis:** Only the "spendable" total is visible on the main dashboard. Full wallet breakdown available one tap away. Tax Reserve hidden by default to prevent temptation.

---

## 9. Risks

### Risk 1: Over-Complexity

**Problem:** Too many wallets creates "which wallet?" friction on every transaction.

**Mitigation:** Default to 3 wallets. Warn when creating more than 5. Auto-allocation rules reduce per-transaction decisions.

### Risk 2: Confusion Between Virtual and Real Accounts

**Problem:** Users might think virtual wallets correspond to actual bank accounts.

**Mitigation:** Clear labeling: "Virtual Wallet — for planning only, not a real account." Onboarding explains the concept. Show actual bank balance alongside wallet breakdown.

### Risk 3: Tax Reserve Obfuscation Backfires

**Problem:** If users can't see tax reserve, they might over-allocate to personal spending.

**Mitigation:** Non-judgmental periodic notifications: "Your Tax Reserve is building as expected." Tax Reserve always visible in detail view (just hidden from primary balance). Safe-to-Spend model (Phase 8) accounts for it.

### Risk 4: Data Model Coupling

**Problem:** Adding walletId to the existing Transaction model could break the frozen transaction system.

**Mitigation:** walletId is nullable — existing transactions without a wallet continue to work unchanged. Migration adds the field with null default. No breaking changes to existing queries or UI.

---

## 10. References

- `docs/research/FREELANCER_CASHFLOW_RESEARCH.md` — The One Big Bucket Fallacy, financial burnout
- `docs/research/BEHAVIORAL_FINANCE_RESEARCH.md` — Buffer obfuscation, tax blindness
- `docs/research/USER_PSYCHOLOGY.md` — Operational money behaviors, switching costs
- `docs/specs/PHASE_7_FREELANCER_INCOME_TRACKING.md` — Hard dependency
- `docs/specs/SAFE_TO_SPEND_MODEL.md` — Integration point for Safe-to-Spend calculation
