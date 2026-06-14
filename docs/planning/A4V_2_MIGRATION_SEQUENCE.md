# A4V-2: Migration Sequence

> **Sprint:** A4V-2
> **Date:** 2026-06-08
> **Purpose:** Exact execution order for visual maturity migration
> **Dependency:** A4V-2 Visual Rescue Plan

---

## Phase Overview

| Phase | Name | Effort | Score Impact | Dependencies | Approval |
|-------|------|--------|-------------|-------------|----------|
| P1 | Kill BLOCKERs | ~2 hrs | 52 -> 62 | None | None |
| P2 | Typography Migration | ~3 hrs | 62 -> 72 | P1 (italic/bold already clean) |  None |
| P3 | Weight + Color Cleanup | ~1.5 hrs | 72 -> 76 | P1 | None |
| P4 | Icon System Migration | ~3.5 hrs | 76 -> 82 | P1 | **pubspec approval** |
| P5 | Spacing + Shadow Cleanup | ~2.5 hrs | 82 -> 85 | P2 | None |
| P6 | Screen-Level Polish | ~4 hrs | 85 -> 88+ | P1-P5 | Design review for splash |
| P7 | Final Verification | ~1 hr | N/A | P1-P6 | None |

**Total estimated: ~17.5 hours across 7 phases**
**Minimum viable (P1-P3): ~6.5 hours for score 76**

---

## Phase Dependency Graph

```
P1 Kill BLOCKERs
 |
 +--> P2 Typography Migration
 |     |
 |     +--> P5 Spacing + Shadow
 |
 +--> P3 Weight + Color
 |
 +--> P4 Icon System [requires approval]
 |
 +--> P6 Screen Polish [after P1-P5]
       |
       +--> P7 Final Verification
```

P2, P3, P4 can run in parallel after P1. P5 depends on P2 (typography must be clean before spacing). P6 depends on all prior phases. P7 is final verification.

---

## Phase 1: Kill BLOCKERs

**Goal:** Resolve all 7 BLOCKER findings. Zero BLOCKERs after this phase.

### Execution Order

| Step | Task | File(s) | BLOCKERs Killed |
|------|------|---------|-----------------|
| 1.1 | Rewrite AppButton to use HelmColors | `lib/core/widgets/buttons/button_multiple_types.dart` | B1 |
| 1.2 | Remove expense categories | `lib/features/transactions/presentation/views/add_transaction_screen.dart` | B2 |
| 1.3 | Remove italic from STS settings | `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart` | B6 |
| 1.4 | Remove italic from income list | `lib/features/income/presentation/views/income_list_screen.dart` | B7 |
| 1.5 | Reduce splash animation to 320ms | `lib/features/splash/views/splash_screen.dart` | B4 |
| 1.6 | Fix splash curve to easeOut | `lib/features/splash/views/splash_screen.dart` | (B4 cont.) |
| 1.7 | Delete dead code file | `lib/features/safe_to_spend/presentation/widgets/safe_to_spend_hero.dart` | M11 |

**Note:** B3 (splash CircleAvatar) and B5 (Phosphor icons) are deferred to P4/P6 because they require new assets or packages. Splash timing fix (B4) is done here; splash redesign is P6.

### Verification

```bash
dart analyze           # 0/0/0
flutter test           # all pass
grep -r "FontStyle.italic" lib/features/  # 0 results (dead code file deleted)
grep -r "AppColors" lib/core/widgets/buttons/  # 0 results
```

### Commit

```
feat(visual): P1 kill BLOCKERs — AppButton brand color, categories removed, italic killed

- Rewrite button_multiple_types.dart: AppColors.primary -> HelmColors.interactive
- Remove expense categories from add_transaction_screen.dart
- Remove FontStyle.italic from sts_settings_screen.dart, income_list_screen.dart
- Reduce splash animation from 1800ms to 320ms, Curves.easeIn -> easeOut
- Delete dead code: safe_to_spend_hero.dart
- dart analyze clean
```

---

## Phase 2: Typography Migration

**Goal:** Replace all hardcoded fontSize and ResponsiveUtilities.font() with HelmTypography tokens.

### Token Mapping Reference

