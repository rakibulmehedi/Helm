# Visual Identity Requirements — Extracted from Helm Visual Identity System

> **Source:** `docs/research/ux/Helm_Visual_Identity_System.md`
> **Authority level:** Canonical visual layer. Sits beneath Final Product Doctrine and UX Doctrine. Subject to overrides by the Visual Identity Critique & Refined System (see `08_visual_identity_refinements.md`).
> **Extraction date:** 2026-06-04

---

## 1. Color Palette

### VIS-001: Five-Color Philosophy

**Statement:** Five named colors, no more. Every screen uses only this palette. Anything that needs a sixth color is a feature that should not ship.

**Rationale:** Restraint is the brand. The absence of decoration signals seriousness.

**Implementation implication:** `HelmColors` theme extension must contain exactly these tokens. Any additional color in a PR is a blocking review issue.

---

### VIS-002: Core Palette (Light Mode)

**Statement:** Core palette with warm-tinted neutrals:

| Token | Light mode | Usage | Contrast on canvas |
|---|---|---|---|
| `canvas` | `#FAFAF7` | App background (warm white) | -- |
| `surface` | `#FFFFFF` | Card surfaces, sheets, drawers | 1.04:1 vs canvas (intentional micro-contrast) |
| `ink.primary` | `#141413` | All numbers, all critical text, S2S hero | 14.8:1 -- exceeds WCAG AAA |
| `ink.secondary` | `#141413 @ 60%` | Labels, timestamps, helper text | 4.8:1 -- meets WCAG AA |
| `ink.tertiary` | `#141413 @ 38%` | Recessed labels, disabled state, Hope-tier USD | 3.1:1 -- large-text only |
| `interactive` | `#2C5F5D` (deep teal) | Every tappable affordance | 6.2:1 -- AA on canvas |
| `divider` | `#141413 @ 8%` | Hairline rules, card borders | n/a |

**Rationale:** Warm-tinted neutrals avoid the clinical feel of pure white/black while maintaining high contrast for financial figures.

**Implementation implication:** All values must be defined in `HelmColors` ThemeExtension. No raw `Colors.X` anywhere.

---

### VIS-003: Core Palette (Dark Mode)

**Statement:** Dark mode palette is hand-tuned, not auto-generated:

| Token | Dark mode |
|---|---|
| `canvas` | `#0E0E0C` |
| `surface` | `#161614` |
| `ink.primary` | `#F2F1ED` (15.1:1 contrast) |
| `ink.secondary` | `#F2F1ED @ 60%` |
| `ink.tertiary` | `#F2F1ED @ 38%` |
| `interactive` | `#3E807D` (luminance-shifted, 4.6:1) |
| `divider` | `#F2F1ED @ 10%` |

**Rationale:** Dark mode is an equal citizen. Auto-generation algorithms would shift the warm tints incorrectly.

**Implementation implication:** Both light and dark `ThemeData` must be hand-built. Use `ThemeMode.system` only; no manual toggle in MVP.

---

### VIS-004: State Palette (Semantic, Sacred)

**Statement:** Four semantic state colors used only for mathematically-determined states:

| State | Light | Dark | Where used | Where NOT used |
|---|---|---|---|---|
| `state.safe` | `#6B8F71` (desat sage) | `#82A887` | Accent line under S2S; "Received" pipeline dot | Backgrounds, button fills, large fills |
| `state.tight` | `#B88A4A` (muted amber) | `#D4A668` | Accent line; "due 3-7 days" obligation dot | Anywhere as fill (reads as warning) |
| `state.atRisk` | `#9E4A3A` (muted brick red) | `#C56A58` | Accent line; Reserve Mode indicator; <72h obligations | Anywhere not actually at-risk |
| `state.hope` | `#5A7A8C @ 40%` (cool desat blue) | `#7A95A8 @ 40%` | Tier 3 USD figures, "Expected" dots, FX context | S2S number, Liquid BDT figures |

**Rationale:** State colors are deterministic mappings from math to visual signal, not decoration.

**Implementation implication:** State color tokens must only be applied via the S2S state enum. No manual application of state colors.

---

### VIS-005: Color Hard Rules

**Statement:** Six non-negotiable color rules:

