# Microcopy Requirements — Extracted from Pocketa Microcopy System

> **Source:** `docs/research/ux/Pocketa_Microcopy_System.md`
> **Authority level:** Copy authority for all user-facing text in Pocketa MVP and V1.
> **Extraction date:** 2026-06-04

---

## 1. Tone and Voice Rules

### COPY-001: One-Line Voice Rule

**Statement:** Every line of copy must do one of three jobs: (1) reduce anxiety, (2) increase trust, or (3) move the user toward one safe action. If a line does none of these, remove it.

**Rationale:** Pocketa speaks like a calm, precise financial instrument: "Clear enough to trust. Quiet enough to calm. Specific enough to act."

**Implementation implication:** Every string in the localization layer must be auditable against these three criteria. No decorative or filler copy is permitted.

---

### COPY-002: Core Voice Attributes

**Statement:** Pocketa copy must be Calm, Protective, Clear, Premium, Non-judgmental, Freelancer-aware, and Deterministic.

**Rationale:** Each attribute maps to a specific behavior:

| Attribute | Use this | Avoid this |
|---|---|---|
| Calm | `Rent is due in 6 days. Covered.` | `Urgent: Rent is coming soon` |
| Protective | `Not counted yet` | `Available soon` |
| Clear | `FX rate is missing. Add it to review this payment.` | `Some payment details may need updating` |
| Premium | `Updated 2 min ago - inputs current` | `Hey Mehedi, welcome back` |
| Non-judgmental | `Safe-to-Spend is tk0.00 after fixed costs and buffer.` | `You have no spending money` |
| Freelancer-aware | `Expected from Upwork - not received yet` | `Income pending` |
| Deterministic | `after fixed costs + 15% buffer` | `Your financial health looks good` |

**Implementation implication:** Widget and screen copy must be validated against this attribute table. No greeting-heavy, chatty, motivational, or vague copy.

---

### COPY-003: Copy Posture by Product State

**Statement:** Each product state has a defined emotional posture and copy pattern.

| Product state | Emotional posture | Copy pattern |
|---|---|---|
| Safe | Quiet confirmation | `Safe-to-Spend is tk32,400.00 after fixed costs + buffer.` |
| Tight | Calm boundary | `Safe-to-Spend is tight. Current BDT covers obligations, but uses part of your buffer.` |
| At Risk | Specific, direct, non-alarming | `Rent is short by tk3,600 in 4 days.` |
| Unknown / failed calc | Honest repair surface | `Safe-to-Spend is unavailable. Add the missing FX rate to restore it.` |
| Pending / Expected | Protective boundary | `Not counted yet` |
| Received money | Closure | `Added to liquid BDT` |
| Empty state | Normalized next step | `Add an expected payment when you invoice or expect money.` |
| Delete / export | User sovereignty | `Your data is yours. Export before deleting if you want a copy.` |

**Rationale:** Emotional posture must match mathematical state, not be generic.

**Implementation implication:** State-driven copy must be wired to the S2S calculation engine output. Copy strings must be selected by state enum, not hardcoded.

---

### COPY-004: Sentence Rules

**Statement:** Use short sentences, specific numbers, specific timing, consequence-based button labels, and the "Counted" vs "Not counted yet" language. Use "Covered", "uses buffer", "short tkX" for obligations. Use "Unavailable" for calculation failure. Use "Restore" for fixing missing inputs.

**Rationale:** Precision builds trust; vagueness creates doubt.

**Implementation implication:** All CTA buttons must use verb-led, consequence-aware labels (e.g., "Confirm received -- updates Safe-to-Spend"). No generic "OK", "Submit", "Done" labels.

---

### COPY-005: Forbidden Sentence Patterns

**Statement:** Never use exclamation marks, emojis, or any of these phrases: "Oops", "Congratulations", "Great job", "Don't worry", "You can do it", "Budget smarter", "Financial health", "Score", "AI insight", "Recommended spending", "You are overspending", "You are broke", "Emergency mode", "Lockdown mode", "Reserve Mode" as user-facing primary copy.

