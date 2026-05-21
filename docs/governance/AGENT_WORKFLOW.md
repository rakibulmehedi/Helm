# POCKETA — Agent Workflow Protocol

> Standard operating procedure for all AI agents working on Pocketa.
> This document defines how Claude Code, Gemini CLI, and Antigravity must behave.

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

## Pre-Flight Checklist

Before implementing **any** feature, every agent must:

1. **Follow the Session Start Protocol** — execute all steps in `docs/governance/SESSION_START_PROTOCOL.md`.
2. **Read** these core documents:
   - `docs/core/POCKETA_BRAIN.md` — understand the product
   - `docs/core/ARCHITECTURE_RULES.md` — understand the constraints
   - `docs/core/ROADMAP.md` — understand what's been done and what's next
   - `AGENTS.md` — understand your role and boundaries

3. **Confirm scope** — only implement what was explicitly requested
4. **Check analyzer** — run `dart analyze` before and after changes
5. **Preserve existing flows** — never break working features
6. **Ask before expanding** — if scope is ambiguous, ask the Chief Architect

---

## Post-Flight Checklist

After completing any feature, every agent must:

1. **Follow the Session End Protocol** — execute all steps in `docs/governance/SESSION_END_PROTOCOL.md`.

---

## Phase-Based Execution Model

Pocketa is built in **strict phases**. Each phase:
- Has a defined scope (provided by the Chief Architect)
- Must not bleed into other phases
- Must produce a clean `dart analyze` result
- Must include a structured completion report
- Must end with a git commit

### Phase Lifecycle

```
┌─────────────────────────────────────────────────┐
│  Chief Architect defines phase scope            │
│                    ↓                            │
│  Agent reads brain + rules + roadmap            │
│                    ↓                            │
│  Agent implements within constraints            │
│                    ↓                            │
│  Agent runs dart analyze (must be clean)        │
│                    ↓                            │
│  Agent delivers completion report               │
│                    ↓                            │
│  Chief Architect reviews and approves           │
│                    ↓                            │
│  Agent commits with descriptive message         │
│                    ↓                            │
│  Chief Architect defines next phase             │
└─────────────────────────────────────────────────┘
```

---

## Feature Execution Report Format

Every phase completion must include:

```markdown
# Phase N — [Phase Name] Complete

## 1. Summary
Brief description of what was implemented.

## 2. Files Created
List of new files with purpose.

## 3. Files Modified
List of modified files with description of changes.

## 4. Data Flow
How data moves through the new/changed code.

## 5. State Flow
How state is managed (providers, notifiers).

## 6. UX Impact
What the user sees differently.

## 7. Analyzer Result
Output of dart analyze.

## 8. Documentation Used
- List docs read
- Explain how docs influenced the implementation

## 9. Documentation Updated
- List docs updated
- Explain why

## 10. Documentation Gaps Found
- Mention missing/outdated docs if found

## 11. Suggested Git Commit Message
Ready-to-use commit message.
```

---

## Scope Enforcement

### Allowed
- Implementing exactly what the phase spec requests
- Using existing shared code (`AppColors`, `AppButton`, `AppTheme`, etc.)
- Creating new files within the feature's directory structure
- Adding to existing providers when the phase requires it
- Fixing analyzer warnings introduced by your changes

### Forbidden
- Adding packages to `pubspec.yaml` without explicit approval
- Refactoring unrelated code
- Redesigning existing screens not in scope
- Implementing features from future phases
- Introducing architectural patterns not established in the codebase
- Breaking existing routes, persistence, or state management
- Committing with analyzer errors or warnings

---

## Conflict Resolution

When instructions are ambiguous:

1. **Check POCKETA_BRAIN.md** — does it answer the question?
2. **Check ARCHITECTURE_RULES.md** — is there a binding constraint?
3. **Check ROADMAP.md** — is this feature in scope for the current phase?
4. **If still unclear** — ask the Chief Architect. Do not guess.

---

## Multi-Agent Coordination

When multiple agents work on Pocketa:

- Each agent must read the same documentation set
- No agent may override another agent's committed work without approval
- All agents follow the same commit format
- Conflicts are resolved by the Chief Architect
- The `AGENTS.md` file defines which agent is optimized for which tasks

---

## Quality Gates

No phase is complete until:

- [ ] All requested features are implemented
- [ ] `dart analyze` returns 0 issues
- [ ] Existing features still work (no regressions)
- [ ] Completion report is delivered
- [ ] Chief Architect has approved
- [ ] Changes are committed with proper message