1. **No gradients. Anywhere.** Not on buttons, cards, icons, or splash.
2. **No tinted backgrounds for state.** S2S number is always `ink.primary` in all states. State lives on accent line.
3. **One accent color total.** `interactive` (deep teal) is the only tappable-affordance color. No secondary brand color.
4. **At-Risk red is the rarest pixel.** If visible >3% of sessions, the math thresholds are wrong.
5. **No raw black (`#000`), no raw white (`#FFF`).** Always warm-tinted variants.
6. **Dark mode is automatic from OS preference.** No manual toggle in MVP.

**Rationale:** Each rule prevents a specific failure mode that makes fintech apps feel untrustworthy or noisy.

**Implementation implication:** Custom lint rules must enforce: no `LinearGradient`, no `RadialGradient`, no raw `Colors.black`/`Colors.white`, no `BoxShadow`.

---

### VIS-006: Permanently Killed Color Patterns

**Statement:** These colors are permanently banned: purple, magenta, hot pink (crypto territory), neon/saturated green ("growth" theater), hot orange/safety yellow (generic fintech warnings), more than five colors on screen.

**Rationale:** Each is associated with a product category Helm must never resemble.

**Implementation implication:** If a developer reaches for any of these, the feature design is wrong.

---

## 2. Typography Scale and Rules

### VIS-007: Typeface Stack

**Statement:** Two type families plus a Bangla pair:

| Role | Family | Fallback | Rationale |
|---|---|---|---|
| Financial numerals | **JetBrains Mono Variable** | IBM Plex Mono, SF Mono, Menlo | Monospace = decimal alignment = spreadsheet-trust trigger. Humanist warmth. |
| UI text (Latin) | **Inter Variable** | Geist, SF Pro, Roboto | Humanist sans, culture-neutral, handles 11pt-64pt. |
| Bangla text | **Hind Siliguri** | Noto Sans Bengali, Kalpurush | Matched x-height with Inter. Confident editorial Bangla. |

**Rationale:** Minimal typeface count signals restraint. Monospace numerals are a deliberate trust-building choice.

**Implementation implication:** Bundle all three fonts in `pubspec.yaml` assets (not runtime Google Fonts). Subset Bangla to Bengali + Latin ranges (~60KB vs ~280KB). JetBrains Mono with fontVariations for weights 400, 500, 600 only.

---

### VIS-008: Type Scale

**Statement:** Mobile-first scale on 6.1" reference device:

| Token | Size | Weight | Line height | Usage |
|---|---|---|---|---|
| `display.hero` | 64pt | 600 | 1.05 | S2S number only. Nothing else uses this size. |
| `display.large` | 40pt | 600 | 1.10 | Breakdown drawer totals, onboarding headlines |
| `heading.lg` | 22pt | 600 | 1.25 | Screen titles |
| `heading.md` | 18pt | 600 | 1.30 | Section headers, sheet titles |
| `heading.sm` | 15pt | 600 | 1.35 | Card titles, list group headers |
| `body.lg` | 16pt | 400 | 1.50 | Default reading text, onboarding copy |
| `body.md` | 14pt | 400 | 1.50 | Secondary body, list items |
| `body.sm` | 13pt | 400 | 1.45 | Helper text, captions |
| `label.md` | 12pt | 500 | 1.30 | Form labels, table headers (always non-italic) |
| `label.sm` | 11pt | 500 | 1.25 | Timestamps, tier markers |
| `mono.financial` | 16pt-64pt | 500/600 | Matches role | All BDT and USD figures everywhere |

**Rationale:** The S2S number at 64pt is the largest element in the entire product, establishing visual hierarchy through size alone.

**Implementation implication:** Define as `HelmTypography` ThemeExtension. The `display.hero` token must be used only by the `HelmSafeToSpend` widget.

---

### VIS-009: Typographic Hard Rules

**Statement:** Seven non-negotiable typography rules:

1. **No italics. Anywhere.** Italics signal aside; Helm has no asides.
2. **No ALL-CAPS** except optionally on tab bar labels at 11pt.
3. **No underlines** except on inline links in the Calculation Breakdown drawer.
4. **No letter-spacing trickery.** Default tracking on Inter and JetBrains Mono.
5. **No font weight below 400 (regular).** 300/light reads as fragile on small-screen finance.
6. **No font weight above 600 (semibold) anywhere.** Bold (700+) is a shout.
7. **Bangla and Latin must share baseline** at body and label sizes. Test with mixed-script strings.

**Rationale:** Each rule prevents a specific trust or readability failure on small Android screens.

**Implementation implication:** Custom lint or code review must catch italic TextStyle, ALL-CAPS transforms, fontWeight outside 400-600 range, and letter-spacing overrides.

---

### VIS-010: Permanently Killed Typography Patterns

**Statement:** These typography patterns are permanently banned: display serif fonts, variable-width numerals on financial figures, hand-script fonts, font sizes below 11pt, light/thin weights (100-300), ALL-CAPS body text, italic body text.

**Rationale:** Each pattern undermines trust, readability, or professionalism in a financial context.

**Implementation implication:** Any PR introducing a new TextStyle must be validated against this kill list.

---

## 3. Spacing and Grid System

### VIS-011: 8pt Grid (Non-Negotiable)

**Statement:** Every margin, padding, gap, height, and stroke offset is a multiple of 4pt, biased to 8pt. Enforced in code review.

**Rationale:** Consistent spacing creates visual order that signals reliability.

**Implementation implication:** Define as `HelmSpacing` ThemeExtension. Custom lint rule must reject raw spacing values (e.g., `EdgeInsets.all(15)` fails; only `HelmSpacing` tokens allowed).

---

### VIS-012: Spacing Tokens

**Statement:** Named spacing tokens:

| Token | Value | Use |
|---|---|---|
| `space.0` | 0 | Reset |
| `space.1` | 4pt | Icon-label binding, inside small chips |
| `space.2` | 8pt | Internal padding for chips, small cards |
| `space.3` | 12pt | List row vertical padding |
| `space.4` | 16pt | Card internal padding (default), screen edge margin |
| `space.5` | 20pt | Section vertical rhythm |
| `space.6` | 24pt | Between Tier blocks on home screen |
| `space.8` | 32pt | Above S2S hero ("let it breathe" gap) |
| `space.10` | 40pt | Between major sections |
| `space.12` | 48pt | Top-of-screen safe inset on home screen |

**Rationale:** Named tokens prevent spacing drift across screens and developers.

**Implementation implication:** All `EdgeInsets`, `SizedBox`, and `Gap` must reference `HelmSpacing` tokens.

---

### VIS-013: Layout Primitives

**Statement:** Core layout constraints:

| Container | Width/Height | Notes |
|---|---|---|
| Screen edge gutter | 16pt minimum | Never less on 6.1" device |
| Card max-width | 100% within gutters | Full-bleed within gutters on phone |
| Sheet handle inset | 24pt top, 12pt sides | 4pt x 36pt drag handle in `divider` color |
| Safe area | Respect OS insets fully | S2S hero clears notch by >= `space.6` |
| Bottom nav height | 56pt | Matches iOS HIG and Material guidelines |

**Rationale:** Consistent containers prevent visual chaos on different device sizes.

**Implementation implication:** These values must be constants in the layout system, not per-screen decisions.

---

### VIS-014: The 9-Line Rule

**Statement:** The home screen displays no more than 9 lines of content above the fold on a 6.1" reference device. Counted as: greeting (1) + S2S hero (2) + accent sub-line (1) + threat rows (3) + hope tier (2) = 9. A 10th line is a design defect.

**Rationale:** Density violations fail both accessibility and anxiety-reduction goals.

**Implementation implication:** Layout test in CI must verify 9-line maximum on reference device.

---

### VIS-015: Vertical Rhythm Budget

**Statement:** The home screen above-the-fold uses a defined vertical budget totaling ~616pt:

| Element | Height |
|---|---|
| Safe inset | ~48pt |
| Greeting + timestamp | ~24pt |
| Breath | ~32pt |
| S2S hero block | ~140pt |
| Accent line + tail | ~36pt |
| Breath | ~24pt |
| Threat tier (3 rows) | ~144pt |
| Breath | ~20pt |
| Hope tier (2 lines) | ~52pt |
| Breath | ~40pt |
| Bottom nav | ~56pt |

