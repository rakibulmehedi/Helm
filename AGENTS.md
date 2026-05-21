# AGENTS.md — Multi-Agent Coordination for Pocketa

> This file defines how multiple AI agents collaborate on the Pocketa project.
> All agents must read this file to understand their role and boundaries.

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
| Product Brain | What Pocketa is and isn't | `docs/POCKETA_BRAIN.md` |
| Architecture Rules | How code must be structured | `docs/ARCHITECTURE_RULES.md` |
| Agent Workflow | How to execute phases | `docs/AGENT_WORKFLOW.md` |
| Roadmap | What's done and what's next | `docs/ROADMAP.md` |
| Session Start | Initialization rules | `docs/SESSION_START_PROTOCOL.md` |
| Session End | Completion rules | `docs/SESSION_END_PROTOCOL.md` |
| Project State | Current stability and debt | `docs/PROJECT_STATE.md` |
| Current Sprint | Active goals | `docs/CURRENT_SPRINT.md` |
| Context Recovery | Re-onboarding rules | `docs/CONTEXT_RECOVERY.md` |
| Anti-Patterns | Forbidden practices | `docs/ANTI_PATTERNS.md` |
| Escalation Rules | When to stop and ask | `docs/ESCALATION_RULES.md` |
| Feature Spec Template | How to request features | `docs/FEATURE_SPEC_TEMPLATE.md` |
| Review Checklist | Quality gates | `docs/REVIEW_CHECKLIST.md` |

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
2. **Update** `docs/ROADMAP.md` with completed phase
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
