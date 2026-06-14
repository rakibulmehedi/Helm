// lib/core/themes/helm_spacing.dart
// UX-5.03 — Visual Identity: Spacing Token Foundation
// Plain Dart class with static constants — NOT a ThemeExtension.
// All values follow an 8pt grid.

// ignore_for_file: avoid_classes_with_only_static_members

class HelmSpacing {
  // ---------------------------------------------------------------------------
  // 8pt grid spacing tokens
  // ---------------------------------------------------------------------------
  static const double s0  = 0;
  static const double s1  = 4;
  static const double s2  = 8;
  static const double s3  = 12;
  static const double s4  = 16;  // card internal padding (default), screen edge margin
  static const double s5  = 20;  // section vertical rhythm
  static const double s6  = 24;  // between Tier blocks
  static const double s8  = 32;  // above S2S hero ("let it breathe")
  static const double s10 = 40;  // between major sections
  static const double s12 = 48;  // top-of-screen safe inset

  // ---------------------------------------------------------------------------
  // Component dimension constants
  // ---------------------------------------------------------------------------
  static const double cardRadius      = 12;  // cards: modern but serious
  static const double buttonRadius    = 10;  // primary/secondary/destructive buttons
  static const double sheetTopRadius  = 16;  // modal bottom sheets (top only)
  static const double fabSize         = 56;  // FAB circle diameter
  static const double bottomNavHeight = 56;  // matches iOS HIG + Material
  static const double screenEdge      = 16;  // minimum screen gutter
  static const double cardBorder      = 1;   // hairline card border

  // Ledger accent rails
  static const double ledgerRailHeight          = 3;   // hero accent rail
  static const double ledgerRailHeightSecondary = 1.5; // secondary rails
  static const double ledgerRailWidth           = 72;  // compact screen
  static const double ledgerRailWidthRegular    = 96;  // regular screen

  // Icon sizes
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 28;

  // Progress bar
  static const double progressBarRadius   = 1;   // hairline progress indicator
  static const double progressBarHeight   = 2;   // thin accent bar
  static const double progressBarHeightOnboarding = 3; // onboarding progress

  // Onboarding step progress fractions
  static const List<double> onboardingSteps = [
    0.20, // step 2
    0.40, // step 3
    0.55, // step 4 (income pattern)
    0.70, // step 5
    0.90, // step 6
  ];
  static const double onboardingBuffer     = 0.88;
  static const double onboardingFixedCost  = 0.50;
  static const double onboardingLiquidBalance = 0.25;
}