**Rationale:** If a layout breaks this budget, the layout is wrong, not the device.

**Implementation implication:** Home screen widget must be tested against this vertical budget on 5.4" (minimum) and 6.1" (reference) devices.

---

## 4. Component Styling Rules

### VIS-016: Card Specification

**Statement:** Cards are containers of fact, not visual objects competing for attention:

| Property | Value | Rationale |
|---|---|---|
| Background | `surface` | Subtle micro-contrast with canvas |
| Border | 1pt `divider` | Replaces shadow; depth without theater |
| Border radius | **12pt** | Modern but serious (not 16+ friendly, not 4 brutalist) |
| Internal padding | `space.4` (16pt) default; `space.5` (20pt) for hero cards | Generous; density signals overwhelm |
| Card-to-card gap | `space.3` (12pt) | Never less; never zero |
| Max nesting | 1 card inside 1 card | Card-in-card-in-card is a UI smell |
| Shadow | **None. Period.** | Not even 1% shadow. Borders only. |

**Rationale:** Depth is conveyed by border + spacing, never by faked physics.

**Implementation implication:** `HelmCard` widget must enforce these values. Raw `Card` widget with `elevation > 0` is banned.

---

### VIS-017: Card Types

**Statement:** Four defined card types:

| Type | Use | Rules |
|---|---|---|
| Hero card | S2S block | Border is `transparent`; exists only through spacing |
| Data card | Obligations, pipeline entries, fixed cost rows | Standard border + 16pt padding |
| Sheet | Modal drawers | 16pt top radius only; 0pt bottom radius |
| Inline row | Lists inside a card | No nested card; `divider` lines between rows |

**Rationale:** Limiting card types prevents visual fragmentation.

**Implementation implication:** Every container in the app must use one of these four types.

---

### VIS-018: Button System

**Statement:** Four button levels:

| Level | Visual | Frequency |
|---|---|---|
| Primary | Filled `interactive` bg, `surface` label | At most 1 per screen |
| Secondary | `surface` bg, 1pt `interactive` border, `interactive` label | 0-2 per screen |
| Tertiary (text) | No bg, no border, `interactive` label | Unrestricted but disciplined |
| Destructive | `state.atRisk` border + label, `surface` bg | At most 1 per screen, rare |

**Rationale:** More than four button types means the screen is asking too much.

**Implementation implication:** `HelmButton.{primary, secondary, tertiary, destructive}` factory constructors. Never two primaries on one screen.

---

### VIS-019: Button Specifications

**Statement:** Detailed button specs:

| Property | Primary | Secondary | Tertiary | Destructive |
|---|---|---|---|---|
| Height | 48pt | 48pt | 44pt | 48pt |
| Horizontal padding | 16pt | 16pt | 12pt | 16pt |
| Border radius | 10pt | 10pt | 0pt | 10pt |
| Label weight | 500 | 500 | 500 | 500 |
| Label size | 14pt (body.md) | 14pt | 14pt | 14pt |
| Icon position | Leading, 20pt, 8pt gap | Same | Same | Same |
| Min touch target | 48x48pt | 48x48pt | 44x44pt | 48x48pt |

**Rationale:** Consistent sizing ensures predictable touch targets and visual hierarchy.

**Implementation implication:** All values must be enforced in the `HelmButton` widget. No overrides allowed.

---

### VIS-020: Button States

**Statement:** Button states for visual feedback:

| State | Primary | Secondary | Tertiary |
|---|---|---|---|
| Default | Filled `interactive` | Border `interactive` | Label `interactive` |
| Pressed | Background darkens 8% (light) / lightens 8% (dark) | Background `interactive @ 6%` | Background `interactive @ 6%` |
| Disabled | Background `ink.tertiary @ 20%`, label `ink.tertiary` | Border + label `ink.tertiary` | Label `ink.tertiary` |
| Loading | Label replaced by 16pt monochrome spinner | Same | Same |

**Rationale:** Predictable state feedback builds interaction confidence.

**Implementation implication:** Each button state must be implemented. Loading state requires a spinner widget.

---

### VIS-021: Button Hard Rules

**Statement:** Six non-negotiable button rules:

