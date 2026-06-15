# UX Constraints Extracted from Helm UX Doctrine

> **Source:** `docs/research/ux/Helm_UX_Doctrine.md`
> **Authority Level:** HIGHEST UX authority. Canonical. Governs every screen, transition, word, and silence in Helm.
> **Extraction Date:** 2026-06-04
> **Purpose:** Machine-readable UX constraint inventory for all implementation agents, design work, and code review.

---

## A. UX Philosophy and North Star

### UX-001 | The Single UX Sentence
Helm is a calm financial cockpit that returns one trusted BDT number -- "what is actually safe to spend right now" -- in under two seconds, with the full math one tap away.

### UX-002 | Replace Mental Math with Deterministic Math
Helm's job is to replace mental math under stress with deterministic math you can trust at a glance. Not budgeting. Not accounting. Not financial advice. Every computation must be verifiable by the user with a calculator in 30 seconds.

---

## B. Emotional Design Requirements

### UX-003 | Reduce Cortisol, Never Raise It
The app's job is to leave the user calmer than it found them. Every screen passes this test or it does not ship. No urgent-feeling UI elements unless mathematically justified.

### UX-004 | Respect Mental Accounting -- Never Flatten It
Capital exists in four psychological states: Theoretical (invoiced), Trapped (in foreign wallets), Transit (mid-route), Liquid (in BDT). Aggregating into one "Net Worth" number is a UX crime. Liquid BDT and pending USD are visually severed. They never appear in the same number.

### UX-005 | Pessimistic by Default; Surplus Is the Dopamine
Always model the worst plausible case. Use lower-bound FX volatility. Assume worst-case fees. Surplus is the only acceptable surprise. Conservative FX rate is the default in all calculations.

### UX-006 | Closed Cognitive Loops (Zeigarnik Antidote)
Every screen must answer a question the user is already carrying. Never introduce a new open question. Never end an interaction without a resolved state. No screens that end with "come back later."

### UX-007 | Calm Is Louder Than Alarm
The default emotional tone is settled. Alarm exists but is rare and earned. Only one red color in the entire app, reserved for the At Risk state. No red in error messages, no red on buttons, no red in navigation.

### UX-008 | Respect the User's Adulthood
The freelancer is running a complex cross-border micro-business. They do not need encouragement, mascots, streaks, or motivational copy. Helm is a chronometer, not a coach. No coaching copy, no motivational messages, no "great job!" feedback.

### UX-009 | Faith- and Culture-Aligned Restraint
No interest-bearing nudges. No gambling-adjacent language ("you might win," "lucky day," "jackpot rate"). No premium FOMO ("upgrade now and unlock"). Tone is clinical, kind, exact.

---

## C. Information Hierarchy Rules

### UX-010 | Three-Tier Cognitive Stack
Every Helm screen: Tier 1 (The Answer: S2S in BDT, ~40% of canvas), Tier 2 (The Threat: next 3 obligations with countdown, ~25%), Tier 3 (The Hope: pending pipeline summary, ~20%). Remaining ~15% is whitespace and navigation.

### UX-011 | What Never Appears on Tier 1
Forbidden on top tier: "Total Net Worth," aggregated USD+BDT figures, charts/graphs/sparklines, health scores/ratings, AI-generated insights, promotional banners, upgrade nudges, anyone else's data.

### UX-012 | S2S Typographic Contract
S2S is the largest typographic element in the entire app (~64pt). Rendered in a monospaced numeric font. Currency symbol at half-weight. State color conveyed by a thin accent line below the number. Number is always black on light / white on dark. Font choice: JetBrains Mono Variable or IBM Plex Mono for numbers. Inter or Geist for UI text. Noto Sans Bengali or Hind Siliguri for Bangla.

### UX-013 | Progressive Disclosure as Architecture
Tap S2S -> Breakdown drawer. Tap obligation -> Edit/mark paid. Tap pipeline entry -> Edit. Pull down -> Refresh. Long-press S2S -> Reset. No separate "details" pages for home-screen content.

