# UX Constraints Extracted from Helm UX Doctrine

> **Source:** `docs/research/ux/Helm_UX_Doctrine.md`
> **Authority Level:** HIGHEST UX authority. Canonical. Governs every screen, transition, word, and silence in Helm.
> **Foundation:** Built on the Final Product Doctrine (June 2026) and the UX Research Sprint behavioral evidence.
> **Extraction Date:** 2026-06-04
> **Purpose:** Machine-readable UX constraint inventory for all implementation agents, design work, and code review.

---

## A. UX Philosophy and North Star

### UX-001 | The Single UX Sentence
- **Statement:** Helm is a calm financial cockpit that returns one trusted BDT number -- "what is actually safe to spend right now" -- in under two seconds, with the full math one tap away.
- **Rationale:** This sentence resolves every UX question. If a design decision moves toward it, ship. If away, kill.
- **Implementation Implication:** Every screen must be testable against this sentence. If a screen does not serve the one-number-in-two-seconds goal, it does not belong.

### UX-002 | Replace Mental Math with Deterministic Math
- **Statement:** Helm's job is to replace mental math under stress with deterministic math you can trust at a glance. Not budgeting. Not accounting. Not financial advice.
- **Rationale:** The ICP spends 8.5 hours/month on cognitive overhead of payment management. Helm competes for those 102 hours/year.
- **Implementation Implication:** Every computation must be verifiable by the user with a calculator in 30 seconds. No opaque algorithms.

---

## B. Emotional Design Requirements

### UX-003 | Reduce Cortisol, Never Raise It
- **Statement:** The app's job is to leave the user calmer than it found them. Every screen passes this test or it does not ship.
- **Rationale:** 50-55% of gig workers report psychological distress from payment uncertainty. Helm is an emotional regulation event.
- **Implementation Implication:** No urgent-feeling UI elements unless mathematically justified. No anxiety-inducing patterns (counters, timers, red states used casually). Every screen must pass the "does my heart rate feel lower?" test.

### UX-004 | Respect Mental Accounting -- Never Flatten It
- **Statement:** Capital exists in four psychological states: Theoretical (invoiced), Trapped (in foreign wallets), Transit (mid-route), Liquid (in BDT). Aggregating into one "Net Worth" number is a UX crime.
- **Rationale:** The research is explicit: freelancers mentally segregate money by reachability. Violating this model feels dishonest.
- **Implementation Implication:** Liquid BDT and pending USD are visually severed. They never appear in the same number. They never share typography weight. Trapped wealth is acknowledged but visually demoted.

### UX-005 | Pessimistic by Default; Surplus Is the Dopamine
- **Statement:** Always model the worst plausible case. Use lower-bound FX volatility. Assume worst-case fees. Surplus is the only acceptable surprise.
- **Rationale:** If Helm shows 30,000 and actual yields 30,800, the user feels relief. If Helm shows 30,800 and actual yields 30,000, the user feels betrayed.
- **Implementation Implication:** Conservative FX rate is the default in all calculations. Optimistic rate is available one tap away but never used for S2S.

### UX-006 | Closed Cognitive Loops (Zeigarnik Antidote)
- **Statement:** Every screen must answer a question the user is already carrying. Never introduce a new open question. Never end an interaction without a resolved state.
- **Rationale:** The freelancer's brain holds open every uninvoiced, unpaid, unconfirmed loop (allostatic load). Helm closes loops, not surfaces them.
- **Implementation Implication:** No screens that end with "come back later." Every flow resolves to a concrete state. Empty states provide clear next actions, not open-ended prompts.

### UX-007 | Calm Is Louder Than Alarm
- **Statement:** The default emotional tone is settled. Alarm exists but is rare and earned. A user who never sees a red state has used the product correctly.
- **Rationale:** Most fintech apps default to alarm. Helm inverts this -- calm is the baseline.
- **Implementation Implication:** Only one red color in the entire app, reserved for the At Risk state. No red in error messages, no red on buttons, no red in navigation.

### UX-008 | Respect the User's Adulthood
- **Statement:** The freelancer is running a complex cross-border micro-business. They do not need encouragement, mascots, streaks, or motivational copy. Helm is a chronometer, not a coach.
- **Rationale:** Patronizing UX is a trust-killer for a financially sophisticated user under stress.
- **Implementation Implication:** No coaching copy, no motivational messages, no "great job!" feedback, no tutorials that assume incompetence.

### UX-009 | Faith- and Culture-Aligned Restraint
- **Statement:** No interest-bearing nudges. No gambling-adjacent language ("you might win," "lucky day," "jackpot rate"). No premium FOMO ("upgrade now and unlock"). Tone is clinical, kind, exact.
- **Rationale:** Respects the cultural and religious sensibilities of the Bangladeshi freelancer population.
- **Implementation Implication:** Microcopy review must check for gambling vocabulary, interest-bearing framing, and FOMO language. All copy must pass a cultural sensitivity filter.

---

## C. Information Hierarchy Rules

### UX-010 | Three-Tier Cognitive Stack
- **Statement:** Every Helm screen is built on a three-tier model: Tier 1 (The Answer: S2S in BDT, ~40% of canvas), Tier 2 (The Threat: next 3 obligations with countdown, ~25%), Tier 3 (The Hope: pending pipeline summary, ~20%). Remaining ~15% is whitespace and navigation.
- **Rationale:** When a panicked freelancer opens Helm at a checkout counter, they have ~1.5 seconds of cognitive bandwidth. Whatever wins the visual hierarchy IS the product.
- **Implementation Implication:** Layout measurements must enforce these proportions. The S2S number is always the dominant visual element. Whitespace is mandatory, not optional.

### UX-011 | What Never Appears on Tier 1
- **Statement:** The following never appear on the top tier: "Total Net Worth," aggregated USD+BDT figures, charts/graphs/sparklines, health scores/ratings, AI-generated insights, promotional banners, upgrade nudges, anyone else's data.
- **Rationale:** Anything competing with S2S for visual dominance dilutes the product's single purpose.
- **Implementation Implication:** Code review must verify that the Tier 1 zone contains only S2S number, state color accent, and last-update timestamp.