1. No glowing or pulsing buttons.
2. No full-width primary buttons except on Quick-Confirm sheets and onboarding.
3. Verb-led labels ("Confirm Received" not "OK").
4. No emoji or icon-only buttons in production (except tab bar icons and FAB).
5. FAB: 56pt circle, `interactive` bg, `surface` "+", no shadow, 1pt `divider` ring.
6. Never two primaries on one screen.

**Rationale:** Each rule prevents attention-theft or confusion patterns.

**Implementation implication:** Code review must verify button usage per screen.

---

## 5. Icon Conventions

### VIS-022: Icon Family

**Statement:** Single restrained outline icon family: Phosphor Icons (regular weight) as base, with custom additions only for Bangladesh-specific needs (Payoneer, bKash, Nagad, Upay).

| Property | Value |
|---|---|
| Style | Outline only |
| Stroke weight | 1.5pt at 24pt icon size |
| Stroke joins | Rounded (1.5pt radius) |
| Stroke caps | Rounded |
| Corner radius | 2pt minimum |
| Fill | **Never.** No filled icons anywhere. |

**Rationale:** Outline-only icons maintain the calm, restrained aesthetic. Filled icons add visual weight that competes with financial data.

**Implementation implication:** Use `phosphor_flutter` package. `HelmIcon` wrapper must reject filled variants. Custom icons must match Phosphor geometry.

---

### VIS-023: Icon Sizes

**Statement:** Four icon size tokens:

| Token | Size | Use |
|---|---|---|
| `icon.sm` | 16pt | Inline within text, list-row chevrons |
| `icon.md` | 20pt | Default (buttons, inline affordances) |
| `icon.lg` | 24pt | Tab bar, sheet headers |
| `icon.xl` | 28pt | Onboarding step icons only |

**Rationale:** Consistent sizing prevents visual chaos.

**Implementation implication:** `HelmIcon` widget must enforce these sizes via token enum.

---

### VIS-024: Iconography Hard Rules

**Statement:** Six non-negotiable icon rules:

1. No filled icons, ever. Outline-only across all states.
2. Active tab signaled by color + underline, not fill swap. Active tab icon turns `interactive` with 2pt x 18pt underline 4pt below.
3. No notification dots on home screen. Notification dots train app-blame.
4. No illustrated empty states. No smiling envelopes, piggy banks, or cartoons. Typography only.
5. No mascot, avatar, or profile photo. Home screen is an instrument.
6. Custom icons match Phosphor geometric language (1.5pt outline, Phosphor metrics).

**Rationale:** Each rule prevents a specific pattern that would make Helm feel like a lifestyle app.

**Implementation implication:** Tab bar must use color + underline for active state. Empty states must use text widgets only.

---

## 6. Shadow and Elevation Rules

### VIS-025: No Shadows Anywhere

**Statement:** No shadows on any element. Not cards, not buttons, not sheets, not FAB. Not even 1% shadow. Depth is conveyed by borders and spacing only.

**Rationale:** Shadows are faked physics. In a financial instrument, depth should come from information hierarchy, not visual theater.

**Implementation implication:** Custom lint rule must reject any `BoxShadow` in widget code. `Card` widget must never use `elevation > 0`. FAB uses 1pt `divider` ring instead of shadow.

---

## 7. Border Radius Conventions

### VIS-026: Border Radius Values

**Statement:** Defined radius values by component:

| Component | Border radius |
|---|---|
| Cards | 12pt |
| Primary/Secondary/Destructive buttons | 10pt |
| Tertiary buttons | 0pt (text-only) |
| Sheets (modal) | 16pt top only, 0pt bottom |
| FAB | Full circle (56pt diameter) |
| Accent line under S2S | Implied by line width |

**Rationale:** 12pt for cards is soft enough to feel modern, sharp enough to feel serious. Not 16+ (too friendly) or 4 (too brutalist).

**Implementation implication:** Border radius values must be centralized constants, not per-widget decisions.

---

## 8. Animation and Motion Principles

### VIS-027: Motion Philosophy

**Statement:** Motion is rare and slow. The S2S number does not wiggle. Sacred things do not bounce.

**Rationale:** In a financial tool, motion should communicate state changes, not add entertainment.

**Implementation implication:** Every animation must justify itself against this principle.

---

