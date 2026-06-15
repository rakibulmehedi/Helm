# QA Pre-Release Fix Dispatch

> Generated 2026-06-15 from `.commandcode/adversarial_audit_report.md` + QA gate execution.
> 9 findings to fix across 6 files + 1 config change.
> Fix order: BLOCKERs first, then HIGHs, then MEDIUM/LOW.

---

## Fix 1 (BLOCKER): API 21–23 Support — `android/app/build.gradle.kts` + `android/app/src/main/AndroidManifest.xml`

**Finding**: Merged manifest resolves to `minSdkVersion="24"` because Flutter SDK defaults to 24 and four plugins (`flutter_local_notifications`, `local_auth_android`, `shared_preferences_android`, `flutter_plugin_android_lifecycle`) all declare `minSdkVersion="24"` in their library manifests. Android manifest merging picks the MAX, overriding any app-level setting.

**Reasoning**: The PRODUCT_STATE.md explicitly targets Galaxy A14 (API 33) compatibility — but the constraint was `minSdk 21`. The four plugins at v24 don't actually use API 24+ features, they inherited the default from Flutter's SDK bump. The correct Android approach is to explicitly override the merged value via `tools:overrideLibrary` rather than fighting the manifest merger.

**Fix (2 changes)**:

1. **`android/app/build.gradle.kts` line 34**:
   Replace:
   ```kotlin
   minSdk = flutter.minSdkVersion
   ```
   With:
   ```kotlin
   minSdk = 21
   ```

2. **`android/app/src/main/AndroidManifest.xml`** — add inside the `<manifest>` element (before `<application>`):
   ```xml
   <uses-sdk
       tools:overrideLibrary="com.dexterous.flutterlocalnotifications,
                              io.flutter.plugins.localauth,
                              io.flutter.plugins.sharedpreferences,
                              io.flutter.embedding.engine.plugins.lifecycle" />
   ```
   Also add `xmlns:tools="http://schemas.android.com/tools"` to the `<manifest>` opening tag if not present.

**Why this approach over alternatives**:
- **Not** `tools:node="replace"` on `<uses-sdk>` — that only works within the same manifest file, not on merged children.
- **Not** downgrading plugins — those versions are stable and don't actually use API 24 features.
- **Not** `manifestPlaceholders` — that only affects placeholder substitution, not merged attributes.
- `tools:overrideLibrary` is the canonical Android mechanism for "I accept the risk, let this library run on a lower API." It's designed exactly for this scenario.

**Verification**: After fixing, run `./gradlew assembleRelease` then `aapt dump badging build/app/outputs/flutter-apk/app-release.apk | grep sdkVersion` — must show `sdkVersion:'21'`.

---

## Fix 2 (BLOCKER — C-16): Bundle Fonts as Assets, Remove `google_fonts`

**Finding**: 22 calls across 2 files use `GoogleFonts.inter()`, `GoogleFonts.jetBrainsMono()`, and `GoogleFonts.hindSiliguri()` — all download font files at runtime over the internet. Offline rendering breaks.

**Reasoning**: All three fonts are SIL Open Font License (free to bundle). The type scale uses only 3 weights each (Inter 400/500/600, JetBrains Mono 500/600, Hind Siliguri 400/500). Bundling as `.ttf` assets eliminates the runtime download, guarantees offline rendering, and removes the `google_fonts: 8.1.0` dependency entirely. The `GoogleFonts.*()` calls in `helm_typography.dart` are static token definitions — they don't need the dynamic font loading feature of google_fonts at all. The `getFontStyle()` helper in `app_theme.dart` is a thin wrapper that simply selects a font family by locale — easily replaced with a simple `TextStyle(fontFamily: ...)`.

**Fix (4 steps)**:

### Step A — Download font files

Download from Google Fonts and place in `assets/fonts/`:

| File | Weight | Style |
|------|--------|-------|
| `Inter-Regular.ttf` | 400 | normal |
| `Inter-Medium.ttf` | 500 | normal |
| `Inter-SemiBold.ttf` | 600 | normal |
| `JetBrainsMono-Medium.ttf` | 500 | normal |
| `JetBrainsMono-SemiBold.ttf` | 600 | normal |
| `HindSiliguri-Regular.ttf` | 400 | normal |
| `HindSiliguri-Medium.ttf` | 500 | normal |

