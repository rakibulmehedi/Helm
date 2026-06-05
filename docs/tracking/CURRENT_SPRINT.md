# CURRENT SPRINT

> Details for the active sprint and immediate priorities.

## 1. Active Sprint

**UX Canon Implementation — Sprint 3: UX-2 Onboarding Redesign**
Status: **READY TO START** — Sprint 2 (UX-1) complete, dashboard cockpit live

**Prior Phases (All Complete):**
- Phase 8 — Safe-to-Spend Engine ✅
- Phase 9 — Pre-Beta QA & Validation ✅
- UX Canon Extraction & Planning Sprint ✅ (2026-06-05)
- Sprint 1: UX-5 Visual Identity / Design System ✅ (2026-06-05)

## 2. Current Priority

- **Sprint 2 (UX-1) COMPLETE** — 14/14 tasks done, dart analyze 0/0/0
- **Sprint 3 (UX-2) is next** — 11 tasks: Onboarding Redesign
- **Dashboard is now doctrine-aligned** — Reality Stack live, no Income/Expense chips, no transaction list on home
- **Token foundation is stable** — new widgets consume pocketa_colors, pocketa_typography, pocketa_spacing, pocketa_motion
- **Execution docs**: `docs/planning/UX_EXECUTION_TODO.md`, `UX_SPRINT_SEQUENCE.md`, `UX_TO_CODE_FILE_MAP.md`
- **Canonical spec**: `docs/ux/POCKETA_CANONICAL_UX_IMPLEMENTATION_SPEC.md`
- MVP success criteria locked per Doctrine §4:
  - Pipeline update compliance ≥85%
  - Override-equivalent rate <5%
  - 30-day retention ≥60%
  - Onboarding completion ≥70%
  - S2S comprehension ≥80%

## 3. Sprint Status — UX Canon Implementation

| Sprint | ID | Status | Tasks |
|--------|-----|--------|-------|
| 1 | UX-5 Visual Identity / Design System | **COMPLETE** ✅ | 12/12 |
| 2 | UX-1 Dashboard Cockpit Redesign | **COMPLETE** ✅ | 14/14 |
| 3 | UX-2 Onboarding Redesign | **Next** | 11 |
| 4 | UX-3 Pipeline Quick-Update | Pending | 10 |
| 5 | UX-4 Microcopy Replacement | Pending | 8 |
| 6 | D1 Trust Layer Foundation | Pending | 12 |
| 7 | D2 Beta Instrumentation | Pending | 6 |
| 8 | D3 Closed Beta Readiness | Pending | 8 |

### Prior Sprints (Complete)

| Item | Status |
|------|--------|
| Sprint 1: UX-5 Visual Identity / Design System | Done (2026-06-05) |
| UX Canon Extraction & Planning | Done (2026-06-05) |
| Phase 9b — Hypothesis-Based Validation | Done (2026-05-23) |
| Phase 9a — Cognitive Persona Simulation | Done (2026-05-23) |
| Phase 8 — Safe-to-Spend Engine (all sub-phases) | Done (2026-05-23) |
| Phase 7 — Income Pipeline (all sub-phases) | Done (2026-05-22/23) |

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

## 6. UX Canon Planning Deliverables (2026-06-05)

**Extraction (Pass 1):**
- `docs/ux/extracted/01_product_constraints.md` — 79 constraints
- `docs/ux/extracted/02_ux_constraints.md` — 104 constraints
- `docs/ux/extracted/03_dashboard_requirements.md` — full cockpit model
- `docs/ux/extracted/04_onboarding_requirements.md` — 49 requirements
- `docs/ux/extracted/05_pipeline_requirements.md` — 50 requirements
- `docs/ux/extracted/06_microcopy_requirements.md` — 46 requirements
- `docs/ux/extracted/07_visual_identity_requirements.md` — 45 requirements
- `docs/ux/extracted/08_visual_identity_refinements.md` — 34 refinements
- `docs/ux/extracted/09_research_evidence.md` — behavioral findings
- `docs/ux/extracted/10_acceptance_criteria.md` — testable gates
- `docs/ux/extracted/11_implementation_atoms.md` — 42 codebase atoms
- `docs/ux/extracted/12_conflicts_and_overrides.md` — 33 gaps, 8 MVP-blocking

**Canonical Spec (Pass 2):**
- `docs/ux/POCKETA_CANONICAL_UX_IMPLEMENTATION_SPEC.md` — single source of truth

**Planning (Pass 3):**
- `docs/planning/UX_TO_CODE_FILE_MAP.md` — file impact map
- `docs/planning/UX_SPRINT_SEQUENCE.md` — 8 sprints, dependency graph
- `docs/planning/UX_EXECUTION_TODO.md` — 81 atomic tasks with 11 fields each

## 7. Strategic Context

- **Final Product Doctrine** adopted 2026-06-04 — supersedes all prior roadmaps
- **UX Canon** created 2026-06-05 — supersedes ad-hoc UX decisions
- See `docs/strategy/POCKETA_FINAL_PRODUCT_DOCTRINE.md` for canonical product scope
- See `docs/ux/POCKETA_CANONICAL_UX_IMPLEMENTATION_SPEC.md` for canonical UX spec
- See `docs/planning/UX_EXECUTION_TODO.md` for implementation task list
- See `docs/planning/DOCTRINE_TO_CODE_GAP_ANALYSIS.md` for implementation gaps
- Prior decisions (010–021) remain valid where aligned with doctrine and UX canon
