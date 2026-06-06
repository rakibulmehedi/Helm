# Pocketa UX Doctrine

> **Status:** Canonical. Governs every screen, transition, word, and silence in Pocketa.
> **Foundation:** Built on the Final Product Doctrine (June 2026) and the UX Research Sprint behavioral evidence.
> **Posture:** Adversarial-mentor. Every rule here is a constraint, not a suggestion. Violate one and the calm collapses in a predictable way.
> **Reading Order:** Sections 1–3 are philosophy. Sections 4–11 are operational. Sections 12–14 are enforcement.

---

## 1. UX North Star

### The single sentence

> **Pocketa is a calm financial cockpit that returns one trusted BDT number — "what is actually safe to spend right now" — in under two seconds, with the full math one tap away.**

That sentence resolves every UX question. If a design decision moves you toward it, ship. If it moves you away, kill.

### The five tensions, resolved

Mehedi — these are the contradictions every fintech product blurs. Pocketa resolves them in writing, in advance, so no future debate is needed:

| Tension | Resolution |
|---|---|
| **Calm vs Urgency** | Calm is the default. Urgency is earned only by *mathematical proximity to financial harm* — i.e., insufficient liquid BDT for an obligation due within 7 days. Urgency is never used for engagement, promotion, retention, or "we miss you." There is exactly one red color in the entire app and it is reserved. |
| **Transparency vs Simplicity** | Simplicity at the surface; transparency on tap. The home screen shows one number. Tapping it reveals the math. Tapping the math reveals the inputs. Each layer is independently complete — the user can stop at any depth and trust what they see. |
| **User Control vs Financial Safety** | Users own every *input*. Users cannot override the *output*. The math is the contract. If the user dislikes the S2S number, they change an input — never the result. This is the middle path between paternalism and danger. |
| **Trust vs Automation** | Automation reduces effort, not verification. Every automated state change ends in a one-tap human confirmation. Pocketa never silently marks an invoice received. It asks. |
| **Pipeline Visibility vs Cognitive Overload** | Temporal segregation: **Present > Threat > Hope**. Liquid BDT dominates the canvas. Upcoming obligations sit middle. Pending USD recedes to the bottom. Detail lives one layer below the surface. |

### The product's job, in one line

> **Replace mental math under stress with deterministic math you can trust at a glance.**

That's it. Not budgeting. Not accounting. Not financial advice. Not a neobank. Pocketa is a calm answer to a recurring panicked question.

---

## 2. Emotional Design Principles

> **Why this section exists first:** The freelancer's interaction with Pocketa is not a transaction. It is an emotional regulation event. The UX research is unambiguous — 50–55% of gig workers report psychological distress from payment uncertainty, and 8.5 hours per month are spent on the cognitive overhead of payment management. Pocketa is competing for those 102 hours per year. It wins by becoming a place that *reduces cortisol*, not raises it.

### Principle 1 — Reduce cortisol, never raise it

The app's job is to leave the user calmer than it found them. Every screen passes this test or it doesn't ship.

- A user opens Pocketa anxious → leaves with a number, a runway, a known math.
- A user opens Pocketa calm → leaves still calm, with nothing pushed at them.
- A user opens Pocketa during the Trough (Days 29–31) → sees runway in days, not "you have no income."

### Principle 2 — Respect mental accounting; do not flatten it

The research is explicit: capital exists in **four psychological states** in the freelancer's mind — Theoretical (invoiced), Trapped (in foreign wallets), Transit (mid-route), Liquid (in BDT). Aggregating these into one "Net Worth" number is a UX crime.

**Pocketa rule:** Liquid BDT and pending USD are *visually severed*. They never appear in the same number. They never share typography weight. Trapped wealth is acknowledged but visually demoted.

### Principle 3 — Pessimistic by default; surplus is the dopamine

If Pocketa shows ৳30,000 Safe-to-Spend and the actual settlement yields ৳30,800, the user feels relief. If Pocketa shows ৳30,800 and the actual yields ৳30,000, the user feels betrayed.

**Pocketa rule:** Always model the worst plausible case. Use the lower bound of recent FX volatility. Assume worst-case fees if the platform routing is unclear. Surplus is the only acceptable surprise.

### Principle 4 — Closed cognitive loops over open ones (the Zeigarnik antidote)

The freelancer's brain holds open every uninvoiced, unpaid, unconfirmed loop. The research calls this *allostatic load*. Pocketa's job is to *close loops*, not surface them.

**Pocketa rule:** Every screen must answer a question the user is already carrying. Never introduce a new open question. Never end an interaction without a resolved state.

### Principle 5 — Calm is louder than alarm

Most fintech apps default to alarm and reserve calm for special states. Pocketa inverts this. The default emotional tone is *settled*. Alarm exists, but it is rare and earned.

A user who never sees a red state has used the product correctly. A user who sees red sees it because the math says they must.

### Principle 6 — The app must respect the user's adulthood

The freelancer is running a complex cross-border micro-business. They do not need encouragement, mascots, streaks, or motivational copy. They need an objective instrument that does not lie to them.

**Pocketa is a chronometer, not a coach.**

### Principle 7 — Faith- and culture-aligned restraint

No interest-bearing nudges. No gambling-adjacent language ("you might win," "lucky day," "jackpot rate"). No premium FOMO ("upgrade now and unlock"). Pocketa's tone is the financial equivalent of a calm physician — clinical, kind, exact.

---

## 3. Information Hierarchy

> **Why this matters:** When a panicked freelancer opens Pocketa at a checkout counter, they have ~1.5 seconds of cognitive bandwidth. Whatever wins the visual hierarchy in that moment IS the product. Everything else is decoration.

### The Three-Tier Cognitive Stack

Every Pocketa screen is built on this three-tier model. No exceptions.

| Tier | What lives here | Visual weight | Information type |
|---|---|---|---|
| **Tier 1 — The Answer** | Safe-to-Spend in BDT + state color + last-update timestamp | Dominant. Largest font on screen. ~40% of vertical canvas. | Liquid present reality |
| **Tier 2 — The Threat** | Next 3 upcoming obligations (rent, bills, EMI) with countdown days | Secondary. ~25% of canvas. | Imminent liabilities |
| **Tier 3 — The Hope** | Pending USD pipeline summary (count + expected total + ETA window) | Recessive. ~20% of canvas. Smaller, lighter, lower contrast. | Future, uncertain capital |