Command to download:
```bash
mkdir -p assets/fonts
# Inter
curl -L -o assets/fonts/Inter-Regular.ttf "https://github.com/google/fonts/raw/main/ofl/inter/static/Inter_18pt-Regular.ttf"
curl -L -o assets/fonts/Inter-Medium.ttf "https://github.com/google/fonts/raw/main/ofl/inter/static/Inter_18pt-Medium.ttf"
curl -L -o assets/fonts/Inter-SemiBold.ttf "https://github.com/google/fonts/raw/main/ofl/inter/static/Inter_18pt-SemiBold.ttf"
# JetBrains Mono
curl -L -o assets/fonts/JetBrainsMono-Medium.ttf "https://github.com/google/fonts/raw/main/ofl/jetbrainsmono/static/JetBrainsMono-Medium.ttf"
curl -L -o assets/fonts/JetBrainsMono-SemiBold.ttf "https://github.com/google/fonts/raw/main/ofl/jetbrainsmono/static/JetBrainsMono-SemiBold.ttf"
# Hind Siliguri
curl -L -o assets/fonts/HindSiliguri-Regular.ttf "https://github.com/google/fonts/raw/main/ofl/hindsiliguri/HindSiliguri-Regular.ttf"
curl -L -o assets/fonts/HindSiliguri-Medium.ttf "https://github.com/google/fonts/raw/main/ofl/hindsiliguri/HindSiliguri-Medium.ttf"
```

### Step B — Declare fonts in `pubspec.yaml`

Replace the `flutter:` assets section to include:

```yaml
flutter:
  uses-material-design: true
  generate: true
  assets:
    - assets/
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
          weight: 400
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
    - family: JetBrainsMono
      fonts:
        - asset: assets/fonts/JetBrainsMono-Medium.ttf
          weight: 500
        - asset: assets/fonts/JetBrainsMono-SemiBold.ttf
          weight: 600
    - family: HindSiliguri
      fonts:
        - asset: assets/fonts/HindSiliguri-Regular.ttf
          weight: 400
        - asset: assets/fonts/HindSiliguri-Medium.ttf
          weight: 500
```

Also remove line `google_fonts: 8.1.0` from `dependencies:`.

### Step C — Replace GoogleFonts calls in `lib/core/themes/helm_typography.dart`

Replace all 20 `GoogleFonts.*()` calls with `TextStyle(fontFamily: ...)` while keeping all fontSize, fontWeight, height, color values identical:

| Old call | New replacement |
|----------|----------------|
| `GoogleFonts.inter(fontSize: X, fontWeight: Y, height: Z, color: c)` | `TextStyle(fontFamily: 'Inter', fontSize: X, fontWeight: Y, height: Z, color: c)` |
| `GoogleFonts.jetBrainsMono(fontSize: X, fontWeight: Y, height: Z, color: c)` | `TextStyle(fontFamily: 'JetBrainsMono', fontSize: X, fontWeight: Y, height: Z, color: c)` |
| `GoogleFonts.hindSiliguri(fontSize: X, fontWeight: Y, height: Z, color: c)` | `TextStyle(fontFamily: 'HindSiliguri', fontSize: X, fontWeight: Y, height: Z, color: c)` |

Also remove `import 'package:google_fonts/google_fonts.dart';` from the file header.

### Step D — Replace `getFontStyle()` in `lib/core/themes/app_theme.dart`

Replace the entire `getFontStyle` method (lines ~175-188):

```dart
/// Returns a [TextStyle] for the given [AppLanguage].
static TextStyle getFontStyle(AppLanguage lang, double size, FontWeight weight, Color color) {
  final family = lang == AppLanguage.bangla ? 'HindSiliguri' : 'Inter';
  return TextStyle(fontFamily: family, fontSize: size, fontWeight: weight, color: color);
}
```

Remove `import 'package:google_fonts/google_fonts.dart';`.

**Verification**: Enable airplane mode, launch app. All text must render. No "failed to load font" errors in debug console. `grep -r "GoogleFonts" lib/` must return empty. `grep "google_fonts" pubspec.yaml` must return empty.