### VIS-028: Timing Tokens

**Statement:** Six motion timing tokens:

| Token | Value | Curve | Use |
|---|---|---|---|
| `motion.instant` | 0ms | -- | Hard state changes |
| `motion.fast` | 120ms | ease-out | Tap feedback, ripple suppression |
| `motion.base` | 200ms | ease-out (cubic-bezier(0.2, 0, 0, 1)) | Default transitions |
| `motion.medium` | 240ms | ease-out | Breakdown drawer slide-up (showcase animation) |
| `motion.slow` | 320ms | ease-out | Sheet dismissals, full-screen transitions |
| `motion.s2sAppear` | 200ms | linear-fade only | S2S number first appearance (opacity 0-100, never counter-up) |

**Rationale:** Ease-out only. No springs, no bounces.

**Implementation implication:** Define in `HelmMotion` ThemeExtension. Custom lint must reject `Curves.bounceX`, `Curves.elasticX`, and any duration > 320ms without exception tag.

---

### VIS-029: Motion Hard Rules

**Statement:** Eight non-negotiable motion rules:

1. No springs. No bounces. Ease-out only.
2. No parallax.
3. No shimmer skeletons. Static low-opacity placeholders only.
4. No animated counters on financial numbers. S2S appears fully formed at 0-100% opacity over 200ms.
5. No celebratory animations. No confetti, particles, success bounces.
6. Reduce-motion respected aggressively: all transitions collapse to 0ms; drawer becomes 80ms cross-fade; S2S fade becomes instant.
7. Breakdown drawer is the only "performance" animation (240ms, math materializing top-to-bottom).
8. Tab transitions are instant. No slide-in content.

**Rationale:** Each forbidden pattern either trivializes financial events or creates distrust.

**Implementation implication:** Reduce-motion detection via `MediaQuery.disableAnimationsOf(context)`. Breakdown drawer gets special animation treatment.

---

### VIS-030: Forbidden Motion Patterns

**Statement:** Permanently killed:

| Pattern | Reason |
|---|---|
| Hero illustration animation on splash | No illustrations in Helm |
| Pulsing dots on home | Demands unearned attention |
| Slot-machine number rolls | Financial trust violation |
| Parallax cards | Lifestyle-app pattern |
| Bouncy spring physics | Childish for finance |
| Animated gradients | Banned by color rules |
| Lottie animations in MVP/V1 | 100-400KB per file, zero trust value |

**Rationale:** Each is associated with entertainment apps, not financial instruments.

**Implementation implication:** No `lottie` package, no `flutter_animate` confetti/shimmer/shake presets, no `Hero` animations on financial numbers.

---

## 9. Dark Mode Considerations

### VIS-031: Dark Mode Architecture

**Statement:** Dark mode is automatic from OS preference (`ThemeMode.system`). No manual toggle in MVP. Both modes are equal citizens. The dark palette is hand-tuned, not auto-generated.

**Rationale:** Auto-generation algorithms shift warm tints incorrectly. Both modes must be tested equally.

**Implementation implication:** `MaterialApp.themeMode: ThemeMode.system`. Light and dark `ThemeData` built independently with hand-tuned values from VIS-002 and VIS-003.

---

## 10. Accessibility Rules

### VIS-032: WCAG Floor

**Statement:** WCAG 2.2 AA across the entire product, AAA on S2S number and all financial figures. This is the floor, not a stretch goal.

| Surface | Contrast requirement |
|---|---|
| S2S number on canvas | AAA (>= 7:1) |
| All financial figures | AAA (>= 7:1) |
| Body text | AA (>= 4.5:1) |
| Large text (>= 18pt or 14pt bold) | AA (>= 3:1) |
| Interactive controls | AA (>= 3:1) |
| Hope-tier desaturated USD | AA Large-only (>= 3:1) |

**Rationale:** Financial figures are safety-critical information. They need maximum contrast.

**Implementation implication:** Contrast must be verified for every color combination in the palette.

---

### VIS-033: Touch Targets

**Statement:** Minimum touch target sizes:

| Element | Minimum | Recommended |
|---|---|---|
| Primary buttons | 44x44pt | 48x48pt |
| Tab bar items | 44x44pt | 56pt height row |
| List row tap | 44pt vertical | 48pt+ |
| Inline icon buttons | 44x44pt (with invisible padding) | -- |
| FAB | 56x56pt | -- |

