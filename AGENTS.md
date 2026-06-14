# AGENTS.md — Multi-Agent Coordination for Helm

> This file defines how multiple AI agents collaborate on the Helm project.
> All agents must read this file to understand their role and boundaries.

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

## Authority Structure

```
┌──────────────────────────────────────┐
│       CHIEF ARCHITECT (Human)        │
│  Final authority on all decisions     │
├──────────────────────────────────────┤
│                                      │
│  ┌──────────┐ ┌──────┐ ┌──────────┐ │
│  │  Claude   │ │Gemini│ │Antigrav- │ │
│  │  Code     │ │ CLI  │ │  ity     │ │
│  └──────────┘ └──────┘ └──────────┘ │
│   Implementation Agents              │
└──────────────────────────────────────┘
```

---

## Agent Profiles

### Claude Code
**Config File:** `CLAUDE.md`

**Strengths:**
- Deep code reasoning and analysis
- Complex refactoring with high accuracy
- Thorough error handling patterns
- Excellent at following architectural constraints

**Best Used For:**
- Feature implementation (phase execution)
- Code review and analysis
- Bug diagnosis and fixing
- Architecture compliance checks

---

### Gemini CLI
**Config File:** `GEMINI.md`

**Strengths:**
- Fast iteration on well-defined tasks
- Good at following templates and patterns
- Efficient for batch operations

**Best Used For:**
- Quick fixes and small changes
- Template-based code generation
- Documentation updates
- Batch file operations

---

### Antigravity (Gemini in IDE)
**Config File:** `GEMINI.md`

**Strengths:**
- IDE-integrated with full project context
- Subagent parallelization for research
- Real-time file system access
- Can run commands and verify results

**Best Used For:**
- Full phase implementation with verification
- Multi-file coordinated changes
- Research-heavy tasks (codebase exploration)
- End-to-end feature delivery with commit

---

## Shared Documentation

All agents share and must respect:

| Document | Purpose | Location |
|---|---|---|
| Product Brain | What Helm is and isn't | `docs/core/HELM_BRAIN.md` |
| Architecture Rules | How code must be structured | `docs/core/ARCHITECTURE_RULES.md` |
| Agent Workflow | How to execute phases | `docs/governance/AGENT_WORKFLOW.md` |
| Roadmap | What's done and what's next | `docs/core/ROADMAP.md` |
| Session Start | Initialization rules | `docs/governance/SESSION_START_PROTOCOL.md` |
| Session End | Completion rules | `docs/governance/SESSION_END_PROTOCOL.md` |
| Project State | Current stability and debt | `docs/tracking/PROJECT_STATE.md` |
| Current Sprint | Active goals | `docs/tracking/CURRENT_SPRINT.md` |
| Context Recovery | Re-onboarding rules | `docs/governance/CONTEXT_RECOVERY.md` |
| Anti-Patterns | Forbidden practices | `docs/governance/ANTI_PATTERNS.md` |
| Escalation Rules | When to stop and ask | `docs/governance/ESCALATION_RULES.md` |
| Feature Spec Template | How to request features | `docs/templates/FEATURE_SPEC_TEMPLATE.md` |
| Review Checklist | Quality gates | `docs/governance/REVIEW_CHECKLIST.md` |

---

## Coordination Rules

### 1. No Unilateral Decisions
No agent may:
- Add packages without Chief Architect approval
- Expand phase scope beyond what was requested
- Refactor architecture without approval
- Override another agent's committed work

### 2. Document-First
All agents read the same docs. The docs are the contract.
If a doc is outdated, flag it to the Chief Architect.

### 3. One Phase, One Agent
Typically, one agent executes one phase at a time.
If multiple agents work concurrently, they must work on **different features** or **different files**.

### 4. Consistent Output
All agents use the same:
- Commit message format
- Completion report format
- Naming conventions
- Architecture patterns

### 5. No Context Assumptions
Agents must not assume context from previous sessions.
Always re-read documentation at the start of a new task.

---

## Handoff Protocol

When one agent hands off to another:

1. **Commit** all changes with a proper message
2. **Update** `docs/core/ROADMAP.md` with completed phase
3. **Report** what was done (completion report)
4. The receiving agent must:
   - Read all shared docs
   - Run `dart analyze` to verify clean state
   - Check `git status` for uncommitted changes
   - Review the latest commits for context

---

## Escalation

Escalate to the Chief Architect when:
- Two agents would need to modify the same file
- A phase requires architectural changes not covered in rules
- A dependency conflict arises
- An agent discovers a bug in another agent's committed code
- The roadmap needs updating beyond the current phase


<claude-mem-context>
# Memory Context

# [Helm-V2] recent context, 2026-06-13 2:50am GMT+6

No previous sessions found.
</claude-mem-context>