---

## Fix 3 (HIGH): Account Deletion Leaves 4 Hive Boxes — `lib/features/account/presentation/views/delete_account_screen.dart`

**Finding**: `analyticsEventsBox`, `nudgePreferencesBox`, `nudgeLogBox`, and `sessionBox` are opened at startup but not included in the account deletion wipe at line 49. After "Delete Account," analytics data, nudge data, and session data survive on disk.

**Reasoning**: A full account deletion must wipe every box. The existing order is: non-sensitive → financial → audit → auth (last so PIN gate survives mid-wipe crash). The 4 missing boxes (analytics, nudge prefs, nudge logs, session) should be inserted between the non-sensitive tier and the financial tier — they're operational data that's user-tied but not financial.

**Fix**: In `/lib/features/account/presentation/views/delete_account_screen.dart`, replace lines 49-57:

**Current:**
```dart
final boxNames = [
  AppBoxNames.transactions,
  AppBoxNames.incomeBox,
  AppBoxNames.fixedCostsBox,
  AppBoxNames.categories,
  AppBoxNames.auditEventsBox,
  AppBoxNames.auditChainBox,
  AppBoxNames.authBox,
];
```

**Replace with:**
```dart
final boxNames = [
  // Tier 1 — non-sensitive operational data (safe to lose mid-wipe)
  AppBoxNames.transactions,
  AppBoxNames.incomeBox,
  AppBoxNames.fixedCostsBox,
  AppBoxNames.categories,
  AppBoxNames.analyticsEventsBox,
  AppBoxNames.nudgePreferencesBox,
  AppBoxNames.nudgeLogBox,
  AppBoxNames.sessionBox,
  // Tier 2 — audit integrity (should survive as long as possible)
  AppBoxNames.auditEventsBox,
  AppBoxNames.auditChainBox,
  // Tier 3 — identity/PIN gate (last, so crash mid-wipe keeps gate intact)
  AppBoxNames.authBox,
];
```

No other changes needed — the existing loop handles clearing, closing, and deleting each box with try/catch guards.

**Verification**: Delete account, then inspect Hive directory (`adb pull` on Android) — no `.hive` files should remain. All boxes must be gone.

---

## Fix 4 (HIGH — M-13): Pending → Expected Transition Must Be Rejected — `lib/features/income/domain/entities/income_entry_entity.dart`

**Finding**: `IncomeStatus.canTransition(IncomeStatus.pending, IncomeStatus.expected)` returns `true` because the procedural logic allows "pending can go to anything except itself." The M-9 fix was supposed to enforce forward-only transitions (expected → pending → received), but the pending → expected backslide was missed.

**Reasoning**: The current procedural approach (`if/else if` chains) is error-prone — the M-13 bug proves it. A declaration-based approach is simpler, more auditable, and harder to get wrong. The refactor is small (same file, same method, same test expectations for everything except the one broken transition), and the `const` map is optimized away at compile time. The `received` terminal state is expressed as an empty set — no transitions out. The `same-status` shortcut is preserved for idempotency (editing an entry without changing status).

**Fix**: In `/lib/features/income/domain/entities/income_entry_entity.dart`, replace the `canTransition` method body (lines 33-39):

**Current:**
```dart
static bool canTransition(IncomeStatus from, IncomeStatus to) {
  if (from == to) return true;
  if (from == IncomeStatus.received) return false;
  if (from == IncomeStatus.expected) return to != IncomeStatus.expected;
  if (from == IncomeStatus.pending) return to != IncomeStatus.pending;
  return false;
}
```

**Replace with:**
```dart
static bool canTransition(IncomeStatus from, IncomeStatus to) {
  if (from == to) return true;
  const allowed = <IncomeStatus, Set<IncomeStatus>>{
    IncomeStatus.expected: {IncomeStatus.pending, IncomeStatus.received},
    IncomeStatus.pending: {IncomeStatus.received},
    IncomeStatus.received: <IncomeStatus>{},
  };
  return allowed[from]?.contains(to) ?? false;
}
```

