# TDD + Clean Architecture Dispatch — Phase 6: V2 Features (Final Push to 100%)

> Date: 2026-06-12
> Reference: `docs/planning/100_PERCENT_MASTER_PLAN.md`
> Status: Dispatch plan — implementation not yet started
> ⚠️ GATED: V1 stable 2+ weeks. Invoice PDF pre-validated by 5 real clients. Legal L5. Pricing validated ≥50% at ৳299/month.
> Effort: ~20 hours, 4 sprints
> Agent lead: Antigravity
> Review agents: UX Architect, UI Designer, Brand Guardian, Persona Walkthrough, Inclusive Visuals, Behavioral Nudge Engine
> Target: Behavioral 93→95, UI/UX 95→98, Trust Layer 33→35

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

## GROUP 6A — Invoice-Lite Sprint 1: Form + List (P6.1–P6.3)

**Files touched (new feature):**
- `lib/features/invoices/domain/entities/invoice_entity.dart`
- `lib/features/invoices/data/models/invoice_model.dart` (Hive TypeAdapter)
- `lib/features/invoices/data/repositories/invoice_repository_impl.dart`
- `lib/features/invoices/presentation/views/invoice_form_screen.dart`
- `lib/features/invoices/presentation/views/invoice_list_screen.dart`
- `lib/features/invoices/presentation/providers/invoice_providers.dart`

### TDD Approach

```dart
// test/features/invoices/domain/invoice_entity_test.dart
test('InvoiceEntity sequential numbering: first invoice is INV-001', () {
  final invoice = InvoiceEntity(number: 1, ...);
  expect(invoice.displayNumber, equals('INV-001'));
});

test('InvoiceEntity stores TIN, freelancerId, BDT-equivalent display', () { ... });

// test/features/invoices/data/invoice_repository_impl_test.dart
test('create invoice → persisted to Hive', () async { ... });
test('getNextInvoiceNumber returns correct sequential number', () async { ... });
test('sequential numbers never reused after deletion', () async { ... });

// test/features/invoices/presentation/invoice_form_test.dart
testWidgets('client selector, line items, amounts, currency', (tester) async { ... });
testWidgets('BDT-equivalent auto-calculated from current FX rate', (tester) async { ... });
testWidgets('TIN field validates format', (tester) async { ... });
```

### Data Model

```dart
class InvoiceEntity {
  final String id;
  final int sequentialNumber;        // Auto-increment, never reused
  final String clientName;
  final String clientEmail;
  final String tin;                  // User's TIN
  final String freelancerId;         // Freelancer registration/ID
  final List<InvoiceLineItem> lineItems;
  final String currency;
  final double fxRate;               // Manual BDT equivalent rate
  final DateTime issueDate;
  final DateTime dueDate;
  final InvoiceStatus status;        // draft / sent / paid / overdue
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### Clean Architecture
```
features/invoices/
├── domain/
│   ├── entities/invoice_entity.dart     # Pure Dart
│   ├── entities/invoice_line_item.dart
│   └── repositories/invoice_repository.dart
├── data/
│   ├── models/invoice_model.dart        # HiveObject + TypeAdapter
│   └── repositories/invoice_repository_impl.dart
└── presentation/
    ├── providers/invoice_providers.dart
    ├── views/invoice_form_screen.dart
    └── views/invoice_list_screen.dart
```

### Exit Gate
- [ ] Invoice form: client + line items + amounts + currency
- [ ] Invoice list with status filter (draft/sent/paid/overdue)
- [ ] Sequential numbering (INV-001, INV-002...)
- [ ] Numbers never reused
- [ ] 8+ new invoice tests pass
- [ ] `dart analyze` 0/0/0

---

## GROUP 6B — Invoice-Lite Sprint 2: PDF + Email (P6.4–P6.6)

### TDD Approach

```dart
// test/features/invoices/data/invoice_pdf_generator_test.dart
test('PDF contains TIN, freelancerId, BDT equivalent, client details', () async {
  final pdf = await Generator.generate(invoice);
  expect(pdf, isNotNull);
  // Parse PDF text to verify required fields present
});

test('PDF layout matches Bangladeshi invoice conventions', () async { ... });
test('PDF handles multi-line items', () async { ... });
test('PDF handles invoices with 10+ line items without overflow', () async { ... });

