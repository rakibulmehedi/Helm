// lib/features/export/domain/export_service.dart
// D1.08 — CSV Export: service that writes 5 CSV files to documents directory

import 'dart:io';

import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/features/audit_log/data/models/audit_event_model.dart';
import 'package:helm/features/income/data/models/income_model.dart';
import 'package:helm/features/safe_to_spend/data/models/fixed_cost_model.dart';
import 'package:helm/features/transactions/data/models/transaction_model.dart';

import 'export_result.dart';

class ExportService {
  Future<ExportResult> exportAll() async {
    try {
      final now = DateTime.now();
      final ts =
          '${now.year}${_pad(now.month)}${_pad(now.day)}_${_pad(now.hour)}${_pad(now.minute)}${_pad(now.second)}';

      final dir = await getApplicationDocumentsDirectory();

      // ── Income ──────────────────────────────────────────────────────────────
      final incomeModels = _readBox<IncomeModel>(AppBoxNames.incomeBox);
      const statusNames = ['expected', 'pending', 'received'];
      final incomeRows = [
        'id,clientName,projectName,amount,currency,status,expectedDate,'
            'receivedDate,notes,createdAt,updatedAt,fxRate,'
            'excludeFromCalculation,sourceLabel',
        ...incomeModels.map(
          (m) => _row([
            m.id,
            m.clientName,
            m.projectName,
            m.amount.toString(),
            m.currency,
            m.statusIndex < statusNames.length
                ? statusNames[m.statusIndex]
                : m.statusIndex.toString(),
            m.expectedDate.toIso8601String(),
            m.receivedDate?.toIso8601String() ?? '',
            m.notes ?? '',
            m.createdAt.toIso8601String(),
            m.updatedAt.toIso8601String(),
            m.fxRate?.toString() ?? '',
            (m.excludeFromCalculation ?? false).toString(),
            m.sourceLabel ?? '',
          ]),
        ),
      ];

      // ── Transactions ─────────────────────────────────────────────────────────
      final txModels = _readBox<TransactionModel>(AppBoxNames.transactions);
      final txRows = [
        'id,title,amount,date,categoryId,type,note',
        ...txModels.map(
          (m) => _row([
            m.id,
            m.title,
            m.amount.toString(),
            m.date.toIso8601String(),
            m.categoryId ?? '',
            m.type.name,
            m.note ?? '',
          ]),
        ),
      ];

      // ── Fixed Costs ───────────────────────────────────────────────────────────
      final fcModels = _readBox<FixedCostModel>(AppBoxNames.fixedCostsBox);
      final fcRows = [
        'id,label,amount,dueDayOfMonth,createdAt',
        ...fcModels.map(
          (m) => _row([
            m.id,
            m.label,
            m.amount.toString(),
            m.dueDayOfMonth.toString(),
            m.createdAt.toIso8601String(),
          ]),
        ),
      ];

      // ── STS Settings ─────────────────────────────────────────────────────────
      final prefs = await SharedPreferences.getInstance();
      final taxRate = prefs.getDouble('stsSettings_taxRate') ?? 0.10;
      final bufferPercent =
          prefs.getDouble('stsSettings_bufferPercent') ?? 15.0;
      final settingsRows = [
        'taxRate,bufferPercent',
        _row([taxRate.toString(), bufferPercent.toString()]),
      ];

      // ── Audit Log ─────────────────────────────────────────────────────────────
      const eventTypeNames = [
        'created',
        'updated',
        'deleted',
        'confirmed',
        'exported',
      ];
      const entityTypeNames = [
        'income',
        'transaction',
        'stsSettings',
        'fixedCost',
      ];
      final auditModels =
          _readBox<AuditEventModel>(AppBoxNames.auditEventsBox);
      final auditRows = [
        'id,timestamp,eventType,entityType,entityId,previousValue,'
            'newValue,description',
        ...auditModels.map(
          (m) => _row([
            m.id,
            m.timestamp.toIso8601String(),
            m.eventTypeIndex < eventTypeNames.length
                ? eventTypeNames[m.eventTypeIndex]
                : m.eventTypeIndex.toString(),
            m.entityTypeIndex < entityTypeNames.length
                ? entityTypeNames[m.entityTypeIndex]
                : m.entityTypeIndex.toString(),
            m.entityId,
            m.previousValue ?? '',
            m.newValue ?? '',
            m.description,
          ]),
        ),
      ];

      // ── Write files ───────────────────────────────────────────────────────────
      final paths = await Future.wait([
        _writeCsv(dir, 'helm_income_$ts.csv', incomeRows),
        _writeCsv(dir, 'helm_transactions_$ts.csv', txRows),
        _writeCsv(dir, 'helm_fixed_costs_$ts.csv', fcRows),
        _writeCsv(dir, 'helm_settings_$ts.csv', settingsRows),
        _writeCsv(dir, 'helm_audit_$ts.csv', auditRows),
      ]);

      return ExportResult(
        success: true,
        directoryPath: dir.path,
        filePaths: paths,
      );
    } catch (e) {
      return ExportResult(success: false, errorMessage: e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _pad(int n) => n.toString().padLeft(2, '0');

  String _escapeCsv(String v) {
    if (v.contains(',') || v.contains('"') || v.contains('\n')) {
      return '"${v.replaceAll('"', '""')}"';
    }
    return v;
  }

  String _row(List<String> fields) => fields.map(_escapeCsv).join(',');

  List<T> _readBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) return [];
    return Hive.box<T>(boxName).values.toList();
  }

  Future<String> _writeCsv(
    Directory dir,
    String name,
    List<String> rows,
  ) async {
    final file = File('${dir.path}/$name');
    await file.writeAsString(rows.join('\n'));
    return file.path;
  }
}
