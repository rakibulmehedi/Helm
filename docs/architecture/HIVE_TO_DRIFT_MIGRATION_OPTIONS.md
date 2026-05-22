# Hive to Drift Migration Options

> Status: OPTIONS ANALYSIS — Decision pending Chief Architect approval
> Companion to: LOCAL_DATABASE_DECISION_REVIEW.md
> Date: 2026-05-22
> Context: Phase 7 complete, Phase 8 (Safe-to-Spend) upcoming

---

## Decision Context

Pocketa currently uses Hive for local persistence. An external audit recommended immediate
migration to Drift (SQLite). This document evaluates four migration paths against the actual
codebase state, not theoretical concerns.

**Key repo fact that changes the calculus:** Pocketa already uses string primary keys
(`IdGenerator.uniqueId()`), not Hive integer auto-keys. The audit's most severe claim
about integer-to-UUID sync nightmares does not apply.

---

## Option A: Keep Hive for MVP Validation

### Description

Continue with Hive through Phase 8 (Safe-to-Spend) and Phase 9. No storage changes.
Fix only the TransactionType domain violation and missing TransactionEntity.

### Scope of Work

| Task | Effort | Files |
|------|--------|-------|
| Create TransactionEntity (pure Dart) | 2h | 1 new |
| Fix TransactionRepository to use entities | 2h | 2 files |
| Move TransactionType @HiveType to data layer | 1h | 2 files |
| Update transaction providers for entity types | 2h | 2 files |
| **Total** | **~7h** | **~7 files** |

### Evaluation

| Criterion | Score | Notes |
|-----------|-------|-------|
| Engineering cost | 1/5 (very low) | Only domain cleanup, no storage changes |
| Migration risk | 0/5 (zero) | Nothing migrates |
| Product risk | 1/5 (very low) | Ship S2S faster, validate before investing in infra |
| User trust risk | 1/5 (very low) | Hive is reliable for local-only single-device use |
| Phase 7 impact | 0/5 (none) | Phase 7 is complete and untouched |
| Phase 8 S2S impact | 1/5 (minimal) | In-memory aggregation works fine at freelancer scale |
| Sync readiness | 0/5 (none) | Sync remains blocked behind Hive |
| **Recommendation score** | **7/10** | Best for: rapid validation, resource-constrained |

### Risks

- Hive stagnation continues; eventual migration becomes slightly larger as more models are added
- If sync is needed sooner than expected, migration becomes urgent under pressure
- No SQL query capability for future analytics/reporting features

### When This Fails

If the product reaches 500+ active users who demand cloud backup or multi-device sync,
this option forces an emergency migration under user pressure.

---

## Option B: Migrate to Drift Before Safe-to-Spend

### Description

Full migration: replace Hive with Drift (SQLite ORM) before building Phase 8. All existing
data models become Drift table definitions. Hive is completely removed.

### Scope of Work

| Task | Effort | Files |
|------|--------|-------|
| Add drift, drift_dev, sqlite3_flutter_libs to pubspec | 1h | 1 |
| Create Drift database class with table definitions | 4h | 1 new |
| Create IncomeTable (replacing IncomeModel @HiveType) | 2h | 1 new |
| Create TransactionTable (replacing TransactionModel @HiveType) | 2h | 1 new |
| Create TransactionEntity (missing) | 2h | 1 new |
| Rewrite IncomeLocalDataSourceImpl for Drift | 3h | 1 |
| Rewrite TransactionLocalDataSourceImpl for Drift | 3h | 1 |
| Fix TransactionRepository for entities | 2h | 2 |
| Replace HiveService.init() with Drift DB init | 2h | 1 |
| Write data migration script (Hive -> SQLite) | 6h | 1 new |
| Remove Hive packages from pubspec | 1h | 1 |
| Delete all .g.dart Hive adapters | 0.5h | 3 |
| Update main.dart initialization | 1h | 1 |
| Run build_runner for Drift codegen | 1h | 0 |
| Testing migration on real device data | 4h | 0 |
| **Total** | **~34h** | **~15 files** |

### Evaluation

| Criterion | Score | Notes |
|-----------|-------|-------|
| Engineering cost | 4/5 (high) | ~34h of focused work; delays S2S by 1-2 weeks |
| Migration risk | 3/5 (moderate) | Data migration script must handle existing user data safely |
| Product risk | 3/5 (moderate) | Delays the core value feature (S2S) for infrastructure |
| User trust risk | 2/5 (low-moderate) | Migration bugs could lose user financial data |
| Phase 7 impact | 2/5 (low) | Income feature rewired but functionally identical |
| Phase 8 S2S impact | POSITIVE | SQL aggregation is cleaner for S2S formula |
| Sync readiness | 4/5 (high) | SQLite ready for PowerSync when needed |
| **Recommendation score** | **4/10** | Best for: if sync is <6 months away |

