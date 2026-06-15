# PARALLEL AGENT DISPATCH — Insane Practice Hunt

> Date: 2026-06-12
> Purpose: Dispatch all 10 agent lenses in parallel against the Helm codebase to find practices that are aggressive, missing, or architecturally "insane" for a production fintech app.
> Output: Per-agent findings feed back into master plan priority reordering.

---

## Dispatch Status

**Wave 1 (Phases 1-4): COMPLETE.**
**Wave 2: COMPLETE.**

Wave 1 and Wave 2 agents ran against codebase during S1-W4 audit cycle. Findings integrated into master plan. See `docs/audits/` for all deliverable files.

---

## Dispatch Strategy

| Wave | Agents | Status |
|------|--------|--------|
| **Wave 1** | Nudge Engine, UX Researcher, UI Designer, Whimsy Injector, Brand Guardian, UX Architect | COMPLETE |
| **Wave 2** | Persona Walkthrough, Visual Storyteller | COMPLETE |
| **Wave 3** | Inclusive Visuals Specialist, Image Prompt Engineer | Pending — dispatch at Phase 5 exit |

---

## Wave 3 — Pending (App Store / Marketing Phase)

Dispatch when V1 stable and App Store listing prep begins (Phase 5-6 exit).

### 9. Inclusive Visuals Specialist

**Relevance:** App Store screenshots must represent Bangladeshi freelancers authentically — no Western stock photos, no AI clone faces, no gibberish Bangla text, correct cultural context (Dhaka offices, co-working spaces, home setups).

**When to dispatch:** Phase 5 exit (V1 stable, preparing App Store listing).

**Deliverable:** App Store screenshot prompts and a11y imagery brief.

---

### 10. Image Prompt Engineer

**Relevance:** App Store screenshot series, feature graphics, promotional banner for Play Store listing. Requires App Store listing strategy from Brand Guardian + Visual Storyteller first.

**When to dispatch:** Phase 5 exit (V1 stable, preparing App Store listing).

**Deliverable:** App Store feature graphic prompts.

---

## Dispatch Execution Order

```
Wave 1 + Wave 2: COMPLETE
  └── Findings at: docs/audits/*/FINDINGS.md

PHASE 5 EXIT (future):
  Wave 3 (2 parallel agents):
  ├── Inclusive Visuals Specialist ──→ App Store screenshot prompts
  └── Image Prompt Engineer ────────→ App Store feature graphic prompts
```

---

## Integration with Master Plan

All Wave 1 + Wave 2 findings fed back into:

1. **Priority reordering** — Nudge Engine dead-dashboard findings made Phase 1-3 CRITICAL/URGENT.
2. **New task injection** — Persona Walkthrough (Rafiq journey) findings injected tasks into Phase 4.
3. **Score recalibration** — Whimsy Injector audit adjusted behavioral scoring.
4. **Anti-pattern registry** — Architectural Violence findings updated `docs/governance/ANTI_PATTERNS.md`.

**Source of truth:** `docs/planning/100_PERCENT_MASTER_PLAN.md` §9 (Agent Assignment Matrix).

---

## Wave 3 Agent Invocation Format

```
You are the [AGENT NAME] — [agent description].
Dispatched for App Store asset creation for Helm (Bangladeshi freelancer cashflow app).

CONTEXT:
- V1 stable. Preparing Play Store listing.
- Target user: Bangladeshi USD-earning freelancer (Rafiq persona — see docs/audits/persona-walkthrough/)
- Brand: calm, clinical-warm, Bangla-first
- Codebase: Flutter/Dart, feature-first clean architecture
- Prior audit findings: docs/audits/brand-guardian/ + docs/audits/visual-storyteller/

YOUR TASK:
[Agent-specific instructions]

DELIVERABLE:
docs/audits/[your-folder]/[FILE].md — prompts, briefs, or asset specs.
```

---

## Exit Criteria for Wave 3

| Agent | Exit when |
|-------|-----------|
| Inclusive Visuals Specialist | 5+ screenshot concepts with cultural accuracy brief + a11y notes |
| Image Prompt Engineer | Feature graphic prompt + 3-5 screenshot prompts ready for generation |