**Rationale:** These patterns cause panic, fake reassurance, gamification, moral judgment, or financial advice risk.

**Implementation implication:** A copy QA checklist must be run before shipping any string. Lint or review step needed.

---

## 2. Label Conventions

### COPY-006: Product Vocabulary (Approved User-Facing Terms)

**Statement:** Use only approved user-facing terms for core concepts.

| Concept | Approved copy | Notes |
|---|---|---|
| Safe-to-Spend | `Safe-to-Spend` | Product term. Define once in onboarding. |
| Liquid balance | `Liquid BDT` / `Current BDT` | Helper text: `bKash + bank + cash` |
| Pending/expected USD | `Not counted yet` | Highest-leverage trust phrase. |
| Fixed costs | `Fixed costs` / `Monthly costs` | `Monthly costs` in onboarding if needed. |
| Buffer | `Safety buffer` | Never "savings challenge". |
| Calculation failure | `Safe-to-Spend unavailable` | Never show wrong zero. |
| Zero S2S | `tk0.00 Safe-to-Spend` | Only when math is valid. |
| At Risk | `At Risk` | Only when a specific obligation is not covered. |
| Tight | `Tight` | BDT covers obligations but eats buffer. |
| Safe | `Safe` | Covered after fixed costs + buffer. |
| Export | `Export data` | Plain and sovereign. |
| Delete | `Delete account and data` | Explicit, not hidden. |
| Privacy | `Your data is not sold.` | Direct, no fluffy promise. |

**Rationale:** Consistent vocabulary builds the product's mental model in the user's mind.

**Implementation implication:** All strings must use these exact terms. Localization keys must map to these concepts. No synonyms in different screens.

---

### COPY-007: Forbidden User-Facing Phrases with Replacements

**Statement:** The following phrases are permanently forbidden with mandatory replacements.

| Forbidden | Replacement |
|---|---|
| `You are broke` | `Safe-to-Spend is tk0.00 after fixed costs and buffer.` |
| `No money left` | `No Safe-to-Spend available right now.` |
| `Overspending` | `Liquid BDT has decreased by tkX this week.` |
| `Bad spending habit` | `This fixed cost uses part of your buffer.` |
| `Don't worry` | `Rent is covered by current Safe-to-Spend.` |
| `Everything looks fine` | `Safe-to-Spend covers 17 days at your usual pace.` |
| `Financial health score` | `Safe-to-Spend state` |
| `Smart recommendation` | `Calculation detail` |
| `Pocketa recommends` | `Based on your inputs` |
| `Emergency mode` | `At Risk` |
| `Reserve Mode activated` | `Safe-to-Spend is tk0.00` + reason |
| `Unlock insights` | `View calculation` |
| `Powered by AI` | Remove |
| `You saved tkX` | `Held aside as safety buffer: tkX` |
| `Act now` | `Review` |
| `Time is running out` | `Due in 2 days` |
| `Complete your profile` | Ask only when needed for S2S |

**Rationale:** Each forbidden phrase fails on panic, shame, gamification, financial advice risk, or SaaS hype.

**Implementation implication:** Copy review must check all strings against this table. Any match is a blocking issue.

---

### COPY-008: Forbidden Tone Patterns

**Statement:** Four tone patterns are permanently banned.

1. **Toxic positivity:** No "You got this", "Keep going", "Small steps, big wins", "Your future self will thank you." Use: `Safe-to-Spend covers 12 days at your usual pace.`
2. **Moralizing advice:** No "Maybe skip eating out", "Try to spend less", "You should save more." Use: `Adobe subscription uses tk2,400 from this month's fixed costs.`
3. **Corporate accounting language:** No "Liabilities", "Receivables aging", "Cash position", "Reconciliation discrepancy", "Working capital." Use: `Upcoming fixed costs`, `Expected payments`, `Current BDT`, `Needs review`.
4. **Panic framing:** No "Critical alert", "You are at serious risk", "Payment failure danger." Use: `Rent is short by tk3,600 in 4 days.`