The remaining ~15% is whitespace and navigation. **Whitespace is not waste — it is the visual equivalent of breathing room.**

### What never appears on Tier 1

- "Total Net Worth"
- Aggregated USD + BDT figures
- Charts, graphs, sparklines
- Health scores, financial scores, ratings
- AI-generated insights, tips, suggestions
- Promotional banners, upgrade nudges, news
- Anyone else's data

### The S2S typographic contract

The Safe-to-Spend number is the largest typographic element in the entire app. It is rendered in a **monospaced numeric font** so decimals align vertically and the eye reads precision. The currency symbol (৳) is half the weight of the number itself. The state color (Safe / Tight / At Risk) is conveyed through a thin accent line below the number, not through coloring the number itself. The number is always black on light / white on dark — the user reads the value first, then the state.

### Progressive disclosure as architecture

The home screen does not link to "more details." It *contains* more details under the surface, revealed by tap or pull gestures. This is intentional. Navigation costs cognition; gesture-revealed depth does not.

| Surface gesture | Reveals |
|---|---|
| Tap on S2S number | Calculation Breakdown drawer (the math) |
| Tap on an upcoming obligation | Edit / mark paid / reschedule |
| Tap on a pipeline entry | Edit FX rate / expected date / mark received |
| Pull down on home | Refresh + last sync timestamp |
| Long-press on S2S | Quick "—" reset (calculation refresh) |

---

## 4. Dashboard Doctrine

> **The dashboard is not a dashboard. It is a cockpit.** A dashboard reports. A cockpit informs the next decision in a high-stakes environment. Pocketa's home screen must be the latter.

### What the home screen IS

A single-purpose, low-density, instantly-legible answer to "is this money real and is it safe to spend?"

### Anatomy of the home screen (top to bottom)

```
[Time-aware greeting line — small, top-left]
"Good evening, Mehedi"
"Updated 2 min ago"

[ Safe-to-Spend HERO BLOCK ]
        ৳ 32,400
        Safe to spend
   ─────────────────
   [thin Tight-state accent line]
   "covers 17 days at your usual pace"

[ The Threat block — middle ]
↳ Internet bill        ৳1,500    in 2 days   ●
↳ Rent                ৳18,000   in 6 days   ●
↳ Adobe subscription  ৳2,400    in 11 days  ○

[ The Hope block — recessive, lighter ]
Pending pipeline    $1,800 across 2 invoices
                    expected ~Nov 18

[footer: quick-action tab bar — minimal]
```

### Dashboard non-negotiables

1. **Loads to S2S visible in < 2 seconds**, even on a 3G connection in Khulna. Skeleton states show the number's *position*, never a spinner. The number itself is the last thing to populate, with a 200ms fade-in. This trains the eye to wait for the truth, not the chrome.

2. **The S2S number is never animated as a counter.** No "rolling up from 0." That is a slot-machine pattern and breaks the calm contract. The number simply appears, fully formed.

3. **State color is conveyed by a single accent line, not by tinting the number.** Three states only:
   - **Safe** — desaturated muted green accent. Liquid BDT comfortably covers all obligations + buffer.
   - **Tight** — muted amber accent. Liquid BDT covers obligations but eats into buffer.
   - **At Risk** — a single muted red accent. Liquid BDT is insufficient for an obligation due within 7 days.

4. **"Updated X min ago" is always visible.** The user must always know how fresh the truth is. A number without a timestamp is a number without authority.

5. **No avatars, no profile photos, no "welcome back animations."** The user is not a person to be greeted; they are an operator who wants the instrument reading.

6. **No bottom navigation with more than 4 items.** Home, Pipeline, History, Settings. That's it. More items dilute the home screen's gravity.

7. **The "Add Pipeline Entry" action is a single, persistent, floating button.** It is the only proactive affordance on the home screen. Everything else is reactive.

### What the dashboard explicitly forbids

- Welcome banners after onboarding (one-time only, dismissable, never repeated)
- "What's new" announcements (these belong in a versioned changelog in Settings)
- Cross-promotion to other Pocketa features ("Did you know about Tax Reserve?")
- Inline tooltips that appear without being summoned
- Notifications inbox dot indicators on the home screen
- Any metric labeled as a "score"

---

## 5. Onboarding Doctrine

> **Onboarding is the trust handshake.** It is also the highest-attrition surface in the entire product. The research is clear: 70%+ of users abandon finance apps during setup because the effort/reward ratio inverts. Pocketa onboarding must invert the inversion.

### The 3-minute conversational onboarding contract

**Hard constraint:** Median completion time ≤ 3 minutes. P95 ≤ 5 minutes. If a single step takes more than 30 seconds of user thought, it is rewritten or removed.

### Onboarding philosophy: ask for trust, not data

The conventional finance app asks: *"Connect your accounts, enter your transactions, categorize your spending, set your budget."* This is data-extraction theater. The user has not yet seen value; the app is already demanding labor.

Pocketa inverts this. **The first thing the user sees is an answer, populated from minimal input.** Every onboarding question must directly contribute to the S2S number the user sees at the end.

### The 5-step conversational sequence

Each step is a single screen with a single question. No multi-field forms. No optional fields. No skip buttons that lead to broken states.

| Step | Question | Why it earns its place |
|---|---|---|
| 1 | **Qualifying question:** "Have you ever spent money thinking a Payoneer / Upwork payment had cleared, then realized a bill was due before the BDT actually arrived?" → Yes / Not really | If Not really, gracefully disqualify. This is not a marketing trick — it protects retention metrics and respects the user's time. |
| 2 | **Liquid balance entry:** "Roughly how much do you have right now in bKash + bank + cash combined? You can refine this later." → single BDT input + helper hint | One number. No wallet splitting in MVP. The "refine later" framing reduces precision pressure. |
| 3 | **Fixed costs capture:** "What do you pay every month no matter what?" → guided list: Rent, Internet, Phone, Subscriptions, Family support, Other → each with amount + day-of-month | Critical input for S2S. Presented as a conversational checklist, not a form. User can add custom items but defaults cover 80% of cases. |
| 4 | **Income pattern declaration:** "How does income usually arrive?" → three picture-cards: Marketplace escrow (Upwork/Fiverr/FC) / Direct client invoicing / Retainer or recurring | Captures the freelancer's "shape" without making them list every client. Drives the pipeline UX defaults. |
| 5 | **Buffer comfort:** "How much of your money do you want Pocketa to keep aside as a 'don't touch' safety buffer?" → slider 5% / **15%** / 25% / 30% with live BDT preview | Default 15%. The slider's live preview teaches the user immediately that buffer = real money set aside, not abstract. |

