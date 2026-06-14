# UX-to-Code File Map

> Maps UX requirements to affected Flutter files. Updated 2026-06-05.
> Source: Canonical UX Implementation Spec + Codebase Audit (IMPL-001 to IMPL-042)

---

## UX-1: Dashboard Cockpit Redesign

### New Files Required
| File | Purpose |
|------|---------|
| `lib/core/themes/helm_colors.dart` | Doctrine-aligned color tokens (replaces colors.dart) |
| `lib/core/themes/helm_typography.dart` | Type scale with mono/sans/Bangla separation |
| `lib/core/themes/helm_spacing.dart` | 8pt grid spacing tokens |
| `lib/core/widgets/helm_ledger_rail.dart` | S2S state rail (3pt, labeled) |
| `lib/core/widgets/helm_trust_strip.dart` | Timestamp + source + audit link |
| `lib/core/widgets/helm_reality_stack.dart` | 4-layer home screen hierarchy |
| `lib/core/widgets/helm_amount.dart` | Financial number formatting (lakh/crore) |
| `lib/core/widgets/helm_calculation_trace.dart` | Auditable math drawer |
| `lib/core/widgets/helm_fx_estimate.dart` | Dual-currency display with FX |
| `lib/core/widgets/helm_money_source_label.dart` | Source label widget |
| `lib/core/widgets/cards/helm_hero_zone.dart` | S2S hero container |
| `lib/core/widgets/cards/helm_ledger_card.dart` | Standard money card |
| `lib/core/widgets/cards/helm_audit_card.dart` | Calculation trace card |
| `lib/core/widgets/cards/helm_source_card.dart` | Source + status card |
| `lib/core/widgets/cards/helm_caution_card.dart` | AtRisk rail card |
| `lib/core/widgets/helm_toast.dart` | Financial-safe snackbar |

### Modified Files
| File | Changes |
|------|---------|
| `lib/features/dashboard/presentation/views/dashboard_screen.dart` | Complete redesign: Reality Stack layout, remove summary chips, remove transaction list from home |
| `lib/features/safe_to_spend/presentation/widgets/safe_to_spend_hero.dart` | Replace with HelmHeroZone + HelmLedgerRail + HelmTrustStrip |
| `lib/features/income/presentation/widgets/income_pipeline_summary.dart` | Replace with "Not counted yet" section in Reality Stack |
| `lib/core/themes/colors.dart` | Deprecated in favor of helm_colors.dart |
| `lib/core/themes/app_theme.dart` | Update to use new tokens, fonts (Inter/JetBrains Mono/Hind Siliguri) |
| `lib/config/router/app_router.dart` | Add bottom nav with 4 tabs |
| `lib/config/router/route_names.dart` | Add pipeline, history routes |

---

## UX-2: Onboarding Redesign

### New Files Required
| File | Purpose |
|------|---------|
| `lib/features/onboarding/domain/entities/onboarding_data.dart` | Multi-step data model |
| `lib/features/onboarding/presentation/providers/onboarding_data_provider.dart` | Multi-step state |
| `lib/features/onboarding/presentation/views/pages/pain_qualifier_page.dart` | Step 1 |
| `lib/features/onboarding/presentation/views/pages/liquid_balance_page.dart` | Step 2 |
| `lib/features/onboarding/presentation/views/pages/fixed_costs_page.dart` | Step 3 |
| `lib/features/onboarding/presentation/views/pages/income_pattern_page.dart` | Step 4 |
| `lib/features/onboarding/presentation/views/pages/buffer_comfort_page.dart` | Step 5 |
| `lib/features/onboarding/presentation/views/pages/first_pipeline_page.dart` | Step 6 (optional) |
| `lib/features/onboarding/presentation/views/pages/pin_setup_page.dart` | Step 7 |

### Modified Files
| File | Changes |
|------|---------|
| `lib/features/onboarding/presentation/views/onboarding_screen.dart` | Complete rewrite: 7-step conversational flow |
| `lib/features/onboarding/presentation/views/welcome_screen.dart` | Fix copy: remove "pocket accountant" / "Smart budgeting" |
| `lib/features/onboarding/presentation/providers/onboarding_state_provider.dart` | Expand to track step + collected data |
| `lib/l10n/app_en.arb` | Fix tagLine, add all onboarding strings |
| `lib/l10n/app_bn.arb` | Fix tagLine, add Bangla onboarding strings |

