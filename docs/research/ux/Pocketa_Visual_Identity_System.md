# Pocketa Visual Identity System

> **Status:** Canonical visual layer. Sits beneath the Final Product Doctrine and the UX Doctrine; never contradicts either.
> **Posture:** Senior fintech design direction. Restraint over expression. Trust over taste.
> **Reading order:** §1 sets the north star. §2–§9 are operational. §10–§11 are enforcement. §12 is the Flutter handoff.
> **Last Updated:** June 2026

---

## 1. Visual North Star

### The single sentence

> **Pocketa looks like a calm clinical instrument that a Bangladeshi freelancer trusts at 11pm on Day 29 — quiet, exact, ad-free, adult, locally fluent, and visually severed from every other fintech app on their phone.**

If a visual decision moves the product toward that sentence, it ships. If it moves it toward "lifestyle fintech app," "crypto dashboard," "neobank super-app," or "personal-finance influencer template" — it dies.

### The five visual principles

| Principle | What it means in pixels |
|---|---|
| **Calm is the default state, not a mood.** | Warm-white canvas, near-black ink, one accent color, generous whitespace. The screen is settled before anything happens. |
| **Typography carries authority. Color does not.** | The S2S number is heavy because it's large, not because it's colored. Color is reserved for state — Safe / Tight / At Risk / Hope. |
| **Restraint signals seriousness.** | Five colors. Two typefaces (plus Bangla pair). No gradients. No shadows on cards. No illustrations. No mascots. No emoji. The absence of decoration is the brand. |
| **Cultural fluency is non-negotiable.** | ৳ before $ in dual-currency rows. Lakh/crore grouping (1,32,400 not 132,400). Bangla and English share baseline x-height. Bangla is a first-class citizen, never a translation. |
| **Pessimism is built into the visuals.** | Hope tier is desaturated and 40% opacity. Liquid BDT gets full weight. The product never visually flatters pending money. |

### The "next to" test

Place a Pocketa screen next to bKash, Payoneer, TallyKhata, Hishabee, YNAB, and Wise on the same home screen. Pocketa should be the screen that looks **least like a fintech app and most like a chronometer**. Every other app is loud, branded, and feature-promotional. Pocketa is intentionally the quietest icon in the dock.

---

## 2. Color System

### Philosophy

Five named colors. No more. Every screen in the product uses only this palette. Anything that needs a sixth color is a feature that shouldn't ship.

### Core palette

| Token | Light mode | Dark mode | Usage | Contrast on canvas |
|---|---|---|---|---|
| `canvas` | `#FAFAF7` | `#0E0E0C` | App background — warm white / warm black. Pure white feels clinical; pure black feels morbid. | — |
| `surface` | `#FFFFFF` | `#161614` | Card surfaces, sheets, drawers — one notch lighter/darker than canvas | 1.04:1 vs canvas (intentional micro-contrast) |
| `ink.primary` | `#141413` | `#F2F1ED` | All numbers, all critical text — including the S2S hero | 14.8:1 (light) / 15.1:1 (dark) — exceeds WCAG AAA |
| `ink.secondary` | `#141413 @ 60%` | `#F2F1ED @ 60%` | Labels, timestamps, helper text, secondary metadata | 4.8:1 — meets WCAG AA for body text |
| `ink.tertiary` | `#141413 @ 38%` | `#F2F1ED @ 38%` | Recessed labels, disabled state, Hope-tier USD figures | 3.1:1 — large-text only, never body |
| `interactive` | `#2C5F5D` (deep teal) | `#3E807D` (luminance-shifted) | Every tappable affordance: links, button labels, active tab accent | 6.2:1 (light) / 4.6:1 (dark) — AA on canvas |
| `divider` | `#141413 @ 8%` | `#F2F1ED @ 10%` | Hairline rules, card borders — depth without shadow | n/a |

### State palette (semantic, sacred)

| State | Light | Dark | Where it appears | Where it does NOT appear |
|---|---|---|---|---|
| `state.safe` | `#6B8F71` (desat sage) | `#82A887` | Tier 1 accent line under S2S; pipeline state "Received" dot | Backgrounds, button fills, large fills of any kind |
| `state.tight` | `#B88A4A` (muted amber) | `#D4A668` | Tier 1 accent line; "due in 3–7 days" obligation dot | Anywhere as a fill — amber as fill reads as warning banner |
| `state.atRisk` | `#9E4A3A` (muted brick red) | `#C56A58` | Tier 1 accent line; "Reserve Mode" indicator; <72h obligations | Anywhere that isn't actually at-risk — this is the most expensive color in the system |
| `state.hope` | `#5A7A8C @ 40%` (cool desat blue) | `#7A95A8 @ 40%` | Tier 3 USD pipeline figures, "Expected" pipeline state dots, FX rate context | The S2S number itself, Liquid BDT figures |

### Color rules (hard)

1. **No gradients. Anywhere.** Not on buttons, not on cards, not in icons, not in splash. Gradient = lifestyle app = banned.
2. **No tinted backgrounds for state.** The S2S number is rendered in `ink.primary` in all three states — never red text on at-risk. State lives on the accent line below, not on the number.
3. **One accent color total.** `interactive` (deep teal) is the only color allowed for tappable affordances. There is no "secondary brand color." The brand is monochrome + state.
4. **At-Risk red is the rarest pixel.** If it appears more than ~3% of the time across the user's sessions, the underlying math is wrong, not the design.
5. **No raw black (`#000`), no raw white (`#FFF`).** Always the warm-tinted variants. This is a tiny detail; do not break it.
6. **Dark mode is automatic from OS preference.** No manual toggle in MVP. Both modes are equal-citizen; neither is "default."