After step 5: **the home screen loads with the S2S number already computed**. No "Done!" celebration. No confetti. The reward IS the number.

### Onboarding microcopy rules

- Address the user as "you," never "Mehedi" by name during onboarding. Name personalization here feels manipulative. Use the name only in greeting lines on the home screen.
- Every step explains in one sentence WHY the data is needed. "This helps Pocketa show you what's actually safe to spend after your fixed bills." No "we promise to keep this safe" boilerplate — that signals doubt.
- Never use phrases like "Let's get started," "Almost there!", or "Just one more step." Treat the user like an adult; they can see the progress bar.

### The PIN/biometric gate

Set immediately after step 5, before the first home screen render. Framed as: *"Pocketa shows your income. Only you should see it. Set a 6-digit PIN — biometric if your device supports it."*

This is the **first place Pocketa earns trust through friction**. The friction here is itself the trust signal.

### Onboarding state recovery

If a user abandons mid-onboarding, the next app open resumes at the exact step. No "restart" forced. No nag screen. The implicit message: *we respect your time and your decision to pause*.

---

## 6. Pipeline Interaction Doctrine

> **The Pipeline IS the product's beating heart.** Safe-to-Spend is the surface metric, but the pipeline is what makes S2S real. If pipeline maintenance fails, S2S becomes fiction and the product dies. The MVP success threshold of ≥85% pipeline update compliance is therefore THE most important UX metric in Pocketa.

### The three-state pipeline contract

A pipeline entry exists in exactly one of three states. No others. No sub-states. No "partially received."

| State | Visual | Meaning | UX rule |
|---|---|---|---|
| **Expected** | Outline circle, muted text | Invoice sent or work agreed, not yet acknowledged paid | Counts toward "Hope" tier only; never toward S2S |
| **Pending** | Half-filled circle, normal text | Client acknowledged or payment in transit (e.g., Upwork released to Payoneer) | Counts toward "Hope" tier with conservative FX; still never toward S2S |
| **Received** | Filled circle, full text + checkmark | Funds landed in a Pocketa-tracked liquid wallet, converted to BDT | Adds to liquid balance; immediately recalculates S2S |

### The one-tap gesture (the most important interaction in the app)

When a notification fires — *"Your $1,500 from Acme is expected today. Tap to confirm received."* — the user opens the app and lands directly on a quick-confirm sheet.

**Single sheet, three lines:**

```
You expected:    $1,500 from Acme
Did you receive: ৳1,79,500    [edit]
                 (at 119.66 BDT/USD)
                 
[ Confirm Received ]    [ Not yet ]
```

One tap = state advances Pending → Received → S2S recalculates with visible animation of the breakdown drawer opening for 1.2 seconds, then closing.

**This is the single most rehearsed moment in the entire product.** Every other UX decision can be average. This one must be flawless.

### Pipeline visibility without overload

The Pipeline screen is the second-most-visited screen after Home. It must obey:

1. **Group by state, then by date.** Received entries collapse by default into a "this month" summary; Pending and Expected expand by default.
2. **Show the cascade visually.** Each entry has a small horizontal progress bar: Invoice → Acknowledged → In Transit → Settled. The user sees where money lives in the global routing network at a glance.
3. **Show platform routing as logos, not text.** A small Upwork → Payoneer → bKash chain reads in 200ms; a sentence describing the same takes 2 seconds.
4. **Conservative FX is always shown, with the optimistic rate one tap away.** "Expected ~৳1,77,500 (conservative) · live rate would give ৳1,79,800."
5. **Overdue entries get a dedicated section at the top of the Pipeline screen.** Not red. Not alarming. Just a small "Overdue — needs attention" header with a one-tap action: "Send a polite follow-up?" → uses a pre-drafted template.

### Pipeline edits are inputs, never outputs

The user can edit on any entry:
- Expected date
- USD amount
- FX rate (with sanity-check warning if >20% off the 90-day average)
- Routing path
- Exclusion flag ("don't count this in my pipeline")

The user **cannot** edit:
- The S2S impact figure
- The calculated BDT-equivalent (it derives from the inputs above)
- The state without going through the one-tap confirm flow

### The "Duplicate last" gesture

For retainer freelancers — long-press any received entry → "Duplicate as expected for next month?" → one tap creates the next month's entry with same amount, same FX assumption, expected date +30 days. This single gesture is the difference between 30 seconds and 30 minutes of monthly pipeline maintenance for the retainer cohort.

### Pipeline anti-patterns explicitly forbidden

- **Multi-select bulk actions.** Encourages careless state changes on financial entries.
- **Drag-and-drop reordering.** The order is determined by date, not preference.
- **Inline editing inside list rows.** All edits open a focused sheet — financial data deserves intentional editing.
- **Auto-marking as Received based on date passing.** Catastrophic trust failure if a client cancels and the entry was silently confirmed.
- **Bulk import wizards in MVP.** Manual entry IS the trust-building act in MVP. V3 introduces import.

---

## 7. Microcopy Doctrine

> **Microcopy is the voice of the system.** In finance, voice IS trust. A single tone-deaf sentence collapses a month of UX work. Pocketa's voice is calibrated against the research's most damning finding: 42% of freelancers have missed personal payments due to systemic delays. This is not a population that responds to perky copy.

### Voice attributes

