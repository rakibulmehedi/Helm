# Sprint S1 — Codebase-to-Task Mapping

> Generated: 2026-06-14  
> Scope: Map current Helm Flutter source/test files to the 97 adversarial-audit tasks in `docs/tracking/TASKS.md`.

This document is a **code-evidence-based** view of which S1 security tasks are implemented vs. still open. It replaces the previously unchecked task list with observable file-level evidence.

---

## Summary

| Category | Count |
|----------|-------|
| Tasks verified **DONE** in source/tests | 43 |
| Tasks still **PENDING** | 54 |
| Total S1 tasks | 97 |
| Security-related tests | ~77 |

**Quality gates:** `dart analyze` 0 issues, `flutter test` 251/251 pass.

---

## DONE Tasks (with evidence)

### CRITICAL

| ID | Task | Evidence | File(s) |
|----|------|----------|---------|
| C-2 | Token prefix `valid_` predictable → 1M brute force | 32-char `Random.secure()` alphanumeric token; repository validates token format | `lib/features/auth/data/datasources/auth_remote_data_source.dart:46-53`, `lib/features/auth/data/repositories/auth_repository_impl.dart:86-91` |
| C-3 | PIN attempt counter not persisted | `failedAttempts` + `lockoutUntil` read/written to encrypted `auth_box` on every attempt | `lib/features/auth/presentation/providers/auth_provider.dart:95-108`, `170-183`, `257-270` |
| C-4 | Zero at-rest encryption on all Hive boxes | `HiveService` initializes `HiveAesCipher` from secure key for every box | `lib/core/local_storage/hive_service.dart:36-46`, `110-113`; `lib/core/security/secure_key_manager.dart` |
| C-5 | No app lifecycle handling → PIN bypass on resume | `AppLifecycleLock` locks session on any non-resumed lifecycle state | `lib/core/security/widgets/app_lifecycle_lock.dart`; `lib/main.dart:23` |
| C-6 | Release build signed with debug keys | `build.gradle.kts` loads release keystore from `key.properties` | `android/app/build.gradle.kts:24-56` |
| C-7 | PIN gate fail-open when Hive box unavailable | Router now fail-closed: unknown auth state → `/pin-entry` | `lib/config/router/app_router.dart:314-344` |
| C-8 | Hive abandoned → migrate to `hive_ce` | `pubspec.yaml` pins `hive_ce` / `hive_ce_flutter`; adapters use `hive_ce` | `pubspec.yaml:13-14`; `lib/hive_registrar.g.dart` |
| C-11 | `_isSaving` guards bypassable after provider disposal | Every notifier method checks `mounted` after `await` | `lib/features/income/presentation/providers/income_providers.dart:73-96`; `lib/features/transactions/presentation/providers/transaction_provider.dart:56-93`; `lib/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart:73-138` |
| C-12 | CSV formula injection in export | `_sanitizeCellStatic` prefixes formula chars and strips control chars | `lib/features/export/domain/export_service.dart:184-214` |
| C-13 | `AuditEventModel` uses `late` fields → crash on corrupt read | All fields are `final` with constructor parameters | `lib/features/audit_log/data/models/audit_event_model.dart:28-54` |
| C-14 | Negative tax rate & buffer percent in release | Notifier clamps values; `StsSettings.isValid` is runtime-checkable | `lib/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart:127-138`; `lib/features/safe_to_spend/domain/entities/sts_settings.dart:37-45` |
| C-15 | `s2s_calc_failure` passes `e.toString()` → PII leak | Logs only `e.runtimeType.toString()` as `error_type` | `lib/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart:145-151` |

### HIGH

