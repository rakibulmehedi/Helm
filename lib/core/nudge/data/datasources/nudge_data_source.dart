// lib/core/nudge/data/datasources/nudge_data_source.dart
//
// Hive-backed data source for nudge log persistence and retrieval.
// Interface + impl pattern following existing codebase conventions.

import 'package:hive_ce/hive_ce.dart';
import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/core/nudge/data/models/nudge_log_entry_model.dart';
import 'package:helm/core/nudge/domain/nudge_log_entry_entity.dart';

/// Abstract contract for nudge log persistence.
abstract interface class NudgeDataSource {
  /// Save a nudge log entry. Overwrites if same [id] exists.
  Future<void> save(NudgeLogEntryEntity entry);

  /// Retrieve all nudge log entries, newest first.
  List<NudgeLogEntryEntity> getAll();

  /// Count unread nudge entries.
  int countUnread();

  /// Mark entry with [id] as read.
  Future<void> markRead(String id);

  /// Mark entry with [id] as actioned.
  Future<void> markActioned(String id);

  /// Remove entry with [id].
  Future<void> delete(String id);

  /// Remove all nudge log entries.
  Future<void> clearAll();
}

/// Hive implementation of [NudgeDataSource].
class NudgeDataSourceImpl implements NudgeDataSource {
  Box<NudgeLogEntryModel> get _box =>
      Hive.box<NudgeLogEntryModel>(AppBoxNames.nudgeLogBox);

  @override
  Future<void> save(NudgeLogEntryEntity entry) async {
    final model = NudgeLogEntryModel.fromEntity(entry);
    await _box.put(entry.id, model);
  }

  @override
  List<NudgeLogEntryEntity> getAll() {
    final models = _box.values.toList();
    models.sort((a, b) => b.createdAtMs.compareTo(a.createdAtMs));
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  int countUnread() {
    return _box.values.where((m) => m.readAtMs == null).length;
  }

  @override
  Future<void> markRead(String id) async {
    final model = _box.get(id);
    if (model != null && model.readAtMs == null) {
      final updated = NudgeLogEntryModel(
        id: model.id,
        nudgeTypeName: model.nudgeTypeName,
        channelName: model.channelName,
        title: model.title,
        body: model.body,
        actionRoute: model.actionRoute,
        targetEntryId: model.targetEntryId,
        createdAtMs: model.createdAtMs,
        readAtMs: DateTime.now().millisecondsSinceEpoch,
        actionedAtMs: model.actionedAtMs,
      );
      await _box.put(id, updated);
    }
  }

  @override
  Future<void> markActioned(String id) async {
    final model = _box.get(id);
    if (model != null && model.actionedAtMs == null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final updated = NudgeLogEntryModel(
        id: model.id,
        nudgeTypeName: model.nudgeTypeName,
        channelName: model.channelName,
        title: model.title,
        body: model.body,
        actionRoute: model.actionRoute,
        targetEntryId: model.targetEntryId,
        createdAtMs: model.createdAtMs,
        readAtMs: model.readAtMs ?? now,
        actionedAtMs: now,
      );
      await _box.put(id, updated);
    }
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
  }
}
