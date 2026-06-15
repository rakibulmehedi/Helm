# Helm Signal Deck — Mobile UI/UX Architecture

**Status:** Approved design
**Date:** 2026-06-16
**Scope:** Major visual and interaction redesign. No business-logic, persistence, state-management, or trust-model changes.

## 1. Product Definition

Helm is a futuristic cashflow decision instrument for Bangladeshi USD-earning freelancers. It must let a user open the app, identify the exact BDT amount safe to spend, understand the next financial event, and act without anxiety.

The redesign must preserve these product contracts:

- Safe-to-Spend is the dominant answer and is visible in under two seconds.
- Usable, committed, protected, and pending money remain visually distinct.
- Every meaningful financial number exposes a source, timestamp, or calculation path.
- Pending money never appears equivalent to usable BDT.
- The interface remains calm, non-judgmental, and free from gamification.

## 2. Design Philosophy

### Selected Direction: Spatial Editorialism

The visual system combines:

- **Spatial Translucence** for layered depth, atmosphere, and a futuristic native-mobile presence.
- **Editorial Minimalism** for typographic authority, whitespace, and low cognitive load.
- **Skeuomorphic tactility** only in pressed states and haptic feedback.

This direction is named **Helm Signal Deck**.

### Rejected Primary Directions

| Direction | Reason |
|---|---|
| Pure glassmorphism | Excess blur, contrast risk, performance cost, and weak financial authority |
| Pure editorial minimalism | Calm and trustworthy, but too static for the intended premium-futuristic identity |
| Neo-brutalism | Distinctive but too loud and playful for a trust-critical financial product |
| Bento grid | Organizes data but creates a generic finance-dashboard hierarchy |
| Neumorphism | Weak contrast and dated banking-app associations |

## 3. Core Composition

### 3.1 Signal Hero

The upper screen is one dominant instrument:

- Safe-to-Spend label
- Safe-to-Spend BDT value
- State and runway text
- Restrained orbital state visualization
- One-line supporting signals for committed, protected, and pending values

The orbital visual communicates system state only. It must never become a chart, gauge, progress ring, or looping decorative animation.

### 3.2 Signal Horizon

The Signal Horizon is Helm's signature visual boundary:

- A thin luminous line below the Signal Hero
- Separates trusted present reality from upcoming workflow
- Uses semantic state color
- May emit one restrained confirmation pulse after a committed financial state change

### 3.3 Decision Deck

The Decision Deck occupies the lower primary content region:

- Surfaces exactly one next financial event
- Explains why the event matters
- Provides one primary action
- May show one compact route from `Expected` to `Transit` to `Usable`

It replaces generic card grids and passive dashboard summaries.

### 3.4 Flow Navigation

Primary destinations are:

- `Signal`: current trusted answer and next event
- `Flow`: income pipeline and money lifecycle
- `Trace`: calculation history, sources, and auditability

Settings and lower-frequency controls must not compete with these primary destinations.

## 4. Color System

### 4.1 Dark Mode

Dark mode is the primary brand expression.

| Token | Value | Usage |
|---|---:|---|
| `signalCanvas` | `#06100E` | Main background |
| `signalSurface` | `#0E1A17` | Navigation and opaque surfaces |
| `signalDeck` | `#14231F` | Decision Deck fallback surface |
| `signalInkPrimary` | `#EFF8F4` | Critical text and financial values |
| `signalInkSecondary` | `#A7BBB4` | Supporting text |
| `signalInkMuted` | `#789087` | Recessive metadata |
| `signalInteractive` | `#8BE5C9` | Primary actions |
| `signalGlow` | `#53C9A7` | Horizon and orbital accents |

Translucent surface tokens:

- `signalGlass`: white at 7%
- `signalBorder`: white at 13%

These translucent tokens are restricted to spatial overlays. Critical text must use resolved solid colors.

### 4.2 Semantic States

| State | Value | Usage |
|---|---:|---|
| Safe | `#83E3C7` | Stable signal and successful confirmation |
| Tight | `#D2A75B` | Reduced runway |
| At Risk | `#D87868` | Imminent financial-harm proximity only |
| Pending | `#789FB2` | Uncertain money |
| Protected | `#A69BC4` | Reserve and buffer |