| ID | Task | Evidence | File(s) |
|----|------|----------|---------|
| H-2 | Fix 4-digit PIN → 6-digits minimum | `pinLength = 6` enforced in notifier + UI | `lib/features/auth/presentation/providers/auth_provider.dart:22`; `pin_setup_screen.dart`; `pin_entry_screen.dart` |
| H-3 | Email regex allows double dots / special chars | `InputValidator.normalizeEmail` trims, lowercases, length-caps, stricter pattern | `lib/core/utils/input_validator.dart:22-25`; `lib/features/auth/data/repositories/auth_repository_impl.dart:37-40` |
| H-5 | `logout()` doesn't clear Magic Link session/SharedPrefs | `logout()` deletes session token and clears SharedPrefs flag | `lib/features/auth/presentation/providers/auth_provider.dart:234-247` |
| H-6 | Rate limit global per-instance → per-email | `_emailTokens` maps `email → latest token`; 20 s cooldown | `lib/features/auth/data/datasources/auth_remote_data_source.dart:21-35` |
| H-7 | `TransactionTypeAdapter.read()` silently defaults unknown bytes | Now throws `HiveError` on unknown byte | `lib/features/transactions/data/adapters/transaction_type_adapter.dart:28-34` |
| H-8 | `AuditEventModel.toEntity()` no bounds check | `_eventTypeOrDefault` / `_entityTypeOrDefault` clamp to `unknown` | `lib/features/audit_log/data/models/audit_event_model.dart:56-71` |
| H-9 / H-23 | Session token + email in unencrypted Hive `session_box` | `session_box` opened with `encryptionCipher` | `lib/core/local_storage/hive_service.dart:140-148` |
| H-10 | No schema version tracking | `AppBoxNames.schemaVersion` + `schemaVersionKey` defined | `lib/core/constants/app_box_names.dart:18-22` |
| H-12 / M-4 | SharedPreferences `_prefs` nullable → silent no-op | `SharedPrefServices._instance` throws `StateError` if uninitialized | `lib/core/local_storage/shared_pref_service.dart:11-18` |
| H-13 | No input sanitization on free-text fields | `InputValidator.sanitizeText` strips control chars and length-caps | `lib/core/utils/input_validator.dart:97-108` |
| H-14 | No maxLength on text fields | `sanitizeText` enforces max length; UI fields set `maxLength` | `lib/core/utils/input_validator.dart:97-108`; `sts_settings_screen.dart:351`; `add_transaction_screen.dart:229`, `322` |
| H-15 | `safeToSpendProvider` uses `[]` fallback during loading | Uses `transactionsAsync.valueOrNull ?? []` | `lib/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart:141` |
| H-19 | `IncomeNotifier.updateIncome` TOCTOU race | Defensively appends if ID not found in state | `lib/features/income/presentation/providers/income_providers.dart:89-96` |
| H-28 | `setupPin` / `clearPin` 3 non-atomic Hive writes | Now `putAll` (setup) and `deleteAll` (clear) | `lib/features/auth/presentation/providers/auth_provider.dart:119-126`, `273-280` |
| H-30 | No root/jailbreak detection | `JailbreakRootCheck` + provider + blocking screen; splash runs check | `lib/core/security/root_check.dart`; `root_check_provider.dart`; `compromised_device_screen.dart`; `splash_screen.dart:58-73` |
| H-31 | No code obfuscation — `DART_OBFUSCATION=false` | iOS `Release.xcconfig` overrides to `DART_OBFUSCATION=true` | `ios/Flutter/Release.xcconfig:3` |
| H-32 | No ProGuard/R8 custom rules | `proguard-rules.pro` keeps Flutter, secure-storage, local_auth, jailbreak, Hive CE adapters | `android/app/proguard-rules.pro` |
| H-33 | Bundle ID is `com.example.helm` | Android `applicationId = "co.helm.finance"`; iOS bundle id updated | `android/app/build.gradle.kts:41`; `ios/Runner.xcodeproj/project.pbxproj:381`, `560`, `582` |
| H-34 | 4 empty `catch(_){}` blocks | All catch blocks now log with `debugPrint` | `lib/features/account/presentation/views/delete_account_screen.dart:62-82` |

### MEDIUM

| ID | Task | Evidence | File(s) |
|----|------|----------|---------|
| M-1 | Generated `.g.dart` cast failures on corrupted boxes | `AuditEventModel` defensively maps invalid enum indices; `TransactionTypeAdapter` fails loud | `lib/features/audit_log/data/models/audit_event_model.dart:56-71`; `lib/features/transactions/data/adapters/transaction_type_adapter.dart:28-34` |
| M-2 | Audit event ID collision | `IdGenerator.uniqueId()` = `<ms_timestamp>_<6-char secure random>` | `lib/core/utils/id_generator.dart`; `lib/features/audit_log/data/datasources/audit_local_data_source.dart:47` |
| M-3 | `delete_account` hardcodes box names | Uses `AppBoxNames.*` constants | `lib/features/account/presentation/views/delete_account_screen.dart:53-60` |
| M-11 | `AuthNotifier.sessionAuthenticated` static mutable field | Replaced with `ValueNotifier<bool> authRefreshListenable` | `lib/features/auth/presentation/providers/auth_provider.dart:17-20`, `282-288` |
| M-14 | `FLAG_SECURE` not set | `MainActivity.onCreate` sets `FLAG_SECURE` | `android/app/src/main/kotlin/co/helm/finance/MainActivity.kt:17-22` |
| M-18 | No amount upper-bound | `kMaxAmount = 1 trillion`; `parseAmount` rejects above it | `lib/core/utils/input_validator.dart:14`, `30-45` |
| M-23 | `saveSettings` / `getSettings` torn reads/writes | Single atomic `stsSettings_v2` JSON blob | `lib/features/safe_to_spend/data/datasources/sts_settings_data_source.dart:33-67` |
| M-24 | Export CSVs never cleaned up | `_cleanStaleExports` deletes prior `helm_*.csv` from temp dir | `lib/features/export/domain/export_service.dart:261-275` |
| M-25 | iOS `ITSAppUsesNonExemptEncryption` missing | Set to `false` | `ios/Runner/Info.plist:69` |
| M-28 | `AuditEventModel` 6 `late` fields | Same fix as C-13 | `lib/features/audit_log/data/models/audit_event_model.dart:28-54` |

### LOW

| ID | Task | Evidence | File(s) |
|----|------|----------|---------|
| L-3 | `double.parse` instead of `tryParse` | Uses `InputValidator.parseAmount` | `lib/features/transactions/presentation/views/add_transaction_screen.dart:170` |

---

## Still PENDING Tasks (highest risk first)

### CRITICAL

| ID | Task | Why still pending | File(s) |
|----|------|-------------------|---------|
| C-1 | Entire auth trust chain client-side → trivial bypass on rooted device | Magic Link backend is still a client-side mock; PIN verification is local. Root detection mitigates but does not eliminate the threat model. | `lib/features/auth/data/datasources/auth_remote_data_source.dart` |
| C-9 | ~180 hardcoded English strings bypass localization | No systematic audit/replacement performed. | All widget files |
| C-10 | Silent data fabrication — fake "Initial Balance" income entry | Onboarding still creates an initial balance entry. | `lib/features/onboarding/presentation/views/onboarding_screen.dart:137-146` |
| C-16 | `google_fonts` downloads fonts at runtime over internet | `google_fonts: ^8.1.0` still in `pubspec.yaml`. | `pubspec.yaml:22` |
| C-17 | SDK constraint mismatch — declared `^3.7.2`, resolved `>=3.11.0` | `pubspec.yaml` still declares `^3.7.2`. | `pubspec.yaml` |

### HIGH