// test/features/invoices/presentation/invoice_email_test.dart
testWidgets('email button opens mailto: with PDF attachment path', (tester) async { ... });
```

### Exit Gate
- [ ] PDF generated with proper layout (TIN, freelancerId, BDT equivalent)
- [ ] PDF handles edge cases (many line items, long names, special characters)
- [ ] Email delivery via url_launcher (mailto:)
- [ ] Invoice audit log: created, sent, marked paid, edited
- [ ] 6+ new PDF + email tests pass

---

## GROUP 6C — Invoice-Lite Sprint 3: Pipeline Cascade + Clients (P6.7–P6.10)

### TDD Approach

```dart
// test/features/invoices/presentation/invoice_pipeline_cascade_test.dart
test('creating invoice generates pipeline entry (expected status)', () async {
  await invoiceNotifier.create(draft);
  final pipeline = pipelineRepo.getAll();
  expect(pipeline.any((e) => e.sourceInvoiceId == invoice.id), isTrue);
});

test('marking pipeline as received → marks linked invoice as paid', () async {
  // Confirm received on pipeline entry
  // Linked invoice status → paid
  // Both audit-logged
});

test('deleting invoice cascading: does NOT auto-delete pipeline entry', () async {
  // Pipeline entry remains — user manually manages
});

// test/features/invoices/domain/client_entity_test.dart
test('ClientEntity stores name, email, default currency, payment terms', () {
  final client = ClientEntity(
    id: 'c1',
    name: 'Acme Corp',
    email: 'billing@acme.com',
    defaultCurrency: 'USD',
    defaultPaymentTerms: 30, // net-30
  );
  expect(client.defaultPaymentTerms, equals(30));
});

// test/features/invoices/presentation/overdue_flagging_test.dart
testWidgets('overdue invoice shows red flag + reminder button', (tester) async { ... });
testWidgets('reminder button shows pre-filled email template', (tester) async { ... });
```

### Data Models

```dart
class ClientEntity {
  final String id;
  final String name;
  final String email;
  final String defaultCurrency; // USD/BDT
  final int defaultPaymentTerms; // net-15, net-30, net-45
}

// Extend IncomeEntryEntity:
// final String? sourceInvoiceId;  // Links pipeline entry back to invoice
```

### Cascade Rules
1. Create invoice → auto-generate pipeline entry (Expected, 14-day horizon)
2. Pipeline marked "Received" → linked invoice auto-marked "paid"
3. Pipeline entry deleted → invoice unaffected (user manages separately)
4. Pipeline entry amount changed → invoice unaffected (invoice is source of truth)
5. Both changes audit-logged independently

### Exit Gate
- [ ] Invoice → pipeline auto-entry works
- [ ] Pipeline → invoice status sync (received → paid)
- [ ] Client profiles: create, edit, select on invoice form
- [ ] Overdue flagging: red visual + reminder email template
- [ ] Cascade rules 1-5 verified with tests
- [ ] 10+ new cascade + client tests pass

---

## GROUP 6D — Tax Reserve (P6.11–P6.15)

**Files touched:**
- `lib/features/safe_to_spend/domain/entities/sts_settings.dart` (modify — add taxReservePercent)
- `lib/features/safe_to_spend/domain/safe_to_spend_calculator.dart` (modify — tax deduction)
- `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart` (modify — slider + disclaimer)
- Test files (S2S calculator tests — add tax reserve deduction)

### TDD Approach

```dart
// test/features/safe_to_spend/domain/safe_to_spend_calculator_tax_test.dart
test('tax reserve = taxReservePercent × totalReceivedIncomeBdt', () {
  calculator.updateSettings(StsSettings(taxReservePercent: 10, ...));
  // totalReceivedIncomeBdt = 100,000 → taxReserve = 10,000
  // S2S = liquid - taxReserve - fixedCosts - buffer
  expect(result.taxReserve, equals(10000));
});