**Test impact**: The test at `test/features/income/presentation/income_providers_test.dart` line ~85 that expects `pending → expected` to throw `ArgumentError` should now PASS (it was previously failing silently if the test was checking the wrong expectation, or it needs updating if it expects the transition to succeed). After the fix:
- `pending → expected`: REJECTED (throws ArgumentError)
- `pending → received`: ALLOWED
- `received → expected`: REJECTED
- `received → pending`: REJECTED
- `expected → pending`: ALLOWED
- `expected → received`: ALLOWED

**Verification**: Run `flutter test test/features/income/presentation/income_providers_test.dart`. Attempt a pending → expected transition via the UI — should be rejected with a SnackBar or error state.

---

## Fix 5 (HIGH — C-1): Router Gate Order — Magic Link Before Onboarding — `lib/config/router/app_router.dart`

**Finding**: On clean install, the `_globalRedirect` onboarding gate fires first (line 297), bouncing the user to `/welcome` and then `/onboarding`. The magic link gate never runs. The user sees the qualifier/questionnaire before identity is verified. This is a C-1 authentication bypass — the app gates on onboarding knowledge, not identity.

**Reasoning**: The gate must verify identity (magic link) before collecting any user responses (onboarding qualifier). The correct flow is: Magic Link (email identity verification) → PIN setup (local device auth) → Onboarding qualifier → Dashboard. The fix is a simple reorder — move the Magic Link gate block above the Onboarding gate block. The magic link completion flag controls whether onboarding has been seen; on clean install with neither flag set, the magic link gate wins. The PIN gate stays innermost as the fail-closed device-level gate.

**Why reorder, not restructure**: The gates are independent boolean checks on SharedPreferences flags. The only problem is execution order. Restructuring into a pipeline or state machine would be over-engineering for a 3-gate system where each gate is a single boolean. This is a 30-second fix with zero new code.

**Fix**: In `lib/config/router/app_router.dart`, swap the order of the Onboarding gate block (lines 297-305) and the Magic Link gate block (lines 316-324).

**Current order:**
```
1. Onboarding gate (lines 297-305)
2. Onboarding-done dead-end redirect (lines 307-312)
3. Magic Link gate (lines 316-324)
4. PIN gate (lines 327-349)
```

**New order:**
```
1. Magic Link gate (moved up from lines 316-324)
2. Magic-link-done dead-end redirect (same logic)
3. Onboarding gate (moved down from lines 297-305)
4. Onboarding-done dead-end redirect (same logic)
5. PIN gate (unchanged)
```

The `_publicRoutes` set (line ~291) already includes both `/magic-link` and `/onboarding`, so no change needed there. The dead-end redirects should be ordered to match their gates: after magic link is done, visiting `/magic-link` redirects to `/home`. After onboarding is done, visiting `/welcome` or `/onboarding` redirects to `/home`.

**Post-fix flow on clean install**:
1. App launches → `magicLinkDone` is false → redirect to `/magic-link`
2. User completes magic link → `magicLinkDone` set to true → redirect to `/home`
3. At `/home`, PIN gate fires → go to `/pin-setup` or `/pin-entry`
4. After PIN → back to `/home` → onboarding not done → redirect to `/welcome`
5. User completes onboarding qualifier → `onboardingDone` set to true → dashboard

**Verification**: Clear app data, launch. Must land on `/magic-link`. Complete magic link flow, set PIN, then onboarding qualifier appears. Route order is: Magic Link → PIN → Onboarding → Dashboard.

---

## Fix 6 (HIGH): Audit CSV Missing Chain Hashes — `lib/features/export/domain/export_service.dart` + `lib/features/audit_log/data/services/audit_chain_service.dart`

**Finding**: The audit CSV export emits `id,timestamp,eventType,entityType,entityId,previousValue,newValue,description,schemaVersion` but omits `previousHash` and `currentHash`. The tamper-evidence chain is computed and stored but never exported, so no external verifier can validate the audit log's integrity.