| ID | Task | Why still pending | File(s) |
|----|------|-------------------|---------|
| H-1 | `setMagicLinkAuthCompleted` not awaited → redirect loop race | Called without `await`. | `lib/config/router/app_router.dart:167-172` |
| H-4 | `_usedTokens` in-memory → replay after process restart | `_usedTokens` is still an in-memory `Set`. | `lib/features/auth/data/datasources/auth_remote_data_source.dart:18` |
| H-11 | STS buffer migration silently replaces user's absolute BDT with 15% | `_migrateBufferPercent` drops legacy absolute value and writes `15.0`. | `lib/features/safe_to_spend/data/datasources/sts_settings_data_source.dart:74-87` |
| H-16 | Calculator errors silently return `SafeToSpendResult.zero()` | `safeToSpendProvider` swallows all exceptions and returns `zero()`. | `lib/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart:153` |
| H-17 | `FixedCostEntry.dueDayOfMonth` assert bypassed in release | Entity still uses `assert`; only UI form enforces 1–28. | `lib/features/safe_to_spend/domain/entities/fixed_cost_entry.dart:23-24` |
| H-18 | `trackingStreak` uses session count, not consecutive-day streak | `NudgeSessionService` passes `SharedPrefServices.getSessionCount()`. | `lib/core/nudge/presentation/providers/nudge_providers.dart:173` |
| H-20 | `FixedCostNotifier.addFixedCost` no duplicate ID check | Notifier and data source both overwrite by ID. | `lib/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart:73-76`; `fixed_cost_local_data_source.dart:22-24` |
| H-21 | `/onboarding` screen has no guard checking if already completed | No guard implemented. | `lib/features/onboarding/presentation/views/onboarding_screen.dart` |
| H-22 | `_AddEditFixedCostSheet._save()` not awaited before `Navigator.pop` | `_save()` calls `addFixedCost`/`updateFixedCost` synchronously then pops. | `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart:385-401` |
| H-24 | Client names, amounts, notes in plaintext CSV export — add warning | General plaintext warning exists, but no explicit CSV warning. | `lib/features/export/presentation/views/export_screen.dart:68-87` |
| H-25 | Negative fxRate silently subtracts from S2S — add calculator guard | No explicit calculator guard. | `lib/features/safe_to_spend/domain/services/safe_to_spend_calculator.dart:39` |
| H-26 | `saveSettings` — two non-atomic SharedPrefs writes → torn settings | (Note: single JSON blob in M-23 likely covers this; verify and mark done if so.) | `lib/features/safe_to_spend/data/repositories/sts_settings_repository_impl.dart:22-26` |
| H-27 | `SplashScreen` Timer not cancelled in `dispose` | `Timer` created in `_runStartupChecks` is never stored/cancelled. | `lib/features/splash/views/splash_screen.dart:82-86` |
| H-29 | `_deleteAllData` no transactional rollback | Best-effort sequential deletion; no rollback. | `lib/features/account/presentation/views/delete_account_screen.dart:49-63` |
| H-35 | 122+ null-assert `!` on theme extensions → crash if missing | No systematic fix. | 52 files |
| H-36 | `http`, `web_socket_channel`, `url_launcher_*` in transitive deps — audit network surface | No audit documented. | `pubspec.lock` |
| H-37 | No custom lint rules — enable strict lint for financial app | `analysis_options.yaml` not hardened. | `analysis_options.yaml` |
| H-38 | 4 label-action mismatches (First Pipeline button, Skip, Pipeline FAB, Welcome CTA) | No fix. | 4 screens |
| H-39 | Undo-toast for income/fixed-cost deletion is fragile — add confirmation | No confirmation added. | `income_list_screen.dart`; `sts_settings_screen.dart` |
| H-40 | USD-without-FX silent exclusion — add warning badge | No warning badge. | `safe_to_spend_calculator.dart` |
| H-41 | Currency symbol inconsistency: `tk` vs `৳` in 3 formats | No fix. | 4 files |

### MEDIUM

