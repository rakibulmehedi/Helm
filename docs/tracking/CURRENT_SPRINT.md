# CURRENT SPRINT

> Details for the active sprint and immediate priorities.

## 1. Active Sprint

**Phase 7 — Freelancer Income Pipeline**

## 2. Current Priority

- Implement Income Pipeline (Expected / Pending / Received states)
- New feature module: `lib/features/income/`
- Dashboard income summary integration

## 3. Sprint Status

| Item | Status |
|------|--------|
| Research-to-spec refinement | Done (2026-05-22) |
| Phase 7 spec finalized | Done (2026-05-22) |
| Income Pipeline MVP spec | Done (2026-05-22) |
| Phase 7a — Income Data Layer | Done (2026-05-22) |
| Phase 7b — Income Entry UI | Done (2026-05-22) |
| Phase 7c — Income List & Filtering | Done (2026-05-22) |
| Phase 7d — Dashboard Integration | Done (2026-05-22) |
| Phase 7e — Status Transitions | **Pending — NOT yet implemented** |

## 4. Out-of-Scope Systems

- Safe-to-Spend calculation (Phase 8)
- Virtual Wallets (future phase)
- Subscription Leakage Radar (Phase 9)
- AI assistant
- Supabase sync
- Charts / analytics
- Multi-currency conversion
- Invoice generation
- Tax filing

## 5. Sprint Success Metric

A freelancer should be able to:
- Add an expected payment with client name, project, amount, and expected date
- Track that payment through Expected → Pending → Received
- See a dashboard summary of total Expected, Pending, and Received income
- Answer "Am I okay this month?" within 3 seconds of opening the app

## 6. Immediate Next Step

Begin Phase 7e — Status Transitions (quick-action buttons on income cards).
After 7e: Domain cleanup sprint (TransactionEntity, @HiveType fix, fromJson/toJson). ~7–11h.
After cleanup: Begin Phase 8 — Safe-to-Spend Engine.

## 7. Post-Audit Strategic Context

See `docs/planning/POST_AUDIT_EXECUTION_ROADMAP.md` for full strategic synthesis.
Key decisions: Hive migration deferred (Decision 010). External positioning pivot (Decision 011). User validation sprint planned post-Phase 8 (Decision 012).