**Reasoning**: The `AuditChainService` stores each event's SHA-256 hash under `event.id` but doesn't store the previous hash used as input. To export `previousHash`, we need that value. The cleanest approach: modify `appendAndHash` to also store the previous hash under a companion key (`"${event.id}_prev"`), add a `previousHashFor(String eventId)` accessor, then wire it into the CSV export. This changes chain box storage (adds one key per event) but doesn't break existing chain data — existing entries will return empty string for previous hash (same as genesis event behavior). Column ordering should place hashes after the schema version for readability.

**Fix (3 changes)**:

### 6a — Store previous hash in `AuditChainService`

**File**: `lib/features/audit_log/data/services/audit_chain_service.dart`

In `appendAndHash`, after `await box.put(event.id, hash)` (current line ~30), add:
```dart
await box.put('${event.id}_prev', previousHash.isNotEmpty ? previousHash : '');
```

Add a new method:
```dart
/// Returns the previous hash that was chained to produce [eventId]'s hash.
/// Returns empty string for genesis events (first in chain) or unknown IDs.
Future<String> previousHashFor(String eventId) async {
  try {
    final box = await _chainBox;
    return box.get('${eventId}_prev', defaultValue: '') as String;
  } on Exception catch (_) {
    return '';
  }
}
```

### 6b — Export hashes in CSV

**File**: `lib/features/export/domain/export_service.dart`

In the `exportAll()` method where audit rows are built, after obtaining `auditModels`:

1. Get the `AuditChainService` instance (import and inject):
```dart
import 'package:helm_v2/features/audit_log/data/services/audit_chain_service.dart';
```

Inside the export method, before building audit rows:
```dart
final chainService = AuditChainService();
```

2. Change the audit header (current line ~128) from:
```dart
'id,timestamp,eventType,entityType,entityId,previousValue,'
    'newValue,description,schemaVersion',
```
To:
```dart
'id,timestamp,eventType,entityType,entityId,previousValue,'
    'newValue,description,schemaVersion,previousHash,currentHash',
```

3. Change the audit row mapping (current lines ~130-142) to include hash lookups. Make the mapping `async` (change `.map((m) =>` to use `Future.wait`):

```dart
final auditRows = [
  'id,timestamp,eventType,entityType,entityId,previousValue,'
      'newValue,description,schemaVersion,previousHash,currentHash',
  ...await Future.wait(auditModels.map((m) async {
    final currentHash = await chainService.hashFor(m.id) ?? '';
    final previousHash = await chainService.previousHashFor(m.id) ?? '';
    return _row([
      InputValidator.sanitizeText(m.id),
      m.timestamp.toIso8601String(),
      m.eventTypeIndex < eventTypeNames.length
          ? eventTypeNames[m.eventTypeIndex]
          : m.eventTypeIndex.toString(),
      m.entityTypeIndex < entityTypeNames.length
          ? entityTypeNames[m.entityTypeIndex]
          : m.entityTypeIndex.toString(),
      InputValidator.sanitizeText(m.entityId),
      InputValidator.sanitizeText(m.previousValue),
      InputValidator.sanitizeText(m.newValue),
      InputValidator.sanitizeText(m.description),
      kAuditSchemaVersion.toString(),
      previousHash,
      currentHash,
    ]);
  })),
];
```

Note: The method signature for `exportAll()` (currently `Future<Map<String, List<String>>>`) doesn't need to change — it already returns `Future`. The audit rows section just needs to use `await Future.wait(...)` instead of the synchronous `.map()`.

### 6c — Add `hashFor` accessor (if missing)

Ensure `AuditChainService` has this method:
```dart
Future<String?> hashFor(String eventId) async {
  try {
    final box = await _chainBox;
    return box.get(eventId);
  } on Exception catch (_) {
    return null;
  }
}
```

**Verification**: Export CSV, open `helm_audit_log.csv`. Verify columns `previousHash` and `currentHash` exist. Genesis (first) audit event should have empty `previousHash`. Subsequent events should have their previous hash populated with the SHA-256 of the prior event.

---

## Fix 7 (MEDIUM): `.gitignore` Missing `*.hive` Pattern

**Finding**: `.gitignore` doesn't exclude `*.hive` files. Hive database files could be accidentally committed.

**Reasoning**: Simple addition. Place it in the "Generated / build artifacts" section alongside existing patterns.

**Fix**: In `.gitignore`, add a new line:
```
*.hive
```
Place it near the existing `*.g.dart` or build artifact patterns.

