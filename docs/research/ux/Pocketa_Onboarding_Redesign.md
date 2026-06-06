# Pocketa Onboarding Redesign

> **Status:** Operational specification. Extends UX Doctrine §5 and Final Product Doctrine §2.
> **Authority:** Subordinate to both Doctrines. If anything here contradicts them, the Doctrine wins.
> **Posture:** Adversarial-mentor. Every rule below is a constraint that must be defended in code review.
> **Reading Order:** §1–§2 set the strategic frame. §3–§7 are the build spec. §8–§12 are the enforcement and measurement layer.

---

## 1. Onboarding Goal

### The single sentence

> **In under 180 seconds, the right user finishes onboarding feeling "this app already knows my problem," and lands on a Safe-to-Spend number they recognize as mathematically honest — not generous, not pessimistic-as-a-trick, just honest.**

### What "onboarding success" means — strictly defined

Onboarding does **not** succeed when the user completes 5 steps. It succeeds when **three psychological events** occur in sequence:

| Event | Marker | Why it matters |
|---|---|---|
| **Recognition** | The user nods at the qualifying question — silently or audibly. "Yes, that's me." | This is the "this app understands me" moment. Without it, the rest is a form. |
| **Compliance without resistance** | The user enters fixed costs, buffer %, and income pattern without abandoning, without skipping, without searching for a "later" button. | Compliance signals the friction-to-promise ratio is correct. |
| **Comprehension of the S2S number** | On first home-screen render, the user can articulate what the number means without help. "This is what I can spend after my bills and buffer." | If the user reaches S2S and asks "what is this?", onboarding failed even though the funnel completed. |

The MVP success metric (≥70% finish unaided, per Final Doctrine §4) is a **necessary but not sufficient** condition. The above three events are the sufficient condition.

### What onboarding is NOT trying to do

Push back on the default temptations now, before sprint 1, so they don't smuggle themselves into the build:

- **Not trying to maximize signups.** Disqualifying the wrong user is a feature, not a leak.
- **Not trying to collect data for analytics.** Every field asked must directly feed the first S2S calculation.
- **Not trying to demo features.** No carousels, no "here's what Pocketa can do," no value-prop slides.
- **Not trying to convince.** If the qualifying question doesn't sell itself, the rest of the product won't either.
- **Not trying to be friendly.** Pocketa is a chronometer (UX Doctrine §2.6). Onboarding is the moment the user picks up the instrument, not meets a person.

---

## 2. User Qualification Logic

### The qualification frame

Pocketa's onboarding does something almost no fintech product does: **it actively rejects the wrong user on screen 1.** This is strategic, not modesty. Wrong users churn, inflate support costs, dilute beta data, and write reviews from a perspective Pocketa was never built for.

### The qualifying signal

The single source of qualification is the **Overspend Incident** — defined in Final Doctrine §2 as:

> "Have you ever spent money thinking a Payoneer/Upwork payment had cleared, then realized the bill was due before the BDT actually arrived?"

This is not a hypothetical question. It is a **memory probe**. The right user has a specific, embarrassing, recent memory that this sentence retrieves. The wrong user reads it as abstract and answers "I guess?" — that hesitation is itself the disqualifier.

### Qualification decision tree

```
Q1: Overspend Incident Memory
│
├── "Yes — that's happened to me"
│       └─► QUALIFIED. Continue to Q2 (Liquid Balance).
│
├── "Not really / not sure"
│       └─► SOFT DISQUALIFY. 
│            Show the "Pocketa is not for you yet" exit screen.
│            No data captured. No account created. No retry loop.
│
└── "What does that mean?"  (interpreted from > 12s of inactivity on this screen)
        └─► OFFER PLAIN-BANGLA REPHRASE.
            One re-ask. If still unclear → SOFT DISQUALIFY.
```

### The soft-disqualify exit (the screen no one designs)

This is where most fintech products fail their own integrity. They either:
- Force the wrong user through onboarding anyway (greed), or
- Slam the door with "You don't qualify" (cruelty).

Pocketa does neither. The exit copy is honest and dignified:

> **"Pocketa is built for one specific problem — the moment you spend BDT thinking USD has arrived, and the math turns against you. If that hasn't happened to you, you don't need this app yet. Most people don't. Come back if it does."**
>
> [ Close ] [ Tell me when Pocketa adds features for me ] *(email-optional, no account created)*

Notice what this screen does:
- States the boundary as a fact, not a judgment.
- Offers a low-commitment future signal (email-only, no account).
- Names a real product future (V2+ wallet-only mode for less-acute users) without overpromising.
- Closes the loop in one screen. No retry, no "are you sure?", no nag.

### Disqualifying signals beyond Q1

Per Final Doctrine §2, certain users will pass Q1 but still be wrong for Pocketa. Onboarding does **not** try to filter all of them — that's product-positioning's job, not the form's job. But two specific paths surface during onboarding:

| Signal during onboarding | Surface | Treatment |
|---|---|---|
| User enters liquid balance < ৳5,000 *and* fixed costs > liquid | Step 3 calc preview | **Continue onboarding, but show a one-line note on the S2S reveal:** "Your fixed costs exceed liquid balance right now. Pocketa will show this as it is. We won't soften the number." |
| User selects "I don't have recurring fixed costs" | Step 3 | **Continue, but flag the cohort.** This is likely a marketplace beginner; Pocketa's S2S has reduced value for them. Track for V2 product-shape decision. |

**Important:** Onboarding never asks income amount. Never asks USD pending. Never asks client list. Those are pipeline-entry actions that happen post-onboarding, when the user has skin in the game.

---

## 3. Screen-by-Screen Flow

### Architectural decisions made up front

Before the screens themselves, three architectural calls that the doctrine left implicit:

| Decision | Resolution | Reasoning |
|---|---|---|
| **When does account creation occur?** | **After Step 1 qualification, before Step 2.** Magic Link email entered between Q1-Yes and Step 2. | Don't create accounts for disqualified users. Privacy debt and inflated churn metrics. |
| **When does PIN/biometric gate appear?** | **After Step 5, before first S2S render.** | Friction at this point is read as security, not delay. The reveal is the reward; PIN is the lock on the reward. |
| **When does privacy disclosure appear?** | **Inline at Step 2 (balance entry), not as a wall-of-text screen.** A 14-word inline disclosure beats a 200-word ToS scroll. | The doctrine forbids "we promise to keep this safe" boilerplate. Inline matter-of-factness is more trustworthy. |

### The seven-screen sequence

The doctrine specifies "5 steps." Operationally, that becomes **7 screens** because qualification, account creation, and PIN setup are real screens even though they don't feel like questions. Numbering below treats screens as user-facing surfaces.

---

#### Screen 1 — The Qualifying Question