### Delete Files
| File | Reason |
|------|--------|
| `lib/features/onboarding/presentation/views/pages/set_budget_categories.dart` | Dead stub |
| `lib/features/onboarding/presentation/views/pages/set_currency_and_earning_range.dart` | Dead stub |
| `lib/features/onboarding/presentation/views/pages/set_income_source.dart` | Dead stub |

---

## UX-3: Pipeline Quick-Update Interaction

### New Files Required
| File | Purpose |
|------|---------|
| `lib/features/income/presentation/widgets/confirm_received_sheet.dart` | The most important widget |
| `lib/features/income/presentation/widgets/pipeline_entry_card.dart` | State-driven entry card |
| `lib/features/income/presentation/widgets/pipeline_overdue_section.dart` | Overdue entries header |
| `lib/features/income/presentation/views/pipeline_screen.dart` | Dedicated Pipeline tab screen |

### Modified Files
| File | Changes |
|------|---------|
| `lib/features/income/domain/entities/income_entry_entity.dart` | Add fxRate, excludeFromCalculation, sourceLabel fields |
| `lib/features/income/data/models/income_model.dart` | Add HiveFields for fxRate, exclude, source |
| `lib/features/income/presentation/views/add_income_screen.dart` | Add FX rate input, exclude toggle, source selector |
| `lib/features/safe_to_spend/domain/safe_to_spend_calculator.dart` | Use per-entry FX, respect exclude flag |

---

## UX-4: Microcopy Replacement

### Modified Files
| File | Changes |
|------|---------|
| `lib/l10n/app_en.arb` | Complete rewrite: all strings per Microcopy System |
| `lib/l10n/app_bn.arb` | Complete rewrite: authored Bangla (not translated) |
| All screen files | Replace hardcoded strings with localization keys |
| `lib/core/utils/number_formatter.dart` (new) | Lakh/crore BDT formatting, Western USD formatting |

---

## UX-5: Visual Identity / Design System Cleanup

### New Files Required
| File | Purpose |
|------|---------|
| `lib/core/themes/helm_colors.dart` | Full doctrine color system |
| `lib/core/themes/helm_typography.dart` | Inter + JetBrains Mono + Hind Siliguri |
| `lib/core/themes/helm_spacing.dart` | 8pt grid tokens |
| `lib/core/themes/helm_motion.dart` | Animation timing tokens |

### Modified Files
| File | Changes |
|------|---------|
| `lib/core/themes/app_theme.dart` | Rebuild using new token files |
| `lib/core/themes/colors.dart` | Deprecate, redirect to helm_colors |
| `pubspec.yaml` | Add google_fonts for Inter, JetBrains Mono (needs approval) |
| All widget files | Migrate to new color/type tokens |

---

## D1: Trust Layer Foundation

### New Feature Module
```
lib/features/auth/
  domain/entities/auth_state.dart
  presentation/views/pin_setup_screen.dart
  presentation/views/pin_entry_screen.dart
  presentation/providers/auth_provider.dart

lib/features/audit_log/
  domain/entities/audit_event.dart
  data/models/audit_event_model.dart
  data/datasources/audit_local_data_source.dart
  presentation/views/audit_log_screen.dart

lib/features/export/
  domain/export_service.dart
  presentation/views/export_screen.dart

lib/features/account/
  presentation/views/account_settings_screen.dart
  presentation/views/delete_account_screen.dart
```

---

## D2: Beta Instrumentation

### New Files
```
lib/core/analytics/
  analytics_service.dart
  event_registry.dart
  beta_events.dart
```

---

## D3: Closed Beta Readiness

### Modified Files
| File | Changes |
|------|---------|
| `lib/features/safe_to_spend/domain/entities/sts_settings.dart` | Buffer as percentage (5-30%, default 15%) |
| `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart` | Percentage slider for buffer |
| `lib/features/safe_to_spend/domain/safe_to_spend_calculator.dart` | Buffer as % of income, remove or V2-gate tax reserve |