**Verification**: `git status` after adding — no `.hive` files should appear as untracked.

---

## Fix 8 (MEDIUM): Analyzer Ignore Comments — `lib/l10n/app_localizations_bn.dart` + `lib/l10n/app_localizations_en.dart`

**Finding**: Two `// ignore: unused_import` comments on `import 'package:intl/intl.dart' as intl;` in the generated localization files.

**Reasoning**: The `intl` import is genuinely needed by the generated `initializeMessages` function — the analyzer just can't see the usage because it's in generated code. The `// ignore_for_file: type=lint` already covers all rules. The inline `// ignore: unused_import` is redundant and triggers the QA scanner. The fix is to simply delete the two redundant inline comments — they're noise covered by the file-level suppression.

**Fix**:

In `lib/l10n/app_localizations_bn.dart` line 1, change:
```dart
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
```
To:
```dart
import 'package:intl/intl.dart' as intl;
```

Same change in `lib/l10n/app_localizations_en.dart` line 1.

Do NOT remove the `// ignore_for_file: type=lint` on line 5 of either file — that's the file-level suppression that the generated code legitimately needs.

**Note**: The three `avoid_classes_with_only_static_members` suppressions in `number_formatter.dart`, `helm_spacing.dart`, and `helm_motion.dart` are intentional — these are utility namespace classes, a Flutter convention. Converting them to top-level functions or extensions would break the design token pattern used throughout the app. Do NOT "fix" these — they are correct as-is.

**Verification**: `dart analyze` must return 0 issues. `grep -r "// ignore:" lib/` should only return the intentional `ignore_for_file` directives and the three `avoid_classes_with_only_static_members` suppressions.

---

## Fix 9 (LOW): Remove Temporary Onboarding Skip Button — `lib/features/onboarding/presentation/views/onboarding_screen.dart`

**Finding**: The "Set up later" skip button at line 182 was flagged as "temp — remove before release" and is still present.

**Reasoning**: With the gate order fixed (Fix 5), onboarding now runs after magic link + PIN. Users can't bypass identity verification. But the skip button still lets users skip the qualifier and fixed cost setup, which undermines the S2S calculation (no base data). This was always intended to be removed before release.

**Fix**: In `lib/features/onboarding/presentation/views/onboarding_screen.dart`, remove the skip button widget around line 182 and any associated `onSkip` callback/method. The onboarding must be completed to proceed.

**Verification**: Launch app, complete magic link + PIN. During onboarding, verify no "Set up later" or skip option is visible. User must complete the qualifier and initial setup.

---

## Execution Order

```
Fix 1 (BLOCKER)  → API 21–23                  [2 files, 2 lines changed]
Fix 2 (BLOCKER)  → Fonts bundled               [4 steps: download + pubspec + 2 Dart files]
Fix 3 (HIGH)     → Account deletion            [1 file, add 4 box names]
Fix 4 (HIGH)     → State machine               [1 file, replace method body]
Fix 5 (HIGH)     → Router gate order           [1 file, reorder 2 blocks]
Fix 6 (HIGH)     → Audit chain CSV             [2 files, add storage + wire export]
Fix 7 (MEDIUM)   → .gitignore                  [1 file, 1 line]
Fix 8 (MEDIUM)   → Analyzer ignores            [2 files, delete 2 lines]
Fix 9 (LOW)      → Onboarding skip             [1 file, delete widget]
```

**Total**: 12 files modified (including pubspec.yaml and .gitignore), 7 new font assets.

**Post-fix validation sequence**:
1. `dart analyze` → 0 errors, 0 warnings, 0 infos
2. `flutter test` → all 282+ tests pass
3. `flutter build apk --release --target-platform android-arm64 --tree-shake-icons` → clean build
4. `aapt dump badging build/app/outputs/flutter-apk/app-release.apk | grep sdkVersion` → sdkVersion:'21'
5. Install on physical device → clean install → magic link screen appears first
6. Airplane mode → fonts render, all screens functional
7. Account deletion → no .hive files remain
8. Pending → Expected transition → rejected
9. CSV export → audit file has previousHash and currentHash columns populated
