// lib/features/settings/presentation/views/cadence_preference_sheet.dart
//
// Bottom sheet widget for setting notification cadence preferences.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helm/core/analytics/analytics_service.dart';
import 'package:helm/core/analytics/domain/nudge_preferences_entity.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';
import 'package:helm/core/widgets/helm_toast.dart';
import 'package:helm/l10n/app_localization.dart';

class CadencePreferenceSheet extends ConsumerStatefulWidget {
  const CadencePreferenceSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CadencePreferenceSheet(),
    );
  }

  @override
  ConsumerState<CadencePreferenceSheet> createState() => _CadencePreferenceSheetState();
}

class _CadencePreferenceSheetState extends ConsumerState<CadencePreferenceSheet> {
  late Cadence _cadence;
  late TimeOfDay _checkInTime;
  late bool _pushEnabled;
  late bool _inAppEnabled;
  late bool _quietAffirmationsEnabled;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(nudgePreferencesProvider);
    _cadence = prefs.cadence;
    _checkInTime = prefs.checkInTime;
    _pushEnabled = prefs.pushEnabled;
    _inAppEnabled = prefs.inAppEnabled;
    _quietAffirmationsEnabled = prefs.quietAffirmationsEnabled;
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _checkInTime,
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() => _checkInTime = picked);
    }
  }

  Future<void> _save() async {
    final newPrefs = NudgePreferencesEntity(
      cadence: _cadence,
      checkInTime: _checkInTime,
      pushEnabled: _pushEnabled,
      inAppEnabled: _inAppEnabled,
      quietAffirmationsEnabled: _quietAffirmationsEnabled,
    );

    await ref.read(nudgePreferencesProvider.notifier).updatePreferences(newPrefs);

    if (mounted) {
      HelmToast.show(
        context,
        message: context.l10n.notificationPrefsSaved,
        type: ToastType.success,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final typography = context.textStyles;

    return Container(
      decoration: BoxDecoration(
        color: colors.canvas,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.notificationPreferences,
                  style: typography.headingMd.copyWith(color: colors.inkPrimary),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: colors.inkTertiary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Cadence Selection ──────────────────────────────────────────────
            Text(
              l10n.checkInFrequency,
              style: typography.bodyLg.copyWith(fontWeight: FontWeight.bold, color: colors.inkPrimary),
            ),
            const SizedBox(height: 8),
            Row(
              children: Cadence.values.map((c) {
                final isSelected = _cadence == c;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected ? colors.interactive.withValues(alpha: 0.08) : Colors.transparent,
                        side: BorderSide(
                          color: isSelected ? colors.interactive : colors.divider,
                          width: isSelected ? 2.0 : 1.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(HelmSpacing.buttonRadius),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => setState(() => _cadence = c),
                      child: Text(
                        c.name[0].toUpperCase() + c.name.substring(1),
                        style: typography.bodyMd.copyWith(
                          color: isSelected ? colors.interactive : colors.inkSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
  
            // ── Check-in Time ──────────────────────────────────────────────────
            if (_cadence == Cadence.daily) ...[
              Text(
                l10n.preferredCheckInTime,
                style: typography.bodyLg.copyWith(fontWeight: FontWeight.bold, color: colors.inkPrimary),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectTime,
                borderRadius: BorderRadius.circular(HelmSpacing.buttonRadius),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(HelmSpacing.buttonRadius),
                    border: Border.all(color: colors.divider),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _checkInTime.format(context),
                        style: typography.bodyLg.copyWith(color: colors.inkPrimary),
                      ),
                      Icon(Icons.access_time_rounded, color: colors.interactive),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
  
            // ── Channels ───────────────────────────────────────────────────────
            Text(
              l10n.alertChannels,
              style: typography.bodyLg.copyWith(fontWeight: FontWeight.bold, color: colors.inkPrimary),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: colors.divider),
                borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
              ),
              child: Material(
                color: colors.surface,
                borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: Text(
                        l10n.pushNotifications,
                        style: typography.bodySm.copyWith(fontWeight: FontWeight.w600, color: colors.inkPrimary),
                      ),
                      subtitle: Text(
                        l10n.pushNotificationsSubtitle,
                        style: typography.labelMd.copyWith(color: colors.inkSecondary),
                      ),
                      value: _pushEnabled,
                      activeThumbColor: colors.interactive,
                      onChanged: (v) => setState(() => _pushEnabled = v),
                    ),
                    Divider(color: colors.hairline, height: 1),
                    SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: Text(
                        l10n.inAppNotificationBanner,
                        style: typography.bodySm.copyWith(fontWeight: FontWeight.w600, color: colors.inkPrimary),
                      ),
                      subtitle: Text(
                        l10n.inAppNotificationSubtitle,
                        style: typography.labelMd.copyWith(color: colors.inkSecondary),
                      ),
                      value: _inAppEnabled,
                      activeThumbColor: colors.interactive,
                      onChanged: (v) => setState(() => _inAppEnabled = v),
                    ),
                    Divider(color: colors.hairline, height: 1),
                    SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: Text(
                        l10n.quietAffirmations,
                        style: typography.bodySm.copyWith(fontWeight: FontWeight.w600, color: colors.inkPrimary),
                      ),
                      subtitle: Text(
                        l10n.quietAffirmationsSubtitle,
                        style: typography.labelMd.copyWith(color: colors.inkSecondary),
                      ),
                      value: _quietAffirmationsEnabled,
                      activeThumbColor: colors.interactive,
                      onChanged: (v) => setState(() => _quietAffirmationsEnabled = v),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Save Button ────────────────────────────────────────────────────
            AppButton(
              label: l10n.savePreferences,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
