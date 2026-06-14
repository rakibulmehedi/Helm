# TDD + Clean Architecture Dispatch — Phase 4: Doctrine Gap Closure (100% MVP)

> Date: 2026-06-12
> Reference: `docs/planning/100_PERCENT_MASTER_PLAN.md`
> Status: Dispatch plan — implementation not yet started
> Depends on: Phase 0 (beta launched)
> Critical gates: Backend stack decision (Chief Architect by end of Phase 0). Legal opinions L1-L7. `local_auth` package approval. Magic Link provider selected.
> Effort: ~20 hours, 3-4 sprints
> Agent lead: Antigravity (full-stack: Flutter frontend + backend API)
> Review agents: UX Architect, UX Researcher, Persona Walkthrough, Brand Guardian
> Target: Behavioral 82→90, UI/UX 89→93, MVP Feature Completion 87%→100%

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

## GROUP 4A — Auth System (P4.1–P4.9)

**⚠️ Pre-flight:** Backend stack MUST be decided before GROUP 4A starts.
**⚠️ Pre-flight:** Magic Link provider (Resend/Postmark) MUST be selected.
**⚠️ Pre-flight:** Legal opinions L1-L7 obtained (Doctrine §10).

### TDD Approach

Auth is cross-platform (Flutter frontend + backend API). Test layers:

```dart
// Backend (Supabase Edge Function / Next.js API route):
// test/auth/send_magic_link_test.dart
test('POST /auth/send-magic-link rate-limited to 3/min/email', () async { ... });
test('POST /auth/send-magic-link rejects invalid email formats', () async { ... });
test('POST /auth/send-magic-link returns 202 Accepted (does not reveal email existence)', () async { ... });

// test/auth/verify_magic_link_test.dart
test('POST /auth/verify-magic-link with valid token → returns session token', () async { ... });
test('POST /auth/verify-magic-link with expired token (>15 min) → returns 401', () async { ... });
test('POST /auth/verify-magic-link with used token → returns 401 (single-use)', () async { ... });

// Flutter frontend:
// test/features/auth/presentation/magic_link_screen_test.dart
testWidgets('enter email → "check your inbox" screen appears', (tester) async { ... });
testWidgets('shows error when email is empty', (tester) async { ... });

// test/features/auth/providers/auth_notifier_test.dart
test('session does not expire on app restart (token persisted)', () async { ... });
test('logout clears session token', () async { ... });
```

### Architecture: Feature-first

```
lib/features/auth/
├── data/
│   ├── datasources/auth_remote_data_source.dart       # API calls
│   ├── models/session_model.dart                       # Hive TypeAdapter
│   └── repositories/auth_repository_impl.dart
├── domain/
│   ├── entities/session_entity.dart                    # Token + expiry + userId
│   └── repositories/auth_repository.dart               # Abstract
└── presentation/
    ├── providers/auth_provider.dart                    # Riverpod auth state
    ├── views/magic_link_screen.dart
    └── views/biometric_pin_screen.dart
```

### Clean Architecture Enforcement

- `AuthRemoteDataSource` calls backend API — NEVER called from UI
- `AuthRepositoryImpl` manages session token in Hive
- `AuthNotifier` exposes `isAuthenticated` stream
- GoRouter redirect guard: `ref.watch(authProvider).whenOrNull(data: (s) => s == null ? '/magic-link' : null)`

### Exit Gate
- [ ] Magic Link: can request, receive email, click link, get authenticated
- [ ] Rate limiting enforced (3 requests/min/email)
- [ ] Token single-use + 15-min TTL
- [ ] Session persists across app restarts
- [ ] Logout clears session
- [ ] Biometric + PIN gate on every cold start
- [ ] PIN fallback for devices without biometric
- [ ] GoRouter redirect: no session → /magic-link
- [ ] 15+ new auth tests pass

---

## GROUP 4B — Conversational Onboarding Rebuild (P4.10–P4.15)

**Files touched (rebuild):**
- `lib/features/onboarding/presentation/views/onboarding_screen.dart` (total rebuild)
- All onboarding page files (rebuild conversational)
- `lib/features/onboarding/presentation/providers/onboarding_state_provider.dart`

### TDD Approach