| Attribute | Description | Example |
|---|---|---|
| **Calm** | Never urgent unless mathematically required | "Your internet bill is due in 2 days. Covered by current Safe-to-Spend." |
| **Objective** | States facts, never judges | NOT: "You're spending too much." YES: "Liquid balance has decreased by ৳12,400 this week." |
| **Specific** | Numbers, not vague qualifiers | NOT: "Your runway is good." YES: "Your Safe-to-Spend covers 17 days at your usual pace." |
| **Direct** | No padding, no apologies, no qualifiers | NOT: "We're sorry, but it looks like..." YES: "FX rate is missing for this entry. Tap to add." |
| **Respectful** | Adult-to-adult, never paternalistic | NOT: "Oops! Looks like you forgot to update." YES: "Last pipeline update was 6 days ago." |
| **Bangla-aware** | Bilingual without code-mixing chaos | English UI by default; full Bangla mode available (not Banglish). Currency symbols, time formats, and number grouping respect Bangladeshi conventions. |

### The five microcopy archetypes

Every string in Pocketa fits into one of five categories. Each has a strict rule:

#### Archetype 1 — State statements ("here is the truth")

Format: *Subject + verb + number + context*.

> "Safe-to-Spend is ৳32,400 — covers 17 days at your usual pace."
> "Pipeline total: $1,800 across 2 invoices, expected by Nov 18."
> "Buffer set to 15% — ৳5,720 held aside."

Rules: No exclamation marks. No emojis (unless explicitly chosen by user in profile). Always include the unit. Always include the implication when natural.

#### Archetype 2 — Action invitations ("here is what you can do")

Format: *Verb-led + outcome stated*.

> "Confirm received → updates Safe-to-Spend"
> "Edit FX rate"
> "Send polite follow-up to Acme"

Rules: Always lead with the verb. Always state the outcome if it affects S2S. Never use "Tap to..." padding.

#### Archetype 3 — Boundary statements ("here is the limit")

Format: *Direct statement + reason if helpful*.

> "Pocketa does not move money. This is a record-only transfer."
> "This is your declared tax reserve, not tax advice."
> "Pocketa never overrides Safe-to-Spend. Edit an input to change the number."

Rules: No apologies. No softening. Limits are clarity, not punishment.

#### Archetype 4 — Settlement copy ("the thing happened")

Format: *Past tense + specific value + open invitation*.

> "$800 settled to Payoneer at 119.66 — added ৳95,728 to liquid balance."
> "Internet bill marked paid. Safe-to-Spend updated."

Rules: No celebration. No "Yay!" No confetti language. The settlement is its own reward.

#### Archetype 5 — Threat copy ("attention is needed")

Format: *Fact + math implication + action*.

> "Rent of ৳18,000 due in 4 days. Safe-to-Spend after rent: ৳14,400."
> "Adobe subscription failed to deduct on Nov 1 — confirm payment status?"

Rules: Never use "URGENT," "WARNING," "ALERT," or all-caps. The fact itself carries the weight. No exclamation marks even here.

### Forbidden phrases (permanent kill list)

| Banned | Why |
|---|---|
| "Oops!", "Whoops!", "Uh-oh!" | Cutesy reaction to financial events trivializes them |
| "Hang in there!", "You got this!" | Toxic positivity in financial precarity |
| "Just one more thing..." | Suggests the user's time is infinite |
| "Don't worry!" | Patronizing in a context where worry is rational |
| "Looks like...", "It seems..." | Hedging suggests the system isn't sure of its own data |
| "Sorry, something went wrong" | Either say what went wrong, or stay silent |
| "Hi there!", "Hey friend!" | Pocketa is not the user's friend |
| "Awesome!", "Great job!", "Nice!" | The user did not perform; they updated a value |
| "Premium", "Pro", "Power" in promotional voice | Plan names are fine; promotional adjectives are not |
| "Limited time offer" | Never. Not for any reason. |
| Any emoji in system-generated copy (except 🟢🟡🔴 state indicators if used) | Default emoji-free; emojis must earn their place |

### The "Show your work" copy pattern

When the S2S number opens its breakdown drawer, the copy mirrors a spreadsheet's formula bar:

```
Liquid BDT                       ৳ 52,400
+ Pending USD (conservative)     ৳     0    [excluded — needs FX]
─ Fixed costs (next 30 days)     ৳ 14,280
─ Safety buffer (15%)            ৳  5,720
─ Tax reserve (V2)               ৳      0
───────────────────────────────────────
Safe-to-Spend                    ৳ 32,400
```

Every line is tappable. Every line explains itself in one sentence on tap. This is the **algorithmic transparency contract** made literal.

---

## 8. Visual Design Doctrine

> **Pocketa's visual language is restraint.** The freelancer's eye is already overstimulated by Upwork red, Payoneer blue, bKash pink, Telegram cyan, Facebook indigo, and a Bangladeshi tropical environment outside the screen. Pocketa's job is to be the calm room in a noisy house.

### Color system

