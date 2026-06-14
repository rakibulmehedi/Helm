// lib/features/audit_log/data/datasources/audit_local_data_source.dart
//
// Abstract interface and Hive implementation for audit log persistence.
//
// Rules:
//   - Events are APPEND-ONLY — never delete or modify audit records.
//   - Box is always retrieved via Hive.box() — never opened here.
//   - Opening is managed exclusively by HiveService.init().
//
// D1.05 — Trust Layer: Audit Log

import 'package:hive/hive.dart';
import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/features/audit_log/data/models/audit_event_model.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';

// ── Abstract interface ────────────────────────────────────────────────────────

/// Contract for local audit log data access.
///
/// All implementations must honour the append-only constraint:
/// no record may be updated or deleted once written.
abstract class AuditLocalDataSource {
  /// Appends [event] to the audit log. Never overwrites existing records.
  Future<void> addEvent(AuditEvent event);

  /// Returns all audit events, sorted newest-first by timestamp.
  Future<List<AuditEvent>> getAllEvents();

  /// Returns all audit events for a specific [entityId], newest-first.
  Future<List<AuditEvent>> getEventsForEntity(String entityId);
}

// ── Hive implementation ───────────────────────────────────────────────────────

/// Hive-backed implementation of [AuditLocalDataSource].
///
/// The box must be opened before any method is called.
/// Opening is managed exclusively by [HiveService.init()].
class AuditLocalDataSourceImpl implements AuditLocalDataSource {
  Box<AuditEventModel> get _box =>
      Hive.box<AuditEventModel>(AppBoxNames.auditEventsBox);

  @override
  Future<void> addEvent(AuditEvent event) async {
    final model = AuditEventModel.fromEntity(event);
    // Keyed by event id — never overwrite an existing key (append-only).
    await _box.put(event.id, model);
  }

  @override
  Future<List<AuditEvent>> getAllEvents() async {
    final events = _box.values.map((m) => m.toEntity()).toList();
    events.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return events;
  }

  @override
  Future<List<AuditEvent>> getEventsForEntity(String entityId) async {
    final all = await getAllEvents();
    return all.where((e) => e.entityId == entityId).toList();
  }
}
