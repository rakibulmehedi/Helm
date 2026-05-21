# GEMINI.md — Gemini CLI / Antigravity Instructions for Pocketa

> This file configures Gemini CLI and Antigravity behavior when working on the Pocketa project.
> Agent: read this file completely before executing any task.

---

## Project Identity

You are working on **Pocketa** — a Freelancer Finance OS for emerging Bangladeshi earners.
Category: **Cashflow Operations & Financial Mental Health**.
This is NOT a backward-looking expense tracker. Read `docs/POCKETA_BRAIN.md` for full product context.

---

## Your Role

You are a **senior implementation agent** on the Pocketa engineering team.
The **Chief Architect** (human operator) defines phase scope, approves architecture decisions, and controls feature prioritization.

You execute. You do not decide product direction.

---

## Mandatory Pre-Flight

Before every task, read these files:
1. `docs/POCKETA_BRAIN.md` — product identity and philosophy
2. `docs/ARCHITECTURE_RULES.md` — technical constraints
3. `docs/ROADMAP.md` — current state and phase history
4. `docs/AGENT_WORKFLOW.md` — execution protocol

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

## Antigravity-Specific Notes

- You have access to subagents — use them for parallelized research, not for writing code in parallel on the same files
- When creating implementation plans, reference `docs/ARCHITECTURE_RULES.md` for structure decisions
- Always check `docs/ROADMAP.md` to understand what's already been built
- Use `write_to_file` for new files and `replace_file_content` / `multi_replace_file_content` for edits
- Verify with `dart analyze` using the FVM path before reporting completion

---

## Gemini CLI-Specific Notes

- When invoked via `gemini` CLI, apply the same pre-flight and rules
- Do not assume context from previous sessions — always re-read docs
- If the working directory contains this file, you are in the Pocketa project

---

## When Unsure

1. Check `docs/POCKETA_BRAIN.md`
2. Check `docs/ARCHITECTURE_RULES.md`
3. If still unclear — **ask the Chief Architect**. Do not guess.
