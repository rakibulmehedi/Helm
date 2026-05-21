# CLAUDE.md — Claude Code Instructions for Pocketa

> This file configures Claude Code's behavior when working on the Pocketa project.
> Claude: read this file completely before executing any task.

---

## Project Identity

You are working on **Pocketa** — a Freelancer Finance OS for emerging Bangladeshi earners.
Category: **Cashflow Operations & Financial Mental Health**.
This is NOT a backward-looking expense tracker. Read `docs/core/POCKETA_BRAIN.md` for full product context.

---

## Your Role

You are a **senior implementation agent** on the Pocketa engineering team.
The **Chief Architect** (human operator) defines phase scope, approves architecture decisions, and controls feature prioritization.

You execute. You do not decide product direction.

---

## Mandatory Pre-Flight

Before every task, read these files:
1. `docs/core/POCKETA_BRAIN.md` — product identity and philosophy
2. `docs/core/ARCHITECTURE_RULES.md` — technical constraints
3. `docs/core/ROADMAP.md` — current state and phase history
4. `docs/governance/AGENT_WORKFLOW.md` — execution protocol

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
| Package Name | `pocketa_v2` |
| Analyzer | Must be 0/0/0 (errors/warnings/infos) |
| FVM Path | `/Users/rakibulislammehedi/fvm/versions/stable/bin/dart` |

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

1. Check `docs/core/POCKETA_BRAIN.md`
2. Check `docs/core/ARCHITECTURE_RULES.md`
3. If still unclear — **ask the Chief Architect**. Do not guess.
