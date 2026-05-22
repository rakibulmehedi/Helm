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
import 'package:pocketa_v2/features/transactions/domain/entities/transaction_type.dart';
import 'package:pocketa_v2/features/income/data/models/income_model.dart';
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
  }

  /// Open all Hive boxes here.
  /// Phase 0: no typed boxes yet — opened in Phase 1.
  static Future<void> _openBoxes() async {
    await Hive.openBox<TransactionModel>(AppBoxNames.transactions);
    // await Hive.openBox<TransactionCategory>(AppBoxNames.categories);
    await Hive.openBox<IncomeModel>(AppBoxNames.incomeBox);
  }

  /// Generic helper — only use for boxes not managed by [_openBoxes].
  /// Prefer [_openBoxes] for all known boxes.
  static Future<void> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<T>(boxName);
    }
  }
}