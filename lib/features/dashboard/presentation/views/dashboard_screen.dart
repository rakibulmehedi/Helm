// lib/features/dashboard/presentation/views/dashboard_screen.dart
//
// UX-1.08 — Dashboard Cockpit Redesign.
//
// Replaces the generic expense-tracker layout (income/expense chips,
// recent transactions list) with the doctrine-aligned Reality Stack.
//
// Violations removed:
//   - Income / Expense summary chip row (DASH-004)
//   - Recent Transactions list (DASH-004)
//   - Transaction filter chips
//   - Dev reset button in production (UX-1.11)
//
// Added:
//   - PocketaRealityStack with 4 named tiers (UX-1.01)
//   - S2sHeroBlock: SAFE-TO-SPEND cockpit (UX-1.03)
//   - CommittedSection: fixed-cost pressure (UX-1.04)
//   - ReserveSection: anxiety buffer (UX-1.05)
//   - NotCountedSection: pipeline hope tier (UX-1.06)
//   - PocketaCalculationTrace on hero tap (UX-1.09)
//   - FAB "Add Pipeline Entry" → addIncome route (UX-1.10)
//   - kDebugMode gate on dev reset button (UX-1.11)
// D2.03 — analytics: stsViewed + dailyActiveSession on initState,
//          calculationBreakdownOpened on onTapTrace.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/analytics/analytics_service.dart';
import 'package:pocketa_v2/core/analytics/event_registry.dart';
import 'package:pocketa_v2/core/local_storage/shared_pref_service.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/widgets/pocketa_calculation_trace.dart';
import 'package:pocketa_v2/core/widgets/pocketa_reality_stack.dart';
import 'package:pocketa_v2/features/dashboard/domain/affirmation.dart';
import 'package:pocketa_v2/features/dashboard/presentation/widgets/committed_section.dart';
import 'package:pocketa_v2/features/dashboard/presentation/widgets/not_counted_section.dart';
import 'package:pocketa_v2/features/dashboard/presentation/widgets/reserve_section.dart';
import 'package:pocketa_v2/features/dashboard/presentation/widgets/s2s_hero_block.dart';
import 'package:pocketa_v2/features/income/presentation/providers/income_providers.dart';
import 'package:pocketa_v2/features/income/domain/entities/income_entry_entity.dart';
import 'package:pocketa_v2/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _showStsHint = false;
  String? _affirmation;

  @override
  void initState() {
    super.initState();
    // A3.2 — Show one-time S2S hint on first dashboard view.
    if (!SharedPrefServices.getStsHintShown()) {
      _showStsHint = true;
    }
    // D2.03 — Fire session-open analytics events on every dashboard mount.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _computeAffirmation();
      final analytics = ref.read(analyticsProvider);
      final stsResult = ref.read(safeToSpendProvider);
      analytics.trackEvent(TransactionalEvents.stsViewed);
      analytics.trackEvent(
        BoundaryEvents.dailyActiveSession,
        properties: {
          EventProperties.sessionDate:
              DateTime.now().toIso8601String().substring(0, 10),
        },
      );

      // P1.1: sts_at_risk_entered — fire once per session
      if (stsResult.rawSafeToSpend <= -stsResult.anxietyBuffer &&
          !SharedPrefServices.getEventFired(BoundaryEvents.stsAtRiskEntered)) {
        analytics.trackEvent(BoundaryEvents.stsAtRiskEntered);
        SharedPrefServices.setEventFired(BoundaryEvents.stsAtRiskEntered);
      }

      // P1.2: reserve_depleted — fire once per session
      if (stsResult.anxietyBuffer == 0 &&
          !SharedPrefServices.getEventFired(BoundaryEvents.reserveDepleted)) {
        analytics.trackEvent(BoundaryEvents.reserveDepleted);
        SharedPrefServices.setEventFired(BoundaryEvents.reserveDepleted);
      }
    });
  }

  void _computeAffirmation() {
    final incomeEntries = ref.read(incomeNotifierProvider);
    final now = DateTime.now();
    final overdueCount = incomeEntries
        .where((e) =>
            e.status == IncomeStatus.expected &&
            e.expectedDate.isBefore(now))
        .length;
    final sessionCount = SharedPrefServices.getSessionCount();
    SharedPrefServices.incrementSessionCount();

    final result = Affirmation.compute(
      overdueEntryCount: overdueCount,
      sessionCount: sessionCount,
    );
    setState(() {
      _affirmation = result.type != AffirmationType.none ? result.copy : null;
    });
  }

  void _dismissStsHint() {
    setState(() => _showStsHint = false);
    SharedPrefServices.setStsHintShown(true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;
    final stsResult = ref.watch(safeToSpendProvider);

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(
        title: Text('Pocketa', style: typography.headingMd),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          // UX-1.11 — dev reset gated to debug builds only.
          if (kDebugMode)
            IconButton(
              tooltip: 'Reset onboarding (dev only)',
              icon: const Icon(Icons.refresh_rounded, size: 20),
              onPressed: () async {
                await SharedPrefServices.setOnboardingCompleted(false);
                if (context.mounted) context.go(RouteNames.welcome);
              },
            ),
        ],
      ),
      // UX-1.10 — FAB: "Add Pipeline Entry", not "Add Transaction".
      floatingActionButton: FloatingActionButton(
        heroTag: 'addPipelineEntryFab',
        backgroundColor: colors.interactive,
        onPressed: () => context.push(RouteNames.addIncome),
        tooltip: 'Add pipeline entry',
        child: Icon(Icons.add_rounded, color: colors.surface, size: 28),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: PocketaSpacing.s4,
            bottom: 100, // FAB + bottom nav clearance
          ),
          child: Column(
            children: [
              // A3.2 — One-time S2S hint
              if (_showStsHint)
                Padding(
                  padding: const EdgeInsets.only(
                    left: PocketaSpacing.screenEdge,
                    right: PocketaSpacing.screenEdge,
                    bottom: PocketaSpacing.s3,
                  ),
                  child: GestureDetector(
                    onTap: _dismissStsHint,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: colors.interactive.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: colors.interactive.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.touch_app_rounded,
                              size: 18, color: colors.interactive),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Tap the number to see the math',
                              style: typography.bodySm
                                  .copyWith(color: colors.interactive),
                            ),
                          ),
                          Icon(Icons.close_rounded,
                              size: 16, color: colors.inkTertiary),
                        ],
                      ),
                    ),
                  ),
                ),
              PocketaRealityStack(
            // Tier 1 — Hero: dominant S2S answer.
            heroTier: S2sHeroBlock(
              result: stsResult,
              updatedAt: DateTime.now(),
              affirmation: _affirmation,
              // UX-1.09 — tap hero opens calculation breakdown.
              // D2.03 — fire calculationBreakdownOpened before showing trace.
              onTapTrace: () {
                ref
                    .read(analyticsProvider)
                    .trackEvent(TransactionalEvents.calculationBreakdownOpened);
                PocketaCalculationTrace.show(context, stsResult);
              },
            ),
            // Tier 2 — Pressure: committed + reserve stacked.
            pressureTier: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommittedSection(
                  result: stsResult,
                  onSetupFixedCosts: () =>
                      context.push(RouteNames.stsSettings),
                ),
                const SizedBox(height: PocketaSpacing.s4),
                ReserveSection(result: stsResult),
              ],
            ),
            // Tier 3 — Maintenance: not implemented in UX-1.
            maintenanceTier: null,
            // Tier 4 — Hope: pipeline money not yet counted.
            hopeTier: NotCountedSection(
              result: stsResult,
              onAddPipelineEntry: () => context.push(RouteNames.addIncome),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