### 4.3 Color Rules

- Safe-to-Spend values always use neutral primary ink.
- Glow is limited to the Signal Horizon, active navigation marker, and confirmation pulse.
- `BackdropFilter` is limited to the Decision Deck, navigation, and focused overlays.
- State is never communicated by color alone.
- Financial values never sit directly over gradients or blurred imagery.
- Light mode uses a mineral-white canvas, deep-green ink, and opaque deck surfaces.

## 5. Typography

### 5.1 Families

| Role | Family |
|---|---|
| Interface and explanatory text | Inter |
| Financial values and calculation traces | JetBrains Mono |
| Bangla interface | Hind Siliguri |

### 5.2 Scale

| Token | Size | Weight | Usage |
|---|---:|---:|---|
| `signalHero` | 48–56 | 600 | Safe-to-Spend only |
| `moneyLarge` | 28–32 | 600 | Financial detail |
| `eventTitle` | 18–20 | 600 | Next event |
| `bodyPrimary` | 15–16 | 450–500 | Explanations |
| `labelSignal` | 10–11 | 600 | Sparse uppercase system labels |
| `metadata` | 11–12 | 450 | Timestamp and source |

### 5.3 Typography Rules

- Monospace is limited to money, FX, audit timestamps, and calculations.
- Safe-to-Spend uses tabular figures and tight negative tracking.
- No weight exceeds 600.
- Financial values never animate as counters.
- Bangla receives increased line height and separate visual verification.
- Body content supports accessibility scaling. Financial hero scaling is bounded without hiding semantic content.

## 6. Shape and Depth

### 6.1 Shape Tokens

| Element | Radius |
|---|---:|
| Decision Deck | 28dp |
| Bottom navigation | 18dp |
| Primary action | 14dp |
| Compact control | 10dp |
| Orbital signal | Circular |

### 6.2 Depth Model

Depth comes from:

1. Surface luminance difference
2. Hairline borders
3. Blur on restricted spatial overlays
4. Controlled ambient glow
5. Small physical translation during interaction

No generic Material elevation is permitted.

### 6.3 Shadow Rules

- Decision Deck: black, `offsetY: -12`, `blur: 40`, `opacity: 0.18`
- Floating sheet: black, `offsetY: -8`, `blur: 32`, `opacity: 0.22`
- Buttons have no resting shadow.
- Pressed controls translate 1.5dp downward and reduce brightness slightly.
- Neumorphic dual shadows are prohibited.

## 7. Screen Architecture

### 7.1 Signal Screen

- Upper 48%: Signal Hero
- Middle boundary: Signal Horizon
- Lower 38%: Decision Deck
- Bottom 8%: Flow Navigation
- Remaining area: intentional breathing space

Decision Deck constraints:

- One event only
- One primary CTA only
- Maximum two metadata lines
- No horizontal card carousel
- No stat-card grid
- No charts

### 7.2 Flow Screen

- Show money lifecycle as `Expected → Transit → Usable`.
- Group entries by state, then time.
- Keep received history visually recessed.
- Use deliberate swipe thresholds and a clear undo path.
- Never auto-mark money as received.

### 7.3 Trace Screen

- Present calculation as an editorial table.
- Right-align financial values.
- Place pending money below a separate horizon.
- Expose source, timestamp, or calculation path for each meaningful number.
- Use progressive disclosure without hiding trust-critical information.

## 8. Motion Architecture

### 8.1 Principles

- Motion explains hierarchy, state, or causality.
- No bounce, celebration, looping glow, or decorative movement.
- Safe-to-Spend values appear fully formed.
- Reduced-motion mode removes spatial travel and stagger.

### 8.2 Timing Tokens

| Motion | Duration |
|---|---:|
| Tap feedback | 80–110ms |
| Small state change | 160–200ms |
| Deck transition | 240–280ms |
| Full-screen transition | 300–340ms |
| Calculation reveal stagger | 20ms per row |

### 8.3 Spring Profiles

