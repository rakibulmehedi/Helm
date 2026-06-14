# PARALLEL AGENT DISPATCH — Insane Practice Hunt

> Date: 2026-06-12
> Purpose: Dispatch all 10 agent lenses in parallel against the Helm codebase to find practices that are aggressive, missing, or architecturally "insane" for a production fintech app.
> Output: Per-agent findings feed back into master plan priority reordering.

---

## Dispatch Strategy

Three dispatch waves based on dependency chains and domain independence:

| Wave | Agents | Rationale |
|------|--------|-----------|
| **Wave 1** (parallel, zero deps) | Nudge Engine, UX Researcher, UI Designer, Whimsy Injector, Brand Guardian, UX Architect | All 6 analyze the SAME codebase but different dimensions. No agent needs another's output. |
| **Wave 2** (parallel, needs persona profile) | Persona Walkthrough, Visual Storyteller | Persona Walkthrough builds Rafiq profile first. Visual Storyteller consumes persona + UI Designer findings. |
| **Wave 3** (deferred, lower priority) | Inclusive Visuals Specialist, Image Prompt Engineer | Only relevant for App Store assets + a11y imagery. Not codebase-level audit. |

---

## Wave 1 — Six-Way Parallel Dispatch

All 6 agents receive the same codebase context but hunt for different categories of insanity.

### 1. Behavioral Nudge Engine — Hunt for "Dead Dashboard" Anti-Pattern

**What to hunt:**
- Is the dashboard a passive mirror or an active coach? Check `lib/features/dashboard/` — does it show state OR does it guide the next action?
- Does any code exist that reaches OUT to the user (push, in-app notification, SMS)? Search for `flutter_local_notifications`, `firebase_messaging`, any notification package import.
- Does the onboarding ASK about cadence preferences? Check `lib/features/onboarding/` for frequency/channel/time-of-day preference capture.
- Does any screen show "you have X overdue items" vs "here's the ONE most urgent"? Check pipeline list screen.
- Is there an opt-out architecture in any notification stub? Search for "turn off", "snooze", "mute", "preferences".
- Does the app celebrate micro-wins or only show deficits? Check for any affirmation copy ("pipeline up to date", "7 days tracked", "all clear").
- Search for `haptic` or `HapticFeedback` or `vibrate` — zero haptic feedback anywhere?

**Deliverable:** `docs/audits/nudge-engine/DEAD_DASHBOARD_FINDINGS.md` — quantified insanity score per Fogg dimension + priority reordering recommendation for master plan Phase 1-3.

**Insane if:** Dashboard is passive, zero out-of-app reach, zero preference capture, zero haptics, zero celebration — all true for Helm today.

---

### 2. UX Researcher — Hunt for "Assumption-Driven Design" Anti-Pattern

**What to hunt:**
- Is there any A/B testing infrastructure in the codebase? Search for `experiment`, `feature_flag`, `ab_test`, `variant`.
- Are there any analytics events that measure TIME? Check `event_registry.dart` — is there `time_to_X` anywhere?
- Are there any analytics events that measure COMPLETION vs DROPOFF? Check for `completed`/`abandoned`/`step_duration` events.
- Is there any usability testing documentation in `docs/`? Check `docs/beta/` — any task-completion-time data? Any SUS score?
- Is there any heuristic evaluation document? Check `docs/audits/` for heuristic evaluation against Nielsen's 10.
- Does the app log error states for analysis? Search for `analyticsService.log` or `trackEvent` in catch blocks.
- Is there ANY user feedback mechanism in-app? Search for "feedback", "report bug", "rate app", "survey".
- Check `docs/beta/FOUNDER_OBSERVATION_SHEET.md` — is it filled with data or empty?

**Deliverable:** `docs/audits/ux-researcher/ASSUMPTION_DRIVEN_DESIGN_FINDINGS.md` — gap analysis of measurement infrastructure vs what's needed to validate behavioral hypotheses.

**Insane if:** Zero A/B framework, zero time-based metrics, zero completion analytics, zero in-app feedback, zero heuristic evaluation — mostly true for Helm today.

---

### 3. UI Designer — Hunt for "Visually Hostile" Anti-Pattern

**What to hunt:**
- What are the ACTUAL contrast ratios in the design tokens? Check `helm_colors.dart` or `app_colors.dart` — compute WCAG AA/AAA compliance for every foreground/background pair used in text.
- Do buttons have visible active/pressed states? Search for `onPressed`, `onTap` — are there `withValues(alpha:)` reductions or `AnimatedScale`?
- Are there skeleton screens or shimmer loading anywhere? Search for `shimmer`, `skeleton`, `loading_placeholder`.
- Does the onboarding have a global skip? Check `onboarding_screen.dart` for "Set up later" or skip-to-end behavior.
- How many font families are loaded? Check pubspec.yaml and theme files — does the app load 3+ custom fonts?
- Are sliders usable with fine-grained control? Check slider step divisions, label display, ±1% stepper buttons.
- Is the Settings screen a single long scroll or section-collapsed? Check `settings_screen.dart`.
- Check for `Semantics` widget usage — zero or sparse?
- Is there a dark mode? Check `ThemeData.dark()` toggle.

**Deliverable:** `docs/audits/ui-designer/VISUALLY_HOSTILE_FINDINGS.md` — contrast ratio violations, missing states inventory, accessibility gap count.

**Insane if:** WCAG AA violations (3 known), zero active states, zero skeletons, no global skip, 3 fonts (known tradeoff), jumpy sliders, no Semantics, one scrolling Settings — largely true.

---

### 4. Whimsy Injector — Hunt for "Personality Void" Anti-Pattern

**What to hunt:**
- Is there ANY delight in empty states? Check every list screen — what happens when a list is empty? Search for `itemCount == 0`, `isEmpty`, `EmptyState`.
- Are error states friendly or robotic? Check `catch` blocks — what does the user see? "Something went wrong" vs "Hmm, we couldn't load your pipeline. Want to try again?"
- Are there loading animations beyond CircularProgressIndicator? Check for any custom loading, animated icons, progress with personality.
- Is there any celebration or acknowledgment? Search for "congratulations", "well done", "nice", "great", "all clear", "up to date", "✓".
- Are there any Easter eggs or hidden interactions? Search for long-press handlers, shake detection, custom gestures.
- Is there copy that makes you feel something — relief, confidence, motivation? Audit dashboard headline copy for emotional resonance.
- Check the splash screen — branded animation or static logo? Is there a branded app icon animation?
- Are there any micro-interactions? Button press feedback, card hover (desktop), swipe-to-complete celebrations.

**Deliverable:** `docs/audits/whimsy-injector/PERSONALITY_VOID_FINDINGS.md` — screen-by-screen personality audit with delight deficit score.

**Insane if:** Empty states are blank or default text, error states are generic, zero celebration/affirmation, zero Easter eggs, no branded animations — largely true for Helm today.

---

### 5. Brand Guardian — Hunt for "Brand Schizophrenia" Anti-Pattern

**What to hunt:**
- Is the microcopy consistent across ALL screens? Pull every user-facing string — do terms like "Safe-to-Spend", "buffer", "fixed costs", "pipeline" appear consistently with the same casing and meaning?
- Are error messages in brand voice or default English? Check all toast/snackbar/dialog text.
- Is the app name "Helm" consistent everywhere? Check window title, app bar titles, splash text, settings "About" text.
- Are there any competing identity signals? Check for generic fintech language ("income/expenses", "budget", "tracker") that contradicts the freelancer-specific identity.
- Is there a Bangla localization? Check `l10n/` folder — is `app_bn.arb` authored or auto-translated?
- Check the app icon and splash screen — consistent brand colors, no generic Flutter defaults.
- Are the design tokens (colors, typography, spacing) used consistently? Audit 10 random screens for AppColors vs HelmColors usage.
- Is there a brand voice document? Check `docs/` for any voice/tone guide. If missing — insane for a fintech brand.

**Deliverable:** `docs/audits/brand-guardian/BRAND_SCHIZOPHRENIA_FINDINGS.md` — copy inconsistency heatmap, missing brand assets inventory, voice gap analysis.

**Insane if:** Inconsistent terminology across screens, error states in default English not brand voice, no Bangla, no brand voice doc, mixed color token usage — partially true.

---

### 6. UX Architect — Hunt for "Architectural Violence" Anti-Pattern

**What to hunt:**
- Is auth actually implemented? Check for any auth provider, auth guard, session management, token storage. The doctrine says Magic Link + PIN — is either implemented?
- Is the backend stack decided? Search `docs/` for any backend decision — Supabase vs Firebase vs Next.js vs nothing.
- Are there god widgets > 300 lines? Run `find lib/ -name "*.dart" | xargs wc -l | sort -rn | head -20`.
- Are there any circular imports between features? Check all imports for cross-feature dependencies.
- Does the domain layer have framework imports? Check `lib/features/*/domain/` for any Flutter/Dart `material.dart`, `flutter/widgets.dart`, `hive.dart`.
- Is there any raw Hive access from UI? Check presentation files for direct `Hive.box()` calls.
- Is error handling consistent? Sample 20 catch blocks — do they all log + show user feedback? Any `catch (e) {}` empty blocks?
- Are there any `setState` calls for business logic? Search presentation files for `setState` outside of animation/local UI state.
- Is there test coverage for the domain layer? Check `test/features/*/domain/` — does S2S calculator have tests? Does PinHasher have tests?
- Check for `withOpacity()` (deprecated) usage — any remain?
- Are there any `mounted` checks before async gaps? Search for `context.` usage after `await` without `mounted` guard.

**Deliverable:** `docs/audits/ux-architect/ARCHITECTURAL_VIOLENCE_FINDINGS.md` — god widget inventory, auth gap analysis, domain purity violations, error handling consistency score.

**Insane if:** No auth system at all (true), no backend decision (true), god widgets exist (likely), domain imports framework (unlikely — Phase 7f cleaned this), error handling inconsistent (possible).

---

## Wave 2 — Two-Way Parallel Dispatch

These agents need persona definitions + Wave 1 findings to produce their deliverables.

### 7. Persona Walkthrough — Simulate "Rafiq" Through Full User Journey

**Persona profile (pre-defined):**

```
PERSONA PROFILE: Rafiq
=======================
Name:           Rafiq
Age & gender:   28M
Nationality:    Bangladeshi, living in Dhaka
Current situation: Freelances on Upwork/Fiverr. Earns $800-1200/month. 3-4 active clients.
                  Just had a client payment delayed by 2 weeks — caused rent anxiety.
                  Downloads Helm from Play Store. Never used a finance app before.

SEARCH CONTEXT
==============
Google query:      "how to track freelance payments Bangladesh app"
Arrival source:    Google Play Store search
Sites seen before: None (first finance app download)
Device:            Samsung Galaxy A14 (entry-level Android, 720x1600, ~$120 phone)

PSYCHOLOGY
==========
Familiarity level:     Low (never used personal finance app)
Urgency:               Days (rent due in 2 weeks, needs to know if he has enough)
Primary fears:         "What if this app makes me feel worse about money?"
                       "What if I have to input 50 things before I see anything useful?"
                       "Is this going to charge me hidden fees?"
Trust triggers:        Local language (Bangla), simple numbers (no jargon), transparent math
Decision style:        Quick decider — if not useful in 60 seconds, uninstalls
Attachment tendency:   Anxious — needs reassurance at every step that his money is safe

GOAL
====
What success looks like: Open app → see one clear number (safe-to-spend) → understand where it came from → feel relief
Contact threshold:       Would trust app if it shows honest math (deductions visible) and doesn't ask for bank password
```

**Walkthrough path:**
1. App Store listing → Install → App icon first impression
2. Cold start → Splash screen → 5-second test: "What is this? Is it for me? What should I do?"
3. Onboarding Step 1 (qualifier) → Step 6 (pipeline entry)
4. First Dashboard view — S2S hero, pipeline summary, trust strip
5. Tap S2S → breakdown sheet
6. Navigate to Pipeline → see entries → try to update status
7. Settings → try to find something → go back to Dashboard
8. Close app → Cold restart → PIN entry → Dashboard
9. Don't open app for 5 days → open again (no notification, has to remember)

**Deliverable:** `docs/audits/persona-walkthrough/RAFIQ_JOURNEY_FINDINGS.md` — fold-by-fold emotional arc, trust deltas, LIFT assessment per fold, Cialdini gaps, Fogg motivation/ability/prompt analysis per decision point, CTA reachability per screen.

**Insane if:** Rafiq can't answer "What is safe-to-spend and why should I trust it?" in 5 seconds on dashboard, or if onboarding takes >3 minutes, or if there's zero reassurance at any anxiety point.

---

### 8. Visual Storyteller — Hunt for "Narrative Void" Anti-Pattern

**What to hunt (after Persona Walkthrough produces Rafiq findings):**
- Is there a coherent visual narrative from App Store listing → first open → first value → daily use?
- Are App Store screenshots ready? Check for any screenshot files or ASO documentation.
- Is there an onboarding visual story? Does each screen build on the last, or is it disconnected slide->slide?
- Is there a demo video or GIF for the Play Store listing?
- Are there visual metaphors that explain S2S? ("Safety net", "buffer zone", "ledger rail") Are they reinforced visually?
- Does the app icon tell the brand story? Is there a process for the icon design?
- Are there any visual data storytelling elements? (The S2S breakdown sheet — is it a table or a visual explanation?)
- Check the dashboard flow: S2S hero → tap → breakdown. Is the breakdown visual (blocks, rails, colors) or text-heavy?

**Deliverable:** `docs/audits/visual-storyteller/NARRATIVE_VOID_FINDINGS.md` — visual narrative arc mapping, app store asset inventory, onboarding storyboard critique, visual metaphor consistency score.

**Insane if:** Zero App Store screenshots (true), zero demo content (likely true), onboarding is disconnected slides not a story, S2S breakdown is text not visual.

---

## Wave 3 — Deferred (App Store / Marketing Phase)

These agents are image-generation specialists. Their domain is App Store screenshots, marketing assets, and brand imagery — not codebase auditing. Dispatch when V1 stable and App Store listing prep begins (Phase 5-6).

### 9. Inclusive Visuals Specialist

**Relevance:** App Store screenshots must represent Bangladeshi freelancers authentically — no Western stock photos, no AI clone faces, no gibberish Bangla text, correct cultural context (Dhaka offices, co-working spaces, home setups).

**When to dispatch:** Phase 5 exit (V1 stable, preparing App Store listing).

---

### 10. Image Prompt Engineer

**Relevance:** App Store screenshot series, feature graphics, promotional banner for Play Store listing. Requires App Store listing strategy from Brand Guardian + Visual Storyteller first.

**When to dispatch:** Phase 5 exit (V1 stable, preparing App Store listing).

---

## Dispatch Execution Order

```
NOW (Wave 1 — 6 parallel agents):
  ├── Behavioral Nudge Engine ──→ DEAD_DASHBOARD_FINDINGS.md
  ├── UX Researcher ───────────→ ASSUMPTION_DRIVEN_DESIGN_FINDINGS.md
  ├── UI Designer ─────────────→ VISUALLY_HOSTILE_FINDINGS.md
  ├── Whimsy Injector ─────────→ PERSONALITY_VOID_FINDINGS.md
  ├── Brand Guardian ──────────→ BRAND_SCHIZOPHRENIA_FINDINGS.md
  └── UX Architect ────────────→ ARCHITECTURAL_VIOLENCE_FINDINGS.md

AFTER Wave 1 completes:
  Wave 2 (2 parallel agents):
  ├── Persona Walkthrough ─────→ RAFIQ_JOURNEY_FINDINGS.md
  └── Visual Storyteller ──────→ NARRATIVE_VOID_FINDINGS.md

PHASE 5 EXIT (future):
  Wave 3 (2 parallel agents):
  ├── Inclusive Visuals Specialist ──→ App Store screenshot prompts
  └── Image Prompt Engineer ────────→ App Store feature graphic prompts
```

