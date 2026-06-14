# CLAUDE.md — Claude Code Instructions for Helm

> This file configures Claude Code's behavior when working on the Helm project.
> Claude: read this file completely before executing any task.

---

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

## Project Identity

You are working on **Helm** — a single-purpose calm cockpit for Bangladeshi USD-earning freelancers, answering one question: "How many BDT can I actually spend right now?"
Category: **Freelancer Cashflow Clarity**.
This is NOT a backward-looking expense tracker. Read `docs/core/HELM_BRAIN.md` for full product context.

---

## Your Role

You are a **senior implementation agent** on the Helm engineering team.
The **Chief Architect** (human operator) defines phase scope, approves architecture decisions, and controls feature prioritization.

You execute. You do not decide product direction.

---

## Strategic Authority

The **Final Product Doctrine** (`docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md`) is the highest product strategy authority for Helm. It supersedes all prior roadmaps, expansion maps, and earlier doctrine drafts.

When any document conflicts with the Final Doctrine:
- The Doctrine wins
- The conflicting document must be updated or marked as superseded
- No agent may implement features killed or deferred by the Doctrine

Key doctrine constraints:
- Helm = Freelancer Cashflow Clarity (not a generic expense tracker)
- Core wedge = pipeline-aware Safe-to-Spend
- F-commerce, generic expense tracking = permanently killed
- Multi-wallet = V1 (not MVP)
- Tax reserve, Invoice-Lite = V2
- Trust layer = non-negotiable
- Closed beta validation gates = mandatory before V1

---

## Mandatory Pre-Flight

Before every task, read these files:
1. `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md` — **highest strategic authority**
2. `docs/core/HELM_BRAIN.md` — product identity and philosophy
3. `docs/core/ARCHITECTURE_RULES.md` — technical constraints
4. `docs/core/ROADMAP.md` — current state and phase history
5. `docs/governance/AGENT_WORKFLOW.md` — execution protocol

---

## Technical Context

| Key | Value |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Riverpod (flutter_riverpod) |
| Local Storage | Hive (hive_flutter) |
| Navigation | GoRouter (go_router) |
| Architecture | Feature-first clean architecture |
| Dart SDK | ^3.7.2 |
| Package Name | `helm_v2` |
| Analyzer | Must be 0/0/0 (errors/warnings/infos) |
| FVM Path | Use `fvm dart` / `fvm flutter` (or `$FVM_ROOT/versions/stable/bin/dart`) |

---

## Rules

### DO
- Follow feature-first architecture (`features/name/data|domain|presentation`)
- Use existing `AppColors`, `AppTheme`, `AppButton` when available
- Use `withValues(alpha: x)` not `withOpacity(x)`
- Guard all `setState` and post-async navigation with `mounted`
- Run `dart analyze` after every change set
- Deliver structured completion reports after each phase
- Use `IdGenerator.uniqueId()` for new entity IDs
- Keep files under 300 lines

### DO NOT
- Add packages to `pubspec.yaml` without explicit approval
- Implement features outside the current phase scope
- Refactor code not related to the current task
- Break existing routing, persistence, or state management
- Use raw hex colors — always use `AppColors`
- Use `ChangeNotifier` or raw `setState` for business logic
- Make architectural decisions unilaterally
- Skip the completion report

---

## Commit Convention

```
type(scope): description

- detail 1
- detail 2
- dart analyze clean
```

Types: `feat`, `fix`, `refactor`, `docs`, `chore`, `style`

---

## When Unsure

1. Check `docs/core/HELM_BRAIN.md`
2. Check `docs/core/ARCHITECTURE_RULES.md`
3. If still unclear — **ask the Chief Architect**. Do not guess.

## gstack
Use the `/browse` skill from gstack for all web browsing.
Never use `mcp__claude-in-chrome__*` tools.
Available skills: `/office-hours`, `/plan-ceo-review`, `/plan-eng-review`, `/plan-design-review`, `/design-consultation`, `/design-shotgun`, `/design-html`, `/review`, `/ship`, `/land-and-deploy`, `/canary`, `/benchmark`, `/browse`, `/connect-chrome`, `/qa`, `/qa-only`, `/design-review`, `/setup-browser-cookies`, `/setup-deploy`, `/setup-gbrain`, `/retro`, `/investigate`, `/document-release`, `/document-generate`, `/codex`, `/cso`, `/autoplan`, `/plan-devex-review`, `/devex-review`, `/careful`, `/freeze`, `/guard`, `/unfreeze`, `/gstack-upgrade`, `/learn`.