| Hardcoded Value | HelmTypography Token | Semantic Role |
|----------------|------------------------|---------------|
| 11 | labelSm | Small labels, badges |
| 12 | labelMd | Medium labels, captions |
| 13 | bodySm | Body small, descriptions |
| 14 | bodyMd | Body medium, default text |
| 15 | headingSm | Section headings small |
| 16 | bodyLg | Body large, emphasis text |
| 18 | headingMd | Section headings medium |
| 20 | headingMd (or bodyLg + w600) | Context-dependent |
| 22 | headingLg | Section headings large |
| 24 | headingLg (or displaySmall) | Context-dependent |
| 32 | displayLarge | Large display text |
| 36 | displayLarge | Legacy hero (should be 40) |
| 40 | displayLarge | Display numbers |
| 52 | displayHero | Hero display (should be 64) |
| 64 | displayHero | S2S hero number |

### Execution Order

| Step | Scope | File(s) | Replacements |
|------|-------|---------|-------------|
| 2.1 | STS Settings typography | `sts_settings_screen.dart` | 9 fontSize -> tokens |
| 2.2 | Income list typography | `income_list_screen.dart` | 14+ ResponsiveUtilities + fontSize |
| 2.3 | Add income typography | `add_income_screen.dart` | 5+ ResponsiveUtilities + fontSize |
| 2.4 | Add transaction typography | `add_transaction_screen.dart` | ResponsiveUtilities + fontSize |
| 2.5 | Export screen typography | `export_screen.dart` | 4 fontSize -> tokens |
| 2.6 | Splash typography | `splash_screen.dart` | 2 fontSize -> tokens |
| 2.7 | PIN screens typography | `pin_entry_screen.dart`, `pin_setup_screen.dart` | 3 fontSize -> tokens |
| 2.8 | Audit log typography | `audit_log_screen.dart` | 1 fontSize -> token |
| 2.9 | Delete account typography | `delete_account_screen.dart` | fontSize -> tokens |
| 2.10 | Pipeline summary typography | `income_pipeline_summary.dart` | ResponsiveUtilities + fontSize |
| 2.11 | Onboarding form hardcodes | `fixed_costs_page.dart`, `first_pipeline_page.dart` | Hardcoded form sizes |

### Verification

```bash
dart analyze           # 0/0/0
flutter test           # all pass
grep -rn "fontSize:" lib/features/ | wc -l   # < 10
grep -rn "ResponsiveUtilities.font" lib/features/  # 0 results
```

### Commit

```
feat(visual): P2 typography migration — 99 hardcoded fonts replaced with HelmTypography tokens

- Replace all ResponsiveUtilities.font() calls with semantic tokens
- Replace all hardcoded fontSize: with HelmTypography references
- 14 feature files migrated to token typography
- dart analyze clean
```

---

## Phase 3: Weight + Color Cleanup

**Goal:** Kill all FontWeight.bold violations and raw Colors.black/white references.

### Execution Order

| Step | Scope | File(s) | Replacements |
|------|-------|---------|-------------|
| 3.1 | FontWeight.bold -> w600 | 8 files (see inventory below) | 26 replacements |
| 3.2 | Colors.white -> token | 12 files | ~12 replacements |
| 3.3 | Colors.black -> token | 12 files | ~8 replacements |
| 3.4 | Remove deprecated AppColors imports | 4 remaining files | Import cleanup |

**FontWeight.bold files:**
1. `sts_settings_screen.dart`
2. `export_screen.dart`
3. `splash_screen.dart`
4. `add_income_screen.dart`
5. `income_list_screen.dart`
6. `add_transaction_screen.dart`
7. `linear_progress_bar.dart`
8. (safe_to_spend_hero.dart already deleted in P1)

**Colors.black/white files:**
1. `sts_settings_screen.dart`
2. `splash_screen.dart`
3. `add_income_screen.dart`
4. `income_list_screen.dart`
5. `add_transaction_screen.dart`
6. `dashboard_screen.dart`
7. `delete_account_screen.dart`
8. `confirm_received_sheet.dart`
9. `fixed_costs_page.dart`
10. `pipeline_entry_card.dart`
11. `pipeline_screen.dart`
12. `button_multiple_types.dart` (already fixed in P1, verify)

### Verification

```bash
dart analyze           # 0/0/0
flutter test           # all pass
grep -rn "FontWeight.bold\|FontWeight.w700" lib/features/  # 0 results
grep -rn "Colors.black\|Colors.white" lib/features/  # 0 results
```