**Rationale:** Each pattern violates the calm, non-judgmental, freelancer-aware voice.

**Implementation implication:** Copy authors and reviewers must know all four categories. No pattern is acceptable even if the individual words seem fine.

---

## 3. Button and CTA Label Conventions

### COPY-009: Consequence-Based Button Labels

**Statement:** Buttons must use verb-led labels that describe the consequence, not generic confirmations.

Examples from the system:
- `Confirm received -- updates Safe-to-Spend` (not "OK")
- `Add FX rate -- restores Safe-to-Spend` (not "Submit")
- `Review payments` (not "View")
- `Confirm -- adds to liquid` (not "Confirm")
- `Delete account and data` (not "Delete")
- `Send sign-in link` (not "Submit")
- `Continue anyway` / `Let me add some` (not "Skip" / "Add")
- `Export data first` (not "Export")
- `Move to pending` / `Not yet` (not "Yes" / "No")
- `Keep alerts on` / `Turn off` (not "OK" / "Cancel")

**Rationale:** Consequence-based labels reduce anxiety by telling the user exactly what will happen.

**Implementation implication:** Every button string in the localization layer must describe what happens when tapped.

---

## 4. Error Message Patterns

### COPY-010: Error Message Structure

**Statement:** Every error must include three parts: (1) what happened, (2) why it matters, and (3) what the user can do next. Never say only "Something went wrong."

**Rationale:** Vague errors destroy trust in a financial app.

**Implementation implication:** All error strings must have a body + CTA pair. No standalone error text without an action.

---

### COPY-011: Calculation Error Copy

**Statement:** Specific calculation error strings are defined:

| Error | Copy | CTA |
|---|---|---|
| Missing FX | `FX rate is missing for 1 payment. Safe-to-Spend is unavailable until this is reviewed.` | `Add FX rate` |
| Invalid fixed cost | `One fixed cost has an invalid amount. Review it to restore Safe-to-Spend.` | `Review fixed costs` |
| Date missing | `Expected date is missing for 1 payment. Add a date to keep Pipeline accurate.` | `Add date` |
| Liquid balance missing | `Current BDT is missing. Add your bKash + bank + cash total to restore Safe-to-Spend.` | `Add current BDT` |
| Calculation conflict | `Two inputs conflict. Review recent edits to restore Safe-to-Spend.` | `Review edits` |

**Rationale:** Calculation errors directly affect the core S2S promise and must name the missing input specifically.

**Implementation implication:** Error handlers must map to specific error types and select the correct localization key.

---

### COPY-012: Sync and Offline Error Copy

**Statement:** Defined copy for connectivity-related states:

| Error | Copy | CTA |
|---|---|---|
| Offline | `You are offline. Pocketa is showing the last saved calculation.` | `Retry when online` |
| Sync failed | `Sync did not finish. Your device changes are saved and will retry.` | `Retry sync` |
| Server timeout | `Pocketa could not refresh right now. Last saved calculation is still shown.` | `Try again` |
| Data conflict | `This entry was changed on another device. Review once before saving.` | `Review changes` |
| Export failed | `Export could not be created right now. Your data was not changed.` | `Try again` |

**Rationale:** Offline/sync errors must reassure that data is safe while being honest about staleness.

**Implementation implication:** Offline state detection must be wired to the copy layer to show appropriate freshness/staleness messaging.

---

### COPY-013: Auth and Security Error Copy

**Statement:** Authentication errors use specific, non-alarming copy:

| Error | Copy | CTA |
|---|---|---|
| Magic link expired | `This sign-in link expired. Send a new link to continue.` | `Send new link` |
| Wrong PIN | `PIN did not match. Try again.` | `Try again` |
| Too many PIN attempts | `Pocketa is locked for a short time to protect your data.` | `Try later` |
| Biometric failed | `Biometric unlock did not work. Use your PIN instead.` | `Use PIN` |
| Session expired | `Your session expired. Sign in again to protect your data.` | `Sign in` |

