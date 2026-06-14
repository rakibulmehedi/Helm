// lib/core/nudge/data/models/nudge_log_entry_model.dart
//
// Hive model for NudgeLogEntry (typeId: 8).
// Serializes NudgeType and NudgeChannel as strings.

import 'package:hive_ce/hive_ce.dart';
import 'package:helm/core/nudge/domain/nudge_log_entry_entity.dart';
import 'package:helm/core/nudge/domain/nudge_types.dart';
import 'package:helm/core/utils/input_validator.dart';

part 'nudge_log_entry_model.g.dart';

@HiveType(typeId: 8)
class NudgeLogEntryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nudgeTypeName;

  @HiveField(2)
  final String channelName;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String body;

  @HiveField(5)
  final String? actionRoute;

  @HiveField(6)
  final String? targetEntryId;

  @HiveField(7)
  final int createdAtMs;

  @HiveField(8)
  final int? readAtMs;

  @HiveField(9)
  final int? actionedAtMs;

  NudgeLogEntryModel({
    required this.id,
    required this.nudgeTypeName,
    required this.channelName,
    required this.title,
    required this.body,
    this.actionRoute,
    this.targetEntryId,
    required this.createdAtMs,
    this.readAtMs,
    this.actionedAtMs,
  });

  NudgeLogEntryEntity toEntity() => NudgeLogEntryEntity(
        id: id,
        nudgeType: NudgeType.values.firstWhere(
          (e) => e.name == nudgeTypeName,
          orElse: () => NudgeType.reEngagement,
        ),
        channel: NudgeChannel.values.firstWhere(
          (e) => e.name == channelName,
          orElse: () => NudgeChannel.inAppOnly,
        ),
        title: title,
        body: body,
        actionRoute: actionRoute,
        targetEntryId: targetEntryId,
        createdAt:
            InputValidator.dateTimeFromMillis(createdAtMs) ?? DateTime.now(),
        readAt: InputValidator.dateTimeFromMillis(readAtMs),
        actionedAt: InputValidator.dateTimeFromMillis(actionedAtMs),
      );

  factory NudgeLogEntryModel.fromEntity(NudgeLogEntryEntity entity) =>
      NudgeLogEntryModel(
        id: entity.id,
        nudgeTypeName: entity.nudgeType.name,
        channelName: entity.channel.name,
        title: entity.title,
        body: entity.body,
        actionRoute: entity.actionRoute,
        targetEntryId: entity.targetEntryId,
        createdAtMs: entity.createdAt.millisecondsSinceEpoch,
        readAtMs: entity.readAt?.millisecondsSinceEpoch,
        actionedAtMs: entity.actionedAt?.millisecondsSinceEpoch,
      );
}
