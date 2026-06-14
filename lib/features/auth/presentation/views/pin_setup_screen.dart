// lib/features/auth/presentation/views/pin_setup_screen.dart
//
// PIN setup screen for Helm Trust Layer (D1).
// Two-step flow: enter new PIN → confirm PIN.
// Uses custom numpad — no keyboard input.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:helm/config/router/route_names.dart';
import 'package:helm/core/analytics/analytics_service.dart';
import 'package:helm/core/analytics/event_registry.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/features/auth/presentation/providers/auth_provider.dart';

class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  static const int _pinLength = AuthNotifier.pinLength;

  String _firstPin = '';
  String _currentInput = '';
  bool _isConfirmStep = false;
  String? _errorMessage;

  void _onDigitTap(String digit) {
    HapticFeedback.lightImpact();
    if (_currentInput.length >= _pinLength) return;
    setState(() {
      _currentInput += digit;
      _errorMessage = null;
    });
    if (_currentInput.length == _pinLength) {
      _handlePinComplete();
    }
  }

  void _onClear() {
    HapticFeedback.lightImpact();
    if (_currentInput.isEmpty) return;
    setState(() {
      _currentInput = _currentInput.substring(0, _currentInput.length - 1);
    });
  }

  void _handlePinComplete() {
    if (!_isConfirmStep) {
      setState(() {
        _firstPin = _currentInput;
        _currentInput = '';
        _isConfirmStep = true;
      });
    } else {
      if (_currentInput == _firstPin) {
        HapticFeedback.mediumImpact();
        _finishSetup(_currentInput);
      } else {
        setState(() {
          _errorMessage = "PINs don't match. Try again.";
          _currentInput = '';
          _firstPin = '';
          _isConfirmStep = false;
        });
      }
    }
  }

  Future<void> _finishSetup(String pin) async {
    await ref.read(authProvider.notifier).setupPin(pin);
    // D2P — Beta instrumentation: PIN setup completed
    ref.read(analyticsProvider).trackEvent(
      TransactionalEvents.pinSetupCompleted,
    );
    if (!mounted) return;
    context.go(RouteNames.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            _PinHeader(
              title: _isConfirmStep ? 'Confirm your PIN' : 'Create your PIN',
              errorMessage: _errorMessage,
              colors: colors,
            ),
            const SizedBox(height: 32),
            _PinDots(
              filledCount: _currentInput.length,
              totalCount: _pinLength,
              colors: colors,
            ),
            const Spacer(),
            _NumPad(
              onDigit: _onDigitTap,
              onClear: _onClear,
              colors: colors,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PIN header
// ---------------------------------------------------------------------------

class _PinHeader extends StatelessWidget {
  const _PinHeader({
    required this.title,
    required this.errorMessage,
    required this.colors,
  });

  final String title;
  final String? errorMessage;
  final HelmColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: context.textStyles.headingLg.copyWith(
            color: colors.inkPrimary,
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            errorMessage!,
            style: context.textStyles.bodyMd.copyWith(
              color: colors.stateAtRisk,
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// PIN dot indicators
// ---------------------------------------------------------------------------

class _PinDots extends StatelessWidget {
  const _PinDots({
    required this.filledCount,
    required this.totalCount,
    required this.colors,
  });

  final int filledCount;
  final int totalCount;
  final HelmColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalCount, (i) {
        final filled = i < filledCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? colors.interactive : Colors.transparent,
              border: Border.all(
                color: colors.interactive,
                width: 2,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom numpad (3x4 grid + clear)
// ---------------------------------------------------------------------------

class _NumPad extends StatelessWidget {
  const _NumPad({
    required this.onDigit,
    required this.onClear,
    required this.colors,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onClear;
  final HelmColors colors;

  static const List<List<String?>> _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    [null, '0', 'del'],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: _rows.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              if (key == null) return const SizedBox(width: 72, height: 72);
              if (key == 'del') {
                return _NumKey(
                  label: '⌫',
                  onTap: onClear,
                  colors: colors,
                );
              }
              return _NumKey(
                label: key,
                onTap: () => onDigit(key),
                colors: colors,
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

class _NumKey extends StatelessWidget {
  const _NumKey({
    required this.label,
    required this.onTap,
    required this.colors,
  });

  final String label;
  final VoidCallback onTap;
  final HelmColors colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.surface,
          border: Border.all(color: colors.hairline),
        ),
        child: Text(
          label,
          style: context.textStyles.headingLg.copyWith(
            fontWeight: FontWeight.w500,
            color: colors.inkPrimary,
          ),
        ),
      ),
    );
  }
}
