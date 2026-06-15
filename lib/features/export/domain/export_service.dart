// lib/features/export/domain/export_service.dart
// D1.08 — CSV Export: service that writes 5 CSV files to documents directory

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/core/utils/id_generator.dart';
import 'package:helm/core/utils/input_validator.dart';
import 'package:helm/features/audit_log/core/audit_log_constants.dart';
import 'package:helm/features/audit_log/data/datasources/audit_local_data_source.dart';
import 'package:helm/features/audit_log/data/models/audit_event_model.dart';
import 'package:helm/features/audit_log/data/services/audit_chain_service.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
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

      // Write exports to a temp directory and clean up stale exports so
      // plaintext financial data does not accumulate on the device (M-24).
      final dir = await getTemporaryDirectory();
      await _cleanStaleExports(dir);

      // ── Income ──────────────────────────────────────────────────────────────
      final incomeModels = _readBox<IncomeModel>(AppBoxNames.incomeBox);
      const statusNames = ['expected', 'pending', 'received'];
      final incomeRows = [
        'id,clientName,projectName,amount,currency,status,expectedDate,'
            'receivedDate,notes,createdAt,updatedAt,fxRate,'
            'excludeFromCalculation,sourceLabel',
        ...incomeModels.map(
          (m) => _row([
            InputValidator.sanitizeText(m.id),
            InputValidator.sanitizeText(m.clientName),
            InputValidator.sanitizeText(m.projectName),
            m.amount.toString(),
            InputValidator.normalizeCurrency(m.currency),
            m.statusIndex < statusNames.length
                ? statusNames[m.statusIndex]
                : m.statusIndex.toString(),
            m.expectedDate.toIso8601String(),
            m.receivedDate?.toIso8601String() ?? '',
            InputValidator.sanitizeText(m.notes),
            m.createdAt.toIso8601String(),
            m.updatedAt.toIso8601String(),
            m.fxRate?.toString() ?? '',
            (m.excludeFromCalculation ?? false).toString(),
            InputValidator.sanitizeText(m.sourceLabel),
          ]),
        ),
      ];

      // ── Transactions ─────────────────────────────────────────────────────────
      final txModels = _readBox<TransactionModel>(AppBoxNames.transactions);
      final txRows = [
        'id,title,amount,date,categoryId,type,note',
        ...txModels.map(
          (m) => _row([
            InputValidator.sanitizeText(m.id),
            InputValidator.sanitizeText(m.title),
            m.amount.toString(),
            m.date.toIso8601String(),
            InputValidator.sanitizeText(m.categoryId),
            m.type.name,
            InputValidator.sanitizeText(m.note),
          ]),
        ),
      ];

      // ── Fixed Costs ───────────────────────────────────────────────────────────
      final fcModels = _readBox<FixedCostModel>(AppBoxNames.fixedCostsBox);
      final fcRows = [
        'id,label,amount,dueDayOfMonth,createdAt',
        ...fcModels.map(
          (m) => _row([
            InputValidator.sanitizeText(m.id),
            InputValidator.sanitizeText(m.label),
            m.amount.toString(),
            m.dueDayOfMonth.toString(),
            m.createdAt.toIso8601String(),
          ]),
        ),
      ];

      // ── STS Settings ─────────────────────────────────────────────────────────
      final prefs = await SharedPreferences.getInstance();
      final rawTaxRate = prefs.getDouble('stsSettings_taxRate') ?? 0.10;
      final rawBufferPercent =
          prefs.getDouble('stsSettings_bufferPercent') ?? 15.0;
      // Clamp to the UI-defined ranges to prevent corrupt exports.
      final taxRate = rawTaxRate.clamp(0.0, 1.0);
      final bufferPercent = rawBufferPercent.clamp(0.0, 100.0);
      final settingsRows = [
        'taxRate,bufferPercent',
        _row([taxRate.toString(), bufferPercent.toString()]),
      ];

      // ── Audit Log ─────────────────────────────────────────────────────────────
      const eventTypeNames = [
        'unknown',
        'created',
        'updated',
        'deleted',
        'confirmed',
        'exported',
      ];
      const entityTypeNames = [
        'unknown',
        'income',
        'transaction',
        'stsSettings',
        'fixedCost',
      ];
      final auditModels =
          _readBox<AuditEventModel>(AppBoxNames.auditEventsBox);
      final chainService = AuditChainService();
      final auditRows = [
        'id,timestamp,eventType,entityType,entityId,previousValue,'
            'newValue,description,schemaVersion,previousHash,currentHash',
        ...await Future.wait(auditModels.map((m) async {
          final currentHash = await chainService.hashFor(m.id) ?? '';
          final previousHash = await chainService.previousHashFor(m.id);
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

      // ── Write files ───────────────────────────────────────────────────────────
      final paths = await Future.wait([
        _writeCsv(dir, 'helm_income_$ts.csv', incomeRows),
        _writeCsv(dir, 'helm_transactions_$ts.csv', txRows),
        _writeCsv(dir, 'helm_fixed_costs_$ts.csv', fcRows),
        _writeCsv(dir, 'helm_settings_$ts.csv', settingsRows),
        _writeCsv(dir, 'helm_audit_$ts.csv', auditRows),
      ]);

      // Record that an export occurred. Fail-closed: export success without
      // an audit record is acceptable, but log failures do not roll back files.
      await _recordExportAudit(paths);

      return ExportResult(
        success: true,
        directoryPath: dir.path,
        filePaths: paths,
      );
    } on Exception catch (e) {
      return ExportResult(success: false, errorMessage: e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _pad(int n) => n.toString().padLeft(2, '0');

  /// Neutralizes CSV formula-injection payloads and strips control / BiDi
  /// characters. Values beginning with spreadsheet formula characters
  /// (=, @, +, -, tab, carriage return) are prefixed with a single quote so
  /// Excel/Sheets treat them as text. This is applied before the RFC 4180
  /// escaping so quoted fields remain safe.
  static String _sanitizeCellStatic(String v) {
    if (v.isEmpty) return v;
    // Strip control characters except newline (handled by quoting below).
    var cleaned = v.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '');
    // Strip RTL / BiDi override characters (M-5).
    cleaned = cleaned.replaceAll(RegExp(r'[\u202A-\u202E\u2066-\u2069\u200E\u200F]'), '');
    if (cleaned.isEmpty) return cleaned;
    final first = cleaned.codeUnitAt(0);
    const formulaChars = {'=', '@', '+', '-', 0x09, 0x0D}; // tab, CR
    if (formulaChars.contains(String.fromCharCode(first)) ||
        first == 0x09 ||
        first == 0x0D) {
      return "'$cleaned";
    }
    return cleaned;
  }

  String _escapeCsv(String v) => escapeCsv(v);

  /// Test-only entry point for the CSV escape pipeline.
  @visibleForTesting
  static String escapeCsv(String v) {
    final sanitized = _sanitizeCellStatic(v);
    // Always quote text fields that contain structural characters.
    if (sanitized.contains(',') ||
        sanitized.contains('"') ||
        sanitized.contains('\n')) {
      return '"${sanitized.replaceAll('"', '""')}"';
    }
    return sanitized;
  }

  String _row(List<String> fields) => fields.map(_escapeCsv).join(',');

  List<T> _readBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) return [];
    return Hive.box<T>(boxName).values.toList();
  }

  Future<void> _recordExportAudit(List<String> filePaths) async {
    try {
      if (!Hive.isBoxOpen(AppBoxNames.auditEventsBox)) return;
      final auditDs = AuditLocalDataSourceImpl();
      await auditDs.addEvent(AuditEvent(
        id: IdGenerator.uniqueId(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.exported,
        entityType: AuditEntityType.stsSettings,
        entityId: 'export',
        previousValue: null,
        newValue: filePaths.length.toString(),
        description: InputValidator.sanitizeText(
          'Data exported: ${filePaths.length} files',
        ),
      ));
    } on Exception {
      // Best-effort audit record; do not fail export.
    }
  }

  Future<String> _writeCsv(
    Directory dir,
    String name,
    List<String> rows,
  ) async {
    final file = File('${dir.path}/$name');
    // UTF-8 BOM helps Excel open non-ASCII text correctly.
    const bom = '\uFEFF';
    await file.writeAsString('$bom${rows.join('\n')}', flush: true);
    // Restrict file permissions on Unix-like systems (best-effort).
    try {
      if (!Platform.isWindows) {
        await file.setLastAccessed(DateTime.now());
        await Process.run('chmod', ['600', file.path]);
      }
    } on Exception catch (_) {
      // Permission hardening is best-effort; export must still succeed.
    }
    return file.path;
  }

  /// Removes any previous `helm_*.csv` files in the export directory so
  /// plaintext exports do not accumulate on the device.
  Future<void> _cleanStaleExports(Directory dir) async {
    try {
      final files = dir.listSync().whereType<File>().where(
            (f) =>
                f.path.split(Platform.pathSeparator).last.startsWith('helm_') &&
                f.path.toLowerCase().endsWith('.csv'),
          );
      for (final f in files) {
        await f.delete();
      }
    } on Exception catch (_) {
      // Best-effort cleanup; do not fail export if temp files cannot be removed.
    }
  }
}