```dart
// test/features/onboarding/presentation/onboarding_flow_test.dart
testWidgets('qualifier question appears first', (tester) async {
  await tester.pumpWidget(OnboardingScreen());
  expect(find.text('Have you ever spent money thinking a payment cleared, then realized it hadn\'t?'), findsOneWidget);
});

testWidgets('disqualification screen appears when user says no to qualifier', (tester) async {
  await tester.tap(find.text('No, I always know exactly what cleared'));
  await tester.pumpAndSettle();
  expect(find.textContaining('Helm is built for USD-earning freelancers in Bangladesh'), findsOneWidget);
});

testWidgets('conversational: each answer reveals next question', (tester) async { ... });

testWidgets('completes in ≤3 minutes with simulated Rafiq speed', (tester) async {
  // Measure: time from Welcome to Dashboard < 3:00
});
```

### Conversational Flow

```
Step 1: "Have you ever spent money thinking a payment cleared, then realized it hadn't?"
        → Yes → Step 2
        → No → Disqualification: "Helm is built for USD-earning freelancers in Bangladesh."

Step 2: "How much BDT do you have right now across all your accounts?" → Number input

Step 3: "What fixed costs come out of that regularly?" → List: add name + amount + due day

Step 4: "How does your income usually arrive?"
        → "Every week" / "Every 2 weeks" / "Once a month" / "It varies a lot"

Step 5: "How much cushion do you like to keep?"
        → "None — I track every taka" / "A small buffer" / "A good amount"

Step 6: "Any money you're expecting soon?" → Yes → enter amount + client name → pipeline entry

Step 7: Complete → Dashboard (no celebration screen, per ONB-014)
```

### Exit Gate
- [ ] Qualifier appears first, disqualification works
- [ ] 7-step conversational flow (not form-fill)
- [ ] Rafiq completes onboarding in ≤3 minutes unaided
- [ ] Persona Walkthrough confirmed
- [ ] Copy reviewed by Brand Guardian
- [ ] No confetti, no "Welcome!", no tour (ONB-014)
- [ ] 8+ new onboarding tests pass

---

## GROUP 4C — FX Rate + Exclude Toggle (P4.16–P4.19)

**Files touched:**
- `lib/features/income/domain/entities/income_entry_entity.dart` (modify — add fxRate, isExcluded)
- `lib/features/income/data/models/income_model.dart` (modify — sync fields)
- `lib/features/income/presentation/views/add_income_screen.dart` (modify)
- `lib/features/income/presentation/views/income_list_screen.dart` (modify)
- `lib/features/income/presentation/widgets/income_entry_card.dart` (modify)

### TDD Approach

```dart
// test/features/income/domain/income_entry_entity_test.dart
test('fxRate is nullable, stored as user-entered value', () {
  final entry = IncomeEntryEntity(..., fxRate: 111.5);
  expect(entry.fxRate, equals(111.5));
});

test('isExcludedFromS2S defaults to false', () { ... });
test('USD entries without fxRate are excluded from S2S by calculator', () { ... });
test('BDT entries with exclude toggle → not counted in S2S', () { ... });
```

### Implementation

```dart
class IncomeEntryEntity {
  final String id;
  final String clientName;
  final String projectName;
  final double amount;
  final String currency;
  final IncomeStatus status;
  final DateTime expectedDate;
  final double? fxRate;          // NEW — user-entered, nullable
  final bool isExcludedFromS2S;   // NEW — user-controlled
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### Exit Gate
- [ ] FX rate field appears for USD income entries
- [ ] Exclude toggle appears on every income entry card + edit screen
- [ ] S2S calculator respects fxRate and isExcludedFromS2S
- [ ] 6+ new tests pass

---

## GROUP 4D — Buffer Percentage Conversion (P4.20–P4.23)

**Files touched:**
- `lib/features/safe_to_spend/domain/entities/sts_settings.dart` (modify)
- `lib/features/safe_to_spend/domain/safe_to_spend_calculator.dart` (modify)
- `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart` (modify)
- `lib/features/onboarding/presentation/views/pages/buffer_comfort_page.dart` (modify)
- Test files (update all 30 S2S calculator tests)

### TDD Approach

```dart
// test/features/safe_to_spend/domain/safe_to_spend_calculator_test.dart
test('15% buffer: buffer = 0.15 × totalReceivedIncomeBdt', () {
  calculator.updateSettings(StsSettings(bufferPercent: 15.0));
  // totalReceivedIncomeBdt = 100,000 → buffer = 15,000
  expect(result.anxietyBuffer, equals(15000));
});