### Color tokens you should never invent

If you find yourself reaching for purple, pink, indigo, neon green, hot orange, or any "growth chart green," you are designing a different product. Close the file.

---

## 3. Typography System

### Typeface stack

| Role | Family | Fallback | Why this typeface |
|---|---|---|---|
| **Numerals (financial)** | **JetBrains Mono Variable** | IBM Plex Mono → SF Mono → Menlo | Monospace = vertical decimal alignment = spreadsheet-trust trigger. JetBrains Mono has a humanist warmth that IBM Plex lacks; less "code editor," more "instrument readout." |
| **UI text (Latin)** | **Inter Variable** | Geist → SF Pro → Roboto | Humanist sans, modest, culture-neutral. Inter's optical sizing handles the 11pt to 64pt range without rebreaking. |
| **Bangla text** | **Hind Siliguri** | Noto Sans Bengali → Kalpurush | Matched x-height with Inter at body sizes. Hind Siliguri reads as confident editorial Bangla, not as a system-fallback font. |

Two type families plus the Bangla pair. That's the whole typographic system.

### Type scale (mobile-first, 6.1" reference device)

| Token | Size | Weight | Line height | Usage |
|---|---|---|---|---|
| `display.hero` | 64pt | 600 (semibold) | 1.05 | The S2S number. The largest typographic element in the entire product. Nothing else uses this size. |
| `display.large` | 40pt | 600 | 1.10 | Breakdown drawer totals; onboarding question headlines |
| `heading.lg` | 22pt | 600 | 1.25 | Screen titles (Pipeline, History, Settings) |
| `heading.md` | 18pt | 600 | 1.30 | Section headers, sheet titles |
| `heading.sm` | 15pt | 600 | 1.35 | Card titles, list group headers |
| `body.lg` | 16pt | 400 | 1.50 | Default reading text, onboarding copy |
| `body.md` | 14pt | 400 | 1.50 | Secondary body, list items |
| `body.sm` | 13pt | 400 | 1.45 | Helper text, captions |
| `label.md` | 12pt | 500 (medium) | 1.30 | Form labels, table headers — always non-italic |
| `label.sm` | 11pt | 500 | 1.25 | Timestamps ("Updated 2 min ago"), tier markers ("Pending") |
| `mono.financial` | 16pt — 64pt | 500 / 600 | Matches role | All BDT and USD figures everywhere |

### Numeric formatting (the cultural-fluency contract)

| Rule | Example | Anti-example |
|---|---|---|
| BDT uses **lakh/crore grouping**, not Western thousand grouping | `৳ 1,32,400.00` | `৳ 132,400.00` |
| USD uses **Western grouping** | `$ 1,800.00` | `$ 1,80,000.00` |
| **Always show two decimal places** on financial figures — precision is a trust signal | `৳ 32,400.00` | `৳ 32,400` |
| Currency symbol is rendered at **half the weight** of the number | `৳` at 400 next to `32,400` at 600 | Bold ৳ competing with the number |
| Negative values use **parentheses**, not minus signs (accounting convention) | `(৳ 4,200.00)` | `−৳ 4,200.00` |
| In dual-currency contexts, **BDT precedes USD** vertically | `৳ 1,79,500.00` above `$ 1,500.00 @ 119.66` | USD above BDT |
| Zero is **never used as a placeholder for "unknown"** | `—` | `৳ 0.00` |

### Typographic rules (hard)

1. **No italics. Anywhere.** Italics signal aside; Pocketa has no asides.
2. **No ALL-CAPS** except optionally on tab bar labels at 11pt. ALL-CAPS reads as shouty in a calm product.
3. **No underlines** except on inline links inside the Calculation Breakdown drawer.
4. **No letter-spacing trickery.** Default tracking on Inter; default tracking on JetBrains Mono. Tightening type to "look premium" is the move of a junior designer.
5. **No font weight below 400 (regular)** in any production text. 300/light reads as fragile on small-screen finance.
6. **No font weight above 600 (semibold)** anywhere — including the S2S hero. Bold (700+) is a shout; Pocketa speaks at semibold maximum.
7. **Bangla and Latin must share baseline** at body and label sizes. Test with a mixed-script string before signing off a screen.

---

## 4. Spacing & Layout

### The 8pt grid (non-negotiable)

Every margin, padding, gap, height, and stroke offset is a multiple of 4pt, biased to 8pt. This is enforced in code review.

### Spacing tokens

| Token | Value | Use |
|---|---|---|
| `space.0` | 0 | Reset |
| `space.1` | 4pt | Icon ↔ label tight binding; inside small chips |
| `space.2` | 8pt | Default internal padding for chips, small cards |
| `space.3` | 12pt | List row vertical padding |
| `space.4` | 16pt | Card internal padding (default), screen edge margin |
| `space.5` | 20pt | Section vertical rhythm |
| `space.6` | 24pt | Between Tier blocks on the home screen |
| `space.8` | 32pt | Above the S2S hero (the "let it breathe" gap) |
| `space.10` | 40pt | Between major sections on long screens |
| `space.12` | 48pt | Top-of-screen safe inset on the home screen |

