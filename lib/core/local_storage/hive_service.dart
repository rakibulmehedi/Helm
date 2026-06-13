// lib/core/local_storage/hive_service.dart
//
// Centralised Hive bootstrap for Pocketa.
//
// How to add a new model in Phase 1+:
//   1. Annotate the model with @HiveType(typeId: N)
//   2. Run: flutter pub run build_runner build --delete-conflicting-outputs
//   3. Register the generated adapter below in _registerAdapters()
//   4. Open its box in _openBoxes() using AppBoxNames.<boxName>
//
// NEVER open a box or register an adapter outside of this file.

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pocketa_v2/features/transactions/data/models/transaction_model.dart';
import 'package:pocketa_v2/features/transactions/data/adapters/transaction_type_adapter.dart';
import 'package:pocketa_v2/features/income/data/models/income_model.dart';
import 'package:pocketa_v2/features/safe_to_spend/data/models/fixed_cost_model.dart';
import 'package:pocketa_v2/features/audit_log/data/models/audit_event_model.dart';
import 'package:pocketa_v2/core/analytics/models/analytics_event_model.dart';
import 'package:pocketa_v2/core/analytics/data/models/nudge_preferences_model.dart';
import 'package:pocketa_v2/core/nudge/data/models/nudge_log_entry_model.dart';
import 'package:pocketa_v2/features/auth/data/models/session_model.dart';
import 'package:pocketa_v2/core/constants/app_box_names.dart';

class HiveService {
  HiveService._(); // prevent instantiation

  /// Initialises Hive and registers all adapters + opens all boxes.
  /// Must be called in main() before runApp().
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);

    _registerAdapters();
    await _openBoxes();
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Register all Hive TypeAdapters here.
  /// Phase 0: none yet — transaction model comes in Phase 1.
  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(TransactionModelAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(TransactionTypeAdapter());
    // if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(TransactionCategoryAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(IncomeModelAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(FixedCostModelAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(AuditEventModelAdapter());
    if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(AnalyticsEventModelAdapter());
    if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter(NudgePreferencesModelAdapter());
    if (!Hive.isAdapterRegistered(8)) Hive.registerAdapter(NudgeLogEntryModelAdapter());
    if (!Hive.isAdapterRegistered(9)) Hive.registerAdapter(SessionModelAdapter());
  }

  /// Open all Hive boxes here.
  /// Phase 0: no typed boxes yet — opened in Phase 1.
  static Future<void> _openBoxes() async {
    await Hive.openBox<TransactionModel>(AppBoxNames.transactions);
    // await Hive.openBox<TransactionCategory>(AppBoxNames.categories);
    await Hive.openBox<IncomeModel>(AppBoxNames.incomeBox);
    await Hive.openBox<FixedCostModel>(AppBoxNames.fixedCostsBox);
    // D1 Trust Layer: untyped dynamic box for PIN hash + auth setup status.
    await Hive.openBox<dynamic>(AppBoxNames.authBox);
    // D1.05 Audit Log: append-only financial change history.
    await Hive.openBox<AuditEventModel>(AppBoxNames.auditEventsBox);
    // Phase 2 Analytics Infrastructure
    await Hive.openBox<AnalyticsEventModel>(AppBoxNames.analyticsEventsBox);
    await Hive.openBox<NudgePreferencesModel>(AppBoxNames.nudgePreferencesBox);
    await Hive.openBox<NudgeLogEntryModel>(AppBoxNames.nudgeLogBox);
    await Hive.openBox<SessionModel>(AppBoxNames.sessionBox);
  }

  /// Generic helper — only use for boxes not managed by [_openBoxes].
  /// Prefer [_openBoxes] for all known boxes.
  static Future<void> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<T>(boxName);
    }
  }
}