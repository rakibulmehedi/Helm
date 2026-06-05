import 'package:flutter/material.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';

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

class _BufferComfortPageState extends State<BufferComfortPage> {
  static const List<int> _anchors = [5, 15, 25, 30];

  // 0.0–3.0 maps to _anchors indices
  late double _sliderValue;

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
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typo = Theme.of(context).extension<PocketaTypography>()!;

    final s2sColor =
        _s2sPreview >= 0 ? colors.stateSafe : colors.stateAtRisk;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress indicator — 88%
          LinearProgressIndicator(
            value: 0.88,
            backgroundColor: colors.hairline,
            color: colors.interactive,
            minHeight: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: PocketaSpacing.screenEdge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: PocketaSpacing.s10),
                  Text(
                    'Set your safety buffer',
                    style:
                        typo.headingLg.copyWith(color: colors.inkPrimary),
                  ),
                  const SizedBox(height: PocketaSpacing.s2),
                  Text(
                    'This is not locked money. It is a safety margin inside the calculation.',
                    style:
                        typo.bodyLg.copyWith(color: colors.inkSecondary),
                  ),
                  const SizedBox(height: PocketaSpacing.s8),

                  // Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: colors.interactive,
                      inactiveTrackColor: colors.hairline,
                      thumbColor: colors.interactive,
                      overlayColor: colors.interactive
                          .withValues(alpha: 0.12),
                      trackHeight: 3,
                    ),
                    child: Slider(
                      value: _sliderValue,
                      min: 0,
                      max: 3,
                      divisions: 3,
                      onChanged: (val) =>
                          setState(() => _sliderValue = val),
                      onChangeEnd: (val) => setState(
                          () => _sliderValue = val.roundToDouble()),
                    ),
                  ),

                  // Anchor percentage labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _anchors
                        .map(
                          (pct) => Text(
                            '$pct%',
                            style: typo.labelSm.copyWith(
                              color: pct == _bufferPercent
                                  ? colors.interactive
                                  : colors.inkTertiary,
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: PocketaSpacing.s8),

                  // Live BDT preview card
                  Container(
                    padding: const EdgeInsets.all(PocketaSpacing.s4),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(
                          PocketaSpacing.cardRadius),
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
                              'Safety buffer',
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
                            height: PocketaSpacing.s6),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Safe-to-Spend',
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
                      ],
                    ),
                  ),

                  const Spacer(),
                  AppButton(
                    label: 'Save — finish Safe-to-Spend setup',
                    onPressed: () => widget.onContinue(_bufferPercent),
                    isEnabled: true,
                  ),
                  const SizedBox(height: PocketaSpacing.s4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
