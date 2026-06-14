import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/helm_colors.dart';
import '../../themes/helm_motion.dart';
import '../../themes/helm_spacing.dart';
import '../../themes/helm_typography.dart';

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

  void _handleTap() {
    if (!widget.isEnabled || widget.isLoading) return;
    HapticFeedback.lightImpact();
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<HelmColors>()!;
    final typo = Theme.of(context).extension<HelmTypography>()!;
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

    return Semantics(
      button: true,
      label: widget.label,
      enabled: widget.isEnabled,
      child: AnimatedScale(
        scale: _pressed && !disabled ? 0.97 : 1.0,
        duration: HelmMotion.fast,
        child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(HelmSpacing.buttonRadius),
        child: InkWell(
          onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
          onTapUp: disabled ? null : (_) {
            setState(() => _pressed = false);
            _handleTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          borderRadius: BorderRadius.circular(HelmSpacing.buttonRadius),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: HelmSpacing.s4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(HelmSpacing.buttonRadius),
              border: Border.all(color: borderColor, width: HelmSpacing.cardBorder),
            ),
            child: widget.isLoading
                ? Semantics(
                    label: 'Loading',
                    child: SizedBox(
                      height: HelmSpacing.iconLg,
                      width: HelmSpacing.iconLg,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colors.surface,
                      ),
                    ),
                  )
                : Text(
                    widget.label,
                    style: typo.headingSm.copyWith(
                      color: foregroundColor,
                    ),
                  ),
          ),
        ),
        ),
      ),
    );
  }
}