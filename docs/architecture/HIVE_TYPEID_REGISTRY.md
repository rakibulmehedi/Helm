# Hive TypeId Registry

> **Purpose:** Create a single source of truth for Hive typeIds to prevent collisions.

## Registry Entries

| typeId | Model / Adapter | Status | Notes |
|---|---|---|---|
| `0` | `TransactionModel` | Active | |
| `1` | `Reserved` | Reserved | |
| `2` | `IncomeModel` | Active | |
| `3` | `FixedCostModel` | Active | Added Phase 8b |
| `4` | `TransactionTypeAdapter` | Active | |
| `5` | `AuditEventModel` | Active | Added D1 Trust Layer (Sprint 6) |
| `6` | `AnalyticsEventModel` | Active | Added Phase 2 Analytics Infrastructure |
| `7` | `NudgePreferencesModel` | Active | Added Phase 2 Analytics Infrastructure |

## Rules

- Never reuse typeIds.
- Never change typeIds after release.
- Reserve future typeIds through this doc before implementation.
- Generated/manual adapters must match this registry.
- Data migration required if a typeId mistake ships.
