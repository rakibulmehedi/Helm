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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/local_storage/shared_pref_service.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/widgets/pocketa_calculation_trace.dart';
import 'package:pocketa_v2/core/widgets/pocketa_reality_stack.dart';
import 'package:pocketa_v2/features/dashboard/presentation/widgets/committed_section.dart';
import 'package:pocketa_v2/features/dashboard/presentation/widgets/not_counted_section.dart';
import 'package:pocketa_v2/features/dashboard/presentation/widgets/reserve_section.dart';
import 'package:pocketa_v2/features/dashboard/presentation/widgets/s2s_hero_block.dart';
import 'package:pocketa_v2/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: PocketaSpacing.s4,
            bottom: 100, // FAB + bottom nav clearance
          ),
          child: PocketaRealityStack(
            // Tier 1 — Hero: dominant S2S answer.
            heroTier: S2sHeroBlock(
              result: stsResult,
              updatedAt: DateTime.now(),
              // UX-1.09 — tap hero opens calculation breakdown.
              onTapTrace: () =>
                  PocketaCalculationTrace.show(context, stsResult),
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
        ),
      ),
    );
  }
}
