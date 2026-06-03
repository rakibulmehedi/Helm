# CURRENT SPRINT

> Details for the active sprint and immediate priorities.

## 1. Active Sprint

**Phase 8 — Safe-to-Spend Engine**
Sub-phase: **Phase 8a (Formula & Data Contract) ✅ COMPLETE**
Sub-phase: **Phase 8c (Settings Screen) ✅ COMPLETE**
Sub-phase: **Phase 8d (Dashboard Hero Number) ✅ COMPLETE**
Sub-phase: **Phase 8e (UX Hardening) ✅ COMPLETE**
Sub-phase: **Phase 8f (Real Device QA + Validation Prep) ✅ COMPLETE**

**Phase 9 — Pre-Beta QA & Validation**
Sub-phase: **Phase 9a (Cognitive Persona Simulation) ✅ COMPLETE**
Sub-phase: **Phase 9b (Hypothesis-Based Validation) ✅ COMPLETE**

## 2. Current Priority

- **Final Doctrine adopted** — `docs/strategy/POCKETA_FINAL_PRODUCT_DOCTRINE.md` is now canon (2026-06-04)
- **Phase 8 COMPLETE** — Safe-to-Spend engine is production-grade
- **Phase 9b COMPLETE** — Hypothesis validation done
- **Next: Doctrine Gap Resolution** — align existing implementation with doctrine MVP requirements
- **Then: Closed Beta** — 15–25 freelancers, 4 weeks, per Doctrine §16
- MVP success criteria locked per Doctrine §4:
  - Pipeline update compliance ≥85%
  - Override-equivalent rate <5%
  - 30-day retention ≥60%
  - Onboarding completion ≥70%
  - S2S comprehension ≥80%

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
| Phase 7e — Status Transitions | Done (2026-05-22) |
| Phase 7f — Storage Abstraction & Domain Cleanup | Done (2026-05-23) |
| Phase 8a — Formula & Data Contract | Done (2026-05-23) |
| Phase 8b — Calculation Engine | Done (2026-05-23) |
| Phase 8c — Settings Screen | Done (2026-05-23) |
| Phase 8d — Dashboard Hero Number | Done (2026-05-23) |
| Phase 8e — UX Hardening | Done (2026-05-23) |
| Phase 8f — Real Device QA + Validation Prep | Done (2026-05-23) |
| Phase 9a — Cognitive Persona Simulation | Done (2026-05-23) |
| Phase 9b — Hypothesis-Based Validation | Done (2026-05-23) |

## 4. Out-of-Scope Systems (Per Final Doctrine)

- Virtual Wallets (V1 — after MVP beta clears)
- Subscription Leakage Radar (**KILLED** — not in doctrine)
- AI assistant (**KILLED**)
- Supabase sync (V1+)
- Charts / analytics dashboards (V3)
- Multi-currency conversion (V1)
- Invoice generation (V2)
- Tax reserve (V2)
- Bank balance sync (**KILLED** — never)
- F-commerce / inventory / POS (**KILLED** — wrong product)
- Generic expense categorization (**KILLED**)
- Gamification (**KILLED**)

## 5. Sprint Success Metric

A freelancer should be able to:
- Open the app and immediately see how much they can spend freely (within 3 seconds)
- Tap to see exactly how that number was calculated (full breakdown)
- Trust the number because pending money is explicitly excluded
- Configure tax rate, anxiety buffer, and fixed costs in under 2 minutes

## 6. Phase 8a Deliverables (Complete)

- `docs/specs/SAFE_TO_SPEND_MODEL.md` — Formula contract locked (overwritten from hypothesis)
- `docs/implementation/PHASE_8_SAFE_TO_SPEND_EXECUTION_PLAN.md` — Execution plan created
- `docs/implementation/PHASE_8_ACCEPTANCE_CHECKLIST.md` — Acceptance checklist created
- `docs/tracking/DECISION_LOG.md` — Decision 014 logged (formula finalized)
- `docs/tracking/LESSONS.md` — Phase 8a lessons added
- `docs/tracking/TASKS.md` — Updated
- `docs/tracking/CURRENT_SPRINT.md` — This update

## 7. Strategic Context

- **Final Product Doctrine** adopted 2026-06-04 — supersedes all prior roadmaps
- See `docs/strategy/POCKETA_FINAL_PRODUCT_DOCTRINE.md` for canonical product scope
- See `docs/planning/DOCTRINE_TO_CODE_GAP_ANALYSIS.md` for implementation gaps
- See `docs/planning/DOCTRINE_ALIGNED_EXECUTION_ROADMAP.md` for next steps
- Prior decisions (010–015) remain valid where aligned with doctrine