---

## Integration with Master Plan

All Wave 1 + Wave 2 findings feed back into:

1. **Priority reordering** — if Nudge Engine finds zero cadence infrastructure (99% likely), Phase 1-3 become CRITICAL/URGENT instead of HIGH.
2. **New task injection** — if Persona Walkthrough finds Rafiq abandons the app at fold 3 (onboarding step 4), a new task is injected into Phase 4.
3. **Score recalibration** — if Whimsy Injector finds score inflates due to "agent hallucination" (claims delight where none exists), behavioral scoring adjusts downward.
4. **Anti-pattern registry update** — Architectural Violence findings update `docs/governance/ANTI_PATTERNS.md`.

**Feedback loop:** `100_PERCENT_MASTER_PLAN.md` §9 (Agent Assignment Matrix) is the source of truth. Each deliverable updates the relevant phase task list with new findings.

---

## Agent Invocation Format

Each agent should be invoked with:

```
You are the [AGENT NAME] — [agent description from your definition].
You are being dispatched against the Helm Flutter/Dart codebase to hunt for INSANE PRACTICES in your domain.

CODEBASE CONTEXT:
- 103 Dart files in lib/ + 4 test files (78 tests)
- Flutter/Dart, Riverpod state management, Hive persistence, GoRouter navigation
- Feature-first clean architecture: features/*/data/ domain/ presentation/
- Current state: Behavioral 62/100, UI/UX 78/100, Trust Layer 23/35
- 16 completed sprints, Phase 0 (A5 Bangla + Release Build) pending
- Full master plan: docs/planning/100_PERCENT_MASTER_PLAN.md
- Architecture rules: docs/core/ARCHITECTURE_RULES.md
- Gap analysis: docs/planning/DOCTRINE_TO_CODE_GAP_ANALYSIS.md
- Anti-patterns: docs/governance/ANTI_PATTERNS.md

YOUR HUNT:
[Agent-specific hunt instructions from this dispatch plan]

DELIVERABLE:
Write your findings to docs/audits/[your-agent-folder]/[FINDINGS_FILE].md
Format: quantified findings with code file references, severity per finding, priority recommendation.
```

---

## Exit Criteria Per Agent

| Agent | Exit when | Estimated findings count |
|-------|-----------|-------------------------|
| Behavioral Nudge Engine | Dead dashboard score > 0/10 + 5+ missing nudge infrastructure items identified | 15-20 findings |
| UX Researcher | Assumption count > 10 + measurement infrastructure gap inventory complete | 10-15 findings |
| UI Designer | All contrast violations listed + active state deficit > 20 widgets + Semantics gap count | 20-30 findings |
| Whimsy Injector | Screen-by-screen personality audit complete (all 10+ screens) + delight deficit score | 15-20 findings |
| Brand Guardian | Copy inconsistency heatmap (20+ screens) + voice gap analysis + Bangla gap | 10-15 findings |
| UX Architect | God widget count + auth gap severity + domain purity violations + error handling score | 15-20 findings |
| Persona Walkthrough | Full Rafiq journey (8 stops) with per-fold LIFT/Cialdini/Fogg assessment | 8 fold assessments |
| Visual Storyteller | Visual narrative arc mapped + App Store asset gap inventory + storyboard critique | 10-15 findings |

---

## Immediate Actions

1. [ ] Dispatch Wave 1: 6 agents in parallel (all independent, touch different audit dimensions)
2. [ ] Dispatch Wave 2: 2 agents after Wave 1 completes (Persona Walkthrough needs Rafiq profile, Visual Storyteller benefits from UI Designer + Brand Guardian findings)
3. [ ] Merge findings into master plan: update priority, inject new tasks, recalibrate scores
4. [ ] Update `docs/governance/ANTI_PATTERNS.md` with new architectural violence patterns found
5. [ ] Defer Wave 3 to Phase 5 exit (App Store listing prep)
