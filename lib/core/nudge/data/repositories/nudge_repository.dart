// lib/core/nudge/data/repositories/nudge_repository.dart
//
// Repository for nudge log operations.
// Wraps NudgeDataSource and provides domain-level operations.

import 'package:pocketa_v2/core/nudge/data/datasources/nudge_data_source.dart';
import 'package:pocketa_v2/core/nudge/domain/nudge_log_entry_entity.dart';

/// Abstract repository for nudge log persistence.
abstract interface class NudgeRepository {
  /// Persist a new nudge log entry.
  Future<void> save(NudgeLogEntryEntity entry);

  /// Retrieve all nudge log entries, newest first.
  List<NudgeLogEntryEntity> getAll();

  /// Count unread entries.
  int countUnread();

  /// Mark entry as read.
  Future<void> markRead(String id);

  /// Mark entry as actioned.
  Future<void> markActioned(String id);

  /// Remove a specific entry.
  Future<void> delete(String id);

  /// Clear all entries.
  Future<void> clearAll();
}

/// Concrete implementation of [NudgeRepository].
class NudgeRepositoryImpl implements NudgeRepository {
  final NudgeDataSource _dataSource;

  NudgeRepositoryImpl({required NudgeDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<void> save(NudgeLogEntryEntity entry) => _dataSource.save(entry);

  @override
  List<NudgeLogEntryEntity> getAll() => _dataSource.getAll();

  @override
  int countUnread() => _dataSource.countUnread();

  @override
  Future<void> markRead(String id) => _dataSource.markRead(id);

  @override
  Future<void> markActioned(String id) => _dataSource.markActioned(id);

  @override
  Future<void> delete(String id) => _dataSource.delete(id);

  @override
  Future<void> clearAll() => _dataSource.clearAll();
}