**Rationale:** Bangladesh Android-first context requires generous touch targets.

**Implementation implication:** All interactive elements must be wrapped in containers meeting these minimums.

---

### VIS-034: Screen Reader Requirements

**Statement:** Five screen reader requirements:

1. S2S number reads as a complete sentence: "Safe to spend: 32,400 taka 00 paisa. State: Tight. Covers 17 days at your usual pace. Updated 2 minutes ago."
2. Breakdown drawer navigable in semantic order.
3. Bangla TTS pronunciation validated on real assistive tech (TalkBack Bengali, VoiceOver Bengali).
4. No "icon button" without an accessible label. FAB's label is "Add pipeline entry", not "Plus".
5. State changes announce themselves via live-region: "State changed to Tight. Safe to spend is now tk14,400."

**Rationale:** Screen reader users must get the same mental model as sighted users.

**Implementation implication:** Semantic annotations (`Semantics` widget) must be applied to all financial displays and interactive elements.

---

### VIS-035: Bangla as First-Class Locale

**Statement:** Three Bangla accessibility rules:

1. Bangla is a separate locale, not a translation toggle. Copy authored in Bangla, not machine-translated.
2. Numerals stay Latin even in Bangla mode (deliberate documented exception; Bangla narrative + Latin numerals is the established Bangladeshi fintech pattern).
3. Lakh/crore grouping applies in both English and Bangla locales.

**Rationale:** Bangla is a first-class citizen, not an afterthought.

**Implementation implication:** Locale switching must load independently authored Bangla strings. Number formatters must use Latin digits and lakh/crore grouping regardless of locale.

---

### VIS-036: Color Never the Only Signal

**Statement:** State is conveyed by color + position + label, never by color alone. Accent line has text sub-line that disambiguates for color-blind users. Pipeline markers carry both color AND shape (circle outline, half-filled, filled-with-check).

**Rationale:** Color-blindness rates and low-quality Android screens in Bangladesh require redundant signals.

**Implementation implication:** Every state indicator must have at least two non-color signals (position, shape, text).

---

## 11. Data Visualization Language

### VIS-037: No Charts in MVP/V1/V2

**Statement:** Default chart count is zero. Forbidden chart types through V2: pie, donut, stacked bar, area with gradient fills, sparklines on home, dual-axis USD+BDT, animated counters/bars.

**Rationale:** Charts imply features the product does not have. Categorization is V3+.

**Implementation implication:** No `fl_chart`, `syncfusion_charts`, or any chart package until V3. Numeric tables are preferred.

---

### VIS-038: Future Chart Rules (V3 onward)

**Statement:** When charts eventually ship (V3+, History/Reports only), they follow strict rules:

1. One chart per screen maximum.
2. Tables beat charts under 12 data points.
3. No legends (redesign chart if it needs one).
4. No hover/tap-and-hold tooltips (label directly).
5. No curve interpolation (straight segments only).
6. Y-axis includes zero.
7. Time axis labels in Bangla locale format when Bangla mode is on.

Permitted types: calendar heatmap, single-series line chart, single-series bar chart, numeric tables.

**Rationale:** Each rule prevents dishonesty or complexity that undermines trust.

**Implementation implication:** Chart components (when built) must enforce these constraints.

---

## 12. Permanently Killed Visual Patterns

### VIS-039: Visual Kill List

**Statement:** The following patterns require a Visual Identity amendment (not just a ticket) to add:

- Gradients (linear, radial, mesh)
- Drop shadows on cards
- Glassmorphism / frosted backgrounds
- Neumorphism
- Branded splash screen with animated logo
- Hero illustrations (home, empty states, onboarding)
- Mascots, characters, anthropomorphic brand
- Confetti, particle effects, celebration animations
- Slot-machine counters on S2S
- Glowing/pulsing buttons
- Skeuomorphic finance UI
- Pie/donut charts in MVP/V1/V2
- Dual-axis USD+BDT charts
- Animated growing bars
- Single-number "financial health score"
- Comparison visuals ("you vs other freelancers")
- Tinted backgrounds for state
- Avatars, profile photos, user identity headers
- Notification dot indicators on home
- Time-locked / premium-only visual locks
- Emoji in system-generated copy
- Holiday/festival theming
- Custom illustrations for tax/invoice flows
- Hand-drawn empty-state graphics

