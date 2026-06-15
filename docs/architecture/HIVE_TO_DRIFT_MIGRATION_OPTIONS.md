# Hive to Drift Migration Options

> **Decision: Option C executed in S1-W1. See Decision log.**
> Status: DECIDED — Options A, B, D rejected.
> Date: 2026-05-22

---

## Option C: Storage Abstraction Layer (Executed)

### What Was Done

Formalized existing abstract interfaces. Fixed transaction domain violations. Added JSON serialization to all models. Kept Hive as the implementation. Creates a clean migration surface for a future Drift swap with zero domain/presentation impact.

### Work Executed

| Task | Files |
|------|-------|
| Created TransactionEntity (pure Dart) | 1 new |
| Fixed TransactionRepository to use entities | 2 |
| Moved TransactionType @HiveType to data layer | 2 |
| Added fromEntity/toEntity to TransactionModel | 1 |
| Added fromJson/toJson to IncomeModel + TransactionModel | 2 |
| Updated transaction providers for entity types | 2 |

### Architecture Result

```
Presentation → entities only (zero storage awareness)
Domain       → abstract repository interfaces (zero Hive imports)
Data         → models with Hive + JSON serialization
               concrete datasources behind abstract interfaces
               Hive swappable to Drift with ZERO domain changes
```

Future Drift migration surface = exactly 4 files:
1. `HiveService` → `DriftDatabase`
2. `IncomeLocalDataSourceImpl`
3. `TransactionLocalDataSourceImpl`
4. `pubspec.yaml`

### Why Options A/B/D Were Rejected

- **A (Keep Hive as-is):** Deferred domain cleanup. Left TransactionType in domain layer (wrong). No abstraction surface.
- **B (Migrate to Drift now):** ~34h effort, 1-2 week delay to Safe-to-Spend ship, data migration risk, premature at validation stage.
- **D (Hybrid staged):** More complex than needed; C already enables clean staged migration when actually required.

### Migration Gate Criteria

Upgrade to actual Drift migration when ANY of these become true:
- Cloud sync scheduled within next 2 phases
- Active users exceed 200
- A third data domain is added
- Hive breaks on a Flutter stable release

---

## Audit Corrections (On Record)

| Audit Claim | Accuracy | Correction |
|------------|----------|------------|
| "Hive mandates integer primary keys" | WRONG | Helm uses `box.put(stringId, model)` — string keys throughout |
| "Integer PK makes sync impossible" | N/A | String IDs are already sync-compatible |
| "Immediately deprecate Hive" | PREMATURE | Abstraction first; migrate when needed |
| "Hive binary format blocks export" | VALID | Addressed by fromJson/toJson in Option C |
| "PowerSync requires SQLite" | VALID | True, but sync is Phase 13+ (12+ months away) |
