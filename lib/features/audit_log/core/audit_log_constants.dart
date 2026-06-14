// lib/features/audit_log/core/audit_log_constants.dart
//
// Operational constants for the audit log subsystem (D1.05).

/// Current audit-event schema version. Bumped when new mandatory fields are
/// introduced so consumers can detect incompatible records.
const int kAuditSchemaVersion = 1;

/// Audit records older than this many days are pruned on every append.
const int kAuditRetentionDays = 90;