| ID | Task | Why still pending | File(s) |
|----|------|-------------------|---------|
| M-5 | `_escapeCsv` missing RTL override protection | No explicit BiDi / RTL override scrubbing. | `lib/features/export/domain/export_service.dart:184-214` |
| M-6 | No input formatters on text fields | Partially done; not all free-text fields have formatters. | `sts_settings_screen.dart`; `add_transaction_screen.dart` |
| M-7 | Currency string case-sensitive — `"bdt"`/`"usd"` silently uncounted | No case normalization. | `lib/features/safe_to_spend/domain/services/safe_to_spend_calculator.dart:36-38` |
| M-8 | `fxRate=0` silently zeroes USD contribution | No guard. | `lib/features/safe_to_spend/domain/services/safe_to_spend_calculator.dart:40` |
| M-9 | No state machine enforcement on `IncomeStatus` transitions | Enum documents transitions but code does not enforce them. | `lib/features/income/domain/entities/income_entry_entity.dart:24-32` |
| M-10 | `ExportNotifier.lastResult` mutable field across async gap | Field still mutable. | `lib/features/export/presentation/providers/export_provider.dart:11-18` |
| M-12 | `CadencePreferenceSheet._selectTime()` no mounted check | `setState` called after `showTimePicker` without `mounted` guard. | `lib/features/settings/presentation/views/cadence_preference_sheet.dart:54-59` |
| M-13 | Missing GoRoute for `/history` path | No route implemented. | `lib/config/router/route_names.dart:19` |
| M-15 | Lock screen notifications visible | `AndroidNotificationDetails` / `DarwinNotificationDetails` do not set `visibility: secret`. | `lib/core/nudge/notifications/notification_service.dart:88-94` |
| M-16 | `debugPrint` of analytics properties + notification payloads in debug builds | No audit/fix. | `lib/core/analytics/analytics_service.dart:54,67` |
| M-17 | `excludedUsdIncome` tracking skip for excluded entries — contradiction | No fix. | `lib/features/safe_to_spend/domain/services/safe_to_spend_calculator.dart:32` |
| M-19 | `verifyMagicLink` token reuse — dual concurrent calls both pass | `_usedTokens.add(token)` is not atomic. | `lib/features/auth/data/datasources/auth_remote_data_source.dart:48-52` |
| M-20 | `sendMagicLink` rate limit TOCTOU bypass | Read-check-write on `_emailTokens` is not atomic. | `lib/features/auth/data/datasources/auth_remote_data_source.dart:24-29` |
| M-21 | `markRead`/`markActioned` zombie entry | Optimistic update without repository existence check. | `lib/core/nudge/presentation/providers/nudge_providers.dart:99-120` |
| M-22 | `ExportNotifier` missing double-submit guard | No guard. | `lib/features/export/presentation/providers/export_provider.dart:16` |
| M-26 | All versions use caret `^` ranges — pin critical deps | No pinning policy. | `pubspec.yaml` |
| M-27 | No integration tests for data integrity or export flow | No integration tests. | `test/` |
| M-29 | Hardcoded defaults (taxRate 10%, buffer 15%) mask errors | Defaults still hardcoded. | `lib/features/safe_to_spend/data/repositories/sts_settings_repository_impl.dart:19-20` |
| M-30 | Debug-only dev reset button on dashboard — add confirmation | No confirmation. | `lib/features/dashboard/presentation/views/dashboard_screen.dart:207` |
| M-31 | `inkTertiary` color fails WCAG AA contrast at 11pt | No fix. | `lib/core/theme/helm_colors.dart` |
| M-32 | Bangla translations: 7 quality issues | No quality pass. | `lib/l10n/app_localizations_bn.dart` |
| M-33 | 3 unhelpful error messages (rate limit, lockout, export) | No copy update. | 3 files |

### LOW

| ID | Task | Why still pending | File(s) |
|----|------|-------------------|---------|
| L-1 | `addFixedCost` silent overwrite on duplicate ID | `box.put(model.id, model)` overwrites. | `lib/features/safe_to_spend/data/datasources/fixed_cost_local_data_source.dart:22-24` |
| L-2 | No referential integrity between audit log and entities | Audit records reference `entityId` strings with no FK validation. | Cross-box |
| L-4 | `TransactionsNotifier` wasteful full Hive re-read on every mutation | `add/update/delete` all call `loadTransactions()`. | `lib/features/transactions/presentation/providers/transaction_provider.dart:56-93` |
| L-5 | Nudge `[Client]` literal text — never interpolated | No fix. | `lib/core/nudge/domain/nudge_evaluator.dart:108` |
| L-6 | Path parameter `:id` not format-validated | (Note: `app_router.dart` does validate via `InputValidator.isValidId`; verify and mark done if sufficient.) | `lib/config/router/app_router.dart:100-119` |
| L-7 | `dailyActiveSession` dedup non-atomic | Read-modify-write via SharedPrefs. | `lib/core/analytics/analytics_service.dart:41-48` |
| L-8 | `trackEvent` unawaited Future | `trackEvent` returns void and fires repository save unawaited. | `lib/core/analytics/analytics_service.dart:56` |
| L-9 | `share_plus` temp file exposure — warn user | General plaintext warning only. | `lib/features/export/presentation/views/export_screen.dart:68-87` |
| L-10 | `share_plus` pulls `url_launcher_*` on desktop — accept or suppress | No decision. | `pubspec.lock` |
| L-11 | Notification opt-out friction — defaults to daily push post-onboarding | No change. | `lib/features/settings/presentation/views/cadence_preference_sheet.dart` |
| L-12 | Dead `PopScope` code in `add_income_screen.dart` | Dead code remains. | `lib/features/income/presentation/views/add_income_screen.dart:243-250` |