**Rationale:** Security errors must protect without creating panic.

**Implementation implication:** Each auth error state needs a dedicated string and CTA mapping.

---

### COPY-014: Form Validation Copy

**Statement:** Inline validation messages must be specific and calm:

| Field | Copy |
|---|---|
| Empty amount | `Enter an amount to continue.` |
| Zero amount | `Amount must be greater than tk0.` |
| Negative amount | `Use a positive amount.` |
| Suspicious FX | `This FX rate looks far from recent rates. Check once before saving.` |
| Date in far past | `This date is far in the past. Check once before saving.` |
| Date in far future | `This date is far ahead. You can still save if it is correct.` |
| Duplicate entry | `This looks similar to an existing payment. Review before saving.` |

**Rationale:** Validation copy should nudge verification, not block or blame.

**Implementation implication:** Validation messages must be attached to form fields as localization keys, not hardcoded inline.

---

## 5. Success and Confirmation Message Patterns

### COPY-015: Success Message Patterns

**Statement:** Success messages confirm the consequence and its effect on S2S, without celebration.

| Action | Success copy |
|---|---|
| Save expected payment | `Expected payment saved. It is not counted in Safe-to-Spend yet.` |
| Move to pending | `Moved to pending. Still not counted until received.` |
| Confirm received | `Added to liquid BDT. Safe-to-Spend updated.` |
| Exclude payment | `Payment excluded. Safe-to-Spend was not affected.` |
| Cancel payment | `Payment cancelled and archived.` |
| Account deletion confirmed | `Account deletion confirmed. Your data will be removed.` |
| Deletion cancelled | `Deletion cancelled. Your account is unchanged.` |
| Export ready | `Your export is ready.` |

**Rationale:** Success copy must close the loop by stating the S2S impact. No "Congratulations", no celebration.

**Implementation implication:** Every mutation action must show a toast/confirmation that references the S2S consequence.

---

## 6. Number Formatting Rules

### COPY-016: BDT Formatting (Lakh/Crore Grouping)

**Statement:** BDT uses Bangladeshi lakh/crore grouping: `tk 1,32,400.00`, not `tk 132,400.00`. Always show two decimal places.

**Rationale:** Cultural fluency is non-negotiable. Bangladeshi users read numbers in lakh/crore grouping.

**Implementation implication:** A custom BDT formatter must be written (the `intl` package does not support lakh/crore natively). Unit test against 30+ edge cases.

---

### COPY-017: USD Formatting (Western Grouping)

**Statement:** USD uses Western thousand grouping: `$ 1,800.00`, not `$ 1,80,000.00`. Always show two decimal places.

**Rationale:** USD follows international convention even for Bangladeshi users.

**Implementation implication:** Standard Western number formatting for USD amounts. Separate formatter from BDT.

---

### COPY-018: Currency Symbol Weight

**Statement:** Currency symbol (tk or $) is rendered at half the weight of the number. E.g., tk at weight 400 next to `32,400` at weight 600.

**Rationale:** The number is the primary information; the symbol is context. Bold symbols compete visually.

**Implementation implication:** `PocketaAmount` widget must apply different font weights to symbol vs digits.

---

### COPY-019: Negative Values Use Parentheses

**Statement:** Negative values use parentheses, not minus signs: `(tk 4,200.00)`, not `-tk 4,200.00`.

**Rationale:** Accounting convention that reads as professional and non-alarming.

**Implementation implication:** Number formatter must wrap negative values in parentheses.

---

### COPY-020: BDT Precedes USD in Dual-Currency Display

**Statement:** In dual-currency contexts, BDT appears above USD vertically: `tk 1,79,500.00` above `$ 1,500.00 @ 119.66`.

**Rationale:** BDT is the user's spending reality; USD is the source context.

**Implementation implication:** All dual-currency widgets must stack BDT on top.

---

### COPY-021: Zero vs Unknown Distinction

