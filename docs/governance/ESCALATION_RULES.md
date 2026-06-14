# ESCALATION RULES

> Guidelines for when agents must stop and request human intervention.

## 1. When Agents Must STOP
- When encountering persistent analyzer errors that cannot be solved within 2 attempts.
- When two agents need to modify the exact same file simultaneously.
- When an instruction contradicts the `HELM_BRAIN.md` or `ARCHITECTURE_RULES.md`.

## 2. When Architectural Approval is Required
- Adding new packages to `pubspec.yaml`.
- Changing state management patterns.
- Modifying offline-first data flow.

## 3. High-Risk Modification Areas
- Hive data models and adapters.
- Core routing configuration (`GoRouter`).
- The root `ProviderScope` and global providers.

## 4. Forbidden Autonomous Decisions
- Introducing cloud sync.
- Introducing authentication.
- Performing multi-feature, codebase-wide refactors.
- Modifying frozen systems (see `PROJECT_STATE.md`).