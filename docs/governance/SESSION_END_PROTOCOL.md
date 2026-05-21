# POCKETA — Session End Protocol

> Mandatory completion protocol for all AI agents when wrapping up a session or task.

## 1. Analyzer Verification
- Run `dart analyze lib/`.
- Target must be: 0 errors, 0 warnings, 0 infos.
- Do not commit code that fails this check.

## 2. Git Hygiene
- Ensure all files are properly formatted.
- Commit messages must follow the project convention:
  `type(scope): description`
  `- detail 1`
  `- dart analyze clean`

## 3. Documentation Update Requirements
- Update `docs/core/ROADMAP.md` if a phase was completed.
- Update `docs/tracking/PROJECT_STATE.md` if stable modules or tech debt changed.

## 4. Lessons Learned Logging
- Log any major challenges or discoveries in `docs/tracking/LESSONS.md`.
- Document why certain approaches failed to prevent future mistakes.

## 5. Decision Logging
- Log any significant architectural or technical decisions in `docs/tracking/DECISION_LOG.md`.
- Explain the context, alternatives considered, and the final decision.

## 6. Sprint Progress Update
- Review `docs/tracking/CURRENT_SPRINT.md` and ensure the success metrics are met.
- Provide a summary report to the Chief Architect of what was accomplished.

## 7. Unresolved Issue Tracking
- Document any lingering bugs or blocked items in `docs/tracking/TASKS.md`.
- Escalate severe unresolved issues to the Chief Architect.