**Statement:** Zero (`tk 0.00`) is used only when the math is valid and the result is actually zero. An em dash (`--`) is used when the calculation is unavailable or the value is unknown. Zero is never a placeholder for "unknown."

**Rationale:** Displaying zero when the real answer is unknown is a trust violation.

**Implementation implication:** S2S display widget must check calculation validity state before rendering the number. Invalid state shows em dash.

---

## 7. Placeholder Text Conventions

### COPY-022: Form Field Placeholder Patterns

**Statement:** Form placeholders use the currency symbol prefix and underscores, never example values.

Examples:
- Amount fields: `tk _____` or `$ _____`
- Date fields: `Day __ of each month`
- Text fields: `_____` (no fake data)

**Rationale:** Example values in placeholders can be mistaken for pre-filled data.

**Implementation implication:** All input fields must use symbol + underscore pattern. No "e.g." or example amounts.

---

### COPY-023: Helper Text Below Fields

**Statement:** Helper text appears below input fields to reduce anxiety about precision.

Examples:
- Liquid balance: `A rough number is fine. You can refine it later.`
- FX rate: `Use the rate you actually received.`
- Buffer: `This is not locked money. It is a safety margin inside the calculation.`
- Missing FX save: `You can save without FX. It will stay not counted until reviewed.`

**Rationale:** Helper text reduces abandonment by normalizing imprecision where acceptable.

**Implementation implication:** Every financial input field must have a helper text localization key.

---

## 8. Tooltip and Help Text Rules

### COPY-024: Breakdown Row Helper Copy

**Statement:** Each row in the S2S Calculation Breakdown has defined helper text:

| Row | Helper |
|---|---|
| Liquid BDT | `Current BDT in bKash, bank, and cash.` |
| Fixed costs | `Monthly costs due in the next 30 days.` |
| Safety buffer | `Held aside before showing Safe-to-Spend.` |
| Safe-to-Spend | `The amount left after fixed costs and buffer.` |
| Pending payments | `Expected or in-transit USD. Not counted until received.` |
| Missing inputs | `This input is needed to calculate the number.` |

**Rationale:** The breakdown is Pocketa's trust theater. Every row must be self-explanatory.

**Implementation implication:** Helper text is shown inline below each row, not as tooltips that require tap-and-hold.

---

### COPY-025: Tap Explanation Copy

**Statement:** Tapping calculation rows reveals educational explanations:

- Tap S2S row: `Safe-to-Spend is calculated from your inputs. It cannot be edited directly.`
- Tap buffer row: `Your buffer is a safety margin for irregular income. You can adjust it from 5% to 30%.`
- Tap pending row: `Expected and pending payments are not counted until you confirm they have arrived.`

**Rationale:** Progressive disclosure builds understanding without overwhelming the home screen.

**Implementation implication:** Breakdown rows must be tappable with expansion animation to reveal helper text.

---

### COPY-026: Boundary Explanation

**Statement:** The breakdown drawer includes a non-editable boundary explanation: `Pocketa never edits Safe-to-Spend directly. Edit the inputs to change the number.`

**Rationale:** Prevents user confusion about why S2S cannot be manually adjusted.

**Implementation implication:** This string appears at the bottom of every breakdown drawer instance.

---

## 9. Bangladesh-Specific Language Considerations

### COPY-027: Language Model Rule

**Statement:** English-first UI with full Bangla localization. No chaotic Banglish in product UI. Banglish may be used only in marketing, support, or research interviews.

**Rationale:** Mixed Banglish undermines the premium, trustworthy voice.

**Implementation implication:** Two complete localization files (en, bn). No mixed-language strings within a single locale.

---

### COPY-028: Bangla Voice Rule

**Statement:** Bangla copy must feel calm, mature, clear, non-fear-inducing, and freelancer reality-aware. It must not feel like a bank notice, motivational Facebook post, sales copy, childish gamification, or overly formal government language.

**Rationale:** Bangla fintech copy in Bangladesh tends toward either bank-formal or casual-sales. Pocketa needs a distinct middle.