| Role | Color | Usage |
|---|---|---|
| **Canvas** | Near-white in light mode (#FAFAF7); near-black in dark mode (#0E0E0C) | Slight warm tint — pure white feels clinical; pure black feels morbid |
| **Primary ink** | Near-black on light / Off-white on dark | All numbers, all critical text |
| **Secondary ink** | 60% opacity of primary | Labels, timestamps, recessive metadata |
| **Safe state** | Desaturated sage green (#6B8F71) | Tier 1 accent line only |
| **Tight state** | Muted amber (#B88A4A) | Tier 1 accent line only |
| **At Risk state** | Muted brick red (#9E4A3A) | Tier 1 accent line only — used sparingly |
| **Hope tier** | Cool desaturated blue (#5A7A8C) at 40% opacity | Pending pipeline visualizations |
| **Interactive** | Single accent color, deep teal (#2C5F5D) | All tappable affordances |

**Rules:**
- Five named colors. No more. Every screen uses only this palette.
- No gradients. None. Anywhere. Gradients are decorative; Pocketa is not decorative.
- No drop shadows on cards. Depth is conveyed by border + spacing, not by faked physics.
- Light mode is default; dark mode is automatic from system. No manual toggle in MVP.

### Typography

| Role | Font | Why |
|---|---|---|
| **Numbers** | A monospaced numeric font — JetBrains Mono Variable or IBM Plex Mono | Vertical decimal alignment is the spreadsheet trust trigger; monospace IS the trust signal |
| **UI text** | A neutral humanist sans — Inter or Geist | Legible, modest, culture-neutral |
| **Bangla text** | A pairing font with matching x-height — Noto Sans Bengali or Hind Siliguri | Bangla and Latin must visually align at the baseline |

**Typographic rules:**
- The S2S number is the largest typographic element in the entire product. ~64pt on mobile.
- The currency symbol (৳) is rendered at half-weight of the number — it labels, doesn't compete.
- Decimals are always shown (৳ 32,400.00 not ৳ 32,400) — finance precision is a trust signal.
- Bangladeshi number formatting (lakh / crore separators) — ৳ 1,32,400 not ৳ 132,400. This is non-negotiable cultural correctness.
- No italics anywhere. Italics signal aside, and Pocketa has no asides.
- No ALL-CAPS except in tab bar labels (and only if needed). ALL-CAPS feels shouty.

### Spatial rhythm

- An 8pt grid system. Every margin, every padding, every gap is a multiple of 8.
- Vertical rhythm is generous — Pocketa is less dense than 80% of comparable fintech apps. This is intentional. Density signals overwhelm.
- The Tier 1 (S2S) block has 32pt of breathing room above and 24pt below. The visual frame says: *this is the answer; let it sit*.

### Iconography

- A single, restrained icon family — outline style, 1.5pt stroke, rounded joins (Phosphor, Tabler, or a custom restrained set).
- No filled icons in the active state — instead, the active tab gets the brand accent color and a thin underline. Avoids the "kindergarten lights" feeling of filled active icons.
- No illustrated mascots, no hand-drawn empty-state graphics with smiling envelopes. Pocketa has no mascot. The brand is the math.

### Motion

- Motion is rare and slow. Default transition is 200–280ms with ease-out curves. No springs, no bounces.
- The breakdown drawer slides up over 240ms. That is the showcase animation.
- No micro-interactions on the S2S number — no pulse, no shimmer, no flicker. The number is sacred; sacred things do not wiggle.
- No skeleton shimmer animations. Skeleton states are solid, low-opacity placeholders that hold the position of the eventual content.
- Reduce-motion accessibility setting is respected globally and aggressively.

### Density discipline

The home screen displays no more than **9 lines of content** above the fold on a standard 6.1" mobile screen. If a feature requires more, it lives one layer below. This is the **9-line rule** and it is enforced in code review.

---

## 9. Notification Doctrine

> **A push notification is an uninvited cognitive interruption.** For a population already at 50–55% baseline anxiety, the wrong notification triggers a literal physiological stress response. Pocketa's notification architecture is therefore the most restrained surface in the product.

### The two-class system

Pocketa sends exactly two classes of notification. No others exist.

#### Class A — Transactional notifications

Triggered by a **state change in the user's own data**, not by the system trying to engage them.

| Trigger | Example copy |
|---|---|
| Pipeline entry's expected date arrives | "Your $1,500 from Acme is expected today. Tap to confirm received or mark not yet." |
| Fixed cost obligation is 48 hours out | "Internet bill of ৳1,500 due in 2 days. Covered by current Safe-to-Spend." |
| Pipeline entry passed expected date by 7 days | "Acme invoice is 7 days past expected. Is this still expected? Tap to update." |
| FX rate stored on a pending entry deviates >5% from current rate | "FX rate has moved. $1,500 entry would now convert to ৳1,79,500 instead of ৳1,77,200. Tap to refresh." |
| Successful settlement detected (manual confirm or future bank integration) | "$800 settled at 119.66 — added ৳95,728 to liquid balance. Safe-to-Spend updated." |

#### Class B — Boundary notifications

Triggered by **mathematical proximity to financial harm**.

| Trigger | Example copy |
|---|---|
| S2S transitions into Tight state | "Safe-to-Spend is now ৳14,400 — covers 6 days at your usual pace." |
| S2S transitions into At Risk state | "Rent of ৳18,000 is due in 4 days. Current liquid BDT is short by ৳3,600. Tap to review pipeline." |
| Liquid BDT below buffer floor | "Liquid BDT has dropped below your 15% buffer. Pocketa is now in Reserve mode — see suggestions." |

That's the entire list. Two classes. Roughly seven trigger types. No others exist or may be added without Doctrine amendment.

### Notifications that DO NOT exist in Pocketa

| Type | Why killed |
|---|---|
| "We miss you" / inactivity nudges | Engagement theater; loss of trust |
| "Time to update your pipeline!" reminders | Trains app-blame for user-driven data; killed |
| "You saved ৳X this month!" | Hype copy; financial clarity is its own reward |
| Cross-sell ("Upgrade to Pro!") | Trust collapse |
| "New feature available!" | Goes in a versioned changelog, not push |
| Holiday messages, festival greetings | Pocketa is not the user's friend |
| Tips, suggestions, "did you know" content | Coaching copy; killed |
| Streak / habit notifications | Patronizing; killed |
| Marketing or content notifications | Never |

### Quiet hours and frequency

- No notification fires between **10pm and 8am** in the user's local timezone. No exceptions, including At Risk transitions — those wait until 8am unless the obligation is due that same day before 10am.
- Maximum **2 notifications per day** under any circumstances. If a third trigger fires, it is queued for the next day.
- A user who explicitly disables a class can do so — disabling Class B requires an extra confirmation tap because it disables the safety floor.

### Notification copy rules (in addition to Microcopy Doctrine §7)

- Every notification is ≤140 characters in its expanded form.
- Every notification contains a specific BDT or USD number.
- Every notification states the implication ("Safe-to-Spend updated" / "covers 17 days").
- Every notification offers exactly one tappable action.
- No notification uses an exclamation mark. No notification uses an emoji.

---

## 10. Empty/Error State Doctrine

> **Empty and error states are where products lose trust faster than anywhere else.** A loading spinner that never resolves, a "Something went wrong" screen, an empty list with no explanation — these moments are when the user decides whether Pocketa is a serious instrument or a beta toy.

### The first principle of states

**Pocketa never panics.** Every empty state, error state, and edge case is treated as a normal state with a specific cause and a specific next action.

### Empty state catalog

| Screen | Empty trigger | Pocketa's response |
|---|---|---|
| Home (no pipeline entries, fresh install) | New user, post-onboarding | Show S2S based on liquid balance + fixed costs (it works without pipeline). Tier 3 ("Hope" block) shows: "Add your first expected payment to forecast Safe-to-Spend further." Never: "You have no income." |
| Pipeline screen (no entries) | New user | One illustration-free message: "When you invoice or expect a payment, add it here. Pocketa will track it through to your Safe-to-Spend." Below: prominent "Add first entry" button. |
| Pipeline screen (all received this month) | Successful month with no current pending | "All caught up for now. Pending pipeline will reappear when you add your next expected payment." NOT: "Nothing here! Start earning!" |
| History (new user) | No transaction history | "History will populate as you confirm received payments and pay obligations. Nothing here yet." |
| Tax Reserve (V2, not set up) | User hasn't declared reserve % | "Pocketa can set aside a percentage of received income as a tax reserve. You declare the percentage — Pocketa never decides tax for you." → "Set up tax reserve" button. |

### The Zero-State Panic Killer (the critical rule)

When the freelancer is between contracts and has zero pending pipeline, the home screen does **NOT** scream "৳0 expected income." It pivots to **runway emphasis**:

```
Safe-to-Spend
৳ 18,400
─────────────────
"covers 14 days at your usual pace"

[ Threat tier — unchanged, shows upcoming obligations ]

[ Hope tier — replaced with: ]
"No pending pipeline right now.
 Add expected payments as work comes in."
```

The user's psychological state is protected. The math is unchanged. **Truth without alarm.**

### Error state catalog

Errors fall into three categories. Each has a strict response pattern.

#### Category 1 — Calculation failure (S2S cannot be computed)

When inputs are missing, stale, or contradictory and S2S cannot be safely computed:

```
Safe-to-Spend
    —
─────────────────
"Some inputs need attention.
 Tap to review."
```

A dash, never a wrong number. This is the **most important error pattern in the entire product**. Better to show "—" for an hour than to show a wrong number for one second.

#### Category 2 — Sync / connectivity errors

```
"Last sync 4 hours ago. Tap to refresh.
 You can still use Pocketa offline."
```

Pocketa is offline-tolerant. Edits made offline queue and sync on reconnection. The user never sees "no internet" as a blocker.

#### Category 3 — Input validation errors

```
"FX rate of 140.00 is 18% above the 90-day average of 118.50.
 Are you sure? [ Confirm ] [ Adjust ]"
```

Validation is a conversation, not a rejection. Pocketa flags anomalies, explains the discrepancy, lets the user proceed with eyes open.

### What error states never do

- Show "Something went wrong" without specifying what.
- Show stack traces or error codes without a human translation.
- Default to "Try again later" — always provide an alternative action.
- Lose user input — every modal that errors preserves all entered data.
- Make the user feel they broke something. The system breaks; the user does not.

---

## 11. Zero/Reserve Mode Doctrine

> **The Trough is real.** Days 29–31 of any freelancer's emotional timeline — and any inter-contract gap — push Pocketa into its most important psychological role: not the gardener of abundance, but the lifeguard of survival. This mode is what separates Pocketa from a tracker.

### When Reserve Mode activates

Reserve Mode is **automatically entered** when the math indicates one of:

| Condition | Trigger |
|---|---|
| Liquid BDT drops below the safety buffer threshold | E.g., buffer set to 15% (৳5,720), liquid BDT is ৳5,400 |
| Safe-to-Spend would be negative without the buffer | The obligation total exceeds the liquid balance minus buffer |
| No pending pipeline + S2S covers fewer than 10 days | The Trough phase, mathematically detected |

### What Reserve Mode looks like

The home screen does **not** transform into a panic UI. It transforms into a **runway UI**.

```
[Time-aware greeting line]
"Reserve mode is on"

[ Hero block ]
        ৳ 5,400
        Liquid BDT remaining
   ─────────────────
   [muted brick red accent]
   "covers 6 days at minimum-essentials pace"

[ The Path block — replaces Threat & Hope tiers ]
↳ Internet bill — ৳1,500 in 2 days — covered
↳ Rent — ৳18,000 in 6 days — uncovered by ৳14,100
↳ "What can help: confirm Acme invoice receipt, follow up on overdue, defer 2 subscriptions"

[ Footer action ]
[ View suggested actions ]
```

### Reserve Mode behavioral rules

1. **No new feature promotions appear.** Tax reserve setup, multi-wallet onboarding, all secondary CTAs are suppressed.
2. **Suggested actions are presented as options, never as instructions.** Pocketa offers; the user decides.
3. **The buffer is visible and editable in this mode.** If the user explicitly chooses to dip into the buffer, they do so with eyes open — a single confirmation modal: *"Reducing buffer from 15% to 10% releases ৳1,900. This reduces Safe-to-Spend protection. Proceed?"*
4. **No paywalls appear during Reserve Mode.** A user in financial duress is never shown an "Upgrade to Pro" prompt. This is an absolute rule.
5. **Tone shifts to extra-clinical, not extra-warm.** The user does not need empathy in Reserve Mode — they need precision. Empathy here reads as pity, and pity damages dignity.

### The Reserve Mode action menu

When the user taps "View suggested actions," Pocketa presents a context-aware list, sorted by impact in BDT:

```
Actions Pocketa can help with

→ Confirm Acme invoice receipt              + ৳89,750 potential
→ Send polite follow-up to overdue clients  + variable potential
→ Defer Adobe & Notion subscriptions        + ৳3,400 immediate
→ Reduce safety buffer 15% → 10%            + ৳1,900 immediate
```

Each item taps into a one-screen workflow. No item is automated. The user makes every decision.

### Exit from Reserve Mode

When liquid BDT rises above the buffer threshold OR S2S returns to >10 days of runway, Reserve Mode silently exits. There is **no celebration, no "you made it!" copy**. The accent line returns to green. The Path block returns to standard Threat + Hope tiers. The transition is invisible.

The user does not need to be reminded they were in trouble. They lived it.

---

## 12. Forbidden UX Patterns

> **This section exists because every product, given enough time and feature pressure, drifts into anti-patterns.** This list is canonical. Adding to a Pocketa surface anything in this list requires a Doctrine amendment, not a Jira ticket.

### Permanently killed visual patterns

| Pattern | Why forbidden |
|---|---|
| Confetti, particle effects, celebration animations | Trivializes financial events; reads as patronizing |
| Slot-machine counter animations on numbers | The S2S number is not a jackpot |
| Glowing buttons, pulsing CTAs | Demands attention the math hasn't earned |
| Hero illustrations on home screen | Decoration where decision lives |
| Mascots, characters, anthropomorphized brand | Pocketa is an instrument, not a friend |
| Gradient backgrounds | Decorative; signals lifestyle app |
| Skeuomorphic finance UI (leather wallets, paper receipts) | Cultural mismatch + dated aesthetic |
| Dashboards with 4+ widgets visible at once | Cognitive overload |
| Pie charts of spending categories | Categorization is V3; presence here implies V1 has more than it does |
| Health scores, financial ratings, single-number summaries other than S2S | Competes with the one sacred metric |

### Permanently killed interaction patterns

| Pattern | Why forbidden |
|---|---|
| Onboarding tooltips that appear without invitation | Interrupt cognition |
| Modal dialogs to dismiss other modal dialogs | Stack hell |
| Force-categorization gatekeepers ("complete categorization to see S2S") | S2S is never gated |
| Hard override of the S2S number | Trains distrust of the math; user blames the app forever |
| Bulk-edit financial entries | Reckless on a finance surface |
| Auto-categorization without user confirmation | Silent decisions on user money |
| "Are you sure?" double-confirms on routine actions | Erodes routine trust |
| Permanent banner ads or upgrade nags | Trust collapse |
| Modals that block app use for engagement (NPS in mid-flow) | Hostility |
| Forced tutorials / coach-marks on every new feature | The product must explain itself in use |
| Hidden withdrawal or export actions | Buried liquidity is dark pattern |
| Time-locked features ("available again in 24 hours") | Pocketa is not a game |

### Permanently killed copy patterns

| Pattern | Why forbidden |
|---|---|
| Toxic positivity ("Don't worry!", "Hang in there!", "You got this!") | See Microcopy Doctrine §7 |
| Moralizing financial advice ("Maybe skip eating out this week") | Pocketa is not a moralist |
| Vague reassurance ("Everything looks fine!") | The math is the reassurance |
| Mystery copy ("Something interesting happened in your account") | Either say it or stay silent |
| "Powered by AI", "AI-driven insights" | AI is a tool; not a value proposition |
| Comparison copy ("You're spending more than 78% of freelancers") | Surveillance dystopia framing |
| Fear-induced urgency ("Don't miss out!", "Time is running out!") | Fear is reserved for math; never for marketing |

### Permanently killed conceptual patterns

| Pattern | Why forbidden |
|---|---|
| Gamification (streaks, badges, points, levels) | Financial clarity is its own reward — Final Doctrine §8 |
| Social comparison features | Owned by Facebook + Telegram; not Pocketa's lane |
| Affiliate-driven product recommendations | Conflict of neutrality |
| In-product credit scoring / creditworthiness display | Regulatory + classification risk |
| Auto-advice ("Pocketa recommends you spend less on X") | Borders on financial advice classification |
| Aggregated "net worth" number combining USD + BDT | Mental accounting violation |
| Reset / restart features ("Start fresh this month") | Implies the user failed; never |

---

## 13. Product Feeling Checklist

> **A product can be functionally correct and emotionally wrong.** This checklist is the final gate before any new screen, feature, or copy block ships. It is reviewed in code review with the same gravity as type safety or test coverage.

For every Pocketa surface, ask:

### The Calm Test

- [ ] After 5 seconds on this screen, does my heart rate feel lower or higher than when I opened it?
- [ ] Is there exactly one thing the user should look at first, and is it the largest thing on the screen?
- [ ] Could a user with English as a second language understand the primary message?
- [ ] Could a user in financial duress understand and use this screen without being condescended to?

### The Truth Test

- [ ] Is every number on this screen sourced from a calculation that can be revealed on tap?
- [ ] Does every shown number include its unit and its freshness (timestamp or "as of")?
- [ ] If a calculation could fail, is there a graceful "—" fallback?
- [ ] Are all edits traceable in an audit log?

### The Trust Test

- [ ] Could a user verify this number with a calculator in 30 seconds?
- [ ] If I removed the brand colors and logo, would this still feel trustworthy?
- [ ] Are fees, conversions, and deductions explicit, not implied?
- [ ] Does any copy on this screen overpromise or hedge?

### The Restraint Test

- [ ] Is there anything on this screen the user did not ask for?
- [ ] Did I add an animation, gradient, or decoration that isn't load-bearing?
- [ ] Is there an exclamation mark, an emoji, or a piece of hype copy that doesn't earn its place?
- [ ] Can I remove one thing and still ship?

### The Sovereignty Test

- [ ] Can the user export this data?
- [ ] Can the user delete this data?
- [ ] Did I ask permission before doing anything in their financial state?
- [ ] If a user with limited English ability hit "go," do they know exactly what will happen?

### The Cultural Test

- [ ] Are numbers formatted in lakh/crore convention?
- [ ] Are currency symbols (৳, $) shown clearly and consistently?
- [ ] Does the Bangla copy read naturally, not as machine translation?
- [ ] Are religious/cultural sensitivities respected — no interest-bearing language, no gambling vocabulary, no haram-adjacent framings?

### The Bangladeshi Freelancer Test (the final gate)

- [ ] Would a Bangladeshi freelancer at 11pm on Day 29 of their cycle, anxious about rent due Day 5, find this screen useful?
- [ ] Would they trust the number enough to act on it?
- [ ] Would they feel respected as an adult professional running a complex micro-business?

**If any answer is "no" or "I'm not sure," the surface is not ready to ship.**

---

## 14. Engineering Implications

> **UX is enforced by engineering, not by good intentions.** This section translates the Doctrine into the architectural and implementation constraints that make it real. If the engineering doesn't enforce it, the UX is theater.

### Implication 1 — S2S as pure function, never as state

The Safe-to-Spend value is **computed, never stored** at the application level. The breakdown drawer must render from the same pure function that renders the headline number. This is not a code style preference; it is a UX integrity contract.

```
Implementation rule:
  S2S = computeS2S(liquidBDT, pipeline, fixedCosts, buffer, taxReserve, fxRates, today)
  
The function is:
  - Pure (no side effects)
  - Deterministic (same inputs → same output)
  - Cached only by input hash (invalidated on any input change)
  - Identical on client and server (same code, shared module)
  - Returns null on calc failure (UI maps null → "—")
```

### Implication 2 — Event sourcing of all financial inputs

Every change to a financial entry (income, fixed cost, FX rate, buffer %, reserve %) writes an append-only event with `{user_id, entity_id, field, old_value, new_value, timestamp, source, device_id}`. The current state is a left-fold over the event stream. This enables:

- Audit log (Trust Layer 4 from Final Doctrine §10)
- Multi-device conflict resolution (Trust Layer 6)
- Daily S2S snapshot job in V3
- Per-entry history visible to the user

This is **architected from MVP**, even if visible features come later.

### Implication 3 — Integer paisa storage

Money is stored as `bigint` paisa across the entire stack. No floats. No decimal types. No currency-as-string. The conversion to display BDT (with two decimal places) happens **only at the rendering layer**, never in business logic.

Why this is UX: a single floating-point rounding error in S2S that the user could replicate on a calculator destroys trust irrecoverably.

### Implication 4 — Conservative FX is a first-class concept

FX rate handling has two distinct values on every pending entry:
- `user_declared_rate` — what the user entered
- `conservative_rate` — `min(user_declared_rate, 90_day_lower_bound)`

S2S uses `conservative_rate`. The display shows both with the optimistic value labeled "live rate would give...".

This is enforced at the data layer, not the UI layer, so a future UI cannot accidentally show the optimistic value as the canonical one.

### Implication 5 — Calculation failure mode is explicit

The S2S compute function returns a tagged union:
```
{ ok: true, value: int8 } | { ok: false, reason: 'missing_fx' | 'stale_data' | 'contradictory_inputs' }
```

The UI maps each reason to a specific copy and a specific recovery action. There is no generic "Something went wrong" path because there is no generic failure type.

### Implication 6 — Notification governance lives in code

Notification triggers are defined in a single registry module. Adding a notification type requires a code change with explicit reference to Doctrine §9. Engagement-class notifications cannot be added without a Doctrine amendment.

```
Registry pattern:
  registerNotification({
    id: 'pipeline_expected_today',
    class: 'transactional',  // 'transactional' | 'boundary' — only two values allowed
    quietHoursRespect: true,
    maxPerDay: 2,
    copyTemplate: '...',
    requiresUserDataChange: true,
  })
```

A `class: 'engagement'` value does not exist as a type. The TypeScript / Dart compiler rejects it.

### Implication 7 — Performance budget is a deployment gate

The S2S number must render within 2 seconds of cold app open on a representative low-end device (Samsung A14, 3G network). This is **automated in CI** — performance regression blocks deploy.

- Time-to-S2S-visible: P95 < 2,000ms
- App cold-start to first frame: P95 < 800ms
- S2S calculation time: P95 < 50ms
- Breakdown drawer open animation: 240ms ± 20ms

### Implication 8 — Accessibility as a baseline, not a feature

- All touch targets ≥ 44pt × 44pt.
- All text contrasts meet WCAG AA minimum, AAA on the S2S number.
- Reduce-motion respected globally.
- Bangla and English screen-reader pronunciation validated on real assistive tech.
- The S2S breakdown is fully navigable by screen reader in semantic order.

### Implication 9 — Offline tolerance

The app must function in read-only mode without network. Edits queue locally and sync on reconnection. Conflict resolution uses event timestamps + device IDs; last-write-wins is forbidden.

### Implication 10 — Theming and localization architecture

Strings live in a single localization layer. Bangla and English are equal-priority targets. No string is hardcoded in a component. This makes future Doctrine-driven microcopy changes a one-file edit, not a hunt across 200 files.

### Implication 11 — Feature flags for graceful Doctrine evolution

Every Doctrine-significant UI surface is behind a feature flag in MVP. This is not for A/B testing engagement — it is for **safe rollback of Doctrine drift**. If a future feature accidentally introduces a forbidden pattern in production, it can be killed without a deploy.

### Implication 12 — The 9-line rule is linted

A custom lint rule (or a layout test in the test suite) verifies that the home screen renders no more than 9 lines of content above the fold on a reference device. Density violations fail CI.

### Implication 13 — Instrumentation matches Doctrine metrics

The events captured (from Final Doctrine §16) directly drive the Closed Beta thresholds. The instrumentation layer is the Doctrine's measurement instrument:

| UX claim | Event proving it |
|---|---|
| "S2S is trustworthy" | `input_edit` events with S2S delta < 20% |
| "Pipeline is maintained" | `pending_to_received_tapped` time-since-creation < 7 days median |
| "Reduces cortisol" | `s2s_view` daily frequency + session duration < 90 seconds |
| "Doesn't annoy" | `notification_opened` / `notifications_sent` ratio > 40% |

If the instrumentation can't measure a Doctrine claim, the claim is unfalsifiable and the surface fails review.

---

## Closing Note

Mehedi — this Doctrine and the Product Doctrine are now a closed loop. The Product Doctrine tells you *what to build and why*. This UX Doctrine tells you *how it must feel, behave, speak, and guide attention*. Together they form a single constitutional document.

The discipline these two docs ask for is identical to the discipline that did not finish APEX V5 cleanly or deploy Wolf Syndicate. The pattern is well-known to you. The corrective is also well-known: **freeze the docs, open Day 1, build the boring thing**.

The right next action is not amending this Doctrine. It is sitting with the home screen on paper for 30 minutes and asking, of every element, the questions in §13.

If you finish this 30-minute exercise and Pocketa still feels right — you are ready for Sprint 1.

If it doesn't feel right — kill it now, before the repo exists. That is also a victory. The strategy docs are not the product. The shipped app is.

> **The system is the product, not the founder. The Doctrine is the system's spine. Now go build the body.**

---

*End of Pocketa UX Doctrine. Frozen. No amendments without an explicit Doctrine review session.*