**Control Press**

- Mass: 1.0
- Stiffness: 650
- Damping: 48
- Scale target: 0.975

**Deck Settle**

- Mass: 1.0
- Stiffness: 420
- Damping: 38
- Maximum travel: 12dp

**Pipeline State Advance**

- Mass: 1.0
- Stiffness: 360
- Damping: 34

### 8.4 Animation Selection

Use implicit animation for:

- Pressed state
- Color and border transitions
- Small visibility changes
- Navigation selection

Use explicit controllers for:

- Decision Deck entrance
- Pipeline state advance
- Calculation Trace reveal
- Signal Horizon confirmation pulse

## 9. Haptic Architecture

| Interaction | Haptic |
|---|---|
| Navigation selection | `selectionClick` |
| Button press | `lightImpact` |
| Open Decision Deck or Trace | `selectionClick` |
| Confirm payment received | `mediumImpact` |
| Successful Safe-to-Spend recalculation | One delayed `lightImpact` |
| Destructive confirmation | `heavyImpact` after explicit confirmation |
| Validation failure | One `vibrate` |
| Slider or stepper threshold | `selectionClick` at meaningful increments |

Rules:

- Never trigger haptics from passive animation.
- Never stack multiple impacts simultaneously.
- Financial confirmation haptics occur after state commit, not on tap.
- Reduced-motion preferences do not disable critical confirmation haptics.

## 10. Key Interaction Sequences

### 10.1 Pending to Received

1. User confirms received amount.
2. State commit completes.
3. Medium haptic confirms commit.
4. Flow route advances into `Usable`.
5. Signal Horizon emits one restrained pulse.
6. Updated Safe-to-Spend value replaces the prior value without counting animation.
7. One delayed light haptic confirms recalculation.

### 10.2 Trace Reveal

1. Decision Deck expands vertically.
2. Calculation rows appear top-to-bottom.
3. Final Safe-to-Spend row appears last.
4. Pending amount remains below a separate horizon.

### 10.3 At-Risk State

- Do not tint the full screen red.
- Change the Signal Horizon to the muted risk token.
- Explain the exact threat in the Decision Deck.
- Provide one next required action.
- Do not use alarm animation.

## 11. Accessibility and Performance

- Every interactive control has semantic labels, state, and role.
- State is never color-only.
- Touch targets are at least 44dp.
- Core screens must maintain 60fps on target low-to-mid-range Android hardware.
- Blur layers must be measured on physical target devices.
- Reduced-motion mode removes travel, stagger, and confirmation pulse while preserving final states.
- Safe-to-Spend remains identifiable within 1.5 seconds.
- Next required action remains identifiable within 3 seconds.

## 12. Hard Guardrails

- No generic Material 3 visual defaults
- No card-grid dashboard
- No heavy glass across the full screen
- No gradients behind financial values
- No animated counters
- No celebratory motion
- No financial state hidden behind gesture only
- No glow without semantic purpose
- No more than one primary action per viewport
- No haptic before financial state successfully commits
- No business-logic, trust-model, persistence, routing, or state-management changes during visual redesign
- No new package without Chief Architect approval

## 13. Validation Criteria

The redesign is ready for implementation only when prototypes demonstrate:

- Safe-to-Spend identification within 1.5 seconds
- Next-action identification within 3 seconds
- Clear distinction between usable and pending money without explanation
- WCAG AA contrast
- Reduced-motion behavior
- 60fps target-device performance
- User perception of Helm as calm, futuristic, and trustworthy rather than dashboard-like

## 14. Documentation Sources

- `docs/core/HELM_BRAIN.md`
- `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md`
- `docs/research/ux/Helm_UX_Doctrine.md`
- `docs/research/ux/Helm_Visual_Identity_Critique_and_Refined_System.md`
- `docs/audits/UI_UX_AUDIT_2026-06-12.md`
- `docs/design/A4V_2_VISUAL_RESCUE_PLAN.md`
- `docs/core/ARCHITECTURE_RULES.md`
- `docs/tracking/CURRENT_SPRINT.md`
- `docs/tracking/PROJECT_STATE.md`