### Layout primitives

| Container | Width | Notes |
|---|---|---|
| Screen edge gutter | 16pt (mobile) | Never less. 16pt is the minimum visual breath on a 6.1" device. |
| Card max-width | 100% within gutters | No center-constrained cards on phone; full-bleed within gutters |
| Sheet handle inset | 24pt top, 12pt sides | Modal sheets always carry a 4pt × 36pt drag handle in `divider` color |
| Safe area | Respect OS insets fully | The S2S hero block must clear the notch by ≥ `space.6` |
| Bottom nav height | 56pt | iOS HIG / Material both land here; Pocketa matches |

### Vertical rhythm (the home screen budget)

The home screen above the fold uses this distribution:

```
| Safe inset           | space.12  |   ~48pt
| Greeting + timestamp | label.sm  |   ~24pt
| (Breath)             | space.8   |   ~32pt
| S2S HERO BLOCK       | hero+sub  |   ~140pt
| Accent line + tail   | 1pt + sub |   ~36pt
| (Breath)             | space.6   |   ~24pt
| Threat tier          | 3 rows    |   ~144pt
| (Breath)             | space.5   |   ~20pt
| Hope tier            | 2 lines   |   ~52pt
| (Breath)             | space.10  |   ~40pt
| Bottom nav           | 56pt      |   ~56pt
─────────────────────────────────────────────
Total                                ~616pt
```

This fits on every phone wider than a 5.4" iPhone Mini. If a layout breaks this budget, the layout is wrong, not the device.

### The 9-line rule

The home screen displays **no more than 9 lines of content** above the fold on a reference 6.1" device. Counted as: greeting (1) + S2S hero (2) + accent sub-line (1) + threat rows (3) + hope tier (2) = 9. A 10th line is a design defect.

---

## 5. Card Language

### Philosophy

Cards in Pocketa are **containers of fact**, not visual objects competing for attention. Depth is conveyed by border + spacing, never by faked physics.

### Card specification

| Property | Value | Why |
|---|---|---|
| Background | `surface` (1 notch from canvas) | Subtle micro-contrast; readable in both modes without a border |
| Border | 1pt `divider` (8–10% ink opacity) | Replaces shadow; depth without theater |
| Border radius | **12pt** | Soft enough to feel modern; sharp enough to feel serious. Not 16+ (too friendly), not 4 (too brutalist). |
| Internal padding | `space.4` (16pt) default; `space.5` (20pt) for hero cards | Generous; density signals overwhelm |
| Card-to-card gap | `space.3` (12pt) | Never less; never zero (no "joined" cards) |
| Maximum nesting depth | 1 card inside 1 card | A card inside a card inside a card is a UI smell |
| Shadow | **None.** | Period. Not even a 1% shadow. Borders only. |

### Card types

| Type | Use | Specific rules |
|---|---|---|
| **Hero card** | The S2S block — but only barely; this card has no visible border, just whitespace | Border is `transparent`; the card "exists" only through spacing |
| **Data card** | Threat-tier obligations, pipeline entries, fixed cost rows | Standard border + 16pt padding |
| **Sheet** | Modal drawers (Calculation Breakdown, Quick-Confirm) | 16pt top radius only; 0pt bottom radius (anchored to screen edge) |
| **Inline row** | Lists inside a card (e.g. breakdown math) | No nested card; divider lines between rows in `divider` color |

### 5.4 Data Visualization Language

> **Read this section twice before adding any chart.** Pocketa's default chart count is zero. Every chart is a request to violate the cockpit's calm — and every request must justify itself against this section.

#### What is forbidden (V0 through V2)

| Chart type | Why killed |
|---|---|
| Pie charts of any kind | Categorization is V3+; pies imply features the product doesn't have |
| Donut charts (same as pies) | Same reason; also reads as "lifestyle app" |
| Stacked bar charts | Cognitive load > information value at mobile scale |
| Area charts with gradient fills | Decorative; banned by the no-gradient rule |
| Sparklines on the home screen | Compete with the S2S number; Tier 1 violation |
| Dual-axis charts | Mental accounting violation if axes are USD + BDT |
| Animated counters or growing bars | Slot-machine pattern; banned (UX §4) |

#### What is permitted (V3 onward, in History/Reports only)

| Chart type | Specification |
|---|---|
| **Calendar heatmap** of pipeline activity | Cells are `interactive` (deep teal) at opacity steps 0% / 20% / 40% / 60% / 80%. No second color. |
| **Single-series line chart** (e.g. liquid BDT over 90 days) | 1.5pt stroke in `interactive`; no fill; no gridlines except one baseline; no point markers; no animation on load |
| **Single-series bar chart** (e.g. monthly received income) | Bars in `interactive` at 80% opacity; no gridlines; no axis labels beyond start/end; data labels above each bar in `mono.financial` |
| **Numeric tables** (preferred over charts whenever the data has ≤ 12 points) | `mono.financial` for values, right-aligned. This is the most "Pocketa" form of data visualization. |

#### Chart rules (when one finally ships)