### UX-012 | S2S Typographic Contract
- **Statement:** S2S is the largest typographic element in the entire app (~64pt). Rendered in a monospaced numeric font. Currency symbol at half-weight. State color conveyed by a thin accent line below the number, not by coloring the number. Number is always black on light / white on dark.
- **Rationale:** Monospace IS the spreadsheet trust trigger. The user reads the value first, then the state. The number must never be visually manipulated.
- **Implementation Implication:** Font choice: JetBrains Mono Variable or IBM Plex Mono for numbers. Inter or Geist for UI text. Noto Sans Bengali or Hind Siliguri for Bangla. The number itself is never tinted by state color.

### UX-013 | Progressive Disclosure as Architecture
- **Statement:** The home screen contains more details under the surface, revealed by tap or pull gestures. Navigation costs cognition; gesture-revealed depth does not.
- **Rationale:** Every navigation event is a cognitive tax. Gestures on existing surfaces are nearly free.
- **Implementation Implication:** Tap S2S -> Breakdown drawer. Tap obligation -> Edit/mark paid. Tap pipeline entry -> Edit. Pull down -> Refresh. Long-press S2S -> Reset. No separate "details" pages for home-screen content.

---

## D. Dashboard Doctrine

### UX-014 | Cockpit, Not Dashboard
- **Statement:** The home screen is a cockpit (informs the next decision in a high-stakes environment), not a dashboard (reports).
- **Rationale:** A dashboard reports. A cockpit enables action under pressure. The distinction determines every layout choice.
- **Implementation Implication:** Every element on the home screen must answer "what do I do next?" not just "what happened?"

### UX-015 | S2S Loads Visible in < 2 Seconds
- **Statement:** S2S must be visible in under 2 seconds even on a 3G connection in Khulna. Skeleton states show the number's position, never a spinner. The number populates last with a 200ms fade-in.
- **Rationale:** The 200ms fade trains the eye to wait for the truth, not the chrome.
- **Implementation Implication:** Performance budget enforced in CI. P95 time-to-S2S-visible < 2,000ms. Cold start to first frame < 800ms. S2S calculation < 50ms.

### UX-016 | S2S Number Is Never Animated as a Counter
- **Statement:** No "rolling up from 0" animation. The number simply appears, fully formed.
- **Rationale:** Counter animation is a slot-machine pattern that breaks the calm contract.
- **Implementation Implication:** The S2S widget renders the final value directly. No AnimatedCount, no Tween on the number value.