### Commit

```
feat(visual): P3 weight + color cleanup — bold->w600, raw Colors->tokens

- Replace 26 FontWeight.bold/w700 with FontWeight.w600
- Replace 20 Colors.black/white with HelmColors tokens
- Remove deprecated AppColors imports from remaining files
- dart analyze clean
```

---

## Phase 4: Icon System Migration

**REQUIRES APPROVAL: Adding `phosphor_flutter` to pubspec.yaml**

**Goal:** Replace all 66 Material Icons with Phosphor equivalents.

### Pre-requisite

Chief Architect approves `phosphor_flutter` package addition.

### Icon Mapping (prepared before execution)

| Material Icon | Phosphor Equivalent | Context |
|--------------|-------------------|---------|
| Icons.home_rounded | PhosphorIcons.house | Bottom nav |
| Icons.inbox_rounded | PhosphorIcons.tray | Bottom nav (pipeline) |
| Icons.settings_rounded | PhosphorIcons.gear | Bottom nav |
| Icons.add_rounded | PhosphorIcons.plus | FAB, add buttons |
| Icons.add | PhosphorIcons.plus | Outline buttons |
| Icons.close_rounded | PhosphorIcons.x | Dismiss |
| Icons.close | PhosphorIcons.x | Close buttons |
| Icons.refresh_rounded | PhosphorIcons.arrowClockwise | Debug refresh |
| Icons.touch_app_rounded | PhosphorIcons.handTap | Hint |
| Icons.delete | PhosphorIcons.trash | Swipe delete |
| Icons.delete_forever_outlined | PhosphorIcons.trashSimple | Danger delete |
| Icons.download_outlined | PhosphorIcons.downloadSimple | Export |
| Icons.history_outlined | PhosphorIcons.clockCounterClockwise | Change history |
| Icons.chevron_right | PhosphorIcons.caretRight | List trailing |
| Icons.arrow_back_ios_new_rounded | PhosphorIcons.caretLeft | Back button |
| Icons.keyboard_arrow_up_rounded | PhosphorIcons.caretUp | Expand |
| Icons.keyboard_arrow_down_rounded | PhosphorIcons.caretDown | Collapse |
| Icons.check | PhosphorIcons.check | Checkbox |
| Icons.check_circle_outline | PhosphorIcons.checkCircle | Success state |
| Icons.info_outline_rounded | PhosphorIcons.info | Info hint |
| Icons.remove_circle_outline | PhosphorIcons.minusCircle | Remove item |
| Icons.add_circle_outline | PhosphorIcons.plusCircle | Add audit |
| Icons.edit_outlined | PhosphorIcons.pencilSimple | Edit audit |

### Execution Order

| Step | Scope | File(s) |
|------|-------|---------|
| 4.1 | Add phosphor_flutter to pubspec.yaml | `pubspec.yaml` |
| 4.2 | Run flutter pub get | Terminal |
| 4.3 | Bottom nav icons | `app_router.dart` |
| 4.4 | Dashboard icons | `dashboard_screen.dart` |
| 4.5 | Pipeline + pipeline card icons | `pipeline_screen.dart`, `pipeline_entry_card.dart` |
| 4.6 | Income screens icons | `income_list_screen.dart`, `add_income_screen.dart` |
| 4.7 | Transaction screen icons | `add_transaction_screen.dart` |
| 4.8 | STS settings icons | `sts_settings_screen.dart` |
| 4.9 | Export screen icons | `export_screen.dart` |
| 4.10 | Audit log icons | `audit_log_screen.dart` |
| 4.11 | Delete account icons | `delete_account_screen.dart` |
| 4.12 | Onboarding icons | `fixed_costs_page.dart`, `first_pipeline_page.dart` |
| 4.13 | Confirm received sheet | `confirm_received_sheet.dart` |
| 4.14 | Pipeline summary icons | `income_pipeline_summary.dart` |

### Verification

```bash
dart analyze           # 0/0/0
flutter test           # all pass
grep -rn "Icons\." lib/features/ lib/config/  # 0 results (except system widgets)
```

### Commit

```
feat(visual): P4 icon system migration — 66 Material Icons replaced with Phosphor

- Add phosphor_flutter to pubspec.yaml [approved]
- Replace all Icons.* references in 16 feature files
- Phosphor outline icons (1.5pt stroke) for ledger-calm aesthetic
- dart analyze clean
```