1. **One chart per screen, maximum.** A reports screen with three charts is wrong; show one chart and a table.
2. **Tables beat charts under 12 data points.** A spreadsheet-style table in monospace is more trustworthy than a small chart, every time.
3. **No legends.** If a chart needs a legend, the chart is too complex; redesign the chart.
4. **No tooltips that appear on hover/tap-and-hold.** Values are labeled directly on the data; if there are too many to label, there are too many.
5. **No "fancy" curve interpolation.** Lines are straight segments between data points. Smoothed curves lie about what happened between samples.
6. **Y-axis includes zero unless explicitly noted.** Truncated axes in financial UI are dishonest.
7. **Time axis labels in Bangla locale format** when Bangla mode is on (১ অক্টোবর, not 1 Oct).

---

## 6. Iconography

### Family

A single restrained outline icon family. Recommendation: **Phosphor Icons (regular weight)** as base, with custom additions only where Phosphor doesn't cover Bangladesh-specific needs (Payoneer, bKash, Nagad, Upay).

| Property | Value |
|---|---|
| Style | Outline only |
| Stroke weight | 1.5pt at 24pt icon size |
| Stroke joins | Rounded (1.5pt radius) |
| Stroke caps | Rounded |
| Corner radius (within icons) | 2pt minimum |
| Fill | **Never.** No filled icons anywhere. |

### Icon sizes

| Token | Size | Use |
|---|---|---|
| `icon.sm` | 16pt | Inline within text, list-row chevrons |
| `icon.md` | 20pt | Default — buttons, inline affordances |
| `icon.lg` | 24pt | Tab bar, sheet headers |
| `icon.xl` | 28pt | Onboarding step icons only |

### Iconography rules

1. **No filled icons, ever.** Outline-only across all states (default, hover, active, disabled).
2. **Active tab is signaled by color + underline, not by fill swap.** The active tab icon turns `interactive` (deep teal) and gains a 2pt × 18pt underline 4pt below the icon. The icon itself stays outlined.
3. **No icon carries a notification dot on the home screen.** Notification dots train app-blame; the home screen never carries them.
4. **No illustrated empty states.** No smiling envelope, no friendly piggy bank, no "no transactions yet" cartoon. Empty states are typography only.
5. **No mascot. No avatar. No profile photo.** The user is not greeted with a face. The home screen is an instrument, not a hello.
6. **Custom icons match Phosphor's geometric language.** If a custom Payoneer-style logo mark is needed, it gets redrawn as a 1.5pt outline at the Phosphor metrics — never embedded as the brand's full-color logo.

---

## 7. Button System

### Hierarchy

Four button levels. Anything beyond four is a sign the screen is asking too much.

| Level | Visual | When to use | Frequency on a typical screen |
|---|---|---|---|
| **Primary** | Filled `interactive` background, `surface` label | The single most important action on the screen (e.g. "Confirm Received") | At most 1 per screen, often 0 |
| **Secondary** | `surface` background, 1pt `interactive` border, `interactive` label | Important but not primary (e.g. "Not yet", "Edit FX rate") | 0–2 per screen |
| **Tertiary (text)** | No background, no border, `interactive` label | Low-stakes navigation, "View all", inline actions | Unrestricted but disciplined |
| **Destructive** | `state.atRisk` 1pt border + `state.atRisk` label, `surface` background | Account deletion, "Delete entry" — rare and earned | At most 1 per screen, almost never on Tier 1 surfaces |

### Button specs

| Property | Primary | Secondary | Tertiary | Destructive |
|---|---|---|---|---|
| Height | 48pt | 48pt | 44pt | 48pt |
| Horizontal padding | `space.4` (16pt) | `space.4` | `space.3` | `space.4` |
| Border radius | 10pt | 10pt | 0pt (text) | 10pt |
| Label weight | 500 | 500 | 500 | 500 |
| Label size | `body.md` (14pt) | `body.md` | `body.md` | `body.md` |
| Icon position | Leading, `icon.md`, 8pt gap to label | Same | Same | Same |
| Min touch target | 48pt × 48pt | 48pt × 48pt | 44pt × 44pt | 48pt × 48pt |

### Button states

| State | Primary | Secondary | Tertiary |
|---|---|---|---|
| Default | Filled `interactive` | Border `interactive`, label `interactive` | Label `interactive` |
| Pressed | Background darkens by 8% (light) / lightens 8% (dark) | Background `interactive @ 6%` | Background `interactive @ 6%` |
| Disabled | Background `ink.tertiary @ 20%`, label `ink.tertiary` | Border `ink.tertiary`, label `ink.tertiary` | Label `ink.tertiary` |
| Loading | Label replaced by a 16pt monochrome spinner in matching color | Same | Same |

### Button rules (hard)

1. **No glowing buttons. No pulsing CTAs.** Demands attention the math hasn't earned (UX §12).
2. **No full-width primary buttons except on Quick-Confirm sheets and onboarding.** Full-width buttons signal "do this now"; the home screen never demands a single action.
3. **Verb-led labels.** "Confirm Received" not "OK". "Add Pipeline Entry" not "+". (UX §7 Archetype 2.)
4. **No emoji or icon-only buttons** in production. Icons accompany labels; they don't replace them. The only exceptions are tab bar icons (which have labels below) and the floating "+" FAB on the home screen (which is universally understood).
5. **Floating Action Button** is the only Pocketa exception to "labels required." Style: 56pt circle, `interactive` background, `surface`-colored "+" at `icon.lg`. No shadow; 1pt `divider` ring instead.
6. **Never two primaries on one screen.** If you think you need two, one of them is actually secondary.