**Purpose:** Memory probe + disqualification gate.

**Layout:**
- Top quarter: blank canvas (intentional — the question must dominate).
- Middle half: the qualifying question, in 18pt body type, left-aligned, no exclamation, no emoji.
- Bottom quarter: two large buttons, vertically stacked. "Yes — that's happened to me" / "Not really".

**Copy:**
> Welcome.
>
> Have you ever spent money thinking a Payoneer or Upwork payment had cleared — then realized a bill was due before the BDT actually arrived?
>
> [ Yes — that's happened to me ]
> [ Not really ]

**What is NOT on this screen:**
- No app logo at the top (the user is here; they don't need branding reassurance).
- No "Welcome to Pocketa" headline.
- No progress bar — the user hasn't committed yet.
- No "skip" or "later" affordance.
- No marketing copy explaining what Pocketa does.

**Time budget:** ≤ 15 seconds.

**State handling:** If user closes the app here, no data is stored. No account exists. The next open returns to this same screen.

---

#### Screen 2 — Account Creation (Magic Link)

**Purpose:** Establish identity. Nothing more.

**Trigger:** User tapped "Yes" on Screen 1.

**Layout:**
- One field: email address.
- One button: "Send me a link".
- One inline disclosure under the field, in 12pt secondary ink:
  > *Pocketa uses your email only to sign you in. No marketing. No selling. You can delete your account anytime.*

**Copy:**
> What email should we use to sign you in?
>
> [ email field ]
> [ Send me a link ]
>
> *Pocketa uses your email only to sign you in. No marketing. No selling. You can delete your account anytime.*

**The 14-word privacy disclosure** above replaces the 200-word ToS scroll. The doctrine's stance: inline, factual, non-defensive. If the user wants more, the full Privacy Policy link sits at the bottom — but it is not a click-to-continue gate.

**Time budget:** ≤ 30 seconds (includes the email round-trip).

**After link tap in email:** App opens directly to Screen 3. No "verified!" celebration screen. The act of being inside the app IS the confirmation.

---

#### Screen 3 — Liquid Balance Entry

**Purpose:** Capture the single most important S2S input.

**Layout:**
- Top: one-line context.
- Middle: a single numeric input, centered, monospaced, with the ৳ symbol pre-pended at half-weight.
- Below input: a helper line in secondary ink.
- Bottom: one button.

**Copy:**
> Roughly how much do you have right now in bKash, bank, and cash — combined?
>
> [ ৳ _____ ]
>
> *A rough number is fine. You can refine this later.*
>
> [ Continue ]

**The "rough number is fine" framing is doing serious psychological work:**
1. Reduces precision pressure (lowers abandonment).
2. Sets the precedent that Pocketa values truth over decoration.
3. Establishes the user's relationship with their own inputs — they own them, they can change them.

**What is NOT on this screen:**
- No wallet partitioning (bKash separate from bank separate from cash) — this is MVP scope. Multi-wallet is V1.
- No "connect your bank" affordance — no Pocketa integration exists in MVP, and pretending otherwise is the first trust break.
- No currency picker — BDT is implicit and unambiguous.

**Input validation:**
- Accept any positive integer up to 10 crore (৳100,000,000).
- Reject 0 with a one-line correction: "Pocketa needs at least a small liquid balance to compute S2S. If you have nothing right now, come back when you do."
- Format the number with lakh/crore separators in real time as the user types (UX Doctrine §8 typography rule).

**Time budget:** ≤ 25 seconds.

---

#### Screen 4 — Fixed Costs Capture

**Purpose:** Capture monthly recurring obligations. The subtraction inputs for S2S.

**This is the highest-friction screen in onboarding.** Treat it accordingly.

**Layout:**
- Top: one-line context.
- Middle: a guided checklist with pre-named common categories. Each row has a checkbox; tapping a checkbox expands an inline mini-form for amount and day-of-month.
- Bottom: "Continue" button (active even with zero items selected — see "no recurring costs" path below).

**Copy:**
> What do you pay every month, no matter what?
>
> *Tap to add. Skip what doesn't apply.*
>
> ☐ Rent / housing
> ☐ Internet
> ☐ Mobile / phone
> ☐ Subscriptions (Adobe, Netflix, etc.)
> ☐ Family support / parents
> ☐ Loan EMI
> ☐ Other recurring expense
>
> [ Continue ]

**When user taps a checkbox:**
- Row expands inline (not a modal — modal-stacking on the highest-friction screen is hostile).
- Two fields appear: amount in BDT, day of month (1–31, with a "around the X" qualifier).
- A "Remove" affordance appears next to the row.

**What is NOT on this screen:**
- No "Categories" search — the 7 defaults cover 80% of cases per the doctrine.
- No frequency selector (weekly / quarterly) — monthly only in MVP.
- No automatic suggestions from past data — there is no past data.
- No "we'll detect these from your bank" promise — false, and a permanent trust break.

**The empty-state path:** If the user taps Continue with zero costs selected, present a single inline confirmation:
> "No fixed monthly costs? That's unusual. You can add them later if any come up."
> [ Continue anyway ] [ Let me add some ]

This is **not** a nag. It is one re-ask, because zero fixed costs is genuinely uncommon for the target user and is more likely an "I'll do it later" abandonment than a true zero state. One re-ask, no second.

**Time budget:** ≤ 60 seconds. This is the longest budgeted step.

---

#### Screen 5 — Income Pattern Declaration

**Purpose:** Capture the freelancer's income shape. Drives pipeline UX defaults.

**Layout:**
- Top: one-line context.
- Middle: three large picture-cards stacked vertically. Each card has an icon, a label, and a one-line example.
- Single-select only. No multi-select in MVP.
- Bottom: "Continue" button.

**Copy:**
> How does income usually arrive?
>
> ┌─────────────────────────────────────────┐
> │  [ icon ]                               │
> │  Marketplace escrow                     │
> │  e.g. Upwork, Fiverr, Freelancer.com    │
> └─────────────────────────────────────────┘
>
> ┌─────────────────────────────────────────┐
> │  [ icon ]                               │
> │  Direct client invoicing                │
> │  e.g. you send invoices, clients pay    │
> └─────────────────────────────────────────┘
>
> ┌─────────────────────────────────────────┐
> │  [ icon ]                               │
> │  Retainer or recurring                  │
> │  e.g. same client, same amount monthly  │
> └─────────────────────────────────────────┘
>
> [ Continue ]

**What this drives downstream (not visible to the user, but architecturally real):**
- "Marketplace escrow" → pipeline defaults: 5–14 day Expected→Pending lag, FX entry required.
- "Direct invoicing" → pipeline defaults: net-30 Expected→Pending lag, FX entry required.
- "Retainer" → pipeline defaults: 30-day cycle, "duplicate last" gesture surfaced prominently.

**What is NOT on this screen:**
- No "I do all three" option — pick the dominant pattern. Edge cases handled in pipeline UX, not onboarding.
- No client names asked.
- No platform connection ("Connect Upwork") — fantasy in MVP per Final Doctrine §4.

**Time budget:** ≤ 15 seconds.

---

#### Screen 6 — Buffer Comfort

**Purpose:** Set the safety buffer percentage. The "don't touch" reserve carved out of S2S.

**Layout:**
- Top: one-line context.
- Middle: a horizontal slider with four anchor stops (5%, 15%, 25%, 30%). Default at 15%.
- Below slider: **live BDT preview** showing exactly what is held aside, computed from Screen 3's liquid balance.
- Bottom: "Continue" button.

**Copy:**
> How much of your money should Pocketa keep aside as a "don't touch" buffer?
>
> *Recommended: 15%.*
>
>   5% ─────●───── 30%
>           15%
>
> Held aside: **৳ 7,860**
> Safe-to-Spend after buffer: **৳ 44,540**
>
> [ Continue ]

**The live preview is the entire pedagogical payoff of this screen.** The user sees, in real numbers, what the abstract percentage means. As they drag the slider, both BDT values update with no lag — this is the moment they internalize that **buffer = real money set aside, not a setting**.

**What is NOT on this screen:**
- No "smart suggestion based on your profile" — paternalistic and unprovable in MVP.
- No "skip — use default" button — the slider IS the default; touching it is optional.
- No "Why 15%?" tooltip — if explanation is needed, it lives in Settings.

**Time budget:** ≤ 20 seconds.

---

#### Screen 7 — PIN / Biometric Setup

**Purpose:** Set the security gate before the first S2S render.

**Layout:**
- Top: one-line context (no padding, no preamble).
- Middle: 6-dot PIN entry field with auto-advancing input.
- Below: "Use biometric instead" option, surfaced only if device supports it.
- Bottom: "Continue" button (auto-active when 6 digits entered).

**Copy:**
> Pocketa shows your income. Only you should see it.
>
> Set a 6-digit PIN.
>
> ● ● ● ● ● ●
>
> [ Use Face ID instead ]
>
> [ Continue ]

**Then a confirmation re-entry:**

> Enter that PIN again.
>
> ● ● ● ● ● ●

**Recovery code:**
After PIN confirmation, present a single screen with a 12-word recovery phrase:
> If you forget your PIN, this is the only way back in.
>
> [ 12-word recovery phrase, monospaced, copy button ]
>
> *Save this somewhere offline. Pocketa cannot recover it for you.*
>
> [ I've saved it — Continue ]

**The friction here is the trust signal.** The user is being asked to do something that the average consumer app would consider a UX violation — manually save a recovery phrase. Pocketa does it because the doctrine demands it (Final Doctrine §10, Trust Layer L1).

**Time budget:** ≤ 35 seconds.

---

#### Screen 8 — The S2S Reveal (the payoff)

**Purpose:** Deliver the entire reward of onboarding.

**This is not a screen.** This is the home screen, loaded for the first time, with all 9 lines populated.

**What happens:**
1. After "I've saved it" on Screen 7, the app transitions over 320ms (slightly slower than the standard 200–280ms — this is the one place a transition is allowed to feel "arrived").
2. The home screen renders with the layout from UX Doctrine §4. Skeleton states hold position for the first 800ms.
3. The S2S number fades in last, over 200ms, monospaced, ~64pt, sage-green accent line (or amber if buffer-tight).
4. Below the S2S number, a one-time inline line appears that vanishes on first scroll or tap:
   > *Tap the number to see the math.*

**Copy on the S2S block (first render):**
> ৳ 44,540.00
> Safe to spend
> ─────────────
> covers ~18 days at your usual pace
>
> [ Updated just now ]

**What is NOT on this screen:**
- No "Welcome to Pocketa!" celebration banner.
- No "Onboarding complete!" toast.
- No confetti, no haptic burst, no sound.
- No tour overlay pointing at things.
- No "Add your first invoice" CTA — let the user discover the floating action button in their own time.

**The one allowed help affordance:** The "Tap the number to see the math" hint above. It dismisses on any user action and never returns. It is the **only** in-product hint in MVP.

---

### Total time budget across screens

| Screen | Budget | Cumulative |
|---|---|---|
| 1. Qualifying question | 15s | 0:15 |
| 2. Magic Link email | 30s | 0:45 |
| 3. Liquid balance | 25s | 1:10 |
| 4. Fixed costs | 60s | 2:10 |
| 5. Income pattern | 15s | 2:25 |
| 6. Buffer comfort | 20s | 2:45 |
| 7. PIN + recovery | 35s | 3:20 |
| 8. S2S reveal | — | — |

**Target median: 2:45. Hard ceiling (P95): 5:00.** The doctrine says ≤3 minutes median; this design gives 15s of buffer for slower users.

---

## 4. Emotional Pacing

Onboarding is an **emotional arc**, not a funnel. The user starts in one psychological state and must end in a different one. Mapping the arc:

| Screen | Entering emotional state | Designed emotional shift | Exiting state |
|---|---|---|---|
| 1. Qualifier | Skeptical curiosity ("another finance app") | Recognition — the question retrieves a real memory | Relief: "Someone gets it" |
| 2. Email | Mild guard ("will they spam me?") | Inline disclosure neutralizes the worry in <2 seconds | Neutral, willing to proceed |
| 3. Liquid balance | First commitment moment — is this safe? | "Rough is fine" disarms precision anxiety | Cooperative |
| 4. Fixed costs | Friction peak — this feels like work | Guided checklist removes "what counts as a fixed cost?" decision burden | Mildly fatigued, but engaged |
| 5. Income pattern | Re-engagement — picture cards feel light after the form | Recognition again — "yes, I'm a marketplace person" | Curious about payoff |
| 6. Buffer | Educational moment — the slider teaches | Live preview turns abstraction into concrete BDT | Pedagogical satisfaction |
| 7. PIN | Friction — but the right kind | Friction is read as "this is real, this protects me" | Trust deepens |
| 8. S2S reveal | Anticipation | Number arrives, math is visible on tap | **Recognition + ownership: "this is mine, and it's correct"** |

### The two emotional "danger zones"

Two screens carry disproportionate abandonment risk and must be designed defensively:

**Danger Zone 1 — Screen 4 (Fixed Costs).** This is where the user crosses from "trying it out" to "doing actual work." Mitigations:
- Pre-named categories (no free-text decision).
- Inline expansion (no modal-stacking).
- Default day-of-month from common patterns (rent typically due 1st, internet often 5th, etc. — pre-fill on category select).
- Zero-state honored without nag-lock (one re-ask, then proceed).

**Danger Zone 2 — Screen 7 (PIN + Recovery).** This is where the user crosses from "playing" to "committed." Mitigations:
- PIN entry is one screen, not five.
- Recovery phrase is presented with honest copy ("Pocketa cannot recover it for you") — frightening, but correct. The fear is the feature.
- Biometric option visible immediately for users on capable devices — reduces PIN-typing friction without sacrificing security.

### The deliberate emotional silence at Screen 8

The temptation here is enormous: confetti, "Welcome!", a tour, a celebration toast. The doctrine forbids all of it. The reasoning, made explicit:

> **The number itself is the celebration.** Adding a celebration on top of a celebration breaks both. The S2S figure earned through 2:45 of honest input is a more powerful emotional payoff than any banner or animation could be.

The user's internal monologue at Screen 8, if onboarding succeeded, should be: *"Oh. So that's actually what I can spend. Huh."*

That "Huh" is worth more than 10,000 confetti animations.

---

## 5. Required Inputs

The hard floor of data Pocketa needs to compute a meaningful S2S number on Screen 8.

| Input | Captured on | Used for | Editable later? |
|---|---|---|---|
| **Qualification answer** | Screen 1 | Eligibility gate | No — it's a one-time qualification |
| **Email address** | Screen 2 | Authentication via Magic Link | Yes — Settings → Account |
| **Liquid BDT balance** | Screen 3 | S2S base addend | Yes — Home → tap S2S → tap "Liquid BDT" line |
| **Fixed costs (≥0 items)** | Screen 4 | S2S subtraction; threat-tier rendering | Yes — Settings → Fixed Costs |
| **Income pattern** | Screen 5 | Pipeline UX defaults | Yes — Settings → Income (rare edit) |
| **Buffer percentage** | Screen 6 | S2S subtraction; buffer-tier rendering | Yes — Settings → Buffer (slider preserved) |
| **6-digit PIN** | Screen 7 | App-open gate | Yes — Settings → Security |
| **Recovery phrase (acknowledged)** | Screen 7 | Account recovery | Phrase is regenerable on request, but each regeneration invalidates the previous |

**Total required inputs: 8.** Of these, only 4 require numeric or content entry (balance, fixed costs, buffer, PIN). The rest are taps or selections.

### What is deliberately NOT required

To resist scope creep, the following are **forbidden** as onboarding requirements (they belong elsewhere or nowhere):

- Name, age, gender, profession label
- Phone number (until SMS becomes a real channel, which is V2+)
- Address
- National ID / NID / passport
- Tax ID / TIN
- Bank account number / IFSC
- bKash number
- Profile picture
- Client names
- Income amount (annual, monthly, or estimated)
- Currency preference (BDT is the only display currency in MVP)
- Language selection (auto-detect from device locale; manual toggle in Settings)
- Marketing consent (no marketing exists; nothing to consent to)

If any of these surface in a future design review with a "wouldn't it be useful to capture this during onboarding?" rationale — the answer is **no**. They violate the friction budget.

---

## 6. Optional Inputs

The doctrine's stance on optional inputs is severe and counterintuitive: **there are none during onboarding.**

Every screen either captures a required input or moves the user toward one. There is no "skip" button that leads to a half-populated S2S. There is no "add later" affordance for things needed now.

### Why this is the right call

Optional inputs during onboarding create three failure modes:

1. **Cognitive overhead.** Each "optional" field forces the user to decide whether it applies to them. That decision burden is itself friction.
2. **S2S degradation.** If the user skips an "optional" input that turns out to be needed for S2S, the first reveal shows a wrong or "—" number — catastrophic trust failure.
3. **Future nagging.** Optional fields become "complete your profile" nags — banned by UX Doctrine §4.

### Things that LOOK optional but are actually post-onboarding

These exist in the product, but **not as onboarding screens**. They are discovered organically:

| Feature | Where it surfaces |
|---|---|
| First pipeline entry | Floating "+" button on home screen, post-onboarding |
| Wallet partitioning | V1 release, not MVP |
| Tax reserve % | V2 release, not MVP |
| Invoice-Lite | V2 release, not MVP |
| Bangla mode toggle | Settings → Display (auto from locale) |
| Notification preferences | Settings → Notifications (sensible defaults from Day 1) |
| Custom fixed cost category | Inline within Fixed Costs registry, not onboarding |
| Profile picture / display name | Never. Pocketa doesn't have a profile screen. |

The principle, restated for code review enforcement:

> **If a field is not needed to render Screen 8 correctly, it is not an onboarding field.** Full stop. No exceptions.

---

## 7. First Value Moment

### The exact definition

The **First Value Moment (FVM)** is the precise instant on Screen 8 when the user's eye lands on the S2S number and reads it as a personal, mathematically honest figure.

This is not a moment Pocketa schedules. It is the natural consequence of doing the previous 7 screens correctly.

### What makes FVM "land"

| Condition | If absent, FVM fails |
|---|---|
| The S2S number is non-zero and positive | If zero or negative, user sees only loss — FVM fails |
| The number is recognizable as roughly correct ("yeah, that's about what I'd guess") | If wildly off, user distrusts the math |
| The state color (sage/amber/red) matches the user's gut sense of their financial state | If green when they feel tight, dissonance breaks trust |
| The "covers X days" runway line is comprehensible | If "days" doesn't make sense, the metaphor failed |
| The "Tap the number to see the math" hint is visible | Without it, the transparency contract is hidden |
| The Updated timestamp is "just now" | If stale on first load, the entire freshness contract fails |

### What the user can do at FVM

Nothing they have to do. Three things they can do:

1. **Tap the S2S number** → breakdown drawer opens. They see the math. Trust deepens.
2. **Scroll down** → see the Threat tier (their fixed costs in countdown form) and the Hope tier (currently empty pipeline).
3. **Tap the floating "+"** → add their first pipeline entry. This is the moment Pocketa transitions from "onboarded tool" to "active instrument."

None of these is forced. The user can also simply close the app. That's allowed. The S2S number, once computed, is the entire promise — they came for it, they got it, the rest is theirs to discover.

### The "second value moment" (V2 onwards)

For retention design, FVM is the first opening. The **second** value moment — the one that drives daily-return behavior — is the first time the user adds a pipeline entry, watches it move Expected → Pending → Received, and sees the S2S number update with the new BDT.

This second moment is not part of onboarding scope. But onboarding's job includes **not interfering with it** by over-tutorializing the home screen.

---

## 8. Trust Copy

The microcopy across onboarding, organized by the trust function each line performs. All copy below conforms to UX Doctrine §7 (microcopy doctrine) and §7 forbidden phrases.

### Trust functions and their microcopy

| Trust function | Where | Copy | Why this line works |
|---|---|---|---|
| **Recognition** | Screen 1 | "Have you ever spent money thinking a Payoneer or Upwork payment had cleared — then realized a bill was due before the BDT actually arrived?" | Names the exact moment. Doesn't generalize. The specificity IS the recognition. |
| **Dignified rejection** | Screen 1 (Not-really path) | "If that hasn't happened to you, you don't need this app yet. Most people don't. Come back if it does." | Boundary-stated, not apologetic. "Most people don't" normalizes — no one feels rejected as inferior. |
| **Privacy without paranoia** | Screen 2 | "Pocketa uses your email only to sign you in. No marketing. No selling. You can delete your account anytime." | Three short claims. No legal hedging. The inline placement signals "this is not a wall, just a fact." |
| **Permission to be imprecise** | Screen 3 | "A rough number is fine. You can refine this later." | Lowers precision pressure. Sets a precedent that user inputs are mutable, not contracts. |
| **Friction acceptance** | Screen 4 | "What do you pay every month, no matter what?" | "No matter what" is the qualifier — it narrows the user's mental search to truly recurring items. |
| **Guidance without judgment** | Screen 4 (zero-state) | "No fixed monthly costs? That's unusual. You can add them later if any come up." | "That's unusual" is factual, not corrective. Offers a forward escape without nagging. |
| **Pedagogical clarity** | Screen 6 | "Held aside: ৳7,860 / Safe-to-Spend after buffer: ৳44,540" | The slider teaches by showing. No "Here's how buffer works" tooltip needed. |
| **Security as care** | Screen 7 | "Pocketa shows your income. Only you should see it." | Frames PIN as care, not bureaucracy. "Only you" is a value statement disguised as a fact. |
| **Honest recovery** | Screen 7 | "If you forget your PIN, this is the only way back in. Save this somewhere offline. Pocketa cannot recover it for you." | The honesty is itself the trust. False reassurance ("Don't worry, we can reset it!") would be a permanent break. |
| **Arrival without celebration** | Screen 8 | "৳44,540.00 / Safe to spend / covers ~18 days at your usual pace" | No greeting. No celebration. The number does the talking. |
| **The one allowed hint** | Screen 8 | "Tap the number to see the math." | Single sentence. Vanishes on any action. The transparency contract made discoverable. |

### Forbidden onboarding copy (additional kill list, beyond UX Doctrine §7)

| Banned | Why |
|---|---|
| "Let's get started!" | Performative. The user has already started. |
| "Almost there!", "One more step!" | Treats the user as if they can't see the progress. |
| "Just X more questions" | Counts down to a moment the user already understands. |
| "Welcome to Pocketa!" | Pocketa is a tool, not a destination. |
| "Tell us about yourself" | Pocketa doesn't want to know the user; it wants to compute their S2S. |
| "We need this to give you the best experience" | The doctrine forbids "best experience" as marketing language masquerading as helpfulness. |
| "Your data is safe with us" | Defensive copy is the strongest signal the data isn't safe. |
| "Welcome aboard!" | Pocketa is not a ship. |
| "Awesome! Just one more thing..." | Triple violation: praise, hedge, time-disrespect. |
| Progress bar percentage labels ("33% complete") | The bar itself is enough; the percentage adds anxiety. |

### Bangla mode considerations

In Bangla mode, every line above must be translated by a native-speaker copywriter familiar with the cultural register. Pocketa's Bangla voice is **formal-modern** — the same register as a respected newspaper or a doctor's prescription pad — not the conversational Banglish of social media nor the textbook-formal of government documents. This calibration is non-trivial and is itself a v1 design artifact.

---

## 9. Drop-off Risks

Each onboarding screen carries a distinct abandonment risk profile. Below is the diagnostic map, with mitigations already in place and watch points for closed beta.

### Risk by screen

| Screen | Primary risk | Secondary risk | Mitigation in place | Watch metric |
|---|---|---|---|---|
| 1. Qualifier | Genuinely-disqualified user closes app (correct outcome — not a real drop-off) | Confused user can't parse the question | Plain re-ask if >12s inactivity | % "Not really" + % >12s inactivity |
| 2. Email | Email-typing friction; user doesn't switch to inbox | Magic link delivery delay | Send-link button has 0-latency visual confirmation; resend available at 30s | Time from "Send" to first link tap |
| 3. Balance | Precision paralysis ("I don't know exactly...") | User has no liquid balance right now | "Rough is fine" framing; zero-balance soft-rejection copy | Time on screen; abandonment rate |
| **4. Fixed costs** | **Decision fatigue from category selection** | **Modal-stacking if inline expansion fails** | **Pre-named categories; inline expansion only** | **Median time on screen; per-category tap rate** |
| 5. Income pattern | None significant — single-tap screen | User does all three patterns and freezes | Single-select forces a "dominant" choice — friction is the feature here | Card selection distribution |
| 6. Buffer | User over-adjusts and exits in confusion | User leaves at 5% default to skip thinking | Default at 15%, not 0%, prevents the skip-as-zero failure | Distribution of final buffer % |
| **7. PIN + recovery** | **Recovery phrase friction — "do I really have to save this?"** | **PIN re-entry mistypes** | **Honest copy; biometric option visible** | **Recovery acknowledgment-to-continue time; PIN mismatch rate** |
| 8. S2S reveal | Number doesn't match user's mental estimate | Skeleton state lingers too long (loading failure) | Pessimistic FX, transparent math one tap away | First-tap behavior (breakdown? scroll? pipeline?) |

### The two screens to instrument heaviest

**Screen 4 (Fixed Costs)** is the highest-risk screen. Closed-beta instrumentation must capture:
- Time on screen, broken into "pre-first-tap" vs "post-first-tap" — diagnostic for whether decision paralysis or data entry is the friction.
- Number of categories tapped vs number completed (tapping a category and not entering an amount is a partial-commit signal).
- Abandonment rate from Screen 4 specifically — if >15%, redesign before public launch.

**Screen 7 (PIN + Recovery)** is the second-highest risk. Instrumentation must capture:
- PIN mismatch rate on re-entry.
- Time spent on the recovery phrase screen — if median <8s, users aren't reading it; if median >45s, the copy is too heavy.
- Biometric adoption rate on capable devices.

### What "drop-off" does NOT mean

Two abandonment patterns are **correct outcomes**, not failures:

1. **Closing on Screen 1 after "Not really"** — this is the qualification working. Track separately under "filtered" rather than "dropped."
2. **Closing on Screen 8 after first S2S view** — this is the user getting what they came for and leaving satisfied. Daily-active is a retention metric, not an onboarding metric. The user will return when they need to check S2S again, which is the entire product loop.

Conflating these with true drop-offs (e.g., abandonment mid-Step 4) will produce misleading metrics and bad redesign decisions.

---

## 10. Completion Success Criteria

### The MVP closed-beta gating thresholds

Per Final Doctrine §4, the headline target is **≥70% onboarding completion unaided**. Below is the disaggregated success matrix that this 70% must be composed of.

| Dimension | Threshold | Severity if missed |
|---|---|---|
| **Overall completion rate (qualified users)** | ≥70% | Doctrine-defined; below this, onboarding fails and is redesigned. |
| Qualification rate (Yes on Q1 / total Q1 views) | 40–60% | If <40%, top-of-funnel positioning is wrong (audience targeting). If >60%, qualifier is too loose. |
| Step 4 (Fixed Costs) completion rate | ≥85% | Below this, the highest-friction screen is broken. |
| Step 7 (PIN + Recovery) completion rate | ≥95% | Below this, the security-friction design has failed; users are bouncing at the safety gate. |
| Median onboarding time (Q1 Yes → Screen 8 load) | ≤180s | Doctrine-defined hard target. |
| P95 onboarding time | ≤300s | Doctrine-defined hard ceiling. |
| First S2S calculation success (Screen 8 renders a non-null S2S) | ≥99% | If <99%, the compute path is broken or input validation is failing silently. |
| User taps the S2S number within first session | ≥30% | Below this, the breakdown-drawer transparency contract is invisible. |
| **S2S comprehension** (qualitative, beta-interview only): user can articulate what the number means | ≥80% | Doctrine-defined; this is the sufficient condition for onboarding-as-trust-handshake. |

### Per-screen abandonment thresholds (caps, not floors)

| Screen | Max acceptable abandonment | If exceeded |
|---|---|---|
| 1. Qualifier | n/a (qualification, not abandonment) | Track separately |
| 2. Email | 15% | Magic Link friction redesign |
| 3. Balance | 8% | Precision-anxiety mitigation; redesign helper copy |
| 4. Fixed costs | 15% | **Highest priority redesign target** |
| 5. Income pattern | 5% | Should be near-zero; investigate UX bug |
| 6. Buffer | 8% | Slider clarity issue; redesign live preview |
| 7. PIN + recovery | 10% | Recovery phrase friction tuning |
| 8. (no abandonment possible — onboarding complete) | — | — |

### What success ultimately measures

The thresholds above are necessary but not sufficient. The **sufficient** success criterion is qualitative:

> **In a 5-minute beta interview, the user, when shown their first S2S number, can explain:**
> 1. What the number represents in their own words.
> 2. How it was calculated (at least the additions and subtractions).
> 3. Why it differs from their bKash balance.

If users can do all three, onboarding has done its real job — installing a mental model of S2S that survives the user closing the app.

If they can do (1) but not (2) or (3), the breakdown drawer is invisible and must be surfaced more aggressively.

If they can't do (1), onboarding has failed regardless of any quantitative metric.

---

## 11. Wireframe Description

Below is the spatial and visual specification for each screen, written at a fidelity sufficient for handing to a Flutter implementer.

### General canvas specs (all screens)

- **Canvas color:** #FAFAF7 (light mode), #0E0E0C (dark mode). Per UX Doctrine §8.
- **Safe-area aware:** Top 44pt and bottom 34pt reserved for system UI on iOS; equivalent on Android.
- **Horizontal padding:** 24pt left and right on all screens.
- **Vertical rhythm:** 8pt grid. All gaps in multiples of 8.
- **Typography:** Inter for UI text. JetBrains Mono for all numeric values. Noto Sans Bengali for Bangla mode.
- **No top navigation bar during onboarding.** No "Back" button, no logo, no header. The screens are full-canvas.
- **Progress indicator:** A single thin horizontal line at the very top of the screen (under the safe-area inset), 2pt tall, in interactive teal. Fills left-to-right as steps complete. **No percentage text. No step numbers ("Step 3 of 7"). Just the line.**

### Screen 1 — Qualifier

```
┌─────────────────────────────────────┐
│ [thin progress line — empty]        │ ← 2pt
│                                     │
│                                     │ ← 80pt top margin
│  Welcome.                           │ ← 32pt Inter Regular
│                                     │ ← 32pt gap
│  Have you ever spent money          │ ← 22pt Inter Regular
│  thinking a Payoneer or Upwork      │   line-height 1.4
│  payment had cleared — then         │
│  realized a bill was due before     │
│  the BDT actually arrived?          │
│                                     │ ← flex spacer
│  ┌───────────────────────────────┐  │
│  │ Yes — that's happened to me   │  │ ← 56pt tall, teal fill
│  └───────────────────────────────┘  │
│                                     │ ← 16pt gap
│  ┌───────────────────────────────┐  │
│  │ Not really                    │  │ ← 56pt tall, teal outline
│  └───────────────────────────────┘  │
│                                     │ ← 40pt bottom margin
└─────────────────────────────────────┘
```

### Screen 2 — Magic Link Email

```
┌─────────────────────────────────────┐
│ [thin progress line — ~12% filled]  │
│                                     │
│                                     │ ← 60pt top margin
│  What email should we use to        │ ← 22pt Inter Medium
│  sign you in?                       │
│                                     │ ← 24pt gap
│  ┌───────────────────────────────┐  │
│  │ name@example.com              │  │ ← 56pt input, monospace
│  └───────────────────────────────┘  │
│                                     │ ← 8pt gap
│  Pocketa uses your email only to    │ ← 13pt Inter Regular,
│  sign you in. No marketing.         │   60% opacity
│  No selling. You can delete         │
│  your account anytime.              │
│                                     │ ← flex spacer
│  ┌───────────────────────────────┐  │
│  │ Send me a link                │  │ ← 56pt tall, teal fill
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

### Screen 3 — Liquid Balance

```
┌─────────────────────────────────────┐
│ [thin progress line — ~25% filled]  │
│                                     │
│                                     │ ← 60pt top margin
│  Roughly how much do you have       │ ← 22pt Inter Medium
│  right now in bKash, bank, and      │
│  cash — combined?                   │
│                                     │ ← 40pt gap
│           ৳  ___________            │ ← input centered,
│                                     │   JetBrains Mono 48pt,
│                                     │   ৳ at half-weight
│                                     │ ← 12pt gap
│      A rough number is fine.        │ ← 14pt Inter Regular,
│      You can refine this later.     │   centered, 60% opacity
│                                     │ ← flex spacer
│  ┌───────────────────────────────┐  │
│  │ Continue                      │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

### Screen 4 — Fixed Costs (collapsed state)

```
┌─────────────────────────────────────┐
│ [thin progress line — ~38% filled]  │
│                                     │
│  What do you pay every month,       │ ← 22pt Inter Medium
│  no matter what?                    │
│                                     │ ← 4pt gap
│  Tap to add. Skip what doesn't      │ ← 14pt secondary
│  apply.                             │
│                                     │ ← 24pt gap
│  ☐  Rent / housing                  │ ← 48pt row,
│  ☐  Internet                        │   16pt left padding,
│  ☐  Mobile / phone                  │   checkbox at left
│  ☐  Subscriptions (Adobe, etc.)     │
│  ☐  Family support / parents        │
│  ☐  Loan EMI                        │
│  ☐  Other recurring expense         │
│                                     │ ← flex spacer
│  ┌───────────────────────────────┐  │
│  │ Continue                      │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

### Screen 4 — Fixed Costs (one item expanded)

```
│  ☑  Rent / housing                  │
│     ┌─────────────────────────┐     │
│     │ Amount: ৳ 18,000        │     │ ← inline, 40pt rows
│     │ Day:    1st of month   ▾│     │
│     │                  [Remove]│     │
│     └─────────────────────────┘     │
│  ☐  Internet                        │
│  ☐  Mobile / phone                  │
│  ...                                │
```

### Screen 5 — Income Pattern

```
┌─────────────────────────────────────┐
│ [thin progress line — ~50% filled]  │
│                                     │
│  How does income usually arrive?    │ ← 22pt Inter Medium
│                                     │ ← 24pt gap
│  ┌───────────────────────────────┐  │
│  │  🟢  (icon, 32pt)             │  │ ← 96pt card,
│  │  Marketplace escrow           │  │   rounded 12pt
│  │  e.g. Upwork, Fiverr, FC      │  │
│  └───────────────────────────────┘  │
│                                     │ ← 12pt gap
│  ┌───────────────────────────────┐  │
│  │  🟢  Direct client invoicing  │  │
│  │  e.g. you send invoices,...   │  │
│  └───────────────────────────────┘  │
│                                     │ ← 12pt gap
│  ┌───────────────────────────────┐  │
│  │  🟢  Retainer or recurring    │  │
│  │  e.g. same client monthly     │  │
│  └───────────────────────────────┘  │
│                                     │ ← flex spacer
│  ┌───────────────────────────────┐  │
│  │ Continue                      │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

### Screen 6 — Buffer Comfort

```
┌─────────────────────────────────────┐
│ [thin progress line — ~63% filled]  │
│                                     │
│  How much of your money should      │ ← 22pt Inter Medium
│  Pocketa keep aside as a            │
│  "don't touch" buffer?              │
│                                     │ ← 4pt gap
│  Recommended: 15%.                  │ ← 14pt secondary
│                                     │ ← 32pt gap
│   5% ─────●──────────────── 30%     │ ← slider, anchored
│                15%                  │   stops at 5/15/25/30
│                                     │ ← 32pt gap
│  Held aside:                        │ ← 14pt secondary,
│  ৳ 7,860                            │   JetBrains Mono 28pt
│                                     │ ← 8pt gap
│  Safe-to-Spend after buffer:        │
│  ৳ 44,540                           │
│                                     │ ← flex spacer
│  ┌───────────────────────────────┐  │
│  │ Continue                      │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

### Screen 7a — PIN Entry

```
┌─────────────────────────────────────┐
│ [thin progress line — ~75% filled]  │
│                                     │
│  Pocketa shows your income.         │ ← 22pt Inter Medium
│  Only you should see it.            │
│                                     │ ← 8pt gap
│  Set a 6-digit PIN.                 │ ← 16pt Inter Regular
│                                     │ ← 40pt gap
│       ○   ○   ○   ○   ○   ○         │ ← dots, 16pt diameter
│                                     │   active dot fills teal
│                                     │ ← flex spacer
│  ┌───────────────────────────────┐  │
│  │ Use Face ID instead           │  │ ← text-only, teal
│  └───────────────────────────────┘  │
│                                     │ ← 16pt gap
│  ┌───────────────────────────────┐  │
│  │ Continue                      │  │ ← active when 6 entered
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

### Screen 7b — Recovery Phrase

```
┌─────────────────────────────────────┐
│ [thin progress line — ~88% filled]  │
│                                     │
│  If you forget your PIN, this is    │ ← 22pt Inter Medium
│  the only way back in.              │
│                                     │ ← 24pt gap
│  ┌───────────────────────────────┐  │
│  │  abandon  ability  able       │  │ ← JetBrains Mono 16pt,
│  │  about    above    absent     │  │   3-column grid,
│  │  absorb   abstract absurd     │  │   24pt row gap
│  │  abuse    access   accident   │  │
│  └───────────────────────────────┘  │
│                                     │ ← 16pt gap
│  [ Copy ]                           │ ← text button, teal
│                                     │ ← 16pt gap
│  Save this somewhere offline.       │ ← 13pt secondary
│  Pocketa cannot recover it          │
│  for you.                           │
│                                     │ ← flex spacer
│  ┌───────────────────────────────┐  │
│  │ I've saved it — Continue      │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

### Screen 8 — S2S Reveal (the home screen, first load)

This screen is the home screen defined in UX Doctrine §4, rendered for the first time. The only onboarding-specific element is the one-time hint:

```
┌─────────────────────────────────────┐
│ Good morning, Mehedi                │ ← 14pt Inter Regular
│ Updated just now                    │ ← 12pt secondary
│                                     │ ← 32pt gap
│                                     │
│            ৳ 44,540.00              │ ← JetBrains Mono 64pt
│           Safe to spend             │ ← 14pt Inter Regular
│           ─────────────             │ ← 2pt sage-green line
│                                     │ ← 8pt gap
│      covers ~18 days at your        │ ← 13pt secondary
│           usual pace                │
│                                     │ ← 16pt gap
│      [ Tap the number to see        │ ← 12pt teal,
│            the math ]               │   one-time hint
│                                     │ ← 32pt gap
│  ↳ Rent           ৳ 18,000  in 12d ●│
│  ↳ Internet       ৳ 1,500   in 2d  ●│
│  ↳ Adobe          ৳ 2,400   in 27d ○│
│                                     │ ← 24pt gap
│  Pending pipeline    (empty)        │ ← Hope tier,
│                                     │   40% opacity
│                                     │
│ ┌──┬──┬──┬──┬──┐         ┌──────┐  │
│ │🏠│📊│📋│⚙ │..│         │  +   │  │ ← bottom tab + FAB
│ └──┴──┴──┴──┴──┘         └──────┘  │
└─────────────────────────────────────┘
```

### Visual hierarchy reminder (per UX Doctrine §3)

| Element | Visual weight |
|---|---|
| S2S number | Dominant (largest typographic element in the entire app) |
| State accent line | Single thin 2pt line, sage/amber/red |
| Threat tier (fixed costs countdown) | Secondary text size, full opacity |
| Hope tier (pipeline) | Smaller, 40% opacity |
| Bottom navigation | Restrained, no filled icons |
| Floating "+" button | Persistent, teal, single affordance |

---

## 12. Implementation Notes

Engineering rules that translate the design above into shippable code. These are mandatory in code review.

### Architecture-level

| # | Rule | Why |
|---|---|---|
| 1 | **No account creation in the database until Screen 1 Q1 = Yes.** | Don't pollute the user table with disqualified users. |
| 2 | **Account-creation transaction must be atomic with email send.** | If email send fails, the account creation rolls back. No half-created users. |
| 3 | **Onboarding state is server-side per user, not client-side.** | If user switches devices mid-onboarding, they resume at the exact step. |
| 4 | **Each step's input writes to the event log immediately on tap "Continue".** | Per UX Doctrine §14, all financial inputs are event-sourced from Day 1. |
| 5 | **S2S calculation on Screen 8 must complete in <50ms** (UX Doctrine §14, Implication 7). | If it takes longer on first render, perceived trust collapses before the user reads the number. |
| 6 | **PIN is hashed (Argon2id) before storage; recovery phrase is BIP-39 standard.** | Industry-standard cryptography; no proprietary schemes. |
| 7 | **Magic Link tokens expire in 15 minutes; one-time use; bound to device ID at creation.** | Prevents replay; reduces account-takeover surface. |
| 8 | **All onboarding strings live in `i18n/onboarding.en.json` and `i18n/onboarding.bn.json`.** | No hardcoded strings in components (UX Doctrine §14, Implication 10). |

### Instrumentation events (closed-beta required)

These events must fire and route to the analytics layer, per Final Doctrine §16:

```
onboarding_started                    { device_id, locale, timestamp }
onboarding_q1_answered                { answer: 'yes' | 'not_really', dwell_ms }
onboarding_disqualified               { reason, optional_email_provided: bool }
onboarding_email_submitted            { domain_hash, timestamp }
onboarding_magic_link_clicked         { time_to_click_ms }
onboarding_step_started               { step: 3-7, timestamp }
onboarding_step_completed             { step: 3-7, duration_ms, edits_count }
onboarding_step_abandoned             { step: 3-7, last_field_touched }
onboarding_fixed_cost_added           { category, amount_bin }  // bins, not exact amounts, for privacy
onboarding_fixed_cost_removed         { category }
onboarding_buffer_changed             { final_pct, drag_count }
onboarding_income_pattern_selected    { pattern }
onboarding_pin_set                    { biometric_enabled: bool, retries }
onboarding_recovery_acknowledged      { dwell_ms, copied: bool }
onboarding_completed                  { total_duration_ms, s2s_value_bin }
onboarding_s2s_first_viewed           { color_state, days_runway_bin }
onboarding_s2s_first_tapped           { time_since_complete_ms }
onboarding_pipeline_first_added       { time_since_complete_ms }
```

**Privacy guardrails on instrumentation:**
- Amounts are reported in bins, never exact (e.g., "10k-25k BDT"), per Final Doctrine §10 privacy stance.
- Email addresses are never logged — only domain-hashes for cohort analysis.
- IP addresses are not logged at the application layer; let the CDN/edge handle them per retention policy.

### Performance gates (CI-enforced)

| Metric | Gate | Failure action |
|---|---|---|
| Screen 1 to Screen 3 cold-start path | P95 < 2.5s | Block deploy |
| Screen 8 first paint after Screen 7 completion | P95 < 800ms | Block deploy |
| S2S calculation time on Screen 8 | P95 < 50ms | Block deploy |
| Bundle size delta per onboarding-touching PR | < 30 KB gzipped | Warn at 30, block at 60 |

### Feature flags

The entire onboarding flow lives behind a feature flag `onboarding_v1` from Day 1, per UX Doctrine §14 Implication 11. This enables:
- Safe rollback if a Doctrine violation ships accidentally.
- Cohort-based gradual rollout in closed beta.
- A/B testing of the qualifying question copy specifically (the **only** A/B test approved for MVP onboarding — all other Doctrine surfaces are not A/B-testable because the Doctrine has already made the decision).

### What is forbidden in onboarding code

For code review enforcement, these patterns must be rejected:

- Any `analytics.track('onboarding_completed', {is_lead: true})` — Pocketa has no lead pipeline.
- Any `notification.schedule()` during onboarding — engagement notifications are forbidden by Doctrine.
- Any `localStorage`-only state — onboarding state must be server-side resumable.
- Any third-party SDK initialized before Screen 1 (Mixpanel, Amplitude, Segment) — first-party only until trust is established.
- Any `setTimeout` for "fake delay" UX — Pocketa does not stage performance theater.

### Testing requirements

Before closed beta:

- **Unit tests** on S2S calculation across the full onboarding-input matrix (≥40 test cases, including edge cases: zero buffer, max liquid balance, no fixed costs, all-7 fixed costs, all 3 income patterns).
- **Integration tests** for the full onboarding flow on a representative low-end device (Samsung A14 or equivalent), end-to-end timing under 5 minutes P95.
- **Accessibility tests:** screen-reader walk-through in English and Bangla. All touch targets ≥44pt. All copy meets WCAG AA contrast (AAA on S2S number).
- **Resume tests:** abandon at every screen, reopen on same device — must resume at exact step. Abandon, reopen on different device with same account — must also resume.
- **Adversarial tests:** invalid emails, 0-balance entry, decimal-only entry (`.5`), Bangla numeric input mixed with Latin, paste-bomb (10,000-char input in balance field).

---

## Closing Note

Mehedi — the onboarding is the moment the entire Pocketa promise is delivered or broken. The seven screens above are not a funnel optimization exercise; they are the trust handshake the Doctrine has been describing all along, made operational.

Three things to internalize before Sprint 1:

1. **The qualifying question is the most important sentence in the entire product.** If it doesn't resonate, fix it before anything else. Test it on five real freelancers from the Onyx Traders community. Watch for the silent nod.

2. **Screen 4 (Fixed Costs) is the abandonment cliff.** If you cut a corner anywhere, do not cut it there. Build the inline-expansion interaction with care; it is the load-bearing UX of the entire onboarding.

3. **Screen 8 (S2S Reveal) must not become a celebration.** The temptation to add confetti, a tour, a welcome banner — that temptation will surface during build. Resist it. The number is the celebration.

The pattern you have warned yourself about — preparation without execution completion — has a specific antidote here: **lock this spec, freeze the Doctrine references, and build only what is on these screens.** No "while we're at it" additions. No "wouldn't it be nice if" feature creep.

The shipped onboarding, not the doctrine of onboarding, is the product.

---

*End of Pocketa Onboarding Redesign. Subordinate to UX Doctrine and Final Product Doctrine. No amendments without an explicit Doctrine review session.*