---

## Phase 5: Spacing + Shadow Cleanup

**Goal:** Migrate hardcoded BorderRadius to HelmSpacing tokens, remove all BoxShadow.

### Token Mapping Reference

| Hardcoded Value | HelmSpacing Token | Usage |
|----------------|---------------------|-------|
| BorderRadius.circular(12) | HelmSpacing.cardRadius | Cards, containers |
| BorderRadius.circular(10) | HelmSpacing.buttonRadius | Buttons |
| BorderRadius.circular(16) | HelmSpacing.sheetTopRadius | Bottom sheet top corners |
| BorderRadius.circular(20) | (kill -- use 12 or 16) | Filter chips (non-standard) |
| BorderRadius.circular(24) | (kill -- use 16) | Non-standard |
| BorderRadius.circular(100) | (keep for pills/circles) | Status indicators only |

### Execution Order

| Step | Scope | File(s) |
|------|-------|---------|
| 5.1 | Remove all BoxShadow | `income_pipeline_summary.dart`, `income_list_screen.dart`, `pipeline_entry_card.dart` |
| 5.2 | Card radius migration (12pt) | All files using BorderRadius.circular(12) in card context |
| 5.3 | Button radius migration (10pt) | All files using BorderRadius.circular(10/12) in button context |
| 5.4 | Sheet radius migration (16pt) | Bottom sheet shapes |
| 5.5 | Kill non-standard radii (16, 20, 24 in card context) | income_list_screen, filter chips |
| 5.6 | EdgeInsets standardization | Replace common hardcoded EdgeInsets with HelmSpacing refs |

### Verification

```bash
dart analyze           # 0/0/0
flutter test           # all pass
grep -rn "BoxShadow" lib/features/  # 0 results
grep -rn "BorderRadius.circular" lib/features/ | wc -l  # < 15 (exceptions documented)
```

### Commit

```
feat(visual): P5 spacing + shadow cleanup — zero shadows, radius tokens adopted

- Remove all BoxShadow from 3 feature files
- Migrate ~80 BorderRadius.circular to HelmSpacing tokens
- Kill non-standard radii (16 on cards -> 12, 20 on chips -> 12)
- Standardize EdgeInsets to HelmSpacing references
- dart analyze clean
```

---

## Phase 6: Screen-Level Polish

**Goal:** Fix individual screens that need structural visual changes beyond token migration.

### Execution Order

| Step | Scope | File(s) | Change |
|------|-------|---------|--------|
| 6.1 | Splash redesign | `splash_screen.dart` | Replace CircleAvatar with "Helm" wordmark (Inter w600, inkPrimary, centered on canvas). Keep 320ms HelmMotion.slow fade. |
| 6.2 | Income list HelmAmount adoption | `income_list_screen.dart` | Replace proportional font money values with HelmAmount widget |
| 6.3 | STS Settings money display | `sts_settings_screen.dart` | Use HelmAmount for fixed cost amounts |
| 6.4 | Add transaction simplification | `add_transaction_screen.dart` | Clean up form after category removal (P1). Ensure amount+note+date only. |
| 6.5 | Button height standardization | `delete_account_screen.dart` | Fix 52pt -> 48pt button height per VIS-019 |

**Deferred to separate sprint (not visual rescue scope):**
- History tab (4th bottom nav tab) -- requires new screen, new route
- Income list full rebuild with HelmLedgerCard -- requires design decision
- Loading skeleton states -- interaction maturity, not visual identity

### Verification

```bash
dart analyze           # 0/0/0
flutter test           # all pass
# Visual verification on device required for splash redesign
```

### Commit

```
feat(visual): P6 screen polish — splash wordmark, HelmAmount adoption, form cleanup

- Splash: CircleAvatar -> "Helm" wordmark, Inter w600, canvas bg
- Income list: money values use HelmAmount widget
- STS settings: fixed cost amounts use HelmAmount
- Transaction form: cleaned post-category-removal layout
- Delete account: button height 52pt -> 48pt
- dart analyze clean
```

---

## Phase 7: Final Verification

**Goal:** Confirm all phases achieved their targets. Produce verification report.

### Verification Checklist