**Rationale:** Each pattern moves the product toward lifestyle fintech, expense tracker, or crypto dashboard -- all of which Helm must never resemble.

**Implementation implication:** This list must be referenced in every design review and PR that touches visual elements.

---

## 13. Flutter Implementation Requirements

### VIS-040: Theme Architecture

**Statement:** Do not use Material 3's default `ColorScheme.fromSeed`. Override the entire scheme with hand-built tokens. Use Material 3 widgets but feed custom `ThemeData`.

**Rationale:** Material 3's seed-based scheme generates incorrect palettes and applies them to surfaces and ripples.

**Implementation implication:** `ThemeData` must use `ThemeExtension<T>` for `HelmColors`, `HelmSpacing`, `HelmTypography`, `HelmMotion`.

---

### VIS-041: Critical Custom Widgets

**Statement:** Doctrine-enforcing widgets that replace raw Material widgets:

| Widget | Replaces | Purpose |
|---|---|---|
| `HelmSafeToSpend` | Raw `Text` | Font, size, weight, lakh/crore, "--" fallback, fade-in, accessibility |
| `HelmAmount` | Raw `Text` | Monospace, symbol weight, decimals, lakh/crore for BDT |
| `HelmCard` | `Card` | Border-not-shadow, 12pt radius, 16pt padding, no elevation |
| `HelmButton` | `ElevatedButton` etc. | 4-tier hierarchy, label rules, no shadows, 48pt height |
| `HelmAccentLine` | -- | Safe/Tight/AtRisk line under S2S |
| `HelmSheet` | `showModalBottomSheet` | Drag handle, 16pt top radius, 240ms slide-up |
| `HelmIcon` | `Icon` | Phosphor wrapping, size tokens, rejects filled variants |
| `HelmPipelineDot` | -- | Circle/half-circle/check marker primitive |

**Rationale:** Raw Material widgets allow doctrine violations. Custom widgets enforce rules mechanically.

**Implementation implication:** Lint rules should discourage use of raw equivalents in production code.

---

### VIS-042: Performance Budgets

**Statement:** CI-enforced performance requirements:

| Metric | Budget |
|---|---|
| Cold-start to first frame | P95 < 800ms |
| Time-to-S2S-visible | P95 < 2,000ms |
| S2S calculation (pure function) | P95 < 50ms |
| Breakdown drawer animation | 240ms +/- 20ms |
| Home screen rebuild on state change | < 16ms (60fps) |

**Rationale:** Speed is a trust signal. Slow financial apps feel unreliable.

**Implementation implication:** Flutter Timeline benchmarks in CI on Pixel 4a profile build.

---

### VIS-043: Haptic Feedback

**Statement:** One light-impact haptic on "Confirm Received" action. Nowhere else.

**Rationale:** Haptics acknowledge the most significant user action (money state change). Overuse trivializes the signal.

**Implementation implication:** `HapticFeedback.lightImpact()` in the confirm-received handler only.

---

### VIS-044: Pipeline State Markers

**Statement:** Pipeline uses dot markers with both color AND shape:

| State | Marker | Size | Color |
|---|---|---|---|
| Expected | Outline circle | 10pt | `ink.tertiary` |
| Pending | Half-filled circle | 10pt | `state.hope` solid |
| Received | Filled circle with check | 10pt | `state.safe` solid |

**Rationale:** Shape redundancy ensures color-blind accessibility.

**Implementation implication:** `HelmPipelineDot` widget must render shape variants, not just colored circles.

---

### VIS-045: Reserve Mode Visual Treatment

**Statement:** When Reserve Mode triggers, it adds a 2pt `state.atRisk` border around the home screen viewport. Nothing else. No banner takeover, no modal. Tone is clinical, not alarmist.

**Rationale:** Reserve Mode is a math state, not an emergency. The border is a subtle but unmistakable visual shift.

**Implementation implication:** Home screen wrapper must accept a `reserveMode` boolean that adds or removes the border.
