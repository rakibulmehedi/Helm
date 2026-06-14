# TDD + Clean Architecture Dispatch — Phase 5: V1 Features

> Date: 2026-06-12
> Reference: `docs/planning/100_PERCENT_MASTER_PLAN.md`
> Status: Dispatch plan — implementation not yet started
> ⚠️ GATED: Closed beta must clear ALL 5 thresholds (2+ misses = KILL)
> Effort: ~15 hours, 3 sprints
> Agent lead: Antigravity
> Review agents: UI Designer, UX Architect, Persona Walkthrough, Whimsy Injector
> Target: Behavioral 90→93, UI/UX 93→95

---

## Global TDD Mandate

```
RED: Write failing test → GREEN: Minimal implementation → REFACTOR: Clean architecture guard
```

**Test file convention:** `test/features/<feature>/<layer>/<file>_test.dart` mirrors `lib/` structure.

**Clean architecture gates (universal):**
- No `data/` imports in `presentation/`
- No Flutter/dart imports in `domain/`
- No `Hive.box()` in UI
- No `setState()` for business logic
- `mounted` check after every async gap in stateful widgets
- All domain entities are immutable (`final` fields, no setters)

---

## GROUP 5A — Multi-Wallet System (P5.1–P5.6)

**Files touched (new feature):**
- `lib/features/wallets/domain/entities/wallet_entity.dart`
- `lib/features/wallets/domain/repositories/wallet_repository.dart`
- `lib/features/wallets/data/models/wallet_model.dart` (Hive TypeAdapter)
- `lib/features/wallets/data/repositories/wallet_repository_impl.dart`
- `lib/features/wallets/presentation/views/wallet_list_screen.dart`
- `lib/features/wallets/presentation/views/add_wallet_screen.dart`
- `lib/features/wallets/presentation/providers/wallet_providers.dart`

### TDD Approach

```dart
// test/features/wallets/domain/wallet_entity_test.dart
test('WalletEntity: Payoneer preset type, USD currency', () {
  final wallet = WalletEntity(
    id: 'w1',
    name: 'Payoneer',
    type: WalletType.payoneer,
    currency: 'USD',
    balance: 1200.0,
  );
  expect(wallet.type, equals(WalletType.payoneer));
  expect(wallet.currency, equals('USD'));
});

// test/features/wallets/domain/wallet_repository_test.dart (abstract contract)
// test/features/wallets/data/wallet_repository_impl_test.dart (Hive CRUD)

// test/features/wallets/presentation/wallet_list_screen_test.dart
testWidgets('shows all wallets with balance', (tester) async { ... });
testWidgets('add wallet button opens form', (tester) async { ... });

// test/features/wallets/presentation/transfer_test.dart
testWidgets('intra-wallet transfer deducts from source, adds to target', (tester) async { ... });
testWidgets('transfer is audit-logged but never moves real money', (tester) async { ... });
```

### Clean Architecture
```
features/wallets/
├── domain/
│   ├── entities/wallet_entity.dart    # Pure Dart — WalletType enum, balance, currency
│   ├── entities/transfer_entity.dart  # Pure Dart — source, target, amount, timestamp, audit
│   └── repositories/                  # Abstract
├── data/
│   ├── models/wallet_model.dart       # HiveObject + TypeAdapter
│   ├── models/transfer_model.dart
│   └── repositories/                  # Concrete
└── presentation/
    ├── providers/                     # Riverpod WalletNotifier + TransferNotifier
    └── views/                         # Screens + widgets
```

### S2S Calculator Update
```
S2S = aggregateBalance.allWallets
    − taxReserve(aggregateBalance)
    − fixedCostsDue(30d)
    − bufferPercent(aggregateBalance)
```

### Exit Gate
- [ ] 5 wallet types: Payoneer, bKash, Bank, Cash, Custom
- [ ] Create, edit, delete wallets
- [ ] Intra-wallet transfer: record-only, audit-logged
- [ ] S2S aggregates from all wallets
- [ ] 10+ new wallet tests pass

---

## GROUP 5B — Visual Upgrades (P5.7–P5.9)

### State Colors (P5.7–P5.8)

```dart
// test/features/dashboard/presentation/s2s_state_colors_test.dart
testWidgets('Safe state shows green tint on hero background', (tester) async { ... });
testWidgets('Tight state shows amber tint', (tester) async { ... });
testWidgets('At Risk state shows red tint', (tester) async { ... });
```

```dart
// Implementation
Color _heroTint(SafeToSpendResult r, HelmColors colors) {
  if (r.safeToSpend > 0) return colors.stateSafe.withValues(alpha: 0.08);
  if (r.safeToSpend > -r.anxietyBuffer) return colors.stateTight.withValues(alpha: 0.08);
  return colors.stateAtRisk.withValues(alpha: 0.08);
}
```

### Duplicate Last Entry (P5.9)

```dart
// On pipeline screen: "Quick add — same as last" button
// Copies client name, amount, currency from most recent entry
// Opens AddIncomeScreen pre-filled
```

### Exit Gate
- [ ] State colors visible on S2S hero background (subtle tint, not garish)
- [ ] "Duplicate last entry" works for retainer freelancers
- [ ] 3+ new visual tests pass

---

## GROUP 5C — Polish (P5.10–P5.13)

**Whimsy Injector designs empty/error state copy per screen.**
**UI Designer specs skeleton screen layout.**

### Empty States (P5.10)
Pipeline empty: "No expected payments yet. Your Safe-to-Spend shows money you have right now."
Income list empty: — handled by onboarding.
Transaction list: routed away from dashboard, not prominent.

### Error States (P5.11)
Branded error UI (HelmCautionCard or HelmAuditCard), not default Flutter red screen.
Consistent pattern: "Hmm, we couldn't load [thing]. [Action button]"

### Skeleton Screens (P5.12)
```dart
// test/core/widgets/helm_skeleton_test.dart
testWidgets('skeleton card shows shimmer animation', (tester) async { ... });
testWidgets('skeleton respects disableAnimations', (tester) async { ... });
```

Skeleton screens for: pipeline list, income list (if exposed), wallet list.

### USD Conversion Sanity (P5.13)
```dart
// If user enters USD amount with manual conversion rate:
// If rate > 1.2× 90-day avg OR rate < 0.8× 90-day avg:
// Show warning: "This rate is significantly different from recent entries. Double-check?"
```

### Exit Gate
- [ ] All empty states have friendly copy
- [ ] Error states are branded (not default Flutter)
- [ ] Skeleton screens on 3 list screens
- [ ] USD conversion sanity validation works

---

## Phase 5 Exit Gate

```
[ ] Multi-wallet: create, edit, delete, transfer (record-only)
[ ] S2S aggregates from all wallets
[ ] State colors on hero
[ ] Duplicate-last-entry works
[ ] Skeleton screens on async lists
[ ] USD sanity validation
[ ] 15+ new tests pass
[ ] dart analyze 0/0/0
```

## Score projection after Phase 5

| Dimension | Before | After | Delta |
|---|---|---|---|
| Cognitive load management | 90 | 93 | +3 (duplicate template, skeletons) |
| Celebration & reinforcement | 50 | 60 | +10 (state colors, ETA) |
| **Behavioral Total** | **90** | **93** | **+3** |
| Empty/Loading states | 9/10 | 10/10 | +1 (skeletons) |
| Dark mode | 8/10 | 9/10 | +1 (state colors) |
| **UI/UX Total** | **93** | **95** | **+2** |