| Check | Command | Expected |
|-------|---------|----------|
| Analyzer clean | `dart analyze` | 0/0/0 |
| Tests pass | `flutter test` | All pass |
| Zero BLOCKERs | Grep for known BLOCKER patterns | 0 results |
| Zero italic | `grep -rn "FontStyle.italic" lib/features/` | 0 |
| Zero bold violations | `grep -rn "FontWeight.bold\|FontWeight.w700" lib/features/` | 0 |
| Zero raw colors | `grep -rn "Colors.black\|Colors.white" lib/features/` | 0 |
| Zero shadows | `grep -rn "BoxShadow" lib/features/` | 0 |
| Zero AppColors in buttons | `grep -rn "AppColors" lib/core/widgets/buttons/` | 0 |
| Zero ResponsiveUtilities.font | `grep -rn "ResponsiveUtilities.font" lib/features/` | 0 |
| Hardcoded fontSize < 10 | `grep -rn "fontSize:" lib/features/ \| wc -l` | < 10 |
| Zero expense categories | `grep -rn "defaultCategories\|_defaultCategories" lib/` | 0 |
| Phosphor adopted | `grep -rn "Icons\." lib/features/ \| wc -l` | 0 (if P4 done) |

### Score Re-assessment

After all phases, re-run adversarial scoring on each screen.

Target:

| Screen | Before | After |
|--------|--------|-------|
| AppButton | 15 | 85 |
| Add Transaction | 20 | 65 |
| Splash | 25 | 80 |
| STS Settings | 25 | 70 |
| Income List | 30 | 70 |
| Export | 30 | 65 |
| Income Pipeline Summary | 40 | 70 |
| Add Income | 40 | 70 |
| Audit Log | 45 | 70 |
| Delete Account | 50 | 70 |
| PIN Entry/Setup | 55 | 72 |
| Pipeline Screen | 60 | 78 |
| Confirm Received Sheet | 65 | 78 |
| Onboarding | 65 | 82 |
| Bottom Navigation | 65 | 80 |
| Pipeline Entry Card | 70 | 82 |
| Welcome | 70 | 85 |
| Dashboard | 80 | 90 |
| Calculation Trace | 85 | 88 |
| S2S Hero Block | 90 | 92 |
| **Overall Weighted** | **52** | **~80** |

### Commit

```
docs(visual): P7 verification — post-migration visual maturity assessment

- All phases verified
- Zero BLOCKERs
- Overall score: [actual score]
- Screen floor: [actual minimum]
```

---

## Risky Areas (Watch List)

| Area | Risk | Mitigation |
|------|------|-----------|
| Phosphor icon semantic mapping | Wrong icon = confusing UX | Create mapping document, review each replacement |
| Typography token mapping | Wrong semantic token = broken hierarchy | Use the mapping reference table in P2 |
| Income list ResponsiveUtilities removal | Screen may reflow differently at different widths | Test on 360px (Redmi Note) and 390px (iPhone) widths |
| Splash wordmark design | Subjective -- could look too plain | Keep it minimal: text only, Inter w600, center aligned |
| AppButton radius change (12 -> 10) | May affect layouts with tight constraints | Verify each screen where AppButton is used |
| Category removal from transaction form | Form may have empty space | Re-layout with amount as primary field, note as optional |

---

## Sprint Boundaries (Suggested Implementation Splits)

### Sprint A4V-3: Kill BLOCKERs (Phase 1)
- Scope: P1 only
- Effort: ~2 hours
- Score: 52 -> 62
- Commit: 1

### Sprint A4V-4: Token Saturation (Phase 2 + 3)
- Scope: P2 + P3 (can batch since both are mechanical token migrations)
- Effort: ~4.5 hours
- Score: 62 -> 76
- Commits: 2 (one per phase)

### Sprint A4V-5: Icon + Spacing (Phase 4 + 5)
- Scope: P4 + P5 (requires approval for P4)
- Effort: ~6 hours
- Score: 76 -> 85
- Commits: 2 (one per phase)

### Sprint A4V-6: Screen Polish + Verify (Phase 6 + 7)
- Scope: P6 + P7
- Effort: ~5 hours
- Score: 85 -> 88+
- Commits: 2 (one for polish, one for verification doc)

---

*End of A4V-2 Migration Sequence. No code was modified.*
