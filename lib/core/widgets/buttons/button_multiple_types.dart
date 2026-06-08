// lib/core/widgets/buttons/button_multiple_types.dart
import 'package:flutter/material.dart';

import '../../themes/pocketa_colors.dart';

enum AppButtonType { primary, secondary, outline }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final AppButtonType type;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<PocketaColors>()!;
    final bool disabled = !isEnabled || isLoading;

    // Define colors based on button type
    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;

    switch (type) {
      case AppButtonType.primary:
        backgroundColor = disabled
            ? colors.interactive.withValues(alpha: 0.4)
            : colors.interactive;
        foregroundColor = colors.surface;
        borderColor = Colors.transparent;
        break;

      case AppButtonType.secondary:
        backgroundColor = colors.hairline;
        foregroundColor = colors.inkPrimary;
        borderColor = Colors.transparent;
        break;

      case AppButtonType.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = colors.interactive;
        borderColor = colors.interactive;
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: borderColor, width: 1.5),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colors.surface,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