---

## 8. State Colors

### The four-state semantic model

State colors are **not decoration**. They are a deterministic mapping from the math to a single visual signal.

| State | Trigger (mathematical) | Visual signal | Where it lives |
|---|---|---|---|
| **Safe** | Liquid BDT ≥ obligations + buffer + tax reserve | `state.safe` accent line, 1.5pt × 64pt, below S2S hero | Tier 1 accent line; "Received" pipeline dot |
| **Tight** | Liquid BDT < buffer floor but ≥ obligations | `state.tight` accent line | Tier 1 accent line; "due 3–7 days" obligation dot |
| **At Risk** | Liquid BDT < obligation due within 7 days | `state.atRisk` accent line + Reserve Mode chrome | Tier 1 accent line; <72h obligation dot; Reserve Mode banner |
| **Hope (not a state — a tier)** | Pending USD pipeline, not yet liquid | `state.hope` at 40% opacity | Tier 3 only — never on liquid figures |

### Pipeline state markers

The pipeline uses dot markers, not full color fills:

| Pipeline state | Marker | Size | Color |
|---|---|---|---|
| **Expected** | Outline circle ○ | 10pt | `ink.tertiary` |
| **Pending** | Half-filled circle ◐ | 10pt | `state.hope` solid |
| **Received** | Filled circle with check ● | 10pt | `state.safe` solid |

### State color rules (hard)

1. **State color never tints the S2S number.** The number is always `ink.primary`. Always. The state lives on the accent line below.
2. **State color never fills a background.** No green card, no amber banner, no red alert box. State is always a line or a dot.
3. **At Risk red is the most expensive pixel in the entire product.** Use it only when math demands. If users see it more than ~3% of the time, the threshold is wrong.
4. **Hope tier desaturation is mandatory.** Pending USD figures live at `state.hope @ 40% opacity`. They must visually recede.
5. **Reserve Mode** (when triggered) adds a 2pt `state.atRisk` border around the home screen viewport — nothing else. No banner takeover. No modal. Tone is clinical, not alarmist (UX §11).

---

## 9. Motion Rules

### Philosophy

Motion is rare and slow. The S2S number does not wiggle. Sacred things do not bounce.

### Timing tokens

| Token | Value | Curve | Use |
|---|---|---|---|
| `motion.instant` | 0ms | — | Hard state changes (toggle on/off) |
| `motion.fast` | 120ms | ease-out | Tap-down/up feedback, ripple suppression |
| `motion.base` | 200ms | ease-out (cubic-bezier(0.2, 0, 0, 1)) | Default transitions, hover/press states |
| `motion.medium` | 240ms | ease-out | The Calculation Breakdown drawer slide-up — THE showcase animation |
| `motion.slow` | 320ms | ease-out | Sheet dismissals, full-screen transitions |
| `motion.s2sAppear` | 200ms | linear-fade only | The S2S number's first appearance (fade in from 0 → 100 opacity; **never** counter-up) |

### Motion rules (hard)

1. **No springs. No bounces.** Material spring physics are banned. Ease-out only.
2. **No parallax.** Not on scroll. Not on home. Pocketa is not a magazine.
3. **No shimmer skeletons.** Skeleton states are static low-opacity placeholders that hold the position of incoming content. Animated shimmer reads as "AI loading" — wrong product category.
4. **No animated counters on financial numbers.** The S2S number appears fully formed at 0→100% opacity over 200ms. No rolling digits.
5. **No celebratory animations.** No confetti, no particle effects, no success bounces. The number changing IS the success.
6. **Reduce-motion is respected aggressively.** When the OS reports reduce-motion: all transitions collapse to 0ms; drawer slides become instant cross-fades at 80ms; the S2S fade collapses to instant.
7. **The breakdown drawer is the only "performance" animation in the product.** It slides up over 240ms with the math materializing from top to bottom. This is the moment of transparency made visible.
8. **Tab transitions are instant.** No slide-in tab content. The product is fast, not theatrical.

### Forbidden motion patterns

| Pattern | Why killed |
|---|---|
| Hero illustration animation on splash | No illustrations exist in Pocketa |
| Pulsing dots on the home screen | Demands attention the math hasn't earned |
| Slot-machine number rolls | Financial trust violation |
| Parallax cards | Lifestyle-app pattern |
| Bouncy spring physics | Childish in a finance context |
| Animated gradients (banned by §2 anyway) | — |
| Lottie animations of any kind in MVP/V1 | Adds 100–400KB per file with zero trust value |

---

## 10. Accessibility Rules

### WCAG floor

Pocketa targets **WCAG 2.2 AA across the entire product, AAA on the S2S number and any financial figure**. This is not a stretch goal; it is the floor.

| Surface | Contrast requirement |
|---|---|
| S2S number on canvas | AAA (≥ 7:1) — verified per the palette above |
| All financial figures (numerals) | AAA (≥ 7:1) |
| Body text | AA (≥ 4.5:1) |
| Large text (≥ 18pt or 14pt bold) | AA (≥ 3:1) |
| Interactive controls | AA (≥ 3:1 against adjacent colors) |
| Hope-tier desaturated USD | AA Large-only (≥ 3:1) — these are display, not body, by definition |

