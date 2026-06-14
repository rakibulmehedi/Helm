// lib/core/widgets/helm_toast.dart
// UX-5.09 — Financial-Safe Toast (SnackBar replacement)
//
// Never use raw SnackBar in Helm. Always use HelmToast.show().
// State is signaled via border color only — no background tinting, no icons.
// Elevation 0, no shadows.

import 'package:flutter/material.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';

/// Semantic type of the toast notification.
enum ToastType {
  /// Default neutral information.
  neutral,

  /// Positive outcome (border: stateSafe).
  success,

  /// Caution or soft warning (border: stateTight).
  warning,

  /// Error or destructive outcome (border: stateAtRisk).
  error,
}

/// Displays a financial-safe, border-signaled toast via [ScaffoldMessenger].
///
/// Design constraints:
///   - Background: colors.surface (never tinted)
///   - Border: 1pt, color varies by [ToastType]
///   - Radius: HelmSpacing.cardRadius (12pt)
///   - Text: bodyMd, inkPrimary
///   - No icons, no colored backgrounds, elevation: 0
///   - Action button uses interactive color (tertiary-style teal)
final class HelmToast {
  HelmToast._();

  /// Shows a [HelmToast] in the nearest [ScaffoldMessenger].
  ///
  /// [message] must not contain emoji.
  /// [actionLabel] and [onAction] must both be provided together or both null.
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.neutral,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    assert(
      (actionLabel == null) == (onAction == null),
      'actionLabel and onAction must both be provided or both null.',
    );

    final colors = context.colors;
    final typography = context.textStyles;

    final Color borderColor = _borderColor(type, colors);

    SnackBarAction? action;
    if (actionLabel != null && onAction != null) {
      action = SnackBarAction(
        label: actionLabel,
        textColor: colors.interactive,
        onPressed: onAction,
      );
    }

    final SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: typography.bodyMd.copyWith(color: colors.inkPrimary),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: colors.surface,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
        side: BorderSide(color: borderColor, width: 1),
      ),
      duration: duration,
      action: action,
    );

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  static Color _borderColor(ToastType type, HelmColors colors) {
    switch (type) {
      case ToastType.neutral:
        return colors.divider;
      case ToastType.success:
        return colors.stateSafe;
      case ToastType.warning:
        return colors.stateTight;
      case ToastType.error:
        return colors.stateAtRisk;
    }
  }
}