test('buffer percent at min (5%)', () { ... });
test('buffer percent at max (30%)', () { ... });
test('buffer percent at 0 (no buffer)', () { ... });
test('buffer percent rejects values outside 0-30 range', () {
  expect(() => StsSettings(bufferPercent: -1), throwsA(isA<AssertionError>()));
  expect(() => StsSettings(bufferPercent: 31), throwsA(isA<AssertionError>()));
});
```

### Implementation

```dart
class StsSettings {
  final double taxRate;
  final double bufferPercent; // NEW: 0-30%, default 15%

  const StsSettings({
    this.taxRate = 10.0,
    this.bufferPercent = 15.0,
  }) : assert(bufferPercent >= 0 && bufferPercent <= 30, 'bufferPercent must be 0-30');
}

// In SafeToSpendCalculator:
double _computeBuffer(double totalReceivedIncomeBdt) {
  return (settings.bufferPercent / 100.0) * totalReceivedIncomeBdt;
}
```

### Migration
```dart
// On first load after migration:
// Read old anxietyBuffer absolute value, convert to percentage:
// bufferPercent = (oldAnxietyBuffer / totalReceivedIncomeBdt) × 100
// Clamp to 0-30 and save
```

### Exit Gate
- [ ] All 30 existing S2S calculator tests updated for percentage
- [ ] 5 new buffer percent tests pass
- [ ] Buffer slider in STS Settings shows 0-30%, default 15%
- [ ] Buffer slider in onboarding shows percentage label
- [ ] Old absolute BDT migrated to percentage on first load

---

## GROUP 4E — Instrumentation Hardening (P4.24–P4.28)

5 new events added to `event_registry.dart`. Wired at correct trigger points.

| Event | Trigger Point | File |
|-------|--------------|------|
| `notification_opened` | Tapping notification | `notification_center_screen.dart` |
| `notification_resulted_in_update` | Pipeline update within 30min of notification open | `income_notifier.dart` |
| `onboarding_step_completed` | Each onboarding step advance (with step number) | `onboarding_screen.dart` |
| `time_to_s2s_visible` | Dashboard mount → S2S hero rendered (stopwatch in initState) | `dashboard_screen.dart` |
| `s2s_calc_failure` | Calculator throws exception | `safe_to_spend_calculator.dart` catch |
| `data_export_requested` | Export initiated | `export_screen.dart` |
| `account_deletion_requested` | Deletion confirmation opened | `settings_screen.dart` |

### Exit Gate
- [ ] 7 new events fire correctly (verified via debugPrint in test)
- [ ] `time_to_s2s_visible` measures < 2 seconds on reference device
- [ ] `s2s_calc_failure` never fires in normal operation

---

## Phase 4 Exit Gate

```
[ ] Magic Link auth: sign up → email → verify → authenticated → session persists
[ ] PIN + biometric enforced on every cold start
[ ] Conversational onboarding: 7 steps, ≤3 min, includes qualifier + disqualification
[ ] Per-entry FX rate field present and functioning
[ ] Exclude-entry toggle on every pipeline entry
[ ] Buffer is percentage-based (0-30%, default 15%)
[ ] All beta instrumentation events fire correctly
[ ] Persona Walkthrough: Rafiq completes onboarding ≤3 min unaided
[ ] dart analyze 0/0/0
[ ] 40+ new tests pass (auth + onboarding + FX + buffer + instrumentation)
[ ] Backend stack decided and running
[ ] Legal L1-L7 obtained
```

## Score projection after Phase 4

| Dimension | Before | After | Delta |
|---|---|---|---|
| Cognitive load management | 88 | 90 | +2 |
| Cadence & personalization | 75 | 80 | +5 |
| Default bias | 80 | 85 | +5 (smart defaults from onboarding) |
| Analytics & behavioral data | 80 | 85 | +5 (full instrumentation) |
| Opt-out & user freedom | 85 | 88 | +3 (auth) |
| **Behavioral Total** | **82** | **90** | **+8** |
| Empty/Loading states | 8/10 | 9/10 | +1 |
| Navigation | 9/10 | 9/10 | — |
| **UI/UX Total** | **89** | **93** | **+4** |
