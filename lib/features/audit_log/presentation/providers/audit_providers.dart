// lib/features/audit_log/presentation/providers/audit_providers.dart
//
// Riverpod providers for the audit log feature.
//
// D1.05 — Trust Layer: Audit Log

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helm/features/audit_log/data/datasources/audit_local_data_source.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';

/// Provides the [AuditLocalDataSourceImpl] singleton.
final auditLocalDataSourceProvider = Provider<AuditLocalDataSourceImpl>((ref) {
  return AuditLocalDataSourceImpl();
});

/// Provides all audit events, newest-first.
///
/// Use [ref.refresh(auditEventsProvider)] to force a reload after a write.
final auditEventsProvider = FutureProvider<List<AuditEvent>>((ref) async {
  final ds = ref.read(auditLocalDataSourceProvider);
  return ds.getAllEvents();
});