---

## D. Dashboard Doctrine

### UX-014 | Cockpit, Not Dashboard
The home screen is a cockpit (informs the next decision in a high-stakes environment), not a dashboard (reports). Every element must answer "what do I do next?" not just "what happened?"

### UX-015 | S2S Loads Visible in < 2 Seconds
S2S must be visible in under 2 seconds even on a 3G connection. Skeleton states show the number's position, never a spinner. P95 time-to-S2S-visible < 2,000ms. Cold start to first frame < 800ms. S2S calculation < 50ms.

### UX-016 | S2S Number Is Never Animated as a Counter
No "rolling up from 0" animation. The number simply appears, fully formed. No AnimatedCount, no Tween on the number value.

### UX-017 | Three State Colors Only
Safe (desaturated sage green #6B8F71), Tight (muted amber #B88A4A), At Risk (muted brick red #9E4A3A). Conveyed by a single accent line, not by tinting the number.

### UX-018 | "Updated X Min Ago" Always Visible
The freshness timestamp is always visible on the home screen. Never hidden, never truncated.

### UX-019 | Maximum 4 Bottom Navigation Items
Home, Pipeline, History, Settings. No more. No 5th tab, no "more" overflow menu.

### UX-020 | Single Persistent Floating Action Button
"Add Pipeline Entry" is the only proactive affordance on the home screen. One FAB. No secondary FABs, no expandable FAB menus.

### UX-021 | Dashboard Explicit Forbids
Forbidden on the home screen: welcome banners after onboarding, "what's new" announcements, cross-promotion to other features, inline tooltips appearing without invitation, notification inbox dot indicators, any metric labeled as a "score."

---

## E. Onboarding Constraints

### UX-022 | 3-Minute Conversational Onboarding
Median completion <= 3 minutes. P95 <= 5 minutes. No single step takes more than 30 seconds of user thought. 5 steps, each a single screen with a single question. No multi-field forms. No optional fields. No skip buttons that lead to broken states.

### UX-023 | The 5-Step Sequence
(1) Qualifying question (yes/no pain test), (2) Liquid balance entry (single BDT number), (3) Fixed costs capture (guided checklist), (4) Income pattern declaration (3 picture cards), (5) Buffer comfort (slider 5%/15%/25%/30% with live BDT preview). Exactly 5 screens, fixed order.

### UX-024 | No Celebration at Onboarding End
No "Done!" celebration. No confetti. After step 5 + PIN setup, transition directly to home screen with S2S visible. No interstitial success screen.

### UX-025 | Onboarding Microcopy Rules
Address user as "you" (never by name during onboarding). Every step explains in one sentence WHY the data is needed. Never use "Let's get started," "Almost there!", "Just one more step."

### UX-026 | PIN/Biometric Gate After Step 5
PIN/biometric setup fires immediately after step 5, before the first home screen render. Framed as "Helm shows your income. Only you should see it." No "set up later" option. 6-digit PIN minimum.

### UX-027 | Onboarding State Recovery
If user abandons mid-onboarding, next app open resumes at exact step. No forced restart. No nag screen.

---

## F. Pipeline Interaction Constraints

### UX-028 | Three-State Pipeline Contract (Visual)
Expected = outline circle + muted text (Hope tier only, never S2S). Pending = half-filled circle + normal text (Hope tier, conservative FX, never S2S). Received = filled circle + checkmark + full text (adds to liquid, recalculates S2S).

### UX-029 | One-Tap Confirm Is the Most Important Interaction
The confirm flow is a quick-confirm sheet showing the expected amount, the BDT equivalent at current FX, and two buttons: "Confirm Received" and "Not yet." One tap = state advances, S2S recalculates with breakdown drawer opening for 1.2 seconds, then closing.

### UX-030 | Pipeline Grouping: State Then Date
Group by state, then by date. Received entries collapse by default into a "this month" summary. Pending and Expected expand by default.

### UX-031 | Platform Routing as Logos, Not Text
A small Upwork -> Payoneer -> bKash chain reads in 200ms; a sentence takes 2 seconds. Platform logo assets required. Routing chain widget uses icon sequence, not text description.

### UX-032 | Conservative FX Shown by Default
Conservative FX is the default display. Optimistic rate available one tap away: "Expected ~1,77,500 (conservative) / live rate would give 1,79,800."

### UX-033 | Overdue Entries: Dedicated Section, Not Alarming
Overdue entries get a dedicated section at the top of Pipeline screen. Not red. Not alarming. Small "Overdue -- needs attention" header with one-tap action: "Send a polite follow-up?"

### UX-034 | "Duplicate Last" Gesture for Retainer Freelancers
Long-press any received entry -> "Duplicate as expected for next month?" -> one tap creates next month's entry with same amount, same FX assumption, expected date +30 days.

### UX-035 | Pipeline Anti-Patterns (Explicitly Forbidden)
Forbidden: multi-select bulk actions, drag-and-drop reordering, inline editing inside list rows, auto-marking as Received based on date passing, bulk import wizards in MVP.

---

## G. Microcopy Constraints

### UX-036 | Voice Attributes
Calm, Objective, Specific, Direct, Respectful, Bangla-aware. Every user-facing string must pass a voice review against these six attributes.

### UX-037 | Five Microcopy Archetypes
Every string fits one of: (1) State statements, (2) Action invitations, (3) Boundary statements, (4) Settlement copy, (5) Threat copy. New copy must specify its archetype during PR.

### UX-038 | Forbidden Phrases (Permanent Kill List)
Banned: "Oops!/Whoops!/Uh-oh!", "Hang in there!/You got this!", "Just one more thing...", "Don't worry!", "Looks like.../It seems...", "Sorry, something went wrong", "Hi there!/Hey friend!", "Awesome!/Great job!/Nice!", "Premium/Pro/Power" in promotional voice, "Limited time offer", any emoji in system-generated copy (except state indicators).

### UX-039 | "Show Your Work" Copy Pattern
The S2S breakdown drawer mirrors a spreadsheet formula bar: Liquid BDT + Pending USD (conservative) - Fixed costs - Safety buffer - Tax reserve = Safe-to-Spend. Every line is tappable and self-explaining. Breakdown drawer layout uses monospaced alignment.

### UX-040 | No Exclamation Marks in System Copy
No exclamation marks in any system-generated copy. Lint rule on string files: reject any string ending in "!".

### UX-041 | No Emoji in System-Generated Copy
Default is emoji-free. Only explicitly approved state indicators permitted.

---

## H. Visual Design Constraints

### UX-042 | Five Named Colors Only
Canvas (#FAFAF7 light / #0E0E0C dark), Primary ink, Secondary ink (60% opacity), Safe (#6B8F71), Tight (#B88A4A), At Risk (#9E4A3A), Hope (#5A7A8C at 40%), Interactive (#2C5F5D deep teal). No more. Code review rejects any raw hex color outside this set.

### UX-043 | No Gradients Anywhere
Zero gradients in the entire product. No LinearGradient, RadialGradient, or gradient-containing assets.

### UX-044 | No Drop Shadows on Cards
Depth is conveyed by border + spacing. No BoxShadow or elevation > 0 on card widgets.

### UX-045 | Light Mode Default; Dark Mode from System
Light mode is default. Dark mode is automatic from system preference. No manual toggle in MVP.

### UX-046 | Monospaced Numeric Font for All Numbers
Numbers rendered in JetBrains Mono Variable or IBM Plex Mono. Never use the body font for financial numbers.

### UX-047 | S2S Number Is ~64pt on Mobile
The Safe-to-Spend number is the largest typographic element in the entire product. No other element may exceed this size.

### UX-048 | Currency Symbol at Half-Weight
The currency symbol (taka sign) is rendered at half the font weight of the number itself.

### UX-049 | Decimals Always Shown
Always show two decimal places: 32,400.00 not 32,400.

### UX-050 | Bangladeshi Number Formatting (Lakh/Crore)
Use lakh/crore separators: 1,32,400 not 132,400. Non-negotiable cultural correctness. Custom number formatter required.

### UX-051 | No Italics Anywhere
No fontStyle: FontStyle.italic in any text style.

### UX-052 | No ALL-CAPS Except Tab Bar Labels (If Needed)
ALL-CAPS restricted to tab bar labels only.

### UX-053 | 8pt Grid System
Every margin, padding, and gap is a multiple of 8.

### UX-054 | S2S Block Breathing Room
32pt above the S2S block and 24pt below.

### UX-055 | Outline Icons Only, 1.5pt Stroke
Single restrained icon family: outline style, 1.5pt stroke, rounded joins (Phosphor, Tabler, or custom). Active tab uses accent color tint + underline indicator, not filled variant.

### UX-056 | No Illustrated Mascots or Hand-Drawn Graphics
No mascots, no anthropomorphized brand, no illustrated empty-state graphics. Empty states use text-only messaging.

---

## I. Motion and Animation Constraints

### UX-057 | Motion Is Rare and Slow
Default transition: 200-280ms with ease-out curves. No springs. No bounces.

### UX-058 | Breakdown Drawer Is the Showcase Animation
The breakdown drawer slides up over 240ms. This is the single showcase animation in the product.

### UX-059 | No Micro-Interactions on S2S Number
No pulse, shimmer, flicker, or any animation on the S2S number. The S2S text widget must never have any AnimatedWidget wrapper, shimmer effect, or periodic animation.

### UX-060 | No Skeleton Shimmer Animations
Skeleton states are solid, low-opacity placeholders. No shimmer or pulse animations. No Shimmer package.

### UX-061 | Reduce-Motion Respected Globally
Check MediaQuery.disableAnimations. When true, all transitions are instant (0ms duration).

---

## J. Density and Layout Constraints

### UX-062 | 9-Line Rule
The home screen displays no more than 9 lines of content above the fold on a standard 6.1" mobile screen.

### UX-063 | Generous Vertical Rhythm
Minimum spacing between content groups is 24pt. Minimum spacing within groups is 16pt. Do not compress to "fit more in."

---

## K. Notification Constraints

### UX-064 | Two-Class Notification System Only
Helm sends exactly two classes: Class A (Transactional) and Class B (Boundary). No others. Dart enum for notification class: transactional, boundary. No third value.

### UX-065 | Killed Notification Types
Killed: "We miss you" / inactivity nudges, "Time to update your pipeline!" reminders, "You saved X this month!" hype, cross-sell / upgrade prompts, "New feature available!", holiday/festival messages, tips/suggestions/"did you know", streak/habit notifications, marketing/content notifications.

### UX-066 | Quiet Hours: 10pm-8am
No notification fires between 10pm and 8am local time. Notification scheduler checks local time.

### UX-067 | Maximum 2 Notifications Per Day
Maximum 2 notifications per day. Third trigger queues for next day.

### UX-068 | Notification Copy Rules
Every notification: <= 140 characters expanded, contains a specific BDT or USD number, states the implication, offers exactly one tappable action, no exclamation marks, no emojis.

---

## L. Empty/Error State Constraints

### UX-069 | Helm Never Panics
Every empty state, error state, and edge case is treated as a normal state with a specific cause and a specific next action. No generic error screens.

### UX-070 | S2S Calc Failure = Dash, Never a Wrong Number
On S2S calculation failure, display "--" with "Some inputs need attention. Tap to review."

### UX-071 | Zero-State Panic Killer
When pipeline is empty, Tier 3 shows "No pending pipeline right now. Add expected payments as work comes in." Never "You have no income." Home screen pivots to runway emphasis.

### UX-072 | Offline Tolerance
Helm works in read-only mode without network. Edits queue locally and sync on reconnection. User sees "Last sync X hours ago. Tap to refresh. You can still use Helm offline."

### UX-073 | Input Validation Is a Conversation, Not a Rejection
Validation flags anomalies, explains the discrepancy, and lets the user proceed with eyes open. Example: "FX rate of 140.00 is 18% above the 90-day average of 118.50. Are you sure? [Confirm] [Adjust]"

### UX-074 | Error States Never Lose User Input
Every modal or form that errors preserves all entered data. Form state persisted to controller.

### UX-075 | Error States Never Blame the User
Error copy uses passive voice for the system ("FX rate is missing") not active voice for the user ("You forgot to enter...").

---

## M. Reserve Mode Constraints

### UX-076 | Reserve Mode Activates Automatically on Math
Activates when: liquid BDT drops below buffer threshold, S2S would be negative without buffer, or no pending pipeline + S2S covers fewer than 10 days. Reserve Mode is a computed state, not a user toggle.

### UX-077 | Reserve Mode = Runway UI, Not Panic UI
Home screen transforms to runway UI. Shows liquid BDT remaining, days of coverage at minimum-essentials pace, obligations with covered/uncovered status, and suggested actions.

### UX-078 | No Feature Promotions During Reserve Mode
Tax reserve setup, multi-wallet onboarding, all secondary CTAs are suppressed during Reserve Mode.

### UX-079 | No Paywalls During Reserve Mode
A user in financial duress is never shown an "Upgrade to Pro" prompt. Absolute rule.

### UX-080 | Reserve Mode Tone: Extra-Clinical, Not Extra-Warm
Reserve Mode copy uses the same voice attributes as normal mode, with even greater specificity on numbers and actions.

### UX-081 | Silent Exit from Reserve Mode
When conditions improve, Reserve Mode exits silently. No "you made it!" copy. Accent line returns to green. Transition is invisible.

---

## N. Forbidden UX Patterns (Comprehensive)

### UX-082 | Killed Visual Patterns
Permanently forbidden: confetti/particle effects/celebration animations, slot-machine counter animations, glowing/pulsing buttons, hero illustrations on home screen, mascots/characters, gradient backgrounds, skeuomorphic finance UI, dashboards with 4+ widgets, pie charts of spending categories, health scores/ratings other than S2S.

### UX-083 | Killed Interaction Patterns
Permanently forbidden: uninvited onboarding tooltips, modal-dismissing-modal stacks, force-categorization gates before S2S, hard override of S2S number, bulk-edit financial entries, auto-categorization without confirmation, "are you sure?" double-confirms on routine actions, permanent banner ads/upgrade nags, NPS/engagement modals in mid-flow, forced tutorials/coach-marks, hidden export/withdrawal actions, time-locked features.

### UX-084 | Killed Copy Patterns
Permanently forbidden: toxic positivity, moralizing financial advice ("skip eating out"), vague reassurance ("everything looks fine"), mystery copy ("something interesting happened"), "Powered by AI" / "AI-driven insights," comparison copy ("you're spending more than 78% of freelancers"), fear-induced urgency ("don't miss out!").

### UX-085 | Killed Conceptual Patterns
Permanently forbidden: gamification, social comparison, affiliate-driven recommendations, in-product credit scoring, auto-advice ("Helm recommends..."), aggregated net worth combining USD+BDT, reset/restart features ("start fresh this month").

---

## O. "Real vs Hopeful Money" Presentation Rules

### UX-086 | Liquid BDT and Pending USD Are Visually Severed
Liquid BDT dominates the canvas with full typographic weight. Pending USD recedes to the bottom with smaller, lighter, lower-contrast treatment. They never appear in the same number.

### UX-087 | Temporal Segregation: Present > Threat > Hope
Layout order is fixed: S2S hero block -> Obligation list -> Pipeline summary. This order cannot be rearranged.

### UX-088 | Pending Pipeline Shows ETA and Confidence, Not Certainty
Pipeline entries show "expected ~Nov 18" not "arriving Nov 18." Date formatting always uses "expected" or "~" prefix for non-Received entries.

---

## P. Bangladesh/Android-First Requirements

### UX-089 | 3G Performance on Low-End Device
S2S visible in < 2 seconds on a Samsung A14 with 3G connection. CI gate at P95 < 2,000ms.

### UX-090 | Bangladeshi Number Formatting
Lakh/crore separators mandatory. 1,32,400 not 132,400. Custom NumberFormat with South Asian grouping.

### UX-091 | Bangla as Equal-Priority Language
English UI by default. Full Bangla mode available (not Banglish). Bangla and Latin must visually align at baseline. All strings in localization files, none hardcoded.

### UX-092 | Taka and Dollar Symbols Shown Clearly
Every monetary value must be prefixed with its currency symbol. No bare numbers for financial values.

---

## Q. Accessibility Minimums

### UX-093 | Touch Targets >= 44pt x 44pt
All interactive elements must meet the minimum touch target size.

### UX-094 | WCAG AA Contrast Minimum; AAA on S2S
All text contrasts meet WCAG AA. The S2S number meets WCAG AAA.

### UX-095 | Screen Reader Navigability
The S2S breakdown is fully navigable by screen reader in semantic order. Tested with TalkBack (Android) and VoiceOver (iOS).

---

## R. Engineering-Enforced UX Constraints

### UX-096 | Performance Budget as Deployment Gate
Time-to-S2S-visible P95 < 2,000ms. Cold start P95 < 800ms. S2S calculation P95 < 50ms. Breakdown drawer animation 240ms +/- 20ms. Automated in CI.

### UX-097 | Notification Governance in Code
Notification triggers defined in single registry module. Dart enum: transactional, boundary. No third value. Compiler rejects unknown values.

### UX-098 | 9-Line Rule Linted in CI
Custom lint or layout test verifies home screen renders <= 9 lines above the fold on reference device.

### UX-099 | Feature Flags for Doctrine Surfaces
Every Doctrine-significant UI surface is behind a feature flag in MVP. Flags for: home screen layout, notification types, onboarding flow, pipeline interactions.

### UX-100 | Instrumentation Matches Doctrine Metrics
Every Doctrine claim has a corresponding instrumentation event. Event catalog maps to Doctrine section numbers.

---

## S. Product Feeling Checklists (Enforcement Gates)

### UX-101 | Six Review Checklists Before Shipping Any Surface
Every screen passes six tests: The Calm Test, The Truth Test, The Trust Test, The Restraint Test, The Sovereignty Test, The Cultural Test. Checklist is part of PR review template.

### UX-102 | The Bangladeshi Freelancer Test (Final Gate)
Would a Bangladeshi freelancer at 11pm on Day 29 of their cycle, anxious about rent due Day 5, find this screen useful? Would they trust the number? Would they feel respected? If any answer is "no" or "I'm not sure," the surface is not ready to ship.

---

## T. Conflict Notes

### UX-103 | Potential Conflict: Greeting Line vs. "No Avatars" Rule
The greeting line is a small, top-left, low-prominence element that uses the name without visual decoration. Allowed on home screen; forbidden during onboarding. Simple text greeting only -- no avatar widget, no profile image, no animated greeting.

### UX-104 | Cross-Reference: UX Doctrine and Product Doctrine Alignment
No conflicts found between the two documents during extraction. Both constraint files should be consulted together.

---

*End of UX constraint extraction. 104 constraints identified.*