test('tax reserve at 0% → no deduction', () { ... });
test('tax reserve bounded 0-30%', () { ... });
test('tax reserve changes are audit-logged', () {
  // Change from 10% → 15%
  // Audit log entry: taxReservePercent: 10 → 15
});
```

### Disclaimer (Brand Guardian)
```
⚠️ This is not tax advice. Pocketa's tax reserve is a savings reminder,
not a tax calculation. Consult a tax practitioner for your actual liability.
```

The disclaimer must appear:
- Below the tax reserve slider in STS Settings
- In the S2S breakdown when taxReservePercent > 0
- On first tax reserve setup (one-time dialog the user must acknowledge)

### Exit Gate
- [ ] Tax reserve slider: 0-30%, default 0%
- [ ] S2S formula includes tax reserve deduction
- [ ] Disclaimer visible in 3 locations
- [ ] Audit-logged every % change
- [ ] 4+ new tax tests pass

---

## GROUP 6E — Paid Tier Activation (P6.16–P6.20)

**Files touched (new):**
- `lib/features/subscription/domain/entities/subscription_tier.dart` (enum)
- `lib/features/subscription/domain/feature_gate.dart` (pure Dart gate logic)
- `lib/features/subscription/presentation/views/pricing_screen.dart`
- `lib/features/subscription/presentation/providers/subscription_providers.dart`
- Various feature screens (modify — add paywall triggers)

### Feature Gate Matrix

| Feature | Free | Pro (৳299/mo) | Power (৳599/mo) |
|---------|------|---------------|-----------------|
| S2S + pipeline | ✅ | ✅ | ✅ |
| Fixed costs | ✅ | ✅ | ✅ |
| Single wallet | ✅ | ✅ | ✅ |
| 5 pipeline entries/month | ✅ | ✅ | ✅ |
| Multi-wallet (5+) | ❌ | ✅ | ✅ |
| Unlimited pipeline entries | ❌ | ✅ | ✅ |
| Invoice-Lite | ❌ | ✅ | ✅ |
| Tax reserve | ❌ | ✅ | ✅ |
| CSV export | ❌ | ✅ | ✅ |
| Priority support | ❌ | ❌ | ✅ |
| Reports/analytics | ❌ | ❌ | ✅ |
| Annual pricing | — | ৳2,499/yr | ৳4,999/yr |

### TDD Approach

```dart
// test/features/subscription/domain/feature_gate_test.dart
test('Free tier: multi-wallet disabled', () {
  final gate = FeatureGate(SubscriptionTier.free);
  expect(gate.isEnabled(Feature.multiWallet), isFalse);
});

test('Pro tier: multi-wallet enabled, reports disabled', () {
  final gate = FeatureGate(SubscriptionTier.pro);
  expect(gate.isEnabled(Feature.multiWallet), isTrue);
  expect(gate.isEnabled(Feature.reports), isFalse);
});

test('Power tier: all features enabled', () {
  final gate = FeatureGate(SubscriptionTier.power);
  expect(gate.isEnabled(Feature.reports), isTrue);
});

// test/features/subscription/presentation/paywall_test.dart
testWidgets('paywall triggers when free user tries second wallet', (tester) async {
  // Navigate to add wallet → paywall dialog shown
  // "Upgrade to Pro to add more wallets" heading
});

testWidgets('pricing screen shows monthly vs annual comparison', (tester) async { ... });
testWidgets('free tier stays free forever — no trial expiry', (tester) async { ... });
```

### Clean Architecture

FeatureGate is a pure Dart domain concern:

```dart
// lib/features/subscription/domain/feature_gate.dart
enum SubscriptionTier { free, pro, power }

enum Feature {
  multiWallet,
  unlimitedPipeline,
  invoiceLite,
  taxReserve,
  csvExport,
  reports,
  prioritySupport,
}

class FeatureGate {
  const FeatureGate(this.tier);
  final SubscriptionTier tier;