### Touch targets

| Element | Minimum size | Recommended |
|---|---|---|
| Primary buttons | 44pt × 44pt | 48pt × 48pt |
| Tab bar items | 44pt × 44pt | 56pt height row |
| List row tap | 44pt vertical | 48pt+ |
| Inline icon buttons (e.g. edit pencil) | 44pt × 44pt — with invisible padding extending the icon's apparent size | — |
| FAB | 56pt × 56pt | — |

### Screen reader

1. **The S2S number reads as a complete sentence**, not as a number. Example: `"Safe to spend: 32,400 taka 00 paisa. State: Tight. Covers 17 days at your usual pace. Updated 2 minutes ago."` Not just `"32,400"`.
2. **The breakdown drawer is navigable in semantic order** — every line is a fully announced calculation step.
3. **Bangla TTS pronunciation is validated on real assistive tech** (TalkBack with Bengali voice; VoiceOver with Hindi/Bengali pack). Currency, lakh/crore separators, and ৳ symbol must read correctly.
4. **No "icon button" without an accessible label.** The FAB's accessible label is "Add pipeline entry", not "Plus".
5. **State changes announce themselves.** Moving from Safe → Tight fires a polite live-region announcement: `"State changed to Tight. Safe to spend is now ৳14,400."`

### Reduce-motion

| Setting | Behavior |
|---|---|
| OS reports reduce-motion: ON | All transitions ≤ 80ms cross-fade; no slides; no drawer animation (drawer instant-appears); no fade-in on S2S |
| OS reports reduce-motion: OFF (default) | Motion tokens from §9 apply normally |

### Bangla language as first-class

1. **Bangla is a separate locale, not a translation toggle.** All copy is authored in Bangla, not machine-translated. Bangladesh-resident copywriter required.
2. **Numerals stay Latin even in Bangla mode** (`১, ২, ৩` would visually conflict with the JetBrains Mono numerics). This is a deliberate, documented exception. Bangla narrative copy + Latin numerals = the established Bangladeshi fintech pattern.
3. **Lakh/crore grouping applies in both English and Bangla locales** — `৳ 1,32,400.00` in both modes.

### Density discipline as accessibility

The 9-line home screen rule (UX §8) is also an accessibility rule: high-density screens fail users with cognitive load, low-vision, and stress states. Density violations fail accessibility review.

### Color is never the only signal

State is conveyed by **color + position + label**, never by color alone. The accent line under S2S has a sub-line of text ("covers 17 days at your usual pace") that disambiguates the state for color-blind users. Pipeline state markers carry both color AND shape (○ ◐ ●).

---

## 11. What To Avoid

> This list is the visual equivalent of the Final Doctrine's Permanent Kill List. Adding any item below to a Pocketa screen requires a Visual Identity amendment, not a Jira ticket.

### Permanently killed visual patterns

| Pattern | Why killed |
|---|---|
| Gradients (linear, radial, mesh, any) | Decorative; signals lifestyle app |
| Drop shadows on cards | Faked physics; depth without trust |
| Glassmorphism / frosted backgrounds | iOS-trend chasing; ages immediately |
| Neumorphism | Untrustworthy on financial figures; low contrast |
| Branded splash screen with animated logo | Splash should be invisible; the home screen IS the brand |
| Hero illustrations on home, empty states, or onboarding | The brand is the math, not an envelope cartoon |
| Mascots, characters, anthropomorphic brand | Pocketa is an instrument, not a friend |
| Confetti, particle effects, celebration animations | Trivializes financial events |
| Slot-machine counter animations on the S2S number | Sacred metric never wiggles |
| Glowing buttons, pulsing CTAs, attention-seeking animation | Demands attention the math hasn't earned |
| Skeuomorphic finance UI (leather wallets, paper receipts) | Dated; cultural mismatch |
| Pie charts, donut charts, or any categorical breakdown chart in MVP/V1/V2 | Categorization is V3+; presence implies features the product doesn't have |
| Dual-axis charts mixing USD + BDT | Mental accounting violation |
| Animated growing bars / line charts on load | Slot-machine pattern |
| Single-number "financial health score" | Competes with S2S |
| Comparison visuals ("you vs other freelancers") | Surveillance dystopia framing |
| Tinted backgrounds for state (green Safe card, red At Risk banner) | State lives on lines and dots, never on fills |
| Avatars, profile photos, user identity headers | The home screen is an instrument readout |
| Notification dot indicators on the home screen | Trains app-blame |
| Time-locked or "premium-only" visual locks (padlock icons over features) | Hostile pattern |
| Emoji in system-generated copy | Earned only by explicit user choice |
| Holiday or festival theming (Eid, Pohela Boishakh visual takeovers) | Pocketa is not the user's friend |
| Custom illustrations for tax forms, invoices, ERQ flows | Stock-illustration fintech tropes |
| Hand-drawn empty-state graphics | Brand-voice mismatch |

### Permanently killed color patterns

| Pattern | Why killed |
|---|---|
| Purple, magenta, hot pink | Crypto-app territory |
| Neon / saturated green | "Growth" theater; misleading on a non-investment product |
| Hot orange / safety yellow | Generic-fintech / warning-banner; not Pocketa's emotional range |
| More than five colors on screen | Restraint is the brand |
| Brand color outside `interactive` (deep teal) | One accent. Period. |
| Tinting the S2S number red on At Risk | Sacred number stays in `ink.primary` |

