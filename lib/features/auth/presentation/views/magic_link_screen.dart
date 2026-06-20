// lib/features/auth/presentation/views/magic_link_screen.dart
//
// Magic Link authentication screen.
// State 1: Email input → sends Magic Link
// State 2: "Check your inbox" → paste/enter verification token
// State 3: Error display (rate limited, invalid email, expired token)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';
import 'package:helm/features/auth/presentation/providers/magic_link_provider.dart';
import 'package:helm/l10n/app_localization.dart';

enum _MagicLinkStep { emailInput, verifying }

class MagicLinkScreen extends ConsumerStatefulWidget {
  final VoidCallback onAuthenticated;
  final VoidCallback onGuest;

  const MagicLinkScreen({
    super.key,
    required this.onAuthenticated,
    required this.onGuest,
  });

  @override
  ConsumerState<MagicLinkScreen> createState() => _MagicLinkScreenState();
}

class _MagicLinkScreenState extends ConsumerState<MagicLinkScreen> {
  final _emailCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();
  var _step = _MagicLinkStep.emailInput;
  var _error = '';
  var _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _tokenCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMagicLink() async {
    final l10n = context.l10n;
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _error = l10n.errorEnterEmail);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    final accepted = await ref.read(sendMagicLinkProvider(email).future);

    if (!mounted) return;

    if (accepted) {
      setState(() {
        _step = _MagicLinkStep.verifying;
        _isLoading = false;
        _error = '';
      });
    } else {
      setState(() {
        _error = l10n.errorTooManyRequests;
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyToken() async {
    final l10n = context.l10n;
    final token = _tokenCtrl.text.trim();
    if (token.isEmpty) {
      setState(() => _error = l10n.errorEnterCode);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    final session = await ref.read(verifyMagicLinkProvider(token).future);

    if (!mounted) return;

    if (session != null) {
      widget.onAuthenticated();
    } else {
      setState(() {
        _error = l10n.errorInvalidCode;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: HelmSpacing.screenEdge),
          child: Center(
            child: SingleChildScrollView(
              child: _step == _MagicLinkStep.emailInput
                  ? _buildEmailStep(colors, typo, l10n)
                  : _buildVerifyStep(colors, typo, l10n),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailStep(HelmColors colors, HelmTypography typo, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.signInToHelm,
          style: typo.headingLg.copyWith(color: colors.inkPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HelmSpacing.s2),
        Text(
          l10n.magicLinkSubtitle,
          style: typo.bodyLg.copyWith(color: colors.inkSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HelmSpacing.s6),
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _sendMagicLink(),
          decoration: InputDecoration(
            hintText: l10n.emailHint,
            hintStyle: typo.bodyMd.copyWith(color: colors.inkTertiary),
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.inkTertiary.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.inkTertiary.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.interactive, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: HelmSpacing.s4),
        AppButton(
          label: _isLoading ? l10n.sending : l10n.sendMagicLink,
          onPressed: _isLoading ? null : _sendMagicLink,
          isEnabled: !_isLoading,
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: HelmSpacing.s3),
          Text(_error, style: typo.labelSm.copyWith(color: colors.stateAtRisk), textAlign: TextAlign.center),
        ],
        const SizedBox(height: HelmSpacing.s4),
        AppButton(
          label: 'Use as Guest',
          onPressed: widget.onGuest,
          type: AppButtonType.outline,
        ),
      ],
    );
  }

  Widget _buildVerifyStep(HelmColors colors, HelmTypography typo, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.mark_email_unread_rounded, size: 48, color: colors.interactive),
        const SizedBox(height: HelmSpacing.s4),
        Text(
          l10n.checkYourInbox,
          style: typo.headingLg.copyWith(color: colors.inkPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HelmSpacing.s2),
        Text(
          l10n.magicLinkSentSubtitle(_emailCtrl.text.trim()),
          style: typo.bodyLg.copyWith(color: colors.inkSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HelmSpacing.s6),
        TextField(
          key: const Key('magic_link_token_field'),
          controller: _tokenCtrl,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _verifyToken(),
          decoration: InputDecoration(
            hintText: l10n.pasteVerificationCode,
            hintStyle: typo.bodyMd.copyWith(color: colors.inkTertiary),
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.inkTertiary.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.inkTertiary.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.interactive, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: HelmSpacing.s4),
        AppButton(
          label: _isLoading ? l10n.verifying : l10n.verifyAndSignIn,
          onPressed: _isLoading ? null : _verifyToken,
          isEnabled: !_isLoading,
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: HelmSpacing.s3),
          Text(_error, style: typo.labelSm.copyWith(color: colors.stateAtRisk), textAlign: TextAlign.center),
        ],
        const SizedBox(height: HelmSpacing.s4),
        TextButton(
          onPressed: () {
            setState(() {
              _step = _MagicLinkStep.emailInput;
              _error = '';
            });
          },
          child: Text(l10n.useDifferentEmail, style: typo.labelSm.copyWith(color: colors.interactive)),
        ),
      ],
    );
  }
}