### Risks

- Data migration bugs could corrupt or lose existing user financial records
- 1-2 week delay to Phase 8 ship date
- Drift learning curve (minor — well-documented)
- Over-engineering for current validation stage

### When This Makes Sense

Only if there is concrete evidence that cloud sync / multi-device is needed within 6 months.
Currently, no such evidence exists in the roadmap.

---

## Option C: Add Storage Abstraction Layer, Migrate Later

### Description

Formalize the existing abstract interfaces. Fix the transaction domain violations. Add
JSON serialization to all models. Keep Hive as the implementation. This creates a clean
migration surface for a future Drift swap with zero domain/presentation impact.

### Scope of Work

| Task | Effort | Files |
|------|--------|-------|
| Create TransactionEntity (pure Dart) | 2h | 1 new |
| Fix TransactionRepository to use entities | 2h | 2 |
| Move TransactionType @HiveType to data layer | 1h | 2 |
| Add fromEntity/toEntity to TransactionModel | 1h | 1 |
| Add fromJson/toJson to IncomeModel | 1h | 1 |
| Add fromJson/toJson to TransactionModel | 1h | 1 |
| Update transaction providers for entity types | 2h | 2 |
| Document migration contract in architecture docs | 1h | 1 |
| **Total** | **~11h** | **~11 files** |

### What This Achieves

After this work, the codebase has:

```
Presentation → entities only (zero storage awareness)
Domain → abstract repository interfaces (zero Hive imports)
Data → models with both Hive + JSON serialization
         concrete data sources behind abstract interfaces
         Hive implementation swappable to Drift with ZERO domain changes
```

The migration surface becomes exactly 4 files:
1. `HiveService` → `DriftDatabase`
2. `IncomeLocalDataSourceImpl` (swap implementation)
3. `TransactionLocalDataSourceImpl` (swap implementation)
4. `pubspec.yaml` (swap packages)

### Evaluation

| Criterion | Score | Notes |
|-----------|-------|-------|
| Engineering cost | 2/5 (low) | ~11h, parallelizable with Phase 8 work |
| Migration risk | 0/5 (zero) | No storage change; Hive continues working |
| Product risk | 0/5 (zero) | S2S ships on time; infrastructure prep is invisible |
| User trust risk | 0/5 (zero) | No data movement; no risk of corruption |
| Phase 7 impact | 1/5 (minimal) | Income domain already clean; only transactions change |
| Phase 8 S2S impact | POSITIVE | Clean domain boundaries make S2S easier to build |
| Sync readiness | 2/5 (moderate) | Migration surface reduced to 4 files; actual migration still needed |
| **Recommendation score** | **9/10** | Best for: current stage, validates first, migrates cheaply |

### Risks

- Does not actually achieve SQLite — sync still blocked
- Could be perceived as "kicking the can" if sync timeline accelerates
- Adds ~4h of work that is only useful if migration happens (JSON serialization)

### When This Fails

If sync is needed urgently (investor pressure, competitive threat), this option requires
a follow-up Drift migration. But that migration is now a clean 4-file swap instead of a
15-file refactor.

---

## Option D: Hybrid Staged Migration

### Description

Phase the migration across product phases:
1. **Now (pre-Phase 8):** Fix domain violations + add abstraction layer (Option C work)
2. **During Phase 9-10:** Migrate income domain to Drift first (most trust-critical)
3. **During Phase 11-12:** Migrate transaction domain to Drift
4. **Phase 13:** Add PowerSync on top of fully-Drift architecture

### Scope of Work

| Stage | Effort | When |
|-------|--------|------|
| Stage 1: Domain cleanup + abstraction | ~11h | Before Phase 8 |
| Stage 2: Income Drift migration | ~15h | Phase 9-10 timeframe |
| Stage 3: Transaction Drift migration | ~12h | Phase 11-12 timeframe |
| Stage 4: PowerSync integration | ~20h | Phase 13 |
| **Total** | **~58h** | Spread across 6+ months |

### Evaluation

| Criterion | Score | Notes |
|-----------|-------|-------|
| Engineering cost | 3/5 (moderate total, spread out) | 58h total but amortized over months |
| Migration risk | 2/5 (low) | Each stage is small and testable independently |
| Product risk | 1/5 (very low) | No stage blocks a product phase |
| User trust risk | 1/5 (very low) | Data migrated per-domain, smaller blast radius |
| Phase 7 impact | 0/5 (none) | First stage is domain cleanup only |
| Phase 8 S2S impact | 0/5 (none) | S2S builds on Hive; migrates with income domain later |
| Sync readiness | 5/5 (full) | End state is full Drift + PowerSync |
| **Recommendation score** | **8/10** | Best for: if sync is a confirmed long-term goal |