### Permanently killed typography patterns

| Pattern | Why killed |
|---|---|
| Display serif fonts (Playfair, DM Serif, Fraunces) | Editorial trend; wrong for finance instrumentation |
| Variable-width numerals on financial figures | Decimal columns must align — monospace only |
| Hand-script fonts anywhere | — |
| Font sizes below 11pt for any readable text | Accessibility floor |
| Light or thin weights (100–300) | Fragile on small-screen finance |
| ALL-CAPS body text | Shouty |
| Italic body text | Pocketa has no asides |

---

## 12. Flutter Design System Implications

> **You are a Flutter developer building this. This section is the bridge from doctrine to `theme.dart`.** The goal is a token-driven theme that makes Doctrine drift impossible at the widget level.

### Architecture decision

**Do not use Material 3's default ColorScheme verbatim.** Material 3's seed-based scheme will generate a purple/blue-leaning palette by default and apply it to elevations, surfaces, and ripples. Override the entire scheme with a hand-built token system. Use Material 3 widgets (they're well-tested), but feed them a custom `ThemeData` that reflects this Visual Identity System exactly.

### Recommended package stack (locked before Sprint 1)

| Need | Package | Why |
|---|---|---|
| Theming primitives | Built-in `ThemeData` + custom `ThemeExtension<T>` for design tokens | Native; no extra dep; type-safe |
| Fonts | `google_fonts` for Inter + JetBrains Mono + Hind Siliguri, OR bundled fonts (preferred for offline) | Bundling avoids first-paint FOUT |
| Icons | `phosphor_flutter` | Matches the icon specification exactly |
| Number formatting | `intl` with custom Bangladeshi lakh/crore formatter (write this yourself; `intl` doesn't grok `1,32,400`) | Cultural correctness is non-negotiable |
| Animation curves | Built-in `Curves.easeOutCubic` + custom `Cubic(0.2, 0, 0, 1)` | No external animation library in MVP |
| Reduce-motion detection | `MediaQuery.disableAnimationsOf(context)` | Native Flutter primitive |
| Haptics | `flutter/services.dart` `HapticFeedback` | One light-impact haptic on Confirm Received — nowhere else |

### Design token structure (Dart-friendly)

Define tokens as `ThemeExtension<PocketaTokens>` so they survive theme swaps and are reachable from `Theme.of(context).extension<PocketaTokens>()`.

```dart
@immutable
class PocketaColors extends ThemeExtension<PocketaColors> {
  final Color canvas;
  final Color surface;
  final Color inkPrimary;
  final Color inkSecondary;
  final Color inkTertiary;
  final Color interactive;
  final Color divider;
  final Color stateSafe;
  final Color stateTight;
  final Color stateAtRisk;
  final Color stateHope;
  // ... copyWith, lerp
}

@immutable
class PocketaSpacing extends ThemeExtension<PocketaSpacing> {
  final double s0 = 0;
  final double s1 = 4;
  final double s2 = 8;
  final double s3 = 12;
  final double s4 = 16;
  final double s5 = 20;
  final double s6 = 24;
  final double s8 = 32;
  final double s10 = 40;
  final double s12 = 48;
  // ...
}

@immutable
class PocketaMotion extends ThemeExtension<PocketaMotion> {
  final Duration fast = const Duration(milliseconds: 120);
  final Duration base = const Duration(milliseconds: 200);
  final Duration medium = const Duration(milliseconds: 240);
  final Duration slow = const Duration(milliseconds: 320);
  final Curve curve = const Cubic(0.2, 0, 0, 1);
  // ...
}
```

### Critical custom widgets to build (the doctrine-enforcing layer)

These widgets are the **mechanical enforcement** of the Doctrine. Build them once, then disallow raw Material widgets for these surfaces via lint rule.

| Widget | Replaces | Why custom |
|---|---|---|
| `PocketaSafeToSpend` | Raw `Text` | Enforces font, size, weight, lakh/crore formatting, "—" fallback, fade-in motion, accessibility semantics. The S2S number is too important for a `Text` widget. |
| `PocketaAmount` | Raw `Text` for financial figures | Enforces monospace, currency symbol weight, two-decimal places, lakh/crore for BDT, Western for USD |
| `PocketaCard` | `Card` | Enforces border-instead-of-shadow, 12pt radius, 16pt padding, no `elevation` parameter |
| `PocketaButton.{primary,secondary,tertiary,destructive}` | `ElevatedButton`, etc. | Enforces 4-tier hierarchy, label rules, no shadows, 48pt height |
| `PocketaAccentLine` | — | The thin Safe/Tight/AtRisk line under S2S. Reusable across screens. |
| `PocketaSheet` | `showModalBottomSheet` | Enforces drag handle, 16pt top radius, 240ms slide-up |
| `PocketaIcon` | `Icon` | Wraps `phosphor_flutter` with size tokens; rejects filled variants |
| `PocketaPipelineDot` | — | The ○ ◐ ● marker primitive |

### Lint rules to ship in MVP

Custom lint rules (via `custom_lint` package) that fail CI:

1. **No raw `BoxShadow`** anywhere in widget code. Shadows are forbidden.
2. **No `LinearGradient` / `RadialGradient`** in widget code.
3. **No raw `Colors.X`** — all colors must come from `PocketaColors`.
4. **No raw spacing values** — `EdgeInsets.all(15)` fails; only `PocketaSpacing` tokens are allowed.
5. **No `AnimatedContainer` durations > 320ms** outside an explicitly tagged exception.
6. **No `Curves.bounceX`, `Curves.elasticX`, `Curves.fastLinearToSlowEaseIn`** — only the `PocketaMotion.curve` is allowed.
7. **The home screen widget tree must render ≤ 9 child rows above the fold on a 6.1" reference device** (layout test, not a lint rule, but enforced in CI).

### Performance budgets (CI-enforced)

These are non-negotiable per UX Doctrine §14 Implication 7:

| Metric | Budget | Enforcement |
|---|---|---|
| Cold-start to first frame | P95 < 800ms | Flutter `Timeline` benchmarks in CI on a Pixel 4a profile |
| Time-to-S2S-visible | P95 < 2,000ms | Same |
| S2S calculation time (pure function) | P95 < 50ms | Unit benchmark |
| Breakdown drawer slide animation | 240ms ± 20ms | Widget test |
| Home screen rebuild on state change | < 16ms (60fps frame budget) | Profile mode test |

### Light/dark mode handoff

Use `ThemeMode.system` only. No manual toggle in MVP. The dark mode palette is not "the light palette inverted" — it is hand-tuned per §2's dark column. Do not autogenerate dark colors from a brightness algorithm; the warm tints (`#FAFAF7` / `#0E0E0C`) will shift incorrectly under any automatic algorithm.

### Font loading strategy

1. **Bundle Inter, JetBrains Mono, and Hind Siliguri in `pubspec.yaml` `assets`** rather than fetching via `google_fonts` at runtime. Removes first-paint FOUT and one network dep.
2. **Subset Bangla fonts to Bengali + Latin glyph ranges** before bundling. Hind Siliguri full file is ~280KB; subset is ~60KB.
3. **Declare `JetBrainsMonoVariable` with `fontVariations`** for weight 400 + 500 + 600 only — three weights total. Do not bundle 100/200/300 or 700/800/900.

### What NOT to use (Flutter-specific kill list)

| Don't use | Why |
|---|---|
| `Material 3` default `ColorScheme.fromSeed` purple | Generates a wrong palette and applies it to ripples and surfaces |
| `Card` widget with `elevation > 0` | Shadows are forbidden |
| `Hero` animations on financial numbers | Slot-machine pattern |
| `AnimatedSwitcher` with `transitionBuilder` springs | Springs are forbidden |
| `flutter_animate` package's "confetti", "shimmer", "shake" presets | Each is a doctrine violation |
| `lottie` package in MVP/V1 | Adds size + violates "no illustrations" |
| `chart_X` packages (fl_chart, syncfusion_charts, etc.) until V3 | No charts ship in MVP/V1/V2 |
| `flutter_svg` for icons | Phosphor's Flutter package is enough; SVG adds parse cost |
| Material's `SnackBar` default | Doctrine-noncompliant copy patterns; build `PocketaToast` instead |

### Theme handoff checklist (Sprint 1, Day 1)

1. ✅ `PocketaColors`, `PocketaSpacing`, `PocketaTypography`, `PocketaMotion` extensions defined and registered on `ThemeData.extensions`.
2. ✅ Light + dark `ThemeData` built; verified `MaterialApp.themeMode: ThemeMode.system` switches correctly.
3. ✅ Fonts bundled, subset, declared in `pubspec.yaml` with explicit weight ranges.
4. ✅ Phosphor icons added; custom `PocketaIcon` wrapper built; raw `Icon(Icons.X)` lint rule added.
5. ✅ `PocketaSafeToSpend`, `PocketaAmount`, `PocketaCard`, `PocketaButton`, `PocketaAccentLine`, `PocketaPipelineDot` widgets stubbed with tests.
6. ✅ Custom lint rules (no shadows, no gradients, no raw colors, no raw spacing) failing CI for violations.
7. ✅ Bangla locale + Latin-numeral exception confirmed; lakh/crore formatter unit-tested against 30+ cases including edge cases (negative, < 1000, exactly 1 lakh, 99,99,999 → 1 crore boundary).
8. ✅ Accessibility audit on a single test screen: VoiceOver + TalkBack pass with Bengali + English packs.

---

## Closing Note

This Visual Identity System is the operational layer between the UX Doctrine's principles and the Flutter widget tree. It is **not a moodboard**. It is a contract: every token, every rule, every kill-list item is enforceable in code review or by lint rule.

The temptation, the moment you start `lib/theme/`, will be to add a sixth color, a softer shadow, a friendlier icon set, a more "modern" gradient on the FAB. Every one of those instincts is the failure mode of every fintech app that came before Pocketa. The visual brand is in the restraint. The restraint *is* the trust signal.

If you finish reading this and want to amend it — close the file, open Day 1 of the 30-day plan, and build the boring thing.

> **The system is the product, not the founder. The visual identity is the product's face. Now go ship it.**

---

*End of Pocketa Visual Identity System. Frozen pending an explicit Visual Identity review session.*
