// lib/core/widgets/buttons/button_multiple_types.dart
import 'package:flutter/material.dart';

import '../../themes/pocketa_colors.dart';

enum AppButtonType { primary, secondary, outline }

class AppButton extends StatefulWidget {
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
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final bool disabled = !widget.isEnabled || widget.isLoading;

    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;

    switch (widget.type) {
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

    return AnimatedScale(
      scale: _pressed && !disabled ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
          onTapUp: disabled
              ? null
              : (_) {
                  setState(() => _pressed = false);
                  widget.onPressed?.call();
                },
          onTapCancel: () => setState(() => _pressed = false),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: widget.isLoading
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colors.surface,
                    ),
                  )
                : Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: foregroundColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
