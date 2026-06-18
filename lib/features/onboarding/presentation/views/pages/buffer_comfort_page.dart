import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_motion.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';
import 'package:helm/l10n/app_localization.dart';

// Slider anchor points
const List<int> _anchors = [5, 15, 25, 30];

class BufferComfortPage extends StatefulWidget {
  final int initialBufferPercent;
  final double liquidBalanceBdt;
  final double totalFixedCostsBdt;
  final void Function(int bufferPercent) onContinue;

  const BufferComfortPage({
    super.key,
    required this.initialBufferPercent,
    required this.liquidBalanceBdt,
    required this.totalFixedCostsBdt,
    required this.onContinue,
  });

  @override
  State<BufferComfortPage> createState() => _BufferComfortPageState();
}

class _BufferComfortPageState extends State<BufferComfortPage>
    with TickerProviderStateMixin {
  late double _sliderValue;
  bool _showTooltip = false;
  late AnimationController _tooltipController;
  late Animation<double> _tooltipAnimation;
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int get _bufferPercent => _anchors[_sliderValue.round().clamp(0, 3)];
  double get _bufferAmount =>
      widget.liquidBalanceBdt * _bufferPercent / 100;
  double get _s2sPreview =>
      widget.liquidBalanceBdt - _bufferAmount - widget.totalFixedCostsBdt;

  @override
  void initState() {
    super.initState();
    final idx = _anchors.indexOf(widget.initialBufferPercent);
    _sliderValue = (idx >= 0 ? idx : 1).toDouble();

    _tooltipController = AnimationController(
      vsync: this,
      duration: HelmMotion.fast,
    );
    _tooltipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _tooltipController, curve: Curves.easeOut),
    );

    // Page entry animation
    _entryController = AnimationController(
      vsync: this,
      duration: HelmMotion.slow,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: HelmMotion.defaultCurve),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entryController.forward();
    });
  }

  @override
  void dispose() {
    _tooltipController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  void _onSliderChanged(double val) {
    HapticFeedback.selectionClick();
    setState(() {
      _sliderValue = val;
      _showTooltip = true;
    });
    _tooltipController.forward();
  }

  void _onSliderChangeEnd(double val) {
    final rounded = val.roundToDouble();
    if (rounded != _sliderValue) {
      HapticFeedback.lightImpact();
    }
    setState(() {
      _sliderValue = rounded;
      _showTooltip = false;
    });
    _tooltipController.reverse();
  }

  /// Formats a BDT amount using the South Asian lakh/crore grouping system.
  /// e.g. 125000 → "1,25,000"
  static String _formatLakh(double n) {
    if (n <= 0) return '0';
    final s = n.abs().toInt().toString();
    if (s.length <= 3) return s;
    final result = StringBuffer();
    final last3 = s.substring(s.length - 3);
    final rest = s.substring(0, s.length - 3);
    for (int i = 0; i < rest.length; i++) {
      if (i > 0 && (rest.length - i) % 2 == 0) result.write(',');
      result.write(rest[i]);
    }
    result.write(',');
    result.write(last3);
    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;

    final s2sColor =
        _s2sPreview >= 0 ? colors.stateSafe : colors.stateAtRisk;

    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator — step 6
          LinearProgressIndicator(
            value: HelmSpacing.onboardingBuffer,
            backgroundColor: colors.hairline,
            color: colors.interactive,
            minHeight: HelmSpacing.progressBarHeight,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: HelmSpacing.screenEdge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: HelmSpacing.s10),
                  Text(
                    l10n.bufferTitle,
                    style:
                        typo.headingLg.copyWith(color: colors.inkPrimary),
                  ),
                  const SizedBox(height: HelmSpacing.s2),
                  Text(
                    l10n.bufferSubtext,
                    style:
                        typo.bodyLg.copyWith(color: colors.inkSecondary),
                  ),
                  const SizedBox(height: HelmSpacing.s8),

                  // Slider with floating tooltip
                  Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: colors.interactive,
                          inactiveTrackColor: colors.hairline,
                          thumbColor: colors.interactive,
                          overlayColor: colors.interactive
                              .withValues(alpha: 0.12),
                          trackHeight: HelmSpacing.progressBarHeightOnboarding,
                        ),
                        child: Semantics(
                          label: l10n.bufferSliderSemantics(_bufferPercent),
                          value: l10n.bufferSliderValue(_bufferPercent),
                          child: Slider(
                            value: _sliderValue,
                            min: 0,
                            max: 3,
                            divisions: 3,
                            onChanged: _onSliderChanged,
                            onChangeEnd: _onSliderChangeEnd,
                          ),
                        ),
                      ),

                      // Floating percentage tooltip
                      if (_showTooltip)
                        Positioned(
                          top: -40,
                          child: FadeTransition(
                            opacity: _tooltipAnimation,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: HelmSpacing.s2,
                                vertical: HelmSpacing.s1,
                              ),
                              decoration: BoxDecoration(
                                color: colors.inkPrimary,
                                borderRadius: BorderRadius.circular(
                                    HelmSpacing.s1),
                              ),
                              child: Text(
                                '$_bufferPercent%',
                                style: typo.labelMd.copyWith(
                                  color: colors.surface,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Anchor percentage labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _anchors
                        .asMap()
                        .entries
                        .map(
                          (entry) => Semantics(
                            label: '${entry.value}%',
                            selected: _sliderValue.round() == entry.key,
                            child: Text(
                              '${entry.value}%',
                              style: typo.labelSm.copyWith(
                                color: _sliderValue.round() == entry.key
                                    ? colors.interactive
                                    : colors.inkTertiary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: HelmSpacing.s8),

                  // Live BDT preview card
                  Semantics(
                    label: _s2sPreview >= 0
                        ? l10n.bufferS2sPreviewPositive(_bufferPercent)
                        : l10n.bufferS2sPreviewNegative,
                    child: Container(
                      padding: const EdgeInsets.all(HelmSpacing.s4),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(
                            HelmSpacing.cardRadius),
                        border: Border.all(color: colors.hairline),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.safetyBufferTitle,
                                style: typo.bodyMd.copyWith(
                                    color: colors.inkSecondary),
                              ),
                              Text(
                                '৳ ${_formatLakh(_bufferAmount)}',
                                style: typo.monoFinancialMd.copyWith(
                                    color: colors.inkPrimary),
                              ),
                            ],
                          ),
                          Divider(
                              color: colors.hairline,
                              height: HelmSpacing.s6),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.bufferSafeToSpendLabel,
                                style: typo.bodySm.copyWith(
                                    color: colors.inkSecondary),
                              ),
                              Text(
                                '৳ ${_formatLakh(_s2sPreview)}',
                                style: typo.monoFinancialMd
                                    .copyWith(color: s2sColor),
                              ),
                            ],
                          ),
                          if (_s2sPreview < 0) ...[
                            const SizedBox(height: HelmSpacing.s2),
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: HelmSpacing.iconSm,
                                  color: colors.stateAtRisk,
                                ),
                                const SizedBox(width: HelmSpacing.s1),
                                Expanded(
                                  child: Text(
                                    l10n.bufferCostsExceedBalance,
                                    style: typo.labelSm.copyWith(
                                      color: colors.stateAtRisk,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),
                  AppButton(
                    label: l10n.saveBuffer,
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      widget.onContinue(_bufferPercent);
                    },
                    isEnabled: true,
                  ),
                  const SizedBox(height: HelmSpacing.s4),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
      ),
    );
  }
}