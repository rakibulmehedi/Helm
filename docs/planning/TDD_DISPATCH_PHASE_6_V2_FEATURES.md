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

RED: Write failing test → GREEN: Minimal implementation → REFACTOR: Clean architecture guard

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

**New files:**
- `lib/features/invoices/domain/entities/invoice_entity.dart`
- `lib/features/invoices/data/models/invoice_model.dart` (Hive TypeAdapter)
- `lib/features/invoices/data/repositories/invoice_repository_impl.dart`
- `lib/features/invoices/presentation/views/invoice_form_screen.dart`
- `lib/features/invoices/presentation/views/invoice_list_screen.dart`
- `lib/features/invoices/presentation/providers/invoice_providers.dart`

### Test Files

- `test/features/invoices/domain/invoice_entity_test.dart` — sequential numbering (INV-001), TIN, BDT-equivalent
- `test/features/invoices/data/invoice_repository_impl_test.dart` — persist to Hive, `getNextInvoiceNumber`, no reuse after deletion
- `test/features/invoices/presentation/invoice_form_test.dart` — client selector, line items, BDT auto-calc, TIN format validation

// see implementation

### InvoiceEntity Fields

Fields: `id`, `sequentialNumber` (auto-increment, never reused), `clientName`, `clientEmail`, `tin`, `freelancerId`, `lineItems`, `currency`, `fxRate` (manual), `issueDate`, `dueDate`, `status` (draft/sent/paid/overdue), `createdAt`, `updatedAt`.

### Clean Architecture Layout
```
features/invoices/
├── domain/
│   ├── entities/invoice_entity.dart
│   ├── entities/invoice_line_item.dart
│   └── repositories/invoice_repository.dart
├── data/
│   ├── models/invoice_model.dart
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

### Test Files

- `test/features/invoices/data/invoice_pdf_generator_test.dart` — PDF contains TIN/freelancerId/BDT, Bangladeshi layout, multi-line items, 10+ items no overflow
- `test/features/invoices/presentation/invoice_email_test.dart` — email button opens `mailto:` with PDF attachment path

// see implementation

### Exit Gate
- [ ] PDF generated with proper layout (TIN, freelancerId, BDT equivalent)
- [ ] PDF handles edge cases (many line items, long names, special characters)
- [ ] Email delivery via `url_launcher` (mailto:)
- [ ] Invoice audit log: created, sent, marked paid, edited
- [ ] 6+ new PDF + email tests pass

---

## GROUP 6C — Invoice-Lite Sprint 3: Pipeline Cascade + Clients (P6.7–P6.10)

### Test Files

- `test/features/invoices/presentation/invoice_pipeline_cascade_test.dart`:
  - creating invoice → pipeline entry (Expected status)
  - pipeline Received → linked invoice auto-marked paid
  - deleting invoice → pipeline entry NOT deleted (user manages)
- `test/features/invoices/domain/client_entity_test.dart` — ClientEntity: name, email, defaultCurrency, defaultPaymentTerms
- `test/features/invoices/presentation/overdue_flagging_test.dart` — red flag + reminder button + pre-filled email template

// see implementation

### Cascade Rules
1. Create invoice → auto-generate pipeline entry (Expected, 14-day horizon)
2. Pipeline marked "Received" → linked invoice auto-marked "paid"
3. Pipeline entry deleted → invoice unaffected
4. Pipeline entry amount changed → invoice unaffected (invoice is source of truth)
5. Both changes audit-logged independently

### ClientEntity Fields

Fields: `id`, `name`, `email`, `defaultCurrency` (USD/BDT), `defaultPaymentTerms` (net-15/30/45).

`IncomeEntryEntity` extended with: `final String? sourceInvoiceId`.

### Exit Gate
- [ ] Invoice → pipeline auto-entry works
- [ ] Pipeline → invoice status sync (received → paid)
- [ ] Client profiles: create, edit, select on invoice form
- [ ] Overdue flagging: red visual + reminder email template
- [ ] Cascade rules 1-5 verified with tests
- [ ] 10+ new cascade + client tests pass

---

## GROUP 6D — Tax Reserve (P6.11–P6.15)

**Modified files:**
- `lib/features/safe_to_spend/domain/entities/sts_settings.dart` — add `taxReservePercent`
- `lib/features/safe_to_spend/domain/safe_to_spend_calculator.dart` — tax deduction
- `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart` — slider + disclaimer

### Test Files

- `test/features/safe_to_spend/domain/safe_to_spend_calculator_tax_test.dart`:
  - `taxReserve = taxReservePercent × totalReceivedIncomeBdt`
  - 0% → no deduction
  - bounded 0-30%
  - % changes are audit-logged

// see implementation

### Disclaimer (3 required locations)

```
⚠️ This is not tax advice. Helm's tax reserve is a savings reminder,
not a tax calculation. Consult a tax practitioner for your actual liability.
```

Locations: below slider in STS Settings, in S2S breakdown when `taxReservePercent > 0`, one-time acknowledgment dialog on first setup.

### Exit Gate
- [ ] Tax reserve slider: 0-30%, default 0%
- [ ] S2S formula includes tax reserve deduction
- [ ] Disclaimer visible in 3 locations
- [ ] Audit-logged every % change
- [ ] 4+ new tax tests pass

---

## GROUP 6E — Paid Tier Activation (P6.16–P6.20)

**New files:**
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

### Test Files

- `test/features/subscription/domain/feature_gate_test.dart`:
  - Free: multi-wallet disabled
  - Pro: multi-wallet enabled, reports disabled
  - Power: all features enabled
- `test/features/subscription/presentation/paywall_test.dart`:
  - paywall triggers when free user adds second wallet
  - pricing screen monthly vs annual comparison
  - free tier stays free forever (no trial expiry)

// see implementation

`FeatureGate` is pure Dart domain concern. `featureGateProvider` wraps it in Riverpod. UI reads `ref.watch(featureGateProvider)` and calls `gate.isEnabled(Feature.X)`.

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

| Task | Lead | Requirement |
|---|---|---|
| Accessibility audit (P6.21) | Inclusive Visuals | Semantics label, contrast, 44pt touch targets, Tab order on all 15+ screens |
| Dark mode pass (P6.22) | UI Designer | Every screen in dark mode, hand-tuned HelmColors.dark, no hardcoded light-mode colors |
| Haptic audit (P6.23) | Behavioral Nudge Engine | Every tappable: PIN, confirm, delete, errors, card, slider, form submit. No double-fire. |
| Semantics audit (P6.24) | Inclusive Visuals | Screen reader path: App → Splash → PIN → Dashboard → Pipeline → Add Entry → Settings |
| Performance (P6.25) | UX Architect | S2S loads <2s on reference device (Galaxy A14). Test file: `test/features/dashboard/presentation/s2s_performance_test.dart` |
| Full test suite (P6.26) | Antigravity | All 150+ tests pass, zero flaky |
| dart analyze (P6.27) | Antigravity | Final 0/0/0 verification |
| Documentation (P6.28) | All agents | ROADMAP.md, PROJECT_STATE.md, DECISION_LOG.md, TASKS.md updated |

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

## Score Projection After Phase 6 (FINAL)

| Dimension | Score | Notes |
|---|---|---|
| Psychological framing | 95/100 | V1/V2 polish, FX rate framing, tax reserve framing |
| Cognitive load management | 98/100 | Decomposition, next-best-action, skeletons, templates |
| Cadence & personalization | 95/100 | Full notification system, adaptive cadence, time-of-day |
| Default bias | 90/100 | Smart defaults, pattern-learning, percentage buffer |
| Nudge delivery | 95/100 | Push + in-app + center + scheduled + adaptive + ETA |
| Analytics | 95/100 | Full event pipeline, persistence, nudge tracking |
| Opt-out & user freedom | 92/100 | Global skip, notification opt-out, deletion, honest disqualification |
| Celebration | 90/100 | Quiet affirmation, relief signals, milestone whispers, state colors |
| **Behavioral Total** | **95/100** | |
| Color palette | 10/10 | All contrast ≥4.5:1. Dark mode comprehensive. |
| Typography | 9/10 | 3-font loading overhead = -1 |
| Spacing/Layout | 10/10 | 8pt grid, consistent |
| Accessibility | 10/10 | Full Semantics, WCAG AA, reduced-motion, TextScaler |
| Motion | 9/10 | Reduced-motion compliant (splash delay = -1) |
| Touch/Interaction | 10/10 | Full haptics, active states, stepper buttons, 44pt |
| Empty/Loading states | 10/10 | Empty + skeleton + error + quiet affirmations |
| Dark mode | 10/10 | Hand-tuned, all tokens verified |
| Navigation | 10/10 | Clean 3-tab + notification center + settings IA |
| **UI/UX Total** | **98/100** | |

**Why not 100/100?** Typography -1 (3-font overhead). Motion -1 (intentional splash delay). Psychological framing -5 (gamification deliberately absent — correct for Helm's clinical-warm brand).