  bool isEnabled(Feature feature) => feature.minimumTier.index <= tier.index;
}
```

Provider in presentation:
```dart
final featureGateProvider = Provider<FeatureGate>((ref) {
  final tier = ref.watch(subscriptionTierProvider);
  return FeatureGate(tier);
});
```

UI condition:
```dart
final gate = ref.watch(featureGateProvider);
if (!gate.isEnabled(Feature.multiWallet)) {
  showDialog(context: context, builder: (_) => PaywallDialog(feature: 'multi-wallet'));
}
```

### Exit Gate
- [ ] Free: S2S + pipeline + single wallet + 5 entries/month (stays free forever)
- [ ] Pro: full access (৳299/mo or ৳2,499/yr)
- [ ] Power: reports + priority support (৳599/mo or ৳4,999/yr)
- [ ] Paywall triggers correctly per feature
- [ ] Pricing screen: tier comparison, monthly vs annual
- [ ] 8+ new tier tests pass
- [ ] `dart analyze` 0/0/0

---

## GROUP 6F — Final 100% Polish (P6.21–P6.28)

### Accessibility Audit (P6.21)
Every screen, every interactive element — Semantics label, contrast, touch target ≥44pt, Tab order logical. Inclusive Visuals leads.

### Dark Mode Pass (P6.22)
Verify every screen in dark mode. Hand-tuned tokens from PocketaColors.dark. No hardcoded light-mode-only colors. UI Designer leads.

### Haptic Audit (P6.23)
Every tappable action confirmed: PIN taps, confirm, delete, errors, card taps, slider changes, form submissions. Behavioral Nudge Engine leads.

### Semantics Audit (P6.24)
Screen reader path through full user journey: App open → Splash → PIN → Dashboard → Pipeline → Add Entry → Settings → Back. Inclusive Visuals leads.

### Performance (P6.25)
```dart
// test/features/dashboard/presentation/s2s_performance_test.dart
test('S2S loads in <2 seconds on reference device (A14)', () async {
  final stopwatch = Stopwatch()..start();
  await tester.pumpWidget(ProviderScope(child: MaterialApp(home: DashboardScreen())));
  await tester.pumpAndSettle();
  stopwatch.stop();
  expect(stopwatch.elapsedMilliseconds, lessThan(2000));
});
```
UX Architect leads.

### Full Test Suite (P6.26)
Run all 150+ tests. Antigravity verifies all passing, no flaky tests.

### dart analyze (P6.27)
Final 0/0/0 verification. Antigravity.

### Documentation (P6.28)
Update ROADMAP.md, PROJECT_STATE.md, DECISION_LOG.md, TASKS.md. All agents. Per taste preference: documentation is the operating memory of the product.

### Exit Gate
- [ ] WCAG AA compliance on every screen
- [ ] Dark mode on every screen — no light-mode-only colors
- [ ] Haptics on every tappable action
- [ ] Screen reader path: full user journey readable
- [ ] S2S loads <2s on reference device
- [ ] 150+ total tests, all passing, zero flaky
- [ ] `dart analyze` 0/0/0
- [ ] All tracking docs updated

---

## Phase 6 Exit Gate (FINAL — 100% Maturity)

```
[ ] Invoice-Lite: create → PDF → email → auto-pipeline → status sync → full audit trail
[ ] Invoice PDF accepted by 5 real clients
[ ] Tax reserve: user-declared %, audit-logged, disclaimed
[ ] Paid tiers: Free/Pro/Power with feature gates, Free stays free forever
[ ] 150+ tests pass (total across all phases)
[ ] All Semantics present, all WCAG AA contrast
[ ] Dark mode comprehensive — every screen verified
[ ] Haptics on every tappable action
[ ] S2S <2s on reference Android device
[ ] dart analyze 0/0/0
[ ] Final score: Behavioral 95/100, UI/UX 98/100, Trust Layer 35/35
```

## Score projection after Phase 6 (FINAL)

| Dimension | Score | Notes |
|---|---|---|
| Psychological framing | 95/100 | V1/V2 polish, FX rate framing, tax reserve framing |
| Cognitive load management | 98/100 | Micro-sprint decomposition, next-best-action, skeletons, templates |
| Cadence & personalization | 95/100 | Full notification system, adaptive cadence, time-of-day awareness |
| Default bias | 90/100 | Smart defaults from onboarding, pattern-learning, percentage buffer |
| Nudge delivery mechanisms | 95/100 | Push + in-app + center + scheduled + adaptive + transactional ETA |
| Analytics & behavioral data | 95/100 | Full event pipeline, persistence, nudge tracking, cohorting-ready |
| Opt-out & user freedom | 92/100 | Global skip, notification opt-out, account deletion, honest disqualification |
| Celebration & reinforcement | 90/100 | Quiet affirmation tier, relief signals, milestone whispers, state colors |
| **Behavioral Total** | **95/100** | |
| Color palette | 10/10 | All contrast ratios ≥4.5:1. Dark mode comprehensive. |
| Typography | 9/10 | Excellent (3-font loading overhead = -1) |
| Spacing/Layout | 10/10 | 8pt grid, consistent, next-best-action card, notification center |
| Accessibility | 10/10 | Full Semantics, WCAG AA, reduced-motion, TextScaler.noScaling |
| Motion | 9/10 | Strict, centralized, reduced-motion compliant (splash delay = -1) |
| Touch/Interaction | 10/10 | Full haptics, active states, stepper buttons, 44pt targets |
| Empty/Loading states | 10/10 | Empty states + skeleton screens + error states + quiet affirmations |
| Dark mode | 10/10 | Hand-tuned, all tokens verified, interactive contrast fixed |
| Navigation | 10/10 | Clean 3-tab + notification center + settings IA improved |
| **UI/UX Total** | **98/100** | |

**Why not 100/100?** Typography loses 1 point for 3-font loading overhead. Motion loses 1 point because splash delay is intentionally long (brand moment). Psychological framing loses 5 because gamification is deliberately absent (correct for Pocketa's clinical-warm brand, but score ceiling is lower by design).
