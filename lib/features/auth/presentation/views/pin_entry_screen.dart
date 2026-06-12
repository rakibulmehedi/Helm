// lib/features/auth/presentation/views/pin_entry_screen.dart
//
// PIN entry (unlock) screen for Pocketa Trust Layer (D1).
// Shows attempt counter, locks after 5 failed attempts.
// Uses custom numpad — no keyboard input.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/analytics/analytics_service.dart';
import 'package:pocketa_v2/core/analytics/event_registry.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/features/auth/presentation/providers/auth_provider.dart';

class PinEntryScreen extends ConsumerStatefulWidget {
  const PinEntryScreen({super.key});

  @override
  ConsumerState<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends ConsumerState<PinEntryScreen> {
  static const int _pinLength = 4;
  static const int _maxAttempts = 5;

  String _currentInput = '';
  String? _message;

  @override
  void initState() {
    super.initState();
    // D2P — Beta instrumentation: PIN gate presented
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(analyticsProvider).trackEvent(
          TransactionalEvents.pinGateOpened,
        );
      }
    });
  }

  bool get _isLockedOut {
    final authState = ref.read(authProvider);
    return authState.isLocked && authState.failedAttempts >= _maxAttempts;
  }

  void _onDigitTap(String digit) {
    HapticFeedback.lightImpact();
    if (_isLockedOut) return;
    if (_currentInput.length >= _pinLength) return;
    setState(() {
      _currentInput += digit;
      _message = null;
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

  Future<void> _handlePinComplete() async {
    final pin = _currentInput;
    setState(() => _currentInput = '');

    final success = await ref.read(authProvider.notifier).authenticate(pin);
    if (!mounted) return;

    if (success) {
      HapticFeedback.mediumImpact();
      // D2P — Beta instrumentation: PIN unlock success
      ref.read(analyticsProvider).trackEvent(TransactionalEvents.pinAuthSuccess);
      context.go(RouteNames.dashboard);
      return;
    }

    final authState = ref.read(authProvider);
    HapticFeedback.heavyImpact();
    final remaining = _maxAttempts - authState.failedAttempts;
    // D2P — Beta instrumentation: PIN unlock failure
    ref.read(analyticsProvider).trackEvent(
      TransactionalEvents.pinAuthFailed,
      properties: {EventProperties.remainingAttempts: remaining.clamp(0, _maxAttempts)},
    );
    setState(() {
      if (authState.failedAttempts >= _maxAttempts) {
        _message = 'Too many attempts. Restart the app.';
      } else {
        _message = 'Incorrect PIN — $remaining attempts remaining';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final authState = ref.watch(authProvider);
    final lockedOut = authState.isLocked && authState.failedAttempts >= _maxAttempts;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            _PinEntryHeader(
              message: _message,
              failedAttempts: authState.failedAttempts,
              isLockedOut: lockedOut,
              colors: colors,
            ),
            const SizedBox(height: 32),
            _PinDots(
              filledCount: _currentInput.length,
              totalCount: _pinLength,
              colors: colors,
            ),
            const Spacer(),
            if (!lockedOut)
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
// Header: title + feedback message
// ---------------------------------------------------------------------------

class _PinEntryHeader extends StatelessWidget {
  const _PinEntryHeader({
    required this.message,
    required this.failedAttempts,
    required this.isLockedOut,
    required this.colors,
  });

  final String? message;
  final int failedAttempts;
  final bool isLockedOut;
  final PocketaColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Enter your PIN',
          style: Theme.of(context).extension<PocketaTypography>()!.headingLg.copyWith(
            color: colors.inkPrimary,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(
            message!,
            style: Theme.of(context).extension<PocketaTypography>()!.bodyMd.copyWith(
              color: isLockedOut ? colors.stateAtRisk : colors.stateTight,
            ),
            textAlign: TextAlign.center,
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
  final PocketaColors colors;

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
  final PocketaColors colors;

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
  final PocketaColors colors;

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
          style: Theme.of(context).extension<PocketaTypography>()!.headingLg.copyWith(
            fontWeight: FontWeight.w500,
            color: colors.inkPrimary,
          ),
        ),
      ),
    );
  }
}
