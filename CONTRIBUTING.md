# Contributing to Pocketa

Pocketa is a Freelancer Finance OS. Contributions must serve that mission without compromising product integrity, architecture, or user trust.

---

## Before You Start

Read these docs in order:

1. [docs/core/POCKETA_BRAIN.md](docs/core/POCKETA_BRAIN.md) — product identity and philosophy
2. [docs/core/ARCHITECTURE_RULES.md](docs/core/ARCHITECTURE_RULES.md) — hard technical constraints
3. [docs/core/ROADMAP.md](docs/core/ROADMAP.md) — current phase and direction
4. [docs/governance/AGENT_WORKFLOW.md](docs/governance/AGENT_WORKFLOW.md) — execution protocol

---

## What Requires a Spec First

Any change to product behavior, a new feature, or a new entity requires a spec in `docs/specs/` before implementation begins. Do not implement features from issue descriptions alone.

---

## Technical Requirements

- Flutter / Dart 3.7+
- Riverpod for all state management (no ChangeNotifier, no raw setState for business logic)
- Hive for local storage (do not add storage dependencies without approval)
- GoRouter for navigation
- Feature-first folder structure: `features/name/data|domain|presentation`
- `dart analyze` must be clean (0 errors, 0 warnings, 0 infos) before any PR
- All tests must pass: `flutter test`
- Files must stay under 300 lines
- Use `AppColors` — no raw hex colors
- Use `withValues(alpha: x)` not `withOpacity(x)`
- Guard all `setState` and post-async navigation with `mounted`

---

## Commit Convention

```
type(scope): description

- detail 1
- detail 2
- dart analyze clean
```

Types: `feat`, `fix`, `refactor`, `docs`, `chore`, `style`, `test`

---

## Continuous Integration

Every push to `main` and every pull request runs the CI quality gate automatically:

```
dart analyze   → must be clean (0 errors, 0 warnings, 0 infos)
flutter test   → all tests must pass
```

**CI must pass before any PR is merged.** Do not merge a PR with a failing CI run. If CI fails on your branch, fix it locally before requesting review.

---

## Pull Request Checklist

- [ ] Read all mandatory pre-flight docs
- [ ] Feature references an existing spec or a new spec is included
- [ ] `dart analyze` returns no issues
- [ ] `flutter test` passes
- [ ] No new packages added without discussion
- [ ] No architecture decisions made unilaterally
- [ ] Completion report included in PR description (what changed, what docs updated)

---

## What NOT to Do

- Do not add packages to `pubspec.yaml` without explicit approval
- Do not implement features outside current phase scope
- Do not refactor code unrelated to your task
- Do not use raw hex colors
- Do not use Firebase or cloud services (offline-first MVP)
- Do not touch the Safe-to-Spend formula without a spec change approved by the owner

---

## Reporting Issues

Use GitHub Issues. Bug reports require reproduction steps. Feature requests require a product rationale aligned with [POCKETA_BRAIN.md](docs/core/POCKETA_BRAIN.md).

---

## Questions

If uncertain about scope or approach: open a discussion issue before writing code. Do not guess on architectural decisions.
