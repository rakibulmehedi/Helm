# HELM — Session Start Protocol

> Mandatory initialization protocol for all AI agents when beginning a new session or task.

## Documentation Operating Purpose

**Core principle: Documentation is not archive. Documentation is the active operating memory of the product.**

Every agent must use docs to:
1. Understand product identity
2. Verify current sprint
3. Prevent scope creep
4. Preserve architecture decisions
5. Avoid repeating past mistakes
6. Convert research into product decisions
7. Convert specs into implementation boundaries
8. Update state after every meaningful change

### Documentation Usage Rules
1. No implementation may begin until relevant docs are read.
2. Every feature must reference a spec or create one first.
3. Every major architectural/product decision must update `docs/tracking/DECISION_LOG.md`.
4. Every important mistake or discovery must update `docs/tracking/LESSONS.md`.
5. Every completed task must update `docs/tracking/TASKS.md` or `docs/tracking/CURRENT_SPRINT.md`.
6. Research docs must influence specs, not sit unused.
7. Specs must influence implementation, not sit unused.
8. `docs/core/ROADMAP.md` must reflect major direction changes.
9. `docs/tracking/PROJECT_STATE.md` must be updated when stable/frozen systems change.
10. Agents must explicitly report which docs they used.

---

## 1. Mandatory Reading Order
Every agent must read these documents in exact order before writing any code:
1. `docs/core/HELM_BRAIN.md` — Core identity and philosophy
2. `docs/core/ARCHITECTURE_RULES.md` — Technical boundaries
3. `docs/tracking/PROJECT_STATE.md` — Current system stability
4. `docs/tracking/CURRENT_SPRINT.md` — Active goals and priorities
5. `docs/core/ROADMAP.md` — Historical context and future phases
6. `docs/governance/AGENT_WORKFLOW.md` — Execution rules

## 2. Project Identity Verification
- Verify the task aligns with: *"Helm is a Freelancer Finance OS for emerging Bangladeshi earners."*
- Reject generic expense tracker features.

## 3. Sprint Verification
- Check `docs/tracking/CURRENT_SPRINT.md` to ensure the task belongs to the active sprint.
- Do not execute tasks outside the current sprint scope without explicit Chief Architect approval.

## 4. Task Boundary Setup
- Define the exact scope of the current session.
- Identify the specific files to be created or modified.
- Identify systems that must **not** be touched.

## 5. Implementation Rules
- Follow strictly the feature-first architecture (`features/name/data|domain|presentation`).
- Reuse existing components (`AppColors`, `AppButton`, `AppTheme`).
- Keep files under 300 lines.

## 6. Quality Gates
- Code must not break existing working flows.
- State must be managed via Riverpod (`flutter_riverpod`).
- Storage must be local via Hive (`hive_flutter`).

## 7. Analyzer Requirements
- Ensure `dart analyze` returns `0 issues` before starting any modifications.

## 8. Forbidden Actions
- No unapproved package installations in `pubspec.yaml`.
- No architectural rewrites.
- No modifying `lib/` code that is outside the explicit task scope.
- No placeholder UI/content creation.
