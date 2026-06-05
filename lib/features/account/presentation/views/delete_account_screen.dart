// lib/features/account/presentation/views/delete_account_screen.dart
// D1.10 — Account deletion flow.
//
// Two-step irreversible data wipe:
//   Step 1 — Warning screen with explicit list of what is deleted.
//   Step 2 — ConfirmDeletionDialog: PIN entry (if set) or type "DELETE".
//
// Trust rules:
//   - Language is unambiguous: "This cannot be undone"
//   - Confirm button stays disabled until valid input
//   - Cancel is always available
//   - After deletion: navigates to /welcome (full reset)

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  bool _deleting = false;

  // ── Deletion logic ─────────────────────────────────────────────────────────

  Future<void> _deleteAllData() async {
    if (_deleting) return;
    setState(() => _deleting = true);

    const boxNames = [
      'transactions',
      'income_box',
      'fixed_costs_box',
      'categories',
      'audit_events_box',
      'auth_box',
    ];

    for (final name in boxNames) {
      try {
        if (Hive.isBoxOpen(name)) {
          await Hive.box<dynamic>(name).clear();
        }
      } catch (_) {}
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (_) {}

    if (mounted) context.go(RouteNames.welcome);
  }

  // ── PIN check helper ────────────────────────────────────────────────────────

  /// Returns the stored PIN hash, or null if no PIN has been set up.
  String? _getStoredPinHash() {
    try {
      if (Hive.isBoxOpen('auth_box')) {
        final box = Hive.box<dynamic>('auth_box');
        final hash = box.get('pin_hash');
        if (hash is String && hash.isNotEmpty) return hash;
      }
    } catch (_) {}
    return null;
  }

  // ── Step 2: show confirmation dialog ───────────────────────────────────────

  Future<void> _showConfirmDialog() async {
    final storedHash = _getStoredPinHash();
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => storedHash != null
          ? _PinConfirmDialog(storedPinHash: storedHash)
          : const _TypeDeleteDialog(),
    );

    if (confirmed == true && mounted) {
      await _deleteAllData();
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;
    final atRisk = colors.stateAtRisk;

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(
        backgroundColor: colors.canvas,
        elevation: 0,
        title: Text('Delete all data', style: typography.headingSm),
        leading: BackButton(color: colors.inkPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PocketaSpacing.screenEdge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Warning card
              Container(
                padding: const EdgeInsets.all(PocketaSpacing.s4),
                decoration: BoxDecoration(
                  color: atRisk.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(PocketaSpacing.cardRadius),
                  border: Border.all(color: atRisk.withValues(alpha: 0.35)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: atRisk, size: 24),
                    const SizedBox(width: PocketaSpacing.s3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'This cannot be undone',
                            style: typography.headingSm
                                .copyWith(color: atRisk),
                          ),
                          const SizedBox(height: PocketaSpacing.s1),
                          Text(
                            'Deleting your data will permanently remove all your'
                            ' income entries, transactions, settings, and change'
                            ' history from this device. There is no way to'
                            ' recover this data.',
                            style: typography.bodyMd
                                .copyWith(color: colors.inkSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: PocketaSpacing.s6),

              // What will be deleted
              Text(
                'What will be deleted',
                style: typography.headingSm
                    .copyWith(color: colors.inkPrimary),
              ),
              const SizedBox(height: PocketaSpacing.s3),
              ..._deletionItems(colors, typography),

              const Spacer(),

              // Destructive action button
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: atRisk,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(PocketaSpacing.cardRadius),
                  ),
                ),
                onPressed: _deleting ? null : _showConfirmDialog,
                child: _deleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Continue to delete'),
              ),

              const SizedBox(height: PocketaSpacing.s2),

              // Cancel link
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Cancel',
                  style: typography.bodyMd
                      .copyWith(color: colors.inkTertiary),
                ),
              ),

              const SizedBox(height: PocketaSpacing.s2),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _deletionItems(
    PocketaColors colors,
    PocketaTypography typography,
  ) {
    const items = [
      'All income entries',
      'All transactions',
      'All fixed costs',
      'Your settings',
      'Change history',
    ];
    return items
        .map(
          (item) => Padding(
            padding:
                const EdgeInsets.only(bottom: PocketaSpacing.s2),
            child: Row(
              children: [
                Icon(Icons.remove_circle_outline,
                    size: 16, color: colors.stateAtRisk),
                const SizedBox(width: PocketaSpacing.s2),
                Text(
                  item,
                  style: typography.bodyMd
                      .copyWith(color: colors.inkSecondary),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}

// ---------------------------------------------------------------------------
// PIN confirmation dialog
// ---------------------------------------------------------------------------

class _PinConfirmDialog extends StatefulWidget {
  final String storedPinHash;

  const _PinConfirmDialog({required this.storedPinHash});

  @override
  State<_PinConfirmDialog> createState() => _PinConfirmDialogState();
}

class _PinConfirmDialogState extends State<_PinConfirmDialog> {
  final List<String> _digits = [];
  bool _wrongPin = false;
  static const int _pinLength = 4;

  void _onDigit(String d) {
    if (_digits.length >= _pinLength) return;
    setState(() {
      _digits.add(d);
      _wrongPin = false;
    });
    if (_digits.length == _pinLength) _verify();
  }

  void _onDelete() {
    if (_digits.isEmpty) return;
    setState(() {
      _digits.removeLast();
      _wrongPin = false;
    });
  }

  void _verify() {
    final entered = _digits.join();
    final hash = base64Encode(utf8.encode(entered));
    if (hash == widget.storedPinHash) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _digits.clear();
        _wrongPin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;
    final atRisk = colors.stateAtRisk;

    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PocketaSpacing.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PocketaSpacing.s5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your PIN to confirm',
              style: typography.headingSm.copyWith(color: colors.inkPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PocketaSpacing.s4),

            // 4 dot indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pinLength, (i) {
                final filled = i < _digits.length;
                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: PocketaSpacing.s2),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _wrongPin
                        ? atRisk
                        : filled
                            ? colors.interactive
                            : colors.hairline,
                  ),
                );
              }),
            ),

            if (_wrongPin) ...[
              const SizedBox(height: PocketaSpacing.s2),
              Text(
                'Incorrect PIN',
                style: typography.bodySm.copyWith(color: atRisk),
              ),
            ],

            const SizedBox(height: PocketaSpacing.s4),

            // Keypad
            _Keypad(onDigit: _onDigit, onDelete: _onDelete),

            const SizedBox(height: PocketaSpacing.s4),

            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: typography.bodyMd
                    .copyWith(color: colors.inkTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// "Type DELETE" confirmation dialog (no PIN set)
// ---------------------------------------------------------------------------

class _TypeDeleteDialog extends StatefulWidget {
  const _TypeDeleteDialog();

  @override
  State<_TypeDeleteDialog> createState() => _TypeDeleteDialogState();
}

class _TypeDeleteDialogState extends State<_TypeDeleteDialog> {
  final _controller = TextEditingController();
  bool _valid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final v = _controller.text == 'DELETE';
      if (v != _valid) setState(() => _valid = v);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;
    final atRisk = colors.stateAtRisk;

    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PocketaSpacing.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PocketaSpacing.s5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Type "DELETE" to confirm',
              style: typography.headingSm.copyWith(color: colors.inkPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PocketaSpacing.s4),
            TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'DELETE',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(PocketaSpacing.cardRadius),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(PocketaSpacing.cardRadius),
                  borderSide: BorderSide(color: atRisk),
                ),
              ),
            ),
            const SizedBox(height: PocketaSpacing.s4),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: atRisk,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(PocketaSpacing.cardRadius),
                  ),
                ),
                onPressed:
                    _valid ? () => Navigator.of(context).pop(true) : null,
                child: const Text('Delete all data'),
              ),
            ),
            const SizedBox(height: PocketaSpacing.s2),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: typography.bodyMd
                    .copyWith(color: colors.inkTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Simple numeric keypad
// ---------------------------------------------------------------------------

class _Keypad extends StatelessWidget {
  final void Function(String digit) onDigit;
  final VoidCallback onDelete;

  const _Keypad({required this.onDigit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'del'],
    ];

    return Column(
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((key) {
            if (key.isEmpty) return const SizedBox(width: 72, height: 52);
            if (key == 'del') {
              return SizedBox(
                width: 72,
                height: 52,
                child: TextButton(
                  onPressed: onDelete,
                  child: Icon(Icons.backspace_outlined,
                      color: colors.inkSecondary, size: 20),
                ),
              );
            }
            return SizedBox(
              width: 72,
              height: 52,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: colors.inkPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => onDigit(key),
                child: Text(key, style: typography.headingSm),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
