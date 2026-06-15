# HELM — Agent Workflow Protocol

> Standard operating procedure for all AI agents working on Helm.
> This document defines how Claude Code, Gemini CLI, and Antigravity must behave.

---

## Pre-Flight Checklist

Before implementing **any** feature, every agent must:

1. **Follow the Session Start Protocol** — execute all steps in `docs/governance/SESSION_START_PROTOCOL.md`.
2. **Read** these core documents:
   - `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md` — **highest strategic authority; supersedes all prior roadmaps**
   - `docs/core/HELM_BRAIN.md` — understand the product
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

Helm is built in **strict phases**. Each phase:
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

## 4. Analyzer Result
Output of dart analyze.

## 5. Suggested Git Commit Message
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

1. **Check HELM_FINAL_PRODUCT_DOCTRINE.md** — does the Doctrine address it?
2. **Check HELM_BRAIN.md** — does it answer the question?
3. **Check ARCHITECTURE_RULES.md** — is there a binding constraint?
4. **Check ROADMAP.md** — is this feature in scope for the current phase?
5. **If still unclear** — ask the Chief Architect. Do not guess.

---

## Strategic Authority Hierarchy

When documents conflict, resolve using this precedence order:

1. **Final Product Doctrine** (`docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md`) — supreme authority
2. **CLAUDE.md** — project-level agent instructions
3. **HELM_BRAIN.md** — product identity and philosophy
4. **ARCHITECTURE_RULES.md** — technical constraints
5. **ROADMAP.md** — phase history and current state
6. **Spec documents** (`docs/specs/`) — feature-level details

If a spec or roadmap contradicts the Final Doctrine, the Doctrine wins. Update the conflicting document or flag it for Chief Architect review.

---

## Multi-Agent Coordination

When multiple agents work on Helm:

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