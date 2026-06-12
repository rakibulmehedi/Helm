// lib/core/nudge/domain/nudge_log_entry_entity.dart
//
// Pure domain entity representing a single logged nudge delivery.
// No framework dependencies.

import 'package:flutter/foundation.dart';
import 'package:pocketa_v2/core/nudge/domain/nudge_types.dart';

/// Immutable record of a nudge that was delivered to the user.
///
/// Tracks delivery metadata, read status, and user action for
/// nudge effectiveness measurement (Group 3E).
@immutable
class NudgeLogEntryEntity {
  final String id;
  final NudgeType nudgeType;
  final NudgeChannel channel;
  final String title;
  final String body;
  final String? actionRoute;
  final String? targetEntryId;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? actionedAt;

  const NudgeLogEntryEntity({
    required this.id,
    required this.nudgeType,
    required this.channel,
    required this.title,
    required this.body,
    this.actionRoute,
    this.targetEntryId,
    required this.createdAt,
    this.readAt,
    this.actionedAt,
  });

  /// Whether the user has viewed this nudge.
  bool get isRead => readAt != null;

  /// Whether the user acted on this nudge.
  bool get isActioned => actionedAt != null;

  /// Time between creation and read, or null.
  Duration? get timeToRead =>
      readAt?.difference(createdAt);

  /// Time between creation and action, or null.
  Duration? get timeToAction =>
      actionedAt?.difference(createdAt);

  NudgeLogEntryEntity copyWith({
    String? id,
    NudgeType? nudgeType,
    NudgeChannel? channel,
    String? title,
    String? body,
    String? actionRoute,
    String? targetEntryId,
    DateTime? createdAt,
    DateTime? readAt,
    DateTime? actionedAt,
    bool clearReadAt = false,
    bool clearActionedAt = false,
  }) {
    return NudgeLogEntryEntity(
      id: id ?? this.id,
      nudgeType: nudgeType ?? this.nudgeType,
      channel: channel ?? this.channel,
      title: title ?? this.title,
      body: body ?? this.body,
      actionRoute: actionRoute ?? this.actionRoute,
      targetEntryId: targetEntryId ?? this.targetEntryId,
      createdAt: createdAt ?? this.createdAt,
      readAt: clearReadAt ? null : (readAt ?? this.readAt),
      actionedAt: clearActionedAt ? null : (actionedAt ?? this.actionedAt),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NudgeLogEntryEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