**Implementation implication:** Bangla copy must be authored by a Bangladesh-resident copywriter, not machine-translated.

---

### COPY-029: Bangla Style Rules

**Statement:** Specific Bangla writing rules:

| Rule | Direction |
|---|---|
| Pronoun | Avoid direct `tumi`/`apni` where possible. Use neutral system copy. |
| Tone | Soft-formal. Respectful but not stiff. |
| Numbers | Use Bangladeshi grouping with Bangla digits if enabled. |
| Currency | Use tk for BDT, $ for USD. Do not write "taka" repeatedly near numbers. |
| English product terms | Keep `Safe-to-Spend` as product term initially, with Bangla explanation. |
| Mixed language | Avoid casual Banglish. Use either full English or full Bangla. |
| Warning tone | Use specific facts, not fear. |
| Buttons | Short verbs. No emotional pressure. |

**Rationale:** These rules prevent the Bangla copy from drifting into common fintech patterns.

**Implementation implication:** Bangla localization review must check all rules. Product terms like "Safe-to-Spend" and "Pipeline" may remain in English with Bangla explanatory labels.

---

### COPY-030: Bangla Glossary

**Statement:** Core terms have defined Bangla translations:

| English | Bangla |
|---|---|
| Safe-to-Spend | `nirapade khorchjogyo` (explanatory); keep product term in hero |
| Current BDT | `bortomane hate thaka BDT` |
| Fixed costs | `niyomito mashik khoroch` |
| Safety buffer | `safety buffer` / `nirapotta margin` |
| Not counted yet | `ekhono jog hoyni` |
| Covered | `cover hoyeche` |
| Uses buffer | `buffer-er ongsh bybohar hochche` |
| Short tkX | `tkX kom ache` |
| Expected payment | `prottyashito payment` |
| Received | `pawa hoyeche` |
| Review | `review korun` / `dekhe nin` |
| Export | `data export` |
| Delete account | `account o data muchun` |

**Rationale:** Consistent Bangla vocabulary across all screens.

**Implementation implication:** Bangla localization file must use these exact terms. No freelance translation allowed.

---

### COPY-031: Bangla Phrases to Avoid

**Statement:** The following Bangla phrases are permanently banned:

| Avoid | Why |
|---|---|
| `chinta korben na` | Fake reassurance |
| `apni somossay achen` | Panic framing |
| `apnar taka shesh` | Shame + panic |
| `smart hon` | Judgmental |
| `khoroch koman` | Financial advice |
| `abhinondon` | Not appropriate for financial truth |
| `level up` | Gamification |
| `apni byortho hoyechen` | Shame |
| `joruri shotorkota` | Alarm unless legally required |
| `bishesh offer` | Marketing, not product UX |

**Rationale:** Same voice principles apply in Bangla as in English. Bangla-specific patterns must be explicitly banned.

**Implementation implication:** Bangla copy review must check against this list as a blocking criterion.

---

## 10. Microcopy Anti-Patterns

### COPY-032: Reserve Mode Naming Rule

**Statement:** Do not lead with "Reserve Mode" in user-facing copy. Use: `Safe-to-Spend is tk0.00`, `Tight`, `At Risk`, `uses buffer`, `short tkX`. "Reserve Mode" may remain as an internal state name or analytics value only.

**Rationale:** "Reserve Mode activated" feels threatening and system-centric. The user needs to see the math, not a mode label.

**Implementation implication:** No UI string should contain the phrase "Reserve Mode" as primary text.

---

### COPY-033: No Generic Greetings

**Statement:** The product never opens with "Hey Mehedi, welcome back" or any personalized greeting on the home screen.

**Rationale:** Premium restraint. The home screen is an instrument readout, not a social greeting. The freshness timestamp (`Updated 2 min ago - inputs current`) is the only "greeting."

**Implementation implication:** Home screen top line is always the freshness/timestamp line, not a user name.

---

### COPY-034: No "Skip" for Required S2S Inputs