---

## Platform hardening details

| Control | Status | Evidence |
|---------|--------|----------|
| Android release signing | Done | `android/app/build.gradle.kts:24-56` |
| Android `FLAG_SECURE` | Done | `MainActivity.kt:17-22` |
| Android `allowBackup="false"` | Done | `AndroidManifest.xml` |
| Android `usesCleartextTraffic="false"` | Done | `AndroidManifest.xml` |
| Android ProGuard/R8 rules | Done | `android/app/proguard-rules.pro` |
| Android Dart obfuscation flag | Partial | iOS Release config sets `DART_OBFUSCATION=true`; Android relies on CI/build command. |
| iOS bundle ID | Done | `ios/Runner.xcodeproj/project.pbxproj` |
| iOS `ITSAppUsesNonExemptEncryption` | Done | `ios/Runner/Info.plist:69` |
| iOS file protection | Done | `ios/Runner/Info.plist` |
| Root/jailbreak detection | Done | `root_check.dart`, `root_check_provider.dart`, `compromised_device_screen.dart`, `splash_screen.dart` |

---

## Test coverage summary

| Test file | # tests | Domains covered |
|-----------|---------|-----------------|
| `test/features/auth/domain/pin_hasher_test.dart` | 8 | PBKDF2 hashing, salt, known answer |
| `test/features/auth/domain/session_entity_test.dart` | 6 | Session expiry, TTL |
| `test/features/auth/presentation/auth_provider_test.dart` | 5 | PIN lockout expiry, max attempts, sensitive-action PIN |
| `test/features/auth/data/auth_remote_data_source_test.dart` | 12 | Token format, rate limiting, single-use, expiry |
| `test/features/auth/data/auth_repository_impl_test.dart` | 6 | Email validation, token validation, session persistence |
| `test/features/auth/presentation/magic_link_screen_test.dart` | 10 (1 skipped) | Magic Link UI flow |
| `test/core/security/secure_key_manager_test.dart` | 4 | Key generation, corruption recovery, deletion |
| `test/core/local_storage/hive_service_encryption_test.dart` | 3 | Encrypted box round-trip, disk ciphertext |
| `test/features/audit_log/data/models/audit_event_model_test.dart` | 4 | Corrupt enum index handling |
| `test/features/export/domain/export_service_test.dart` | 3 | CSV formula-injection neutralization |
| `test/features/transactions/data/adapters/transaction_type_adapter_test.dart` | 2 | Corrupted byte handling |
| `test/features/safe_to_spend/domain/sts_settings_validation_test.dart` | 8 | Tax/buffer bounds, due-day bounds |
| `test/features/safe_to_spend/data/sts_settings_data_source_test.dart` | 6 | Atomic v2 blob, migration |

**Untested security controls:** `AppLifecycleLock`, `RootCheck`, CSV cleanup, notification lock-screen visibility.

---

## Recommended next actions

1. **Resolve C-1 / H-4 / M-19 / M-20**: Move Magic Link to a real backend or at least persist `_usedTokens` and make rate-limit atomic.
2. **Close race-condition cluster**: H-1, H-22, H-27, M-12, M-21.
3. **Finish platform hardening**: Android Dart obfuscation build config, notification visibility secret.
4. **Systematic input sweep**: M-5 (RTL/BiDi), M-6 (formatters), M-7 (currency case), C-9 (localization).
5. **Remove/kill C-10 and C-16** if not aligned with beta scope: fake initial balance entry and `google_fonts` runtime download.
6. **Create missing dispatch doc**: `docs/planning/TDD_DISPATCH_SPRINT_S1_SECURITY_HARDENING.md` or remove the reference in `docs/tracking/TASKS.md`.