### UX-017 | Three State Colors Only
- **Statement:** Safe (desaturated sage green #6B8F71), Tight (muted amber #B88A4A), At Risk (muted brick red #9E4A3A). Conveyed by a single accent line, not by tinting the number.
- **Rationale:** Three states are cognitively manageable. More creates ambiguity. Accent line separates the value reading from the state assessment.
- **Implementation Implication:** State color is applied only to the accent line widget below S2S. No state color on backgrounds, cards, or the number itself.

### UX-018 | "Updated X Min Ago" Always Visible
- **Statement:** The freshness timestamp is always visible on the home screen.
- **Rationale:** A number without a timestamp is a number without authority.
- **Implementation Implication:** Timestamp widget is a required child of the S2S hero block. Never hidden, never truncated.

### UX-019 | Maximum 4 Bottom Navigation Items
- **Statement:** Home, Pipeline, History, Settings. No more.
- **Rationale:** More items dilute the home screen's gravity.
- **Implementation Implication:** Bottom nav is a fixed 4-item bar. No 5th tab, no "more" overflow menu.

### UX-020 | Single Persistent Floating Action Button
- **Statement:** "Add Pipeline Entry" is the only proactive affordance on the home screen. Everything else is reactive.
- **Rationale:** One clear action prevents decision paralysis.
- **Implementation Implication:** One FAB on home screen. No secondary FABs, no expandable FAB menus.

### UX-021 | Dashboard Explicit Forbids
- **Statement:** Forbidden on the home screen: welcome banners after onboarding, "what's new" announcements, cross-promotion to other features, inline tooltips appearing without invitation, notification inbox dot indicators, any metric labeled as a "score."
- **Rationale:** Each of these competes with S2S for attention or introduces noise.
- **Implementation Implication:** Code review checks for these patterns. Any home-screen PR introducing any of these is rejected.

---

## E. Onboarding Constraints

### UX-022 | 3-Minute Conversational Onboarding
- **Statement:** Median completion <= 3 minutes. P95 <= 5 minutes. No single step takes more than 30 seconds of user thought. 5 steps, each a single screen with a single question. No multi-field forms. No optional fields. No skip buttons that lead to broken states.
- **Rationale:** 70%+ of users abandon finance apps during setup because effort/reward ratio inverts.
- **Implementation Implication:** Each onboarding step is a single-question screen. Timer instrumentation measures per-step duration. Steps exceeding 30 seconds median are flagged for redesign.

### UX-023 | The 5-Step Sequence
- **Statement:** (1) Qualifying question (yes/no pain test), (2) Liquid balance entry (single BDT number), (3) Fixed costs capture (guided checklist), (4) Income pattern declaration (3 picture cards), (5) Buffer comfort (slider 5%/15%/25%/30% with live BDT preview).
- **Rationale:** Every question directly contributes to the S2S number the user sees at the end. No data-extraction theater.
- **Implementation Implication:** Exactly 5 screens. The order is fixed. The first thing the user sees after step 5 is a computed S2S number on the home screen.

### UX-024 | No Celebration at Onboarding End
- **Statement:** No "Done!" celebration. No confetti. The reward IS the S2S number appearing on the home screen.
- **Rationale:** Celebration trivializes the financial context. The number is its own value proposition.
- **Implementation Implication:** After step 5 + PIN setup, transition directly to home screen with S2S visible. No interstitial success screen.

### UX-025 | Onboarding Microcopy Rules
- **Statement:** Address user as "you" (never by name during onboarding). Every step explains in one sentence WHY the data is needed. Never use "Let's get started," "Almost there!", "Just one more step."
- **Rationale:** Name personalization in onboarding feels manipulative. Progress-tracking phrases are patronizing.
- **Implementation Implication:** Microcopy review on onboarding screens is mandatory. Banned phrases must be in a lint check or review checklist.

### UX-026 | PIN/Biometric Gate After Step 5
- **Statement:** PIN/biometric setup fires immediately after step 5, before the first home screen render. Framed as "Helm shows your income. Only you should see it."
- **Rationale:** The friction IS the trust signal. This is where Helm first earns trust through friction.
- **Implementation Implication:** Auth setup screen is mandatory. No "set up later" option. 6-digit PIN minimum. Biometric if device supports it.

### UX-027 | Onboarding State Recovery
- **Statement:** If user abandons mid-onboarding, next app open resumes at exact step. No forced restart. No nag screen.
- **Rationale:** Respects the user's time and decision to pause.
- **Implementation Implication:** Onboarding progress persisted to local storage. Resume logic checks last completed step on app open.

---

## F. Pipeline Interaction Constraints

### UX-028 | Three-State Pipeline Contract (Visual)
- **Statement:** Expected = outline circle + muted text (Hope tier only, never S2S). Pending = half-filled circle + normal text (Hope tier, conservative FX, never S2S). Received = filled circle + checkmark + full text (adds to liquid, recalculates S2S).
- **Rationale:** Visual distinction prevents the user from confusing hoped-for money with real money.
- **Implementation Implication:** Pipeline entry widget uses a state-driven icon and text style. Visual treatment is non-negotiable per state.

### UX-029 | One-Tap Confirm Is the Most Important Interaction
- **Statement:** The confirm flow is a quick-confirm sheet showing the expected amount, the BDT equivalent at current FX, and two buttons: "Confirm Received" and "Not yet." One tap = state advances, S2S recalculates with visible animation of breakdown drawer opening for 1.2 seconds, then closing.
- **Rationale:** This is the single most rehearsed moment in the entire product. If this is clumsy, the retention loop breaks.
- **Implementation Implication:** The confirm sheet is a dedicated widget with exact layout. The S2S recalculation animation (breakdown drawer open 1.2s, then close) must be implemented as specified. Performance must be flawless.

### UX-030 | Pipeline Grouping: State Then Date
- **Statement:** Group by state, then by date. Received entries collapse by default into a "this month" summary. Pending and Expected expand by default.
- **Rationale:** Active entries (needing action) must be visible. Completed entries should not clutter.
- **Implementation Implication:** Pipeline list uses grouped sections with collapsible headers. Default expansion state is driven by entry state.

### UX-031 | Platform Routing as Logos, Not Text
- **Statement:** A small Upwork -> Payoneer -> bKash chain reads in 200ms; a sentence describing the same takes 2 seconds.
- **Rationale:** Visual shorthand reduces cognitive load on the most-visited non-home screen.
- **Implementation Implication:** Platform logo assets required. Routing chain widget uses icon sequence, not text description.

### UX-032 | Conservative FX Shown by Default
- **Statement:** Conservative FX is the default display. Optimistic rate available one tap away: "Expected ~1,77,500 (conservative) / live rate would give 1,79,800."
- **Rationale:** Pessimistic default protects the user. Optimistic availability satisfies curiosity.
- **Implementation Implication:** Pipeline entry display shows conservative BDT equivalent. Tap reveals optimistic alternative.

### UX-033 | Overdue Entries: Dedicated Section, Not Alarming
- **Statement:** Overdue entries get a dedicated section at the top of Pipeline screen. Not red. Not alarming. Small "Overdue -- needs attention" header with one-tap action: "Send a polite follow-up?"
- **Rationale:** Alarm about overdue payments raises cortisol without providing resolution. A calm action-oriented presentation helps.
- **Implementation Implication:** Overdue section uses standard text color with a subtle highlight. Action button links to pre-drafted follow-up template.

### UX-034 | "Duplicate Last" Gesture for Retainer Freelancers
- **Statement:** Long-press any received entry -> "Duplicate as expected for next month?" -> one tap creates next month's entry with same amount, same FX assumption, expected date +30 days.
- **Rationale:** The difference between 30 seconds and 30 minutes of monthly pipeline maintenance for the retainer cohort.
- **Implementation Implication:** Long-press context menu on Received entries. Duplicate action pre-fills all fields with date offset.

### UX-035 | Pipeline Anti-Patterns (Explicitly Forbidden)
- **Statement:** Forbidden: multi-select bulk actions, drag-and-drop reordering, inline editing inside list rows, auto-marking as Received based on date passing, bulk import wizards in MVP.
- **Rationale:** Multi-select encourages careless state changes. Drag-and-drop implies preference ordering (date determines order). Inline editing lacks intentionality for financial data. Auto-marking is catastrophic trust failure. Bulk import skips the trust-building act.
- **Implementation Implication:** No multi-select checkboxes on pipeline list. No reorderable list widgets. All edits open a focused sheet. No automated state transitions. No import UI in MVP.

---

## G. Microcopy Constraints

### UX-036 | Voice Attributes
- **Statement:** Calm (never urgent unless mathematically required), Objective (states facts, never judges), Specific (numbers, not vague qualifiers), Direct (no padding, no apologies, no qualifiers), Respectful (adult-to-adult, never paternalistic), Bangla-aware (bilingual without code-mixing; English default; full Bangla mode available).
- **Rationale:** 42% of freelancers have missed personal payments due to systemic delays. This population does not respond to perky copy.
- **Implementation Implication:** Every user-facing string must pass a voice review against these six attributes. Copy review is a required step in PR approval.

### UX-037 | Five Microcopy Archetypes
- **Statement:** Every string fits one of: (1) State statements ("here is the truth"), (2) Action invitations ("here is what you can do"), (3) Boundary statements ("here is the limit"), (4) Settlement copy ("the thing happened"), (5) Threat copy ("attention is needed"). Each has strict formatting rules.
- **Rationale:** Categorized copy prevents tone drift. Each archetype has a predictable structure the user learns to recognize.
- **Implementation Implication:** Localization files should tag each string with its archetype. New copy must specify its archetype during PR.

### UX-038 | Forbidden Phrases (Permanent Kill List)
- **Statement:** Banned: "Oops!/Whoops!/Uh-oh!", "Hang in there!/You got this!", "Just one more thing...", "Don't worry!", "Looks like.../It seems...", "Sorry, something went wrong", "Hi there!/Hey friend!", "Awesome!/Great job!/Nice!", "Premium/Pro/Power" in promotional voice, "Limited time offer", any emoji in system-generated copy (except state indicators).
- **Rationale:** Each trivializes financial events, implies doubt, patronizes, or breaks the calm contract.
- **Implementation Implication:** Grep/lint check on all string files for banned phrases. Automated CI check where feasible.

### UX-039 | "Show Your Work" Copy Pattern
- **Statement:** The S2S breakdown drawer mirrors a spreadsheet formula bar: Liquid BDT + Pending USD (conservative) - Fixed costs - Safety buffer - Tax reserve = Safe-to-Spend. Every line is tappable and self-explaining.
- **Rationale:** This is the algorithmic transparency contract made literal. The user can verify the math.
- **Implementation Implication:** Breakdown drawer layout uses monospaced alignment. Each line item is a tappable widget that expands to one-sentence explanation.

### UX-040 | No Exclamation Marks in System Copy
- **Statement:** No exclamation marks in any system-generated copy, including threat copy and error states.
- **Rationale:** Exclamation marks signal either excitement (inappropriate) or alarm (reserved for math).
- **Implementation Implication:** Lint rule on string files: reject any string ending in "!" that is not user-entered content.

### UX-041 | No Emoji in System-Generated Copy
- **Statement:** Default is emoji-free. Emojis must earn their place. Only state indicators (green/yellow/red circles) if used at all.
- **Rationale:** Emojis are casual. Financial data communication is not casual.
- **Implementation Implication:** No emoji characters in localization files except explicitly approved state indicators.

---

## H. Visual Design Constraints

### UX-042 | Five Named Colors Only
- **Statement:** Canvas (near-white #FAFAF7 light / near-black #0E0E0C dark), Primary ink (near-black/off-white), Secondary ink (60% opacity), Safe (#6B8F71), Tight (#B88A4A), At Risk (#9E4A3A), Hope (#5A7A8C at 40%), Interactive (#2C5F5D deep teal). No more.
- **Rationale:** The freelancer's eye is overstimulated by Upwork, Payoneer, bKash, Telegram, Facebook. Helm is the calm room.
- **Implementation Implication:** AppColors must contain exactly these values. Code review rejects any raw hex color outside this set.

### UX-043 | No Gradients Anywhere
- **Statement:** Zero gradients in the entire product.
- **Rationale:** Gradients are decorative. Helm is not decorative.
- **Implementation Implication:** No LinearGradient, RadialGradient, or gradient-containing assets. Lint or review check.

### UX-044 | No Drop Shadows on Cards
- **Statement:** Depth is conveyed by border + spacing, not by faked physics.
- **Rationale:** Drop shadows are decorative and signal a lifestyle app.
- **Implementation Implication:** No BoxShadow or elevation > 0 on card widgets. Use border and padding for visual separation.

### UX-045 | Light Mode Default; Dark Mode from System
- **Statement:** Light mode is default. Dark mode is automatic from system preference. No manual toggle in MVP.
- **Rationale:** Reduces settings surface. Follows platform convention.
- **Implementation Implication:** Theme switching uses MediaQuery.platformBrightness. No theme toggle in settings during MVP.

### UX-046 | Monospaced Numeric Font for All Numbers
- **Statement:** Numbers rendered in JetBrains Mono Variable or IBM Plex Mono. Vertical decimal alignment is the spreadsheet trust trigger.
- **Rationale:** Monospace IS the trust signal. It visually communicates precision.
- **Implementation Implication:** A dedicated text style for all numeric displays using the chosen monospace font. Never use the body font for financial numbers.

### UX-047 | S2S Number Is ~64pt on Mobile
- **Statement:** The Safe-to-Spend number is the largest typographic element in the entire product, approximately 64pt on mobile.
- **Rationale:** Visual dominance enforces the information hierarchy.
- **Implementation Implication:** S2S text style uses a fixed large size. No other element may exceed this size.

### UX-048 | Currency Symbol at Half-Weight
- **Statement:** The currency symbol (taka sign) is rendered at half the font weight of the number itself.
- **Rationale:** The symbol labels; it does not compete with the value.
- **Implementation Implication:** Currency symbol uses a lighter font weight or smaller size than the numeric value.

### UX-049 | Decimals Always Shown
- **Statement:** Always show two decimal places: 32,400.00 not 32,400.
- **Rationale:** Finance precision is a trust signal.
- **Implementation Implication:** Number formatting always includes .00 suffix. No truncation of decimal places.

### UX-050 | Bangladeshi Number Formatting (Lakh/Crore)
- **Statement:** Use lakh/crore separators: 1,32,400 not 132,400. Non-negotiable cultural correctness.
- **Rationale:** Bangladeshi users read numbers in lakh/crore format. Using Western formatting is a cultural mismatch.
- **Implementation Implication:** Custom number formatter that applies Bangladeshi grouping (last 3 digits, then groups of 2). Not the default intl NumberFormat.

### UX-051 | No Italics Anywhere
- **Statement:** Italics signal aside. Helm has no asides.
- **Rationale:** Every piece of text is primary communication. No text is secondary enough for italics.
- **Implementation Implication:** No fontStyle: FontStyle.italic in any text style. Review check.

### UX-052 | No ALL-CAPS Except Tab Bar Labels (If Needed)
- **Statement:** ALL-CAPS feels shouty. Restricted to tab bar labels only, and only if needed.
- **Rationale:** Maintains the calm tone across all surfaces.
- **Implementation Implication:** No TextTransform.uppercase except on bottom nav labels.

### UX-053 | 8pt Grid System
- **Statement:** Every margin, padding, and gap is a multiple of 8.
- **Rationale:** Consistent spatial rhythm reduces visual noise.
- **Implementation Implication:** All spacing values must be multiples of 8 (8, 16, 24, 32, etc.). Enforce via design tokens.

### UX-054 | S2S Block Breathing Room
- **Statement:** 32pt above the S2S block and 24pt below.
- **Rationale:** The visual frame says "this is the answer; let it sit."
- **Implementation Implication:** Fixed padding on the S2S hero widget: top 32, bottom 24.

### UX-055 | Outline Icons Only, 1.5pt Stroke
- **Statement:** Single restrained icon family: outline style, 1.5pt stroke, rounded joins (Phosphor, Tabler, or custom). No filled icons for active state -- use accent color + thin underline.
- **Rationale:** Filled active icons create "kindergarten lights" feeling. Outline maintains restraint.
- **Implementation Implication:** Icon package selection: Phosphor or Tabler. Active tab uses accent color tint + underline indicator, not filled variant.

### UX-056 | No Illustrated Mascots or Hand-Drawn Graphics
- **Statement:** No mascots, no anthropomorphized brand, no illustrated empty-state graphics with smiling envelopes. The brand is the math.
- **Rationale:** Mascots and illustrations are decorative. They trivialize a financial instrument.
- **Implementation Implication:** Empty states use text-only messaging. No SVG illustrations, no Lottie animations in empty states.

---

## I. Motion and Animation Constraints

### UX-057 | Motion Is Rare and Slow
- **Statement:** Default transition: 200-280ms with ease-out curves. No springs. No bounces.
- **Rationale:** Fast or bouncy motion signals playfulness. Helm is not playful.
- **Implementation Implication:** All transition durations must fall in the 200-280ms range. Use Curves.easeOut. No spring physics simulations.

### UX-058 | Breakdown Drawer Is the Showcase Animation
- **Statement:** The breakdown drawer slides up over 240ms. This is the single showcase animation in the product.
- **Rationale:** The drawer reveal is the trust-transparency moment. It deserves to be noticed.
- **Implementation Implication:** Drawer animation duration is exactly 240ms with ease-out curve.

### UX-059 | No Micro-Interactions on S2S Number
- **Statement:** No pulse, shimmer, flicker, or any animation on the S2S number. The number is sacred; sacred things do not wiggle.
- **Rationale:** Animation on the number implies instability or playfulness. Both undermine trust.
- **Implementation Implication:** The S2S text widget must never have any AnimatedWidget wrapper, shimmer effect, or periodic animation.

### UX-060 | No Skeleton Shimmer Animations
- **Statement:** Skeleton states are solid, low-opacity placeholders that hold position. No shimmer or pulse animations.
- **Rationale:** Shimmer implies loading-as-entertainment. Helm's loading is just waiting.
- **Implementation Implication:** Skeleton widgets use static containers with low opacity. No Shimmer package, no animated placeholder effects.

### UX-061 | Reduce-Motion Respected Globally
- **Statement:** The reduce-motion accessibility setting is respected globally and aggressively.
- **Rationale:** Accessibility is a baseline, not a feature.
- **Implementation Implication:** Check MediaQuery.disableAnimations. When true, all transitions are instant (0ms duration).

---

## J. Density and Layout Constraints

### UX-062 | 9-Line Rule
- **Statement:** The home screen displays no more than 9 lines of content above the fold on a standard 6.1" mobile screen. If a feature requires more, it lives one layer below.
- **Rationale:** Density signals overwhelm. Helm is less dense than 80% of comparable fintech apps, intentionally.
- **Implementation Implication:** A custom lint rule or layout test verifies the 9-line limit on a reference device. Density violations fail CI.

### UX-063 | Generous Vertical Rhythm
- **Statement:** Helm is intentionally less dense than comparable apps. Spacing is generous.
- **Rationale:** Density signals overwhelm. The calm room requires breathing space.
- **Implementation Implication:** Minimum spacing between content groups is 24pt. Minimum spacing within groups is 16pt. Do not compress to "fit more in."

---

## K. Notification Constraints

### UX-064 | Two-Class Notification System Only
- **Statement:** Helm sends exactly two classes: Class A (Transactional -- triggered by state change in user's own data) and Class B (Boundary -- triggered by mathematical proximity to financial harm). No others exist or may be added without Doctrine amendment.
- **Rationale:** A push notification is an uninvited cognitive interruption. For a population at 50-55% baseline anxiety, wrong notifications trigger physiological stress.
- **Implementation Implication:** Notification registry enforces two types at the type level. Adding a third type requires a Doctrine review, not just a code change.

### UX-065 | Killed Notification Types
- **Statement:** Killed: "We miss you" / inactivity nudges, "Time to update your pipeline!" reminders, "You saved X this month!" hype, cross-sell / upgrade prompts, "New feature available!", holiday/festival messages, tips/suggestions/"did you know", streak/habit notifications, marketing/content notifications.
- **Rationale:** Each is engagement theater that erodes trust.
- **Implementation Implication:** These patterns cannot be implemented. No code path should allow sending notifications matching these patterns.

### UX-066 | Quiet Hours: 10pm-8am
- **Statement:** No notification fires between 10pm and 8am local time. No exceptions, including At Risk transitions (those wait until 8am unless obligation due that same day before 10am).
- **Rationale:** Financial anxiety notifications at night are harmful.
- **Implementation Implication:** Notification scheduler checks local time. Queue system holds notifications for quiet hours.

### UX-067 | Maximum 2 Notifications Per Day
- **Statement:** Maximum 2 notifications per day under any circumstances. Third trigger queues for next day.
- **Rationale:** Notification fatigue destroys the transactional loop.
- **Implementation Implication:** Daily notification counter per user. Counter resets at midnight local time.

### UX-068 | Notification Copy Rules
- **Statement:** Every notification: <= 140 characters expanded, contains a specific BDT or USD number, states the implication, offers exactly one tappable action, no exclamation marks, no emojis.
- **Rationale:** Precision and brevity respect the user's cognitive bandwidth during an interruption.
- **Implementation Implication:** Notification templates enforced by character count validation. Each template includes a number placeholder and a single action deeplink.

---

## L. Empty/Error State Constraints

### UX-069 | Helm Never Panics
- **Statement:** Every empty state, error state, and edge case is treated as a normal state with a specific cause and a specific next action.
- **Rationale:** "Something went wrong" is where products lose trust faster than anywhere else.
- **Implementation Implication:** No generic error screens. Every error has a specific message and a recovery action.

### UX-070 | S2S Calc Failure = Dash, Never a Wrong Number
- **Statement:** On S2S calculation failure, display "--" with "Some inputs need attention. Tap to review." Never a wrong or stale number.
- **Rationale:** The most important error pattern in the entire product. Better "--" for an hour than a wrong number for one second.
- **Implementation Implication:** The S2S display widget has an explicit null/failure rendering path. This path is tested exhaustively.

### UX-071 | Zero-State Panic Killer
- **Statement:** When the freelancer is between contracts and has zero pending pipeline, the home screen does NOT say "0 expected income." It pivots to runway emphasis: S2S number + "covers X days at your usual pace."
- **Rationale:** The user's psychological state is protected. Truth without alarm.
- **Implementation Implication:** When pipeline is empty, Tier 3 (Hope) shows "No pending pipeline right now. Add expected payments as work comes in." Never "You have no income."

### UX-072 | Offline Tolerance
- **Statement:** Helm works in read-only mode without network. Edits queue locally and sync on reconnection. User sees "Last sync X hours ago. Tap to refresh. You can still use Helm offline."
- **Rationale:** "No internet" must never be a blocker for a financial instrument.
- **Implementation Implication:** Local-first data architecture. Offline edit queue. Conflict resolution by event timestamp + device ID.

### UX-073 | Input Validation Is a Conversation, Not a Rejection
- **Statement:** Validation flags anomalies, explains the discrepancy, and lets the user proceed with eyes open. Example: "FX rate of 140.00 is 18% above the 90-day average of 118.50. Are you sure? [Confirm] [Adjust]"
- **Rationale:** Rejecting user input on a finance tool feels authoritarian. Informing and proceeding respects autonomy.
- **Implementation Implication:** Validation modals present the anomaly, the context (what average is), and two actions (confirm or adjust). Never a blocking error.

### UX-074 | Error States Never Lose User Input
- **Statement:** Every modal or form that errors preserves all entered data.
- **Rationale:** Losing data during an error compounds the frustration and trains the user to distrust the app.
- **Implementation Implication:** Form state persisted to controller. Error handling does not clear fields. Navigation guards preserve input.

### UX-075 | Error States Never Blame the User
- **Statement:** The system breaks; the user does not. Never make the user feel they broke something.
- **Rationale:** Blame erodes trust and discourages the user from using the app.
- **Implementation Implication:** Error copy uses passive voice for the system ("FX rate is missing") not active voice for the user ("You forgot to enter...").

---

## M. Reserve Mode Constraints

### UX-076 | Reserve Mode Activates Automatically on Math
- **Statement:** Activates when: liquid BDT drops below buffer threshold, S2S would be negative without buffer, or no pending pipeline + S2S covers fewer than 10 days.
- **Rationale:** The Trough (Days 29-31) is when Helm's psychological role is most critical.
- **Implementation Implication:** Reserve Mode is a computed state, not a user toggle. Checked on every S2S recomputation.

### UX-077 | Reserve Mode = Runway UI, Not Panic UI
- **Statement:** Home screen transforms to runway UI. Shows liquid BDT remaining, days of coverage at minimum-essentials pace, obligations with covered/uncovered status, and suggested actions.
- **Rationale:** Panic UI raises cortisol. Runway UI provides actionable information.
- **Implementation Implication:** Reserve Mode uses a distinct layout variant of the home screen. Same color system, but switches from S2S to Liquid BDT as hero metric with runway context.

### UX-078 | No Feature Promotions During Reserve Mode
- **Statement:** Tax reserve setup, multi-wallet onboarding, all secondary CTAs are suppressed during Reserve Mode.
- **Rationale:** A user in financial duress must not be marketed to.
- **Implementation Implication:** Feature promotion widgets check Reserve Mode state and suppress themselves when active.

### UX-079 | No Paywalls During Reserve Mode
- **Statement:** A user in financial duress is never shown an "Upgrade to Pro" prompt. Absolute rule.
- **Rationale:** Monetizing distress is a trust collapse event.
- **Implementation Implication:** Paywall gates check Reserve Mode state before rendering. (Cross-referenced with Product Constraint PC-078.)

### UX-080 | Reserve Mode Tone: Extra-Clinical, Not Extra-Warm
- **Statement:** The user does not need empathy in Reserve Mode -- they need precision. Empathy reads as pity; pity damages dignity.
- **Rationale:** The user is an adult professional in a difficult moment. Treat them accordingly.
- **Implementation Implication:** Reserve Mode copy uses the same voice attributes as normal mode, with even greater specificity on numbers and actions.

### UX-081 | Silent Exit from Reserve Mode
- **Statement:** When conditions improve, Reserve Mode exits silently. No "you made it!" copy. Accent line returns to green. Tiers revert to standard. Transition is invisible.
- **Rationale:** The user does not need to be reminded they were in trouble. They lived it.
- **Implementation Implication:** No celebration animation, no toast, no modal on Reserve Mode exit. State simply recomputes and the UI reflects the new state.

---

## N. Forbidden UX Patterns (Comprehensive)

### UX-082 | Killed Visual Patterns
- **Statement:** Permanently forbidden: confetti/particle effects/celebration animations, slot-machine counter animations, glowing/pulsing buttons, hero illustrations on home screen, mascots/characters, gradient backgrounds, skeuomorphic finance UI, dashboards with 4+ widgets, pie charts of spending categories, health scores/ratings other than S2S.
- **Rationale:** Each either trivializes financial events, demands unearned attention, adds decoration where decision lives, or competes with the sacred S2S metric.
- **Implementation Implication:** No Lottie celebration animations. No AnimatedCounter. No Gradient widgets. No illustration assets on home screen. No chart libraries in MVP/V1.

### UX-083 | Killed Interaction Patterns
- **Statement:** Permanently forbidden: uninvited onboarding tooltips, modal-dismissing-modal stacks, force-categorization gates before S2S, hard override of S2S number, bulk-edit financial entries, auto-categorization without confirmation, "are you sure?" double-confirms on routine actions, permanent banner ads/upgrade nags, NPS/engagement modals in mid-flow, forced tutorials/coach-marks, hidden export/withdrawal actions, time-locked features.
- **Rationale:** Each interrupts cognition, gates the core value, enables reckless financial edits, erodes routine trust, or deploys dark patterns.
- **Implementation Implication:** These patterns must be explicitly checked in code review. No Tooltip widgets that auto-show. No categorization gates on home screen. No double-confirm on pipeline updates.

### UX-084 | Killed Copy Patterns
- **Statement:** Permanently forbidden: toxic positivity, moralizing financial advice ("skip eating out"), vague reassurance ("everything looks fine"), mystery copy ("something interesting happened"), "Powered by AI" / "AI-driven insights," comparison copy ("you're spending more than 78% of freelancers"), fear-induced urgency ("don't miss out!").
- **Rationale:** Each either patronizes, lies by vagueness, introduces surveillance framing, or manipulates through fear.
- **Implementation Implication:** Copy review checklist includes these banned patterns. Automated string search where possible.

### UX-085 | Killed Conceptual Patterns
- **Statement:** Permanently forbidden: gamification, social comparison, affiliate-driven recommendations, in-product credit scoring, auto-advice ("Helm recommends..."), aggregated net worth combining USD+BDT, reset/restart features ("start fresh this month").
- **Rationale:** Each either violates the product identity, creates regulatory risk, violates mental accounting, or implies the user failed.
- **Implementation Implication:** No gamification state models. No social features. No recommendation engines. No aggregated cross-currency totals. No "reset month" actions.

---

## O. "Real vs Hopeful Money" Presentation Rules

### UX-086 | Liquid BDT and Pending USD Are Visually Severed
- **Statement:** Liquid BDT dominates the canvas with full typographic weight. Pending USD recedes to the bottom with smaller, lighter, lower-contrast treatment. They never appear in the same number.
- **Rationale:** Mixing real (liquid) and hopeful (pending) money in one figure is the exact cognitive error Helm exists to prevent.
- **Implementation Implication:** Tier 1 shows only BDT liquid figure. Tier 3 shows USD pipeline separately with explicitly reduced visual weight (smaller font, secondary ink color, lower contrast).

### UX-087 | Temporal Segregation: Present > Threat > Hope
- **Statement:** Information hierarchy follows temporal proximity: present reality (liquid BDT) dominates, imminent threats (upcoming obligations) sit middle, future hopes (pending pipeline) recede.
- **Rationale:** The user's decision urgency follows the same temporal order. Present cash determines today's spending. Threats determine this week. Hope determines next month.
- **Implementation Implication:** Layout order is fixed: S2S hero block -> Obligation list -> Pipeline summary. This order cannot be rearranged by user preference or A/B testing.

### UX-088 | Pending Pipeline Shows ETA and Confidence, Not Certainty
- **Statement:** Pipeline entries show "expected ~Nov 18" not "arriving Nov 18." ETAs are labeled as estimates. Confidence indicators (Expected vs Pending) are visible.
- **Rationale:** Language that implies certainty about future money is the linguistic version of the behavioral failure mode.
- **Implementation Implication:** Date formatting for pipeline entries always uses "expected" or "~" prefix. No definitive "arriving on" language for non-Received entries.

---

## P. Bangladesh/Android-First Requirements

### UX-089 | 3G Performance on Low-End Device
- **Statement:** S2S visible in < 2 seconds on a Samsung A14 with 3G connection.
- **Rationale:** The majority of the ICP uses mid-range Android devices on variable network quality.
- **Implementation Implication:** Performance testing on reference device (Samsung A14 or equivalent). CI gate at P95 < 2,000ms time-to-S2S-visible.

### UX-090 | Bangladeshi Number Formatting
- **Statement:** Lakh/crore separators mandatory. 1,32,400 not 132,400.
- **Rationale:** Cultural correctness. Western formatting is a foreign-feeling UX error.
- **Implementation Implication:** Custom NumberFormat that applies South Asian grouping. Applied to all BDT displays.

### UX-091 | Bangla as Equal-Priority Language
- **Statement:** English UI by default. Full Bangla mode available (not Banglish). Bangla and Latin must visually align at baseline. Bangla screen-reader pronunciation validated.
- **Rationale:** Bangla is the first language of the ICP. "English-only" signals foreign product.
- **Implementation Implication:** Full localization layer with Bangla translations. Bangla font pairing (Noto Sans Bengali or Hind Siliguri) with matching x-height. All strings in localization files, none hardcoded.

### UX-092 | Taka and Dollar Symbols Shown Clearly
- **Statement:** Currency symbols (taka, dollar) must be shown clearly and consistently throughout.
- **Rationale:** In a two-currency product, ambiguous currency display is dangerous.
- **Implementation Implication:** Every monetary value must be prefixed with its currency symbol. No bare numbers for financial values.

---

## Q. Accessibility Minimums

### UX-093 | Touch Targets >= 44pt x 44pt
- **Statement:** All interactive elements must meet the minimum touch target size.
- **Rationale:** Accessibility baseline for mobile. Also prevents mis-taps on financial actions.
- **Implementation Implication:** All buttons, tappable rows, and interactive elements enforce minimum 44x44 constraint.

### UX-094 | WCAG AA Contrast Minimum; AAA on S2S
- **Statement:** All text contrasts meet WCAG AA. The S2S number meets WCAG AAA.
- **Rationale:** The S2S number must be legible in any lighting condition, including direct sunlight.
- **Implementation Implication:** Contrast ratios verified in design and enforced via automated contrast checks. S2S number uses maximum contrast (near-black on near-white / near-white on near-black).

### UX-095 | Screen Reader Navigability
- **Statement:** The S2S breakdown is fully navigable by screen reader in semantic order.
- **Rationale:** Accessibility is a baseline, not a feature.
- **Implementation Implication:** Semantic widget tree with proper Semantics labels. Tested with TalkBack (Android) and VoiceOver (iOS).

---

## R. Engineering-Enforced UX Constraints

### UX-096 | Performance Budget as Deployment Gate
- **Statement:** Time-to-S2S-visible P95 < 2,000ms. Cold start P95 < 800ms. S2S calculation P95 < 50ms. Breakdown drawer animation 240ms +/- 20ms. Automated in CI.
- **Rationale:** Performance is UX. A slow app is not a calm app.
- **Implementation Implication:** Integration test suite includes performance benchmarks on reference device. Deploy pipeline blocks on regression.

### UX-097 | Notification Governance in Code
- **Statement:** Notification triggers defined in single registry module. Adding a type requires code change with Doctrine reference. Engagement class does not exist as a type.
- **Rationale:** Governance through code prevents drift.
- **Implementation Implication:** Dart enum for notification class: transactional, boundary. No third value. Compiler rejects unknown values.

### UX-098 | 9-Line Rule Linted in CI
- **Statement:** Custom lint or layout test verifies home screen renders <= 9 lines above the fold on reference device.
- **Rationale:** Density discipline is too important to leave to code review alone.
- **Implementation Implication:** Widget test or integration test that counts renderable content lines on a 6.1" viewport.

### UX-099 | Feature Flags for Doctrine Surfaces
- **Statement:** Every Doctrine-significant UI surface is behind a feature flag in MVP. Not for A/B testing engagement -- for safe rollback of Doctrine drift.
- **Rationale:** If a forbidden pattern accidentally ships, it must be killable without a deploy.
- **Implementation Implication:** Feature flag infrastructure in MVP. Flags for: home screen layout, notification types, onboarding flow, pipeline interactions.

### UX-100 | Instrumentation Matches Doctrine Metrics
- **Statement:** Events must directly prove UX Doctrine claims. If instrumentation cannot measure a Doctrine claim, the claim is unfalsifiable and the surface fails review.
- **Rationale:** UX claims without measurement are aspirational, not operational.
- **Implementation Implication:** Every Doctrine claim has a corresponding instrumentation event. Event catalog maps to Doctrine section numbers.

---

## S. Product Feeling Checklists (Enforcement Gates)

### UX-101 | Six Review Checklists Before Shipping Any Surface
- **Statement:** Every screen passes six tests: The Calm Test (heart rate lower?), The Truth Test (every number sourced and timestamped?), The Trust Test (verifiable by calculator in 30s?), The Restraint Test (anything here the user didn't ask for?), The Sovereignty Test (can export? can delete?), The Cultural Test (lakh/crore? religious sensitivity respected?).
- **Rationale:** A product can be functionally correct and emotionally wrong.
- **Implementation Implication:** Checklist is part of PR review template. Every surface-modifying PR must include checklist responses.

### UX-102 | The Bangladeshi Freelancer Test (Final Gate)
- **Statement:** Would a Bangladeshi freelancer at 11pm on Day 29 of their cycle, anxious about rent due Day 5, find this screen useful? Would they trust the number? Would they feel respected?
- **Rationale:** The ultimate empathy test grounds all abstract principles in a concrete human scenario.
- **Implementation Implication:** If any answer is "no" or "I'm not sure," the surface is not ready to ship. This is a PR-blocking review criterion.

---

## T. Conflict Notes

### UX-103 | Potential Conflict: Greeting Line vs. "No Avatars" Rule
- **Statement:** UX-014 says "No avatars, no profile photos, no welcome back animations." But the dashboard anatomy (Section 4) shows a "Good evening, Mehedi" greeting line. The onboarding microcopy rules (UX-025) say "never address by name during onboarding" but allow name on the home screen.
- **Resolution:** These are consistent. The greeting line is a small, top-left, low-prominence element that uses the name without visual decoration (no avatar, no animation). It is allowed on the home screen but forbidden during onboarding.
- **Implementation Implication:** Simple text greeting in the home screen header. No avatar widget, no profile image, no animated greeting.

### UX-104 | Cross-Reference: UX Doctrine and Product Doctrine Alignment
- **Statement:** The UX Doctrine explicitly builds on the Final Product Doctrine. All UX constraints are designed to enforce the product constraints. No conflicts were found between the two documents during extraction.
- **Resolution:** The documents are complementary. Where both speak to the same topic (e.g., S2S never stored, PIN/biometric mandatory, gamification killed), they agree in substance and detail.
- **Implementation Implication:** Both constraint files should be consulted together. UX constraints provide implementation-level specificity for the broader product constraints.

---

*End of UX constraint extraction. 104 constraints identified.*