**Statement:** During onboarding, do not use "Skip" for inputs required to calculate S2S. "Skip what does not apply" is acceptable only for optional items within a category (e.g., individual fixed cost types).

**Rationale:** Skipping required inputs breaks the core promise.

**Implementation implication:** Onboarding flow must distinguish required vs optional inputs and never show "Skip" on required screens.

---

### COPY-035: No Celebration of Completion

**Statement:** Do not celebrate onboarding completion. The first value moment is the S2S number itself, not a "You're all set!" screen.

**Rationale:** Celebration trivializes the financial tool. The number appearing is the reward.

**Implementation implication:** Onboarding ends with the S2S reveal screen, not a congratulations screen.

---

## 11. Dashboard Copy Hierarchy

### COPY-036: Dashboard Copy Order

**Statement:** The dashboard copy must follow this exact order:

1. Freshness + input confidence
2. Safe-to-Spend label
3. Safe-to-Spend number
4. Meaning line
5. State line
6. Next obligations
7. Not-counted money
8. One conditional maintenance action

**Rationale:** This order matches the user's anxiety-resolution sequence: "Is this current?" then "What can I spend?" then "Am I safe?" then "What's coming?"

**Implementation implication:** Home screen widget tree must enforce this order. No reordering by feature flags or A/B tests.

---

### COPY-037: Freshness Line Patterns

**Statement:** The top line of the dashboard is always a freshness indicator:

| Context | Copy |
|---|---|
| Inputs current | `Updated 2 min ago - inputs current` |
| One input needs review | `Updated 2 min ago - 1 input needs review` |
| Multiple inputs | `Updated 2 min ago - 3 inputs need review` |
| Offline | `Last updated 2 hr ago - offline` |
| Syncing | `Updating calculation...` |
| Sync failed | `Last updated 12 min ago - sync will retry` |
| Manual refresh | `Updated now - inputs current` |

**Rationale:** Freshness is the first trust signal. Stale data must be visible.

**Implementation implication:** Freshness line requires a timestamp service, input validation counter, and connectivity state.

---

### COPY-038: Obligation Row Patterns

**Statement:** Obligation rows follow a strict format: `{name} - {amount} - {timing} - {status}`.

| Context | Copy |
|---|---|
| Covered | `Internet - tk1,500 - in 2d - covered` |
| Covered later | `Adobe - tk2,400 - in 11d - later` |
| Eats buffer | `Rent - tk18,000 - in 6d - uses buffer` |
| Not covered | `Rent - tk18,000 - in 6d - short tk3,600` |
| Due today, covered | `Internet - tk1,500 - today - covered` |
| Due today, not covered | `Internet - tk1,500 - today - short tk500` |
| Already paid | Hide from home; show in History as `Paid this cycle` |

**Rationale:** Consistent row format enables scanning without reading.

**Implementation implication:** Obligation row widget must accept name, amount, days, and coverage state as parameters and render the correct pattern.

---

### COPY-039: Not-Counted Money Block

**Statement:** The pending money section uses "Not counted yet" as its header, never "Pending pipeline."

| Context | Copy |
|---|---|
| Expected only | `Not counted yet - $1,200 expected` |
| Pending only | `Not counted yet - $1,500 in transit` |
| Mixed states | `Not counted yet - $2,700 across 3 payments` |
| No expected | `No expected payments added yet` |
| Missing FX | `Not counted yet - FX missing for 1 payment` |
| Payment overdue | `Not counted yet - 1 payment is overdue` |

**Rationale:** "Not counted yet" is the highest-leverage trust phrase in the product. It tells the user their pending money is visible but protected from spending.

**Implementation implication:** The "Not counted yet" header is a global string token used across dashboard, breakdown, and pipeline screens.

---

### COPY-040: Maintenance Strip Patterns

**Statement:** The maintenance strip appears only when action is required. No engagement bait.

