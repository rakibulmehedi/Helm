// lib/core/widgets/helm_trust_strip.dart
// UX-5.08 — Trust Strip: Timestamp + Source + Audit Access
//
// Proof-of-calculation strip displayed beneath financial figures.
// inkSecondary color ensures readability on low-quality screens.
// "Tap to audit" only shown when onTapAudit callback is provided.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/utils/number_formatter.dart';

/// Renders a single-line trust strip showing when data was last updated,
/// optional source context, FX rate, and an audit tap affordance.
///
/// Design rules:
///   - Color: inkSecondary (readable on low-quality screens; NOT inkTertiary)
///   - Font: labelSm (11pt weight 500)
///   - Max 1 line; overflow → ellipsis
///   - Min touch target 44pt when tappable
///   - Segments separated by " · " (middle dot)
class HelmTrustStrip extends StatelessWidget {
  /// When data was last updated.
  final DateTime updatedAt;

  /// Optional source label (e.g., "Received only", "Payoneer").
  final String? sourceLabel;

  /// Optional FX rate; displayed as "FX tk119.66" when provided.
  final double? fxRate;

  /// When provided, adds "Tap to audit" segment and makes strip tappable.
  final VoidCallback? onTapAudit;

  /// Optional quiet affirmation signal (facts only, no celebration).
  final String? affirmation;

  const HelmTrustStrip({
    super.key,
    required this.updatedAt,
    this.sourceLabel,
    this.fxRate,
    this.onTapAudit,
    this.affirmation,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<HelmColors>()!;
    final typography = Theme.of(context).extension<HelmTypography>()!;

    final String fullLabel = _buildLabel();
    final TextStyle textStyle =
        typography.labelSm.copyWith(color: colors.inkSecondary);

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          fullLabel,
          style: textStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (affirmation != null && affirmation!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            affirmation!,
            style: typography.labelSm.copyWith(
              color: colors.stateSafe,
              fontSize: 10,
              height: 1.3,
            ),
          ),
        ],
      ],
    );

    final Widget semanticChild = Semantics(
      label: '$fullLabel${affirmation != null ? '. $affirmation' : ''}',
      button: onTapAudit != null,
      child: content,
    );

    if (onTapAudit != null) {
      return GestureDetector(
        onTap: onTapAudit,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: HelmSpacing.s10 + 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: semanticChild,
          ),
        ),
      );
    }

    return semanticChild;
  }

  String _buildLabel() {
    final List<String> segments = [_formatTime()];

    if (sourceLabel != null && sourceLabel!.isNotEmpty) {
      segments.add(sourceLabel!);
    }

    if (fxRate != null) {
      segments.add('FX ${NumberFormatter.formatFXRate(fxRate!)}');
    }

    if (onTapAudit != null) {
      segments.add('Tap to audit');
    }

    return segments.join(' \u00B7 '); // · middle dot
  }

  String _formatTime() {
    final Duration diff = DateTime.now().difference(updatedAt);

    if (diff.inMinutes < 5) {
      final int minutes = diff.inMinutes;
      if (minutes <= 0) {
        return 'Updated just now';
      }
      final String plural = minutes == 1 ? '' : 's';
      return 'Updated $minutes min$plural ago';
    }

    // e.g., "Updated 11:42 PM"
    final String timeStr = DateFormat.jm().format(updatedAt);
    return 'Updated $timeStr';
  }
}
