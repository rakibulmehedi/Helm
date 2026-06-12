// lib/core/nudge/domain/nudge_effectiveness_service.dart
//
// Pure domain service for computing nudge effectiveness metrics.
// Reads from NudgeLogEntry + AnalyticsRepository to compute rates.

import 'package:flutter/foundation.dart';
import 'package:pocketa_v2/core/analytics/domain/analytics_repository.dart';
import 'package:pocketa_v2/core/nudge/domain/nudge_log_entry_entity.dart';
import 'package:pocketa_v2/core/nudge/domain/nudge_types.dart';

/// Per-nudge-type effectiveness metrics.
@immutable
class NudgeEffectivenessMetrics {
  final NudgeType nudgeType;
  final int sent;
  final int opened;
  final int dismissed;
  final int actioned;

  const NudgeEffectivenessMetrics({
    required this.nudgeType,
    required this.sent,
    required this.opened,
    required this.dismissed,
    required this.actioned,
  });

  double get openRate => sent > 0 ? opened / sent : 0;
  double get dismissRate => sent > 0 ? dismissed / sent : 0;
  double get actionRate => opened > 0 ? actioned / opened : 0;

  Map<String, dynamic> toReportRow() => {
        'type': nudgeType.name,
        'sent': sent,
        'opened': opened,
        'dismissed': dismissed,
        'actioned': actioned,
        'openRate': (openRate * 100).toStringAsFixed(0),
        'dismissRate': (dismissRate * 100).toStringAsFixed(0),
        'actionRate': (actionRate * 100).toStringAsFixed(0),
      };
}

/// Computes effectiveness metrics for all nudge types.
///
/// Metrics are derived from two sources:
/// - [NudgeLogEntryEntity] records for sent/actioned counts
/// - [AnalyticsRepository] for opened/dismissed event counts
class NudgeEffectivenessService {
  final AnalyticsRepository _analyticsRepository;

  const NudgeEffectivenessService({
    required AnalyticsRepository analyticsRepository,
  }) : _analyticsRepository = analyticsRepository;

  /// Compute effectiveness for a specific [NudgeType] based on log entries.
  Future<NudgeEffectivenessMetrics> computeForType(
    NudgeType nudgeType,
    List<NudgeLogEntryEntity> entries,
  ) async {
    final typeEntries =
        entries.where((e) => e.nudgeType == nudgeType).toList();
    final sent = typeEntries.length;
    final actioned = typeEntries.where((e) => e.isActioned).length;

    final openedCount =
        await _analyticsRepository.getEventCount('nudge_opened');
    final dismissedCount =
        await _analyticsRepository.getEventCount('nudge_dismissed');

    return NudgeEffectivenessMetrics(
      nudgeType: nudgeType,
      sent: sent,
      opened: openedCount,
      dismissed: dismissedCount,
      actioned: actioned,
    );
  }

  /// Compute effectiveness for all nudge types.
  Future<Map<NudgeType, NudgeEffectivenessMetrics>> computeAll(
    List<NudgeLogEntryEntity> entries,
  ) async {
    final results = <NudgeType, NudgeEffectivenessMetrics>{};
    for (final type in NudgeType.values) {
      results[type] = await computeForType(type, entries);
    }
    return results;
  }
}