| Trigger | Copy | CTA |
|---|---|---|
| Payment expected today | `1 payment expected today` | `Confirm received -- updates Safe-to-Spend` |
| Payment overdue | `1 payment is 7 days overdue` | `Review` |
| Missing FX | `1 input needs review` | `Add FX rate -- restores Safe-to-Spend` |
| Fixed cost due, covered | `Internet tk1,500 due in 2 days - covered` | `Got it` |
| Fixed cost due, not covered | Use At Risk hero, not strip | `Review pipeline` |
| Offline stale data | `Calculation is 2 hr old` | `Refresh when online` |

**Rationale:** Maintenance actions should not compete with the S2S number. They appear only when the math needs human input.

**Implementation implication:** Maintenance strip visibility is driven by pipeline state + input validation, not by engagement timers.

---

## 12. Notification Copy Rules

### COPY-041: Notification Doctrine

**Statement:** Notifications exist only for (1) transactional truth maintenance and (2) mathematical proximity to harm. No marketing, habit nudges, streaks, or "we miss you." Every notification must include: a specific number, a clear implication, one action, no emoji, no exclamation mark, no vague urgency.

**Rationale:** Notification abuse is the fastest way to lose trust with Bangladeshi freelancers who are already overwhelmed by app notifications.

**Implementation implication:** Notification triggers must be tied to calculation events and pipeline state changes only. No time-based or engagement-based triggers.

---

## 13. Trust and Privacy Copy

### COPY-042: Trust Copy Rules

**Statement:** Privacy copy must be factual, short, and non-defensive. Avoid: "We take your privacy very seriously", "Bank-grade security", "Military-grade encryption." Use: "Your data is not sold", "You can export your data anytime", "You can delete your account anytime", "Pocketa does not move money."

**Rationale:** Defensive privacy language implies the opposite. Factual statements are more trustworthy.

**Implementation implication:** Privacy surface in Settings must show these four statements directly. No marketing-style trust badges.

---

### COPY-043: No Bank Access Statement

**Statement:** The app must clearly state: `Pocketa does not connect to your bank or bKash in MVP. You enter the numbers you want it to use.`

**Rationale:** Proactively addresses the biggest trust concern: "Will this app access my money?"

**Implementation implication:** This statement appears in onboarding and in the Settings privacy card.

---

## 14. Implementation String Tokens

### COPY-044: Localization Architecture

**Statement:** All strings must be kept in a single localization layer. No hardcoded strings inside components. Use variable placeholders consistently (e.g., `{amount}`, `{source}`, `{days}`, `{count}`, `{time}`, `{name}`, `{percent}`).

**Rationale:** Localization consistency and Bangla parity require centralized string management.

**Implementation implication:** The Microcopy System provides complete string token tables (sections 13.1 through 13.10) covering global, onboarding, dashboard, pipeline, breakdown, zero/at-risk, error, empty state, notification, and privacy strings. These must be the basis for the localization files.

---

## 15. Final Copy QA Checklist

### COPY-045: Pre-Ship Copy Checklist

**Statement:** Before shipping any Pocketa string, verify:

1. Does it state a fact instead of a feeling?
2. Does it avoid blame, shame, and panic?
3. Does it include a number when the user needs one?
4. Does it make counted vs not-counted money clear?
5. Does it avoid financial advice claims?
6. Does it avoid hype, emoji, exclamation marks, and gamification?
7. Does it explain what the next tap will do?
8. Does it respect Bangladeshi money formatting?
9. Does it work in Bangla without becoming taller than the layout can handle?
10. Does it belong in the localization layer, not inside a component?

**Rationale:** This is the final gate before any copy reaches users.

**Implementation implication:** Add this checklist to the PR review template for any change that touches localization files or UI text.

---

### COPY-046: Final Principle

**Statement:** Pocketa should never sound like it is trying to motivate the user. It should sound like it is protecting the truth of the number.

**Rationale:** This is the north star for every copy decision. When in doubt, choose truth-protection over motivation.

**Implementation implication:** This principle must be referenced in every copy review and every onboarding of new team members or agents working on copy.