### Risks

- Maintaining two storage backends during transition (Hive + Drift)
- Requires discipline to actually execute Stage 2-3 (easy to defer indefinitely)
- Hybrid state adds testing complexity during transition phases

---

## Comparison Matrix

| Criterion | A: Keep Hive | B: Migrate Now | C: Abstract First | D: Hybrid Staged |
|-----------|:---:|:---:|:---:|:---:|
| Engineering cost | 7h | 34h | 11h | 58h (spread) |
| Phase 8 delay | None | 1-2 weeks | None | None |
| Data loss risk | None | Moderate | None | Low |
| Sync readiness | None | Full | Partial | Full (eventual) |
| Domain health improvement | Partial | Full | Full | Full |
| S2S can ship on time | YES | NO | YES | YES |
| Future migration cost | ~34h | 0h | ~20h | 0h |
| **Score** | **7/10** | **4/10** | **9/10** | **8/10** |

---

## Recommended Path: Option C (Storage Abstraction First)

### Why

1. **The audit's urgency is overstated.** Integer key concerns don't apply. Sync is 12+ months away.

2. **The income domain is already abstracted.** `IncomeLocalDataSource` interface exists.
   Only `TransactionLocalDataSource` needs alignment. The hard part is already done.

3. **Safe-to-Spend must ship.** S2S is the product's entire value proposition. Delaying it
   for infrastructure that won't be needed for a year is product malpractice.

4. **Option C reduces future migration to a 4-file swap.** When Drift is actually needed,
   the migration is mechanical — no architectural rethinking required.

5. **Fixes real bugs regardless.** TransactionType in domain layer is wrong. Missing
   TransactionEntity is wrong. These fixes are needed whether or not we migrate storage.

### Execution Plan

```
Week 1 (Pre-Phase 8):
  [x] Create TransactionEntity (pure Dart domain class)
  [x] Fix TransactionRepository interface to accept/return entities
  [x] Move TransactionType @HiveType to data layer copy
  [x] Add fromEntity/toEntity to TransactionModel
  [x] Update transaction providers for entity types
  [x] Add fromJson/toJson to both models

Week 2+ (Phase 8):
  [ ] Build Safe-to-Spend on current Hive architecture
  [ ] In-memory aggregation across income + transaction boxes
  [ ] Ship, validate, learn

Future (when sync is actually needed):
  [ ] Execute 4-file Drift migration (database class, 2 datasources, pubspec)
  [ ] Write one-time Hive-to-SQLite data migration script
  [ ] Add PowerSync layer
```

### Migration Gate Criteria

Upgrade from Option C to Option D (actual Drift migration) when ANY of these become true:
- Cloud sync is scheduled within next 2 phases
- Active users exceed 200 (data recovery becomes critical)
- A third data domain is being added (migration cost increases with each domain)
- Hive breaks on a Flutter stable release

---

## Decision Record

| Field | Value |
|-------|-------|
| Decision | Pending Chief Architect approval |
| Options evaluated | A (Keep Hive), B (Migrate Now), C (Abstract First), D (Hybrid Staged) |
| Recommended | Option C — Storage Abstraction First |
| Rejected | Option B — premature, delays S2S, risk without reward |
| Fallback | Option D — if sync timeline accelerates |
| Review trigger | Phase 9 kickoff or sync requirement confirmed |

---

## Appendix: External Audit Corrections

For the record, these specific claims from the Brutal Product Audit are addressed:

| Audit Claim | Accuracy | Correction |
|------------|----------|------------|
| "Hive mandates integer primary keys" | WRONG (for this codebase) | Pocketa uses `box.put(stringId, model)` — string keys throughout |
| "Integer PK makes sync impossible" | N/A | String IDs are already sync-compatible |
| "Immediately deprecate Hive" | PREMATURE | Domain abstraction + validation first, migrate when needed |
| "Migrate before defining data layer" | COUNTERPRODUCTIVE | Data layer already defined and working; rebuild costs 34h |
| "Hive binary format blocks export" | VALID | Adding fromJson/toJson in Option C addresses this |
| "PowerSync requires SQLite" | VALID | True, but sync is Phase 13+ (12+ months away) |
| "Drift + PowerSync is the correct target" | VALID (as end state) | Agree on destination, disagree on timing |
