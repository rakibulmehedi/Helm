# Pocketa Microcopy System

> **Status:** Microcopy doctrine for MVP and V1 surfaces.  
> **Product stance:** Calm financial cockpit for Bangladeshi USD-earning freelancers.  
> **Core promise:** Help the user understand what money is actually safe to spend, without panic, guilt, hype, or advice claims.  
> **Primary language model:** English-first UI with full Bangla localization. No chaotic Banglish in product UI. Banglish may be used only in marketing, support, or research interviews.

---

## 1. Voice Principles

### 1.1 The one-line voice rule

Pocketa speaks like a calm, precise financial instrument:

> **Clear enough to trust. Quiet enough to calm. Specific enough to act.**

Every line must do one of three jobs:

1. **Reduce anxiety**
2. **Increase trust**
3. **Move the user toward one safe action**

If a line does none of these, remove it.

---

### 1.2 Core voice attributes

| Attribute | Meaning | Use this | Avoid this |
|---|---|---|---|
| Calm | No panic unless math requires attention | `Rent is due in 6 days. Covered.` | `Urgent: Rent is coming soon` |
| Protective | Protects the user from counting money too early | `Not counted yet` | `Available soon` |
| Clear | One sentence, one meaning | `FX rate is missing. Add it to review this payment.` | `Some payment details may need updating` |
| Premium | Restrained, exact, no noise | `Updated 2 min ago · inputs current` | `Hey Mehedi, welcome back` |
| Non-judgmental | States facts, not character | `Safe-to-Spend is ৳0.00 after fixed costs and buffer.` | `You have no spending money` |
| Freelancer-aware | Respects USD → BDT timing uncertainty | `Expected from Upwork · not received yet` | `Income pending` |
| Deterministic | Math, not mood | `after fixed costs + 15% buffer` | `Your financial health looks good` |

---

### 1.3 Copy posture by state

| Product state | Emotional posture | Copy pattern |
|---|---|---|
| Safe | Quiet confirmation | `Safe-to-Spend is ৳32,400.00 after fixed costs + buffer.` |
| Tight | Calm boundary | `Safe-to-Spend is tight. Current BDT covers obligations, but uses part of your buffer.` |
| At Risk | Specific, direct, non-alarming | `Rent is short by ৳3,600 in 4 days.` |
| Unknown / failed calc | Honest repair surface | `Safe-to-Spend is unavailable. Add the missing FX rate to restore it.` |
| Pending / Expected money | Protective boundary | `Not counted yet` |
| Received money | Closure | `Added to liquid BDT` |
| Empty state | Normalized next step | `Add an expected payment when you invoice or expect money.` |
| Delete / export | User sovereignty | `Your data is yours. Export before deleting if you want a copy.` |

---

### 1.4 Sentence rules

**Use:**

- Short sentences.
- Specific numbers.
- Specific timing.
- Consequence-based button labels.
- “Counted” vs “Not counted yet” language.
- “Covered”, “uses buffer”, “short ৳X” for obligations.
- “Unavailable” for calculation failure.
- “Restore” for fixing missing inputs.

**Avoid:**

- Exclamation marks.
- Emojis.
- “Oops”.
- “Congratulations”.
- “Great job”.
- “Don’t worry”.
- “You can do it”.
- “Budget smarter”.
- “Financial health”.
- “Score”.
- “AI insight”.
- “Recommended spending”.
- “You are overspending”.
- “You are broke”.
- “Emergency mode”.
- “Lockdown mode”.
- “Reserve Mode” as user-facing primary copy.

---

### 1.5 Product vocabulary

| Concept | Approved user-facing copy | Notes |
|---|---|---|
| Safe-to-Spend | `Safe-to-Spend` | Keep as product term. Define once in onboarding. |
| Liquid balance | `Liquid BDT` / `Current BDT` | Use helper text: `bKash + bank + cash`. |
| Pending/expected USD | `Not counted yet` | Highest-leverage trust phrase. |
| Fixed costs | `Fixed costs` / `Monthly costs` | Use `Monthly costs` in onboarding if needed. |
| Buffer | `Safety buffer` | Never “savings challenge”. |
| Calculation failure | `Safe-to-Spend unavailable` | Never show wrong zero. |
| Zero S2S | `৳0.00 Safe-to-Spend` | Only when math is valid. |
| At Risk | `At Risk` | Use only when a specific obligation is not covered. |
| Tight | `Tight` | Current BDT covers obligations but eats buffer. |
| Safe | `Safe` | Covered after fixed costs + buffer. |
| Export | `Export data` | Plain and sovereign. |
| Delete | `Delete account and data` | Explicit, not hidden. |
| Privacy | `Your data is not sold.` | Direct, no fluffy promise. |

---

## 2. Forbidden Words/Phrases

### 2.1 Permanently forbidden user-facing phrases

| Forbidden phrase | Why it fails | Replacement |
|---|---|---|
| `You are broke` | Shaming, panic framing | `Safe-to-Spend is ৳0.00 after fixed costs and buffer.` |
| `No money left` | Panic + scarcity framing | `No Safe-to-Spend available right now.` |
| `Overspending` | Moral judgment | `Liquid BDT has decreased by ৳X this week.` |
| `Bad spending habit` | Judgment | `This fixed cost uses part of your buffer.` |
| `Don’t worry` | Fake reassurance | `Rent is covered by current Safe-to-Spend.` |
| `Everything looks fine` | Vague reassurance | `Safe-to-Spend covers 17 days at your usual pace.` |
| `Financial health score` | Competes with S2S | `Safe-to-Spend state` |
| `Budget score` | Gamified + judgmental | Remove |
| `Level up your finances` | Childish gamification | Remove |
| `Streak` | Patronizing | Remove |
| `Smart recommendation` | Advice risk | `Calculation detail` |
| `Pocketa recommends` | Financial advice claim | `Based on your inputs` |
| `Emergency mode` | Alarm | `At Risk` |
| `Reserve Mode activated` | Threatening/system-centric | `Safe-to-Spend is ৳0.00` + reason |
| `Unlock insights` | SaaS hype | `View calculation` |
| `Powered by AI` | Gimmick and trust risk | Remove |
| `You saved ৳X` | Fake motivation | `Held aside as safety buffer: ৳X` |
| `Act now` | Panic/marketing | `Review` |
| `Time is running out` | Fear-based | `Due in 2 days` |
| `Complete your profile` | App-centered nag | Ask only when needed for S2S |

---

### 2.2 Forbidden tone patterns

#### Toxic positivity

Do not use:

```text
You got this.
Keep going.
Small steps, big wins.
Your future self will thank you.
```

Use:

```text
Safe-to-Spend covers 12 days at your usual pace.
```

#### Moralizing advice

Do not use:

```text
Maybe skip eating out this week.
Try to spend less on subscriptions.
You should save more.
```

Use:

```text
Adobe subscription uses ৳2,400 from this month’s fixed costs.
```

#### Corporate accounting language

Do not use:

```text
Liabilities
Receivables aging
Cash position
Reconciliation discrepancy
Working capital
```

Use:

```text
Upcoming fixed costs
Expected payments
Current BDT
Needs review
```

#### Panic framing

Do not use:

```text
Critical alert
You are at serious risk
Payment failure danger
```

Use:

```text
Rent is short by ৳3,600 in 4 days.
```

---

## 3. Dashboard Copy

### 3.1 Dashboard hierarchy

The dashboard copy must follow this order:

1. **Freshness + input confidence**
2. **Safe-to-Spend label**
3. **Safe-to-Spend number**
4. **Meaning line**
5. **State line**
6. **Next obligations**
7. **Not-counted money**
8. **One conditional maintenance action**

---

### 3.2 Top freshness line

| Context | Copy |
|---|---|
| Inputs current | `Updated 2 min ago · inputs current` |
| One input needs review | `Updated 2 min ago · 1 input needs review` |
| Multiple inputs need review | `Updated 2 min ago · 3 inputs need review` |
| Offline with cached data | `Last updated 2 hr ago · offline` |
| Syncing | `Updating calculation…` |
| Sync failed but data usable | `Last updated 12 min ago · sync will retry` |
| Manual refresh complete | `Updated now · inputs current` |

---

### 3.3 Safe-to-Spend hero

#### Normal Safe state

```text
SAFE‑TO‑SPEND

৳32,400.00

after fixed costs + 15% buffer
Safe
```

#### Tight state

```text
SAFE‑TO‑SPEND

৳8,900.00

after fixed costs + 15% buffer
Tight · uses part of your buffer
```

#### At Risk state

```text
SAFE‑TO‑SPEND

৳0.00

Rent short by ৳3,600 in 4 days
At Risk
```

#### Calculation unavailable

```text
SAFE‑TO‑SPEND

—

FX rate missing for 1 payment
Review input
```

#### Offline state

```text
SAFE‑TO‑SPEND

৳32,400.00

last calculated 2 hr ago
Offline
```

---

### 3.4 Meaning lines

| Situation | Copy |
|---|---|
| Normal | `after fixed costs + 15% buffer` |
| Buffer adjusted | `after fixed costs + 20% buffer` |
| No fixed costs | `after your safety buffer` |
| No buffer | `after fixed costs · no buffer set` |
| At Risk | `next fixed cost is not fully covered` |
| Calc unavailable | `calculation needs one missing input` |
| First day after onboarding | `based on the numbers you entered` |

---

### 3.5 Obligation rows

| Context | Copy |
|---|---|
| Covered | `Internet · ৳1,500 · in 2d · covered` |
| Covered later | `Adobe · ৳2,400 · in 11d · later` |
| Eats buffer | `Rent · ৳18,000 · in 6d · uses buffer` |
| Not covered | `Rent · ৳18,000 · in 6d · short ৳3,600` |
| Due today, covered | `Internet · ৳1,500 · today · covered` |
| Due today, not covered | `Internet · ৳1,500 · today · short ৳500` |
| Already paid this cycle | Hide from home; show in History as `Paid this cycle` |

---

### 3.6 Not-counted money block

Use this instead of `Pending pipeline`.

```text
Not counted yet
$1,800 · 2 payments · expected ~Nov 18
```

Alternatives:

| Context | Copy |
|---|---|
| Expected only | `Not counted yet · $1,200 expected` |
| Pending only | `Not counted yet · $1,500 in transit` |
| Mixed states | `Not counted yet · $2,700 across 3 payments` |
| No expected payments | `No expected payments added yet` |
| Missing FX | `Not counted yet · FX missing for 1 payment` |
| Payment overdue | `Not counted yet · 1 payment is overdue` |

---

### 3.7 Maintenance strip

The maintenance strip appears only when action is required. No engagement bait.

| Trigger | Copy | CTA |
|---|---|---|
| Payment expected today | `1 payment expected today` | `Confirm received → updates Safe‑to‑Spend` |
| Multiple payments expected today | `3 payments expected today` | `Review payments` |
| Payment overdue | `1 payment is 7 days overdue` | `Review` |
| Missing FX | `1 input needs review` | `Add FX rate → restores Safe‑to‑Spend` |
| Fixed cost due soon and covered | `Internet ৳1,500 due in 2 days · covered` | `Got it` |
| Fixed cost due soon and not covered | Use At Risk hero, not strip | `Review pipeline` |
| Offline stale data | `Calculation is 2 hr old` | `Refresh when online` |

---

## 4. Onboarding Copy

### 4.1 Onboarding tone

Onboarding is not a tour. It is a trust handshake.

Rules:

- Ask only for data needed to calculate the first Safe-to-Spend number.
- Never ask for income amount during onboarding.
- Never ask for client names during onboarding.
- Never ask for NID, phone number, bank account, or bKash number in MVP.
- Do not explain every feature.
- Do not use “skip” for required S2S inputs.
- Do not celebrate completion.
- The first value moment is the number itself.

---

### 4.2 Screen 1 — qualification

```text
Welcome.

Have you ever spent money thinking a Payoneer or Upwork payment had cleared — then realized a bill was due before the BDT actually arrived?

[ Yes — that has happened to me ]
[ Not really ]
```

#### Plain Bangla help copy

```text
মানে, USD আসবে ভেবে BDT খরচ করেছেন — কিন্তু পরে দেখেছেন টাকা আসার আগেই বিল দিতে হচ্ছে।
```

#### Soft disqualification

```text
Pocketa is built for one specific problem: spending BDT before USD actually arrives.

If that has not happened to you, you probably do not need Pocketa yet. Most people do not.

[ Close ]
[ Tell me when Pocketa supports my use case ]
```

---

### 4.3 Screen 2 — email / magic link

```text
What email should we use to sign you in?

[ email field ]

[ Send sign-in link ]

Pocketa uses your email only to sign you in. No marketing. No selling. You can delete your account anytime.
```

#### Waiting state

```text
Check your email for the sign-in link.
```

#### Resend

```text
No link yet?
[ Send again ]
```

#### Invalid email

```text
Enter a valid email address.
```

---

### 4.4 Screen 3 — liquid balance

```text
Roughly how much do you have right now in bKash, bank, and cash — combined?

[ ৳ _____ ]

A rough number is fine. You can refine it later.

[ Continue ]
```

#### Zero input

```text
Pocketa needs a current BDT amount to calculate Safe-to-Spend.
```

#### Very high input sanity check

```text
This amount looks high. Check once before continuing.
```

---

### 4.5 Screen 4 — fixed costs

```text
What do you pay every month, no matter what?

Tap to add. Skip what does not apply.

[ ] Rent / housing
[ ] Internet
[ ] Mobile / phone
[ ] Subscriptions
[ ] Family support
[ ] Loan EMI
[ ] Other monthly cost

[ Continue ]
```

#### Inline expanded row

```text
Rent / housing

Amount
৳ _____

Usually due around
Day __ of each month
```

#### Zero fixed costs confirmation

```text
No fixed monthly costs?

That is unusual for most freelancers. You can continue and add them later if needed.

[ Continue anyway ]
[ Let me add some ]
```

---

### 4.6 Screen 5 — income pattern

```text
How does your income usually arrive?

[ Marketplace escrow ]
Upwork, Fiverr, Freelancer.com

[ Direct client invoicing ]
You send invoices and clients pay later

[ Mixed ]
Both marketplace and direct clients

[ Continue ]
```

---

### 4.7 Screen 6 — safety buffer

```text
How much should Pocketa hold aside before showing Safe-to-Spend?

15% is a calm default for irregular income.

[ 5% — 30% slider ]

[ Continue ]
```

#### Buffer helper

```text
This is not locked money. It is a safety margin inside the calculation.
```

---

### 4.8 Screen 7 — PIN / biometric

```text
Protect your Pocketa.

Set a PIN so your money view stays private on this device.

[ Set PIN ]
```

#### Biometric option

```text
Use fingerprint or face unlock for faster access.
```

#### PIN mismatch

```text
PINs did not match. Try again.
```

---

### 4.9 First Safe-to-Spend reveal

```text
SAFE‑TO‑SPEND

৳32,400.00

after fixed costs + 15% buffer

This number shows what is safe to spend from current BDT. Expected USD is not counted until received.

[ View calculation ]
[ Add expected payment ]
```

#### If fixed costs exceed liquid balance

```text
Your fixed costs exceed current BDT. Pocketa shows this as it is.
```

---

## 5. Pipeline Copy

### 5.1 Pipeline language model

The pipeline is not “income tracking.” It is a truth-maintenance system.

Use these boundaries:

| Internal state | User-facing label | Counts in S2S? | Copy explanation |
|---|---|---:|---|
| Expected | `Expected` | No | `Work agreed or invoice sent. Not counted yet.` |
| Pending | `Pending` | No | `Client acknowledged or money is in transit. Not counted yet.` |
| Received | `Received` | Yes | `Added to liquid BDT.` |
| Excluded | `Excluded` | No | `Kept out of Safe-to-Spend.` |
| Cancelled | `Cancelled` | No | `Archived. Not counted.` |

---

### 5.2 Pipeline screen title and tabs

```text
Pipeline
Track expected money until it becomes current BDT.
```

Tabs:

```text
All
Expected
Pending
Received
Needs review
```

Do not use:

```text
Income
Receivables
Revenue
Cashflow
```

---

### 5.3 Add expected payment

```text
Add expected payment

Amount
$ _____

Expected date
[ Jun 18 ]

Optional details

Client or source
[ _____ ]

FX rate
[ _____ ] optional

[ Save expected payment ]
```

#### Missing FX helper

```text
You can save without FX. It will stay not counted until reviewed.
```

#### Save success

```text
Expected payment saved. It is not counted in Safe-to-Spend yet.
```

---

### 5.4 Expected → Pending

```text
Move to pending?

Use this when the client has acknowledged the payment or the platform has released it.

[ Move to pending ]
[ Not yet ]
```

Success:

```text
Moved to pending. Still not counted until received.
```

---

### 5.5 Pending → Received confirm sheet

```text
Confirm received

You expected $1,500 from Acme.

At rate
119.66 BDT/USD

You receive
৳1,79,490.00

Date received
Today · 04 Jun 2026

[ Confirm — adds to liquid ]
[ Not yet ]
```

#### FX edit helper

```text
Use the rate you actually received.
```

#### Confirm success

```text
Added to liquid BDT. Safe-to-Spend updated.
```

---

### 5.6 Cancel / exclude

#### Exclude entry

```text
Exclude this payment?

It will stay in Pipeline but will not affect Safe-to-Spend.

[ Exclude payment ]
[ Keep counted as pending ]
```

Success:

```text
Payment excluded. Safe-to-Spend was not affected.
```

#### Cancel entry

```text
Cancel this payment?

Use this if the deal fell through or the payment will not arrive.

[ Cancel payment ]
[ Keep payment ]
```

Success:

```text
Payment cancelled and archived.
```

---

### 5.7 Received-entry correction

Avoid `Received → Pending`.

```text
Need to correct a received payment?

Received payments are already added to liquid BDT. To correct this, delete the received entry and create a new one. The change will be saved in your audit log.

[ Delete received entry ]
[ Keep entry ]
```

---

## 6. Safe-to-Spend Breakdown Copy

### 6.1 Drawer title

```text
Safe‑to‑Spend calculation
as of 2 min ago
```

### 6.2 Default breakdown

```text
Counted in Safe‑to‑Spend

Liquid BDT
৳52,400.00

− Fixed costs next 30 days
৳14,280.00

− Safety buffer 15%
৳5,720.00

Safe‑to‑Spend
৳32,400.00

Not counted yet

Pending payments
$1,800 · 2

Reason
not received
```

---

### 6.3 Boundary explanation

```text
Pocketa never edits Safe‑to‑Spend directly. Edit the inputs to change the number.
```

---

### 6.4 Breakdown row helper copy

| Row | Helper |
|---|---|
| Liquid BDT | `Current BDT in bKash, bank, and cash.` |
| Fixed costs | `Monthly costs due in the next 30 days.` |
| Safety buffer | `Held aside before showing Safe-to-Spend.` |
| Safe-to-Spend | `The amount left after fixed costs and buffer.` |
| Pending payments | `Expected or in-transit USD. Not counted until received.` |
| Missing inputs | `This input is needed to calculate the number.` |

---

### 6.5 Tap explanations

#### Tap Safe-to-Spend row

```text
Safe-to-Spend is calculated from your inputs. It cannot be edited directly.
```

#### Tap buffer row

```text
Your buffer is a safety margin for irregular income. You can adjust it from 5% to 30%.
```

#### Tap pending payments row

```text
Expected and pending payments are not counted until you confirm they have arrived.
```

---

## 7. Zero/Reserve Mode Copy

### 7.1 Naming rule

Do **not** lead with `Reserve Mode` in user-facing copy.

Use:

- `Safe-to-Spend is ৳0.00`
- `Tight`
- `At Risk`
- `uses buffer`
- `short ৳X`

`Reserve Mode` may remain an internal state name, analytics value, or developer label, but not the primary UI language.

---

### 7.2 Valid zero state

Use this when the calculation is valid and S2S equals zero.

```text
SAFE‑TO‑SPEND

৳0.00

after fixed costs + 15% buffer
Current BDT is reserved for upcoming costs.
```

Helper:

```text
This is a valid calculation. Expected USD is still not counted.
```

---

### 7.3 At Risk state

```text
SAFE‑TO‑SPEND

৳0.00

Rent short by ৳3,600 in 4 days
At Risk
```

Action:

```text
Review pipeline
```

---

### 7.4 Tight / buffer-used state

```text
SAFE‑TO‑SPEND

৳8,900.00

uses part of your safety buffer
Tight
```

Helper:

```text
Your fixed costs are covered, but the buffer is partly used.
```

---

### 7.5 Calculation unavailable

Use em dash, never zero.

```text
SAFE‑TO‑SPEND

—

Safe-to-Spend is unavailable.
Add the missing FX rate to restore it.
```

Button:

```text
Review input
```

---

### 7.6 Zero-state breakdown

```text
Counted in Safe‑to‑Spend

Liquid BDT
৳18,000.00

− Fixed costs next 30 days
৳16,000.00

− Safety buffer 15%
৳2,700.00

Safe‑to‑Spend
৳0.00

Not counted yet

Pending payments
$900 · 1

Reason
not received
```

---

## 8. Error Copy

### 8.1 Error principles

Every error must include:

1. What happened.
2. Why it matters.
3. What the user can do next.

Never say only:

```text
Something went wrong.
```

---

### 8.2 Calculation errors

| Error | Copy | CTA |
|---|---|---|
| Missing FX | `FX rate is missing for 1 payment. Safe-to-Spend is unavailable until this is reviewed.` | `Add FX rate` |
| Invalid fixed cost | `One fixed cost has an invalid amount. Review it to restore Safe-to-Spend.` | `Review fixed costs` |
| Date missing | `Expected date is missing for 1 payment. Add a date to keep Pipeline accurate.` | `Add date` |
| Liquid balance missing | `Current BDT is missing. Add your bKash + bank + cash total to restore Safe-to-Spend.` | `Add current BDT` |
| Calculation conflict | `Two inputs conflict. Review recent edits to restore Safe-to-Spend.` | `Review edits` |

---

### 8.3 Sync and offline errors

| Error | Copy | CTA |
|---|---|---|
| Offline | `You are offline. Pocketa is showing the last saved calculation.` | `Retry when online` |
| Sync failed | `Sync did not finish. Your device changes are saved and will retry.` | `Retry sync` |
| Server timeout | `Pocketa could not refresh right now. Last saved calculation is still shown.` | `Try again` |
| Data conflict | `This entry was changed on another device. Review once before saving.` | `Review changes` |
| Export failed | `Export could not be created right now. Your data was not changed.` | `Try again` |

---

### 8.4 Auth and security errors

| Error | Copy | CTA |
|---|---|---|
| Magic link expired | `This sign-in link expired. Send a new link to continue.` | `Send new link` |
| Wrong PIN | `PIN did not match. Try again.` | `Try again` |
| Too many PIN attempts | `Pocketa is locked for a short time to protect your data.` | `Try later` |
| Biometric failed | `Biometric unlock did not work. Use your PIN instead.` | `Use PIN` |
| Session expired | `Your session expired. Sign in again to protect your data.` | `Sign in` |

---

### 8.5 Form validation

| Field | Copy |
|---|---|
| Empty amount | `Enter an amount to continue.` |
| Zero amount | `Amount must be greater than ৳0.` |
| Negative amount | `Use a positive amount.` |
| Suspicious FX | `This FX rate looks far from recent rates. Check once before saving.` |
| Date in far past | `This date is far in the past. Check once before saving.` |
| Date in far future | `This date is far ahead. You can still save if it is correct.` |
| Duplicate entry | `This looks similar to an existing payment. Review before saving.` |

---

### 8.6 Destructive action errors

| Error | Copy |
|---|---|
| Delete failed | `Delete did not finish. Your data is unchanged.` |
| Export before delete failed | `Export could not be created. Your account was not deleted.` |
| Account deletion interrupted | `Deletion did not finish. Your account is still active.` |
| Audit log unavailable | `Edit history could not load right now. Try again before making changes.` |

---

## 9. Empty State Copy

### 9.1 Home — no pipeline yet

```text
Not counted yet

No expected payments added yet.

Add an expected payment when you invoice or expect money. Pocketa will keep it out of Safe-to-Spend until received.
```

CTA:

```text
Add expected payment
```

---

### 9.2 Pipeline — empty

```text
No payments in Pipeline yet.

When you expect USD from a client or marketplace, add it here. Pocketa will track it until it becomes current BDT.
```

CTA:

```text
Add expected payment
```

---

### 9.3 Fixed costs — empty

```text
No fixed costs added.

If you pay rent, internet, subscriptions, family support, or EMI monthly, add them here so Safe-to-Spend stays honest.
```

CTA:

```text
Add fixed cost
```

---

### 9.4 History — empty

```text
No history yet.

Edits, received payments, exports, and deletions will appear here once they happen.
```

---

### 9.5 Notifications — empty

```text
No notifications.

Pocketa only notifies you when a payment needs review or a fixed cost may affect Safe-to-Spend.
```

---

### 9.6 Search — no results

```text
No matching payments found.

Try client name, amount, or payment state.
```

---

### 9.7 Export history — empty

```text
No exports yet.

Create an export anytime from Settings.
```

---

### 9.8 Needs review — empty

```text
Nothing needs review.

Safe-to-Spend is using your current inputs.
```

---

## 10. Notification Copy

### 10.1 Notification doctrine

Notifications exist only for:

1. **Transactional truth maintenance**
2. **Mathematical proximity to harm**

No marketing, no habit nudges, no streaks, no “we miss you.”

Every notification must include:

- A specific number.
- A clear implication.
- One action.
- No emoji.
- No exclamation mark.
- No vague urgency.

---

### 10.2 Transactional notifications

| Trigger | Push copy | Tap action |
|---|---|---|
| Payment expected today | `Acme $1,500 is expected today. Confirm received to update Safe-to-Spend.` | Confirm sheet |
| Payment overdue | `Acme $1,500 is 7 days overdue. Review to keep Safe-to-Spend current.` | Pipeline filtered |
| FX missing | `FX rate is missing for Acme $1,500. Add it to restore Safe-to-Spend.` | FX edit |
| Fixed cost due soon, covered | `Internet ৳1,500 is due in 2 days. Covered by current Safe-to-Spend.` | Obligation detail |
| Fixed cost due today, covered | `Internet ৳1,500 is due today. Covered by current Safe-to-Spend.` | Obligation detail |
| Export ready | `Your Pocketa export is ready.` | Export screen |
| Account deletion requested | `Account deletion requested. Data will be removed after confirmation.` | Deletion screen |

---

### 10.3 Boundary notifications

| Trigger | Push copy | Tap action |
|---|---|---|
| S2S becomes Tight | `Safe-to-Spend is now ৳14,400. Current BDT covers costs but uses buffer.` | Home |
| S2S becomes At Risk | `Rent ৳18,000 is due in 4 days. Current BDT is short by ৳3,600.` | Review pipeline |
| Liquid BDT below buffer | `Current BDT has moved below your 15% buffer.` | Breakdown |
| Calculation unavailable | `Safe-to-Spend is unavailable. One input needs review.` | Repair surface |
| Stale data | `Safe-to-Spend was last updated 8 hr ago. Refresh when online.` | Refresh |

---

### 10.4 Notification preference copy

```text
Notifications

Pocketa sends only two kinds of alerts: payment reviews and Safe-to-Spend boundary changes.

[ Payment reviews ]
Expected, pending, or overdue payments that need confirmation.

[ Safety boundary alerts ]
Tight or At Risk changes that may affect fixed costs.

[ Quiet hours ]
No notifications from 10 PM to 8 AM.
```

#### Disabling boundary alerts

```text
Turn off safety boundary alerts?

Pocketa will stop notifying you when Safe-to-Spend becomes Tight or At Risk. You can still check the app anytime.

[ Turn off ]
[ Keep alerts on ]
```

---

## 11. Trust/Privacy Copy

### 11.1 Trust posture

Pocketa’s privacy copy must be factual, short, and non-defensive.

Avoid:

```text
We take your privacy very seriously.
Your security is our top priority.
Bank-grade security.
Military-grade encryption.
```

Use:

```text
Your data is not sold.
You can export your data anytime.
You can delete your account anytime.
Pocketa does not move money.
```

---

### 11.2 Privacy surface copy

#### Settings privacy card

```text
Privacy

Pocketa uses your financial inputs only to calculate Safe-to-Spend and show your history.

Your data is not sold.
Pocketa does not move money.
You can export or delete your data anytime.
```

CTAs:

```text
Export data
Delete account and data
View privacy policy
```

---

### 11.3 Data export

```text
Export your data

Create a CSV copy of your Pipeline, fixed costs, received payments, and edit history.

[ Create export ]
```

Export ready:

```text
Your export is ready.

[ Download CSV ]
```

Export helper:

```text
Exports include your financial inputs. Keep the file somewhere private.
```

---

### 11.4 Account deletion

```text
Delete account and data

This removes your Pocketa account, Pipeline, fixed costs, history, and saved settings.

This cannot be undone.

[ Export data first ]
[ Delete account and data ]
```

Confirmation:

```text
Type DELETE to confirm.
```

Final confirmation:

```text
Account deletion confirmed. Your data will be removed.
```

Cancellation:

```text
Deletion cancelled. Your account is unchanged.
```

---

### 11.5 Audit log

```text
Edit history

Every financial edit is saved here so you can see what changed and when.
```

Entry examples:

```text
FX rate changed from 118.40 to 119.20 BDT/USD.
Expected date changed from Jun 14 to Jun 18.
Payment confirmed received and added to liquid BDT.
Fixed cost updated from ৳1,200 to ৳1,500.
```

---

### 11.6 Permission copy

#### Biometrics

```text
Use fingerprint or face unlock

This unlocks Pocketa faster on this device. Your biometric data stays on your device.
```

#### Notifications

```text
Allow notifications

Pocketa will only notify you when a payment needs review or Safe-to-Spend changes state.
```

#### No bank access

```text
Pocketa does not connect to your bank or bKash in MVP. You enter the numbers you want it to use.
```

---

## 12. Bangla Copy Direction

### 12.1 Bangla voice rule

Bangla copy should feel like:

> **শান্ত, পরিণত, পরিষ্কার, অযথা ভয় না দেখানো, এবং freelancer reality-aware.**

It should not feel like:

- Bank notice.
- Motivational Facebook post.
- Sales copy.
- Childish app gamification.
- Overly formal government language.

---

### 12.2 Bangla style rules

| Rule | Direction |
|---|---|
| Pronoun | Avoid direct `তুমি`/`আপনি` where possible. Use neutral system copy. |
| Tone | Soft-formal. Respectful but not stiff. |
| Numbers | Use Bangladeshi grouping: `৳১,৩২,৪০০.০০` if Bangla digits are enabled. |
| Currency | Use `৳` for BDT and `$` for USD. Do not write “টাকা” repeatedly near numbers. |
| English product terms | Keep `Safe-to-Spend` as product term initially, with Bangla explanation. |
| Mixed language | Avoid casual Banglish in the app. Use either full English or full Bangla. |
| Warning tone | Use specific facts, not fear. |
| Buttons | Short verbs. No emotional pressure. |

---

### 12.3 Bangla glossary

| English | Bangla direction |
|---|---|
| Safe-to-Spend | `নিরাপদে খরচযোগ্য` as explanatory label, but keep product term `Safe-to-Spend` in hero if needed. |
| Current BDT | `বর্তমান BDT` / `বর্তমান টাকা` |
| Liquid BDT | `বর্তমানে হাতে থাকা BDT` |
| Fixed costs | `নিয়মিত মাসিক খরচ` |
| Safety buffer | `সেফটি বাফার` / `নিরাপত্তা মার্জিন` |
| Not counted yet | `এখনও যোগ হয়নি` |
| Counted | `হিসাবে যোগ হয়েছে` |
| Covered | `কভার হয়েছে` |
| Uses buffer | `বাফারের অংশ ব্যবহার হচ্ছে` |
| Short ৳X | `৳X কম আছে` |
| Expected payment | `প্রত্যাশিত পেমেন্ট` |
| Pending payment | `প্রসেসিং পেমেন্ট` / `অপেক্ষমান পেমেন্ট` |
| Received | `পাওয়া হয়েছে` |
| Review | `রিভিউ করুন` / `দেখে নিন` |
| Export | `ডেটা এক্সপোর্ট` |
| Delete account | `অ্যাকাউন্ট ও ডেটা মুছুন` |

---

### 12.4 Bangla sample copy

#### Dashboard Safe

```text
SAFE‑TO‑SPEND

৳৩২,৪০০.০০

নিয়মিত খরচ + ১৫% বাফার বাদ দেওয়ার পর
Safe
```

#### Not counted yet

```text
এখনও যোগ হয়নি
$১,৮০০ · ২টি পেমেন্ট · সম্ভাব্য Nov 18
```

#### Covered obligation

```text
ইন্টারনেট · ৳১,৫০০ · ২ দিনের মধ্যে · কভার হয়েছে
```

#### At Risk

```text
ভাড়া ৳৩,৬০০ কম আছে · ৪ দিনের মধ্যে দিতে হবে
```

#### Missing input

```text
Safe-to-Spend এখন দেখানো যাচ্ছে না।
১টি FX rate যোগ করলে হিসাব আবার দেখা যাবে।
```

#### Privacy

```text
Pocketa আপনার ডেটা বিক্রি করে না।
আপনি যেকোনো সময় ডেটা এক্সপোর্ট বা মুছে ফেলতে পারবেন।
```

---

### 12.5 Bangla phrases to avoid

| Avoid | Why |
|---|---|
| `চিন্তা করবেন না` | Fake reassurance |
| `আপনি সমস্যায় আছেন` | Panic framing |
| `আপনার টাকা শেষ` | Shame + panic |
| `স্মার্ট হন` | Judgmental |
| `খরচ কমান` | Financial advice |
| `অভিনন্দন` | Not appropriate for financial truth |
| `লেভেল আপ` | Gamification |
| `আপনি ব্যর্থ হয়েছেন` | Shame |
| `জরুরি সতর্কতা` | Alarm unless legally required |
| `বিশেষ অফার` | Marketing, not product UX |

---

## 13. Implementation Copy Table

> Suggested structure: keep these strings in a single localization layer. Do not hardcode strings inside components. Use variable placeholders consistently.

### 13.1 Global string tokens

| Key | Surface | Context | English copy | Bangla direction |
|---|---|---|---|---|
| `global.safe_to_spend` | Global | Product term | `Safe‑to‑Spend` | Keep term; explain as `নিরাপদে খরচযোগ্য টাকা` |
| `global.not_counted_yet` | Global | Expected/pending money | `Not counted yet` | `এখনও যোগ হয়নি` |
| `global.counted` | Global | Included money | `Counted` | `হিসাবে যোগ হয়েছে` |
| `global.covered` | Global | Obligation covered | `covered` | `কভার হয়েছে` |
| `global.uses_buffer` | Global | Obligation eats buffer | `uses buffer` | `বাফার ব্যবহার হচ্ছে` |
| `global.short_amount` | Global | Obligation shortage | `short {amount}` | `{amount} কম আছে` |
| `global.review` | Global | Review action | `Review` | `দেখে নিন` |
| `global.current_inputs` | Global | Input confidence | `inputs current` | `ইনপুট আপডেটেড` |
| `global.needs_review` | Global | Input issue | `{count} input needs review` | `{count}টি ইনপুট দেখে নিতে হবে` |
| `global.updated_ago` | Global | Freshness | `Updated {time} ago` | `{time} আগে আপডেট হয়েছে` |
| `global.offline` | Global | Offline | `offline` | `অফলাইন` |
| `global.try_again` | Global | Retry | `Try again` | `আবার চেষ্টা করুন` |

---

### 13.2 Onboarding strings

| Key | Surface | Context | English copy | Bangla direction |
|---|---|---|---|---|
| `onboarding.qual.title` | Onboarding | Screen 1 title | `Welcome.` | `স্বাগতম।` |
| `onboarding.qual.question` | Onboarding | Qualification | `Have you ever spent money thinking a Payoneer or Upwork payment had cleared — then realized a bill was due before the BDT actually arrived?` | Natural Bangla memory-probe, not formal survey |
| `onboarding.qual.yes` | Onboarding | Button | `Yes — that has happened to me` | `হ্যাঁ, এমন হয়েছে` |
| `onboarding.qual.no` | Onboarding | Button | `Not really` | `না, তেমন না` |
| `onboarding.qual.help` | Onboarding | Helper | `Meaning, you spent BDT because USD seemed on the way, but the bill came before the money arrived.` | Plain Bangla explanation |
| `onboarding.disqual.body` | Onboarding | Soft disqualify | `Pocketa is built for one specific problem: spending BDT before USD actually arrives.` | Boundary as fact, no judgment |
| `onboarding.email.title` | Onboarding | Email | `What email should we use to sign you in?` | `সাইন ইনের জন্য কোন ইমেইল ব্যবহার করবেন?` |
| `onboarding.email.privacy` | Onboarding | Privacy note | `Pocketa uses your email only to sign you in. No marketing. No selling. You can delete your account anytime.` | Direct, factual |
| `onboarding.balance.title` | Onboarding | Liquid balance | `Roughly how much do you have right now in bKash, bank, and cash — combined?` | `bKash, bank, cash মিলিয়ে এখন আনুমানিক কত আছে?` |
| `onboarding.balance.helper` | Onboarding | Helper | `A rough number is fine. You can refine it later.` | `আনুমানিক দিলেই হবে। পরে ঠিক করতে পারবেন।` |
| `onboarding.fixed.title` | Onboarding | Fixed costs | `What do you pay every month, no matter what?` | `প্রতি মাসে নিয়মিত কী কী খরচ দিতে হয়?` |
| `onboarding.fixed.helper` | Onboarding | Helper | `Tap to add. Skip what does not apply.` | `যেটা লাগে সেটি যোগ করুন। বাকিগুলো বাদ দিন।` |
| `onboarding.fixed.zero.title` | Onboarding | Zero fixed cost | `No fixed monthly costs?` | `কোনো নিয়মিত মাসিক খরচ নেই?` |
| `onboarding.fixed.zero.body` | Onboarding | Zero fixed cost | `That is unusual for most freelancers. You can continue and add them later if needed.` | Calm recheck |
| `onboarding.income.title` | Onboarding | Income pattern | `How does your income usually arrive?` | `আপনার ইনকাম সাধারণত কীভাবে আসে?` |
| `onboarding.buffer.title` | Onboarding | Buffer | `How much should Pocketa hold aside before showing Safe-to-Spend?` | `Safe-to-Spend দেখানোর আগে কতটুকু বাফার ধরে রাখবে?` |
| `onboarding.buffer.helper` | Onboarding | Buffer | `This is not locked money. It is a safety margin inside the calculation.` | `এটা লক করা টাকা নয়; হিসাবের নিরাপত্তা মার্জিন।` |
| `onboarding.pin.title` | Onboarding | Security | `Protect your Pocketa.` | `আপনার Pocketa সুরক্ষিত করুন।` |
| `onboarding.reveal.explain` | Onboarding | FVM | `This number shows what is safe to spend from current BDT. Expected USD is not counted until received.` | Core explanation |

---

### 13.3 Dashboard strings

| Key | Surface | Context | English copy | Bangla direction |
|---|---|---|---|---|
| `home.fresh.current` | Dashboard | Current inputs | `Updated {time} ago · inputs current` | `{time} আগে আপডেট · ইনপুট আপডেটেড` |
| `home.fresh.review` | Dashboard | Input needs review | `Updated {time} ago · {count} input needs review` | `{time} আগে আপডেট · {count}টি ইনপুট দেখে নিতে হবে` |
| `home.hero.meaning.default` | Dashboard | Meaning line | `after fixed costs + {buffer}% buffer` | `নিয়মিত খরচ + {buffer}% বাফার বাদ দিয়ে` |
| `home.hero.safe` | Dashboard | Safe state | `Safe` | `Safe` or `নিরাপদ` |
| `home.hero.tight` | Dashboard | Tight state | `Tight · uses part of your buffer` | `Tight · বাফারের অংশ ব্যবহার হচ্ছে` |
| `home.hero.risk` | Dashboard | At Risk | `{costName} short by {amount} in {days} days` | `{costName} {amount} কম আছে · {days} দিনের মধ্যে` |
| `home.hero.unavailable` | Dashboard | Calculation unavailable | `Safe-to-Spend is unavailable.` | `Safe-to-Spend এখন দেখানো যাচ্ছে না।` |
| `home.hero.unavailable.reason.fx` | Dashboard | Missing FX | `FX rate missing for {count} payment` | `{count}টি পেমেন্টে FX rate নেই` |
| `home.obligation.covered` | Dashboard | Row | `{name} · {amount} · in {days}d · covered` | `{name} · {amount} · {days} দিনের মধ্যে · কভার হয়েছে` |
| `home.obligation.short` | Dashboard | Row | `{name} · {amount} · in {days}d · short {shortAmount}` | `{name} · {amount} · {days} দিনের মধ্যে · {shortAmount} কম` |
| `home.not_counted.summary` | Dashboard | Hope tier | `{usdAmount} · {count} payments · expected ~{date}` | `{usdAmount} · {count}টি পেমেন্ট · সম্ভাব্য {date}` |
| `home.maintenance.payment_today` | Dashboard | Maintenance strip | `{count} payment expected today` | `আজ {count}টি পেমেন্ট প্রত্যাশিত` |
| `home.maintenance.confirm_received` | Dashboard | CTA | `Confirm received → updates Safe‑to‑Spend` | `পাওয়া হয়েছে নিশ্চিত করুন → Safe-to-Spend আপডেট হবে` |
| `home.maintenance.add_fx` | Dashboard | CTA | `Add FX rate → restores Safe‑to‑Spend` | `FX rate যোগ করুন → Safe-to-Spend আবার দেখা যাবে` |

---

### 13.4 Pipeline strings

| Key | Surface | Context | English copy | Bangla direction |
|---|---|---|---|---|
| `pipeline.title` | Pipeline | Title | `Pipeline` | `Pipeline` / `পেমেন্ট Pipeline` |
| `pipeline.subtitle` | Pipeline | Subtitle | `Track expected money until it becomes current BDT.` | `প্রত্যাশিত টাকা বর্তমান BDT হওয়া পর্যন্ত ট্র্যাক করুন।` |
| `pipeline.state.expected` | Pipeline | State | `Expected` | `প্রত্যাশিত` |
| `pipeline.state.pending` | Pipeline | State | `Pending` | `অপেক্ষমান` |
| `pipeline.state.received` | Pipeline | State | `Received` | `পাওয়া হয়েছে` |
| `pipeline.state.excluded` | Pipeline | State | `Excluded` | `বাদ দেওয়া` |
| `pipeline.state.cancelled` | Pipeline | State | `Cancelled` | `বাতিল` |
| `pipeline.add.title` | Pipeline | Add sheet | `Add expected payment` | `প্রত্যাশিত পেমেন্ট যোগ করুন` |
| `pipeline.add.amount` | Pipeline | Field | `Amount` | `Amount` / `পরিমাণ` |
| `pipeline.add.date` | Pipeline | Field | `Expected date` | `প্রত্যাশিত তারিখ` |
| `pipeline.add.client` | Pipeline | Field | `Client or source` | `ক্লায়েন্ট বা সোর্স` |
| `pipeline.add.fx` | Pipeline | Field | `FX rate` | `FX rate` |
| `pipeline.add.fx_optional` | Pipeline | Helper | `You can save without FX. It will stay not counted until reviewed.` | `FX ছাড়া সেভ করা যাবে। রিভিউ না করা পর্যন্ত এটি যোগ হবে না।` |
| `pipeline.add.success` | Pipeline | Success | `Expected payment saved. It is not counted in Safe-to-Spend yet.` | `প্রত্যাশিত পেমেন্ট সেভ হয়েছে। Safe-to-Spend-এ এখনও যোগ হয়নি।` |
| `pipeline.confirm.title` | Pipeline | Confirm sheet | `Confirm received` | `পাওয়া হয়েছে নিশ্চিত করুন` |
| `pipeline.confirm.expected` | Pipeline | Confirm sheet | `You expected {amount} from {source}.` | `{source} থেকে {amount} প্রত্যাশিত ছিল।` |
| `pipeline.confirm.receive` | Pipeline | Confirm sheet | `You receive {amount}` | `আপনি পাবেন {amount}` |
| `pipeline.confirm.cta` | Pipeline | Button | `Confirm — adds to liquid` | `নিশ্চিত করুন — বর্তমান BDT-তে যোগ হবে` |
| `pipeline.confirm.not_yet` | Pipeline | Tertiary | `Not yet` | `এখনও না` |
| `pipeline.confirm.success` | Pipeline | Success | `Added to liquid BDT. Safe-to-Spend updated.` | `বর্তমান BDT-তে যোগ হয়েছে। Safe-to-Spend আপডেট হয়েছে।` |
| `pipeline.exclude.title` | Pipeline | Exclude | `Exclude this payment?` | `এই পেমেন্ট বাদ দেবেন?` |
| `pipeline.exclude.body` | Pipeline | Exclude | `It will stay in Pipeline but will not affect Safe-to-Spend.` | `Pipeline-এ থাকবে, কিন্তু Safe-to-Spend-এ প্রভাব ফেলবে না।` |
| `pipeline.cancel.title` | Pipeline | Cancel | `Cancel this payment?` | `এই পেমেন্ট বাতিল করবেন?` |
| `pipeline.cancel.body` | Pipeline | Cancel | `Use this if the deal fell through or the payment will not arrive.` | Calm literal explanation |

---

### 13.5 Breakdown strings

| Key | Surface | Context | English copy | Bangla direction |
|---|---|---|---|---|
| `breakdown.title` | Breakdown | Title | `Safe‑to‑Spend calculation` | `Safe-to-Spend হিসাব` |
| `breakdown.as_of` | Breakdown | Timestamp | `as of {time}` | `{time} অনুযায়ী` |
| `breakdown.counted` | Breakdown | Section | `Counted in Safe‑to‑Spend` | `Safe-to-Spend-এ যোগ হয়েছে` |
| `breakdown.liquid_bdt` | Breakdown | Row | `Liquid BDT` | `বর্তমানে হাতে থাকা BDT` |
| `breakdown.fixed_costs` | Breakdown | Row | `Fixed costs next 30 days` | `পরবর্তী ৩০ দিনের নিয়মিত খরচ` |
| `breakdown.buffer` | Breakdown | Row | `Safety buffer {percent}%` | `সেফটি বাফার {percent}%` |
| `breakdown.not_counted` | Breakdown | Section | `Not counted yet` | `এখনও যোগ হয়নি` |
| `breakdown.pending_payments` | Breakdown | Row | `Pending payments` | `অপেক্ষমান পেমেন্ট` |
| `breakdown.reason.not_received` | Breakdown | Reason | `not received` | `এখনও পাওয়া যায়নি` |
| `breakdown.boundary` | Breakdown | Explanation | `Pocketa never edits Safe‑to‑Spend directly. Edit the inputs to change the number.` | Direct Bangla, no lecture |

---

### 13.6 Zero / At Risk strings

| Key | Surface | Context | English copy | Bangla direction |
|---|---|---|---|---|
| `zero.valid.meaning` | Zero S2S | Valid zero | `Current BDT is reserved for upcoming costs.` | `বর্তমান BDT আসন্ন খরচের জন্য ধরা আছে।` |
| `zero.valid.helper` | Zero S2S | Helper | `This is a valid calculation. Expected USD is still not counted.` | `এটি সঠিক হিসাব। প্রত্যাশিত USD এখনও যোগ হয়নি।` |
| `risk.short_line` | At Risk | Hero reason | `{costName} short by {amount} in {days} days` | `{costName} {amount} কম আছে · {days} দিনের মধ্যে` |
| `tight.buffer_line` | Tight | Buffer used | `Current BDT covers costs, but uses part of your buffer.` | `বর্তমান BDT খরচ কভার করে, তবে বাফারের অংশ ব্যবহার হচ্ছে।` |
| `calc.unavailable.title` | Error | Repair surface | `Safe-to-Spend is unavailable.` | `Safe-to-Spend এখন দেখানো যাচ্ছে না।` |
| `calc.unavailable.fx` | Error | Missing FX | `Add the missing FX rate to restore it.` | `FX rate যোগ করলে হিসাব আবার দেখা যাবে।` |

---

### 13.7 Error strings

| Key | Surface | Context | English copy | Bangla direction |
|---|---|---|---|---|
| `error.fx_missing` | Error | Missing FX | `FX rate is missing for {count} payment. Safe-to-Spend is unavailable until this is reviewed.` | Direct Bangla |
| `error.fixed_invalid` | Error | Invalid fixed cost | `One fixed cost has an invalid amount. Review it to restore Safe-to-Spend.` | Direct Bangla |
| `error.date_missing` | Error | Missing date | `Expected date is missing for {count} payment. Add a date to keep Pipeline accurate.` | Direct Bangla |
| `error.balance_missing` | Error | Missing liquid BDT | `Current BDT is missing. Add your bKash + bank + cash total to restore Safe-to-Spend.` | Direct Bangla |
| `error.offline` | Error | Offline | `You are offline. Pocketa is showing the last saved calculation.` | Direct Bangla |
| `error.sync_failed` | Error | Sync | `Sync did not finish. Your device changes are saved and will retry.` | Direct Bangla |
| `error.magic_expired` | Auth | Expired link | `This sign-in link expired. Send a new link to continue.` | Direct Bangla |
| `error.pin_wrong` | Auth | PIN | `PIN did not match. Try again.` | Direct Bangla |
| `error.delete_failed` | Delete | Failure | `Delete did not finish. Your data is unchanged.` | Direct Bangla |
| `error.export_failed` | Export | Failure | `Export could not be created right now. Your data was not changed.` | Direct Bangla |

---

### 13.8 Empty state strings

| Key | Surface | Context | English copy | Bangla direction |
|---|---|---|---|---|
| `empty.home.no_pipeline.title` | Home | No pipeline | `No expected payments added yet.` | `এখনও কোনো প্রত্যাশিত পেমেন্ট যোগ হয়নি।` |
| `empty.home.no_pipeline.body` | Home | No pipeline | `Add an expected payment when you invoice or expect money. Pocketa will keep it out of Safe-to-Spend until received.` | Direct Bangla |
| `empty.pipeline.title` | Pipeline | No entries | `No payments in Pipeline yet.` | `Pipeline-এ এখনও কোনো পেমেন্ট নেই।` |
| `empty.pipeline.body` | Pipeline | No entries | `When you expect USD from a client or marketplace, add it here.` | Direct Bangla |
| `empty.fixed.title` | Fixed costs | No fixed costs | `No fixed costs added.` | `কোনো নিয়মিত খরচ যোগ হয়নি।` |
| `empty.history.title` | History | No history | `No history yet.` | `এখনও কোনো history নেই।` |
| `empty.review.title` | Needs review | No issues | `Nothing needs review.` | `দেখে নেওয়ার মতো কিছু নেই।` |
| `empty.review.body` | Needs review | No issues | `Safe-to-Spend is using your current inputs.` | `Safe-to-Spend বর্তমান ইনপুট দিয়ে হিসাব করছে।` |

---

### 13.9 Notification strings

| Key | Surface | Context | English copy | Bangla direction |
|---|---|---|---|---|
| `notif.payment_today` | Push | Payment today | `{source} {amount} is expected today. Confirm received to update Safe-to-Spend.` | Direct Bangla |
| `notif.payment_overdue` | Push | Overdue | `{source} {amount} is {days} days overdue. Review to keep Safe-to-Spend current.` | Direct Bangla |
| `notif.fx_missing` | Push | Missing FX | `FX rate is missing for {source} {amount}. Add it to restore Safe-to-Spend.` | Direct Bangla |
| `notif.cost_due_covered` | Push | Covered cost | `{name} {amount} is due in {days} days. Covered by current Safe-to-Spend.` | Direct Bangla |
| `notif.s2s_tight` | Push | Tight | `Safe-to-Spend is now {amount}. Current BDT covers costs but uses buffer.` | Direct Bangla |
| `notif.s2s_risk` | Push | At Risk | `{name} {amount} is due in {days} days. Current BDT is short by {shortAmount}.` | Direct Bangla |
| `notif.calc_unavailable` | Push | Error | `Safe-to-Spend is unavailable. One input needs review.` | Direct Bangla |
| `notif.export_ready` | Push | Export | `Your Pocketa export is ready.` | Direct Bangla |

---

### 13.10 Privacy / data strings

| Key | Surface | Context | English copy | Bangla direction |
|---|---|---|---|---|
| `privacy.title` | Settings | Privacy | `Privacy` | `Privacy` / `গোপনীয়তা` |
| `privacy.body` | Settings | Privacy | `Pocketa uses your financial inputs only to calculate Safe-to-Spend and show your history.` | Direct Bangla |
| `privacy.not_sold` | Settings | Trust | `Your data is not sold.` | `আপনার ডেটা বিক্রি করা হয় না।` |
| `privacy.no_money_move` | Settings | Trust | `Pocketa does not move money.` | `Pocketa টাকা স্থানান্তর করে না।` |
| `privacy.export_anytime` | Settings | Trust | `You can export your data anytime.` | `যেকোনো সময় ডেটা এক্সপোর্ট করতে পারবেন।` |
| `privacy.delete_anytime` | Settings | Trust | `You can delete your account anytime.` | `যেকোনো সময় অ্যাকাউন্ট মুছতে পারবেন।` |
| `export.title` | Export | Start | `Export your data` | `ডেটা এক্সপোর্ট করুন` |
| `export.body` | Export | Start | `Create a CSV copy of your Pipeline, fixed costs, received payments, and edit history.` | Direct Bangla |
| `export.warning` | Export | Privacy | `Exports include your financial inputs. Keep the file somewhere private.` | Direct Bangla |
| `delete.title` | Delete | Start | `Delete account and data` | `অ্যাকাউন্ট ও ডেটা মুছুন` |
| `delete.body` | Delete | Start | `This removes your Pocketa account, Pipeline, fixed costs, history, and saved settings.` | Direct Bangla |
| `delete.irreversible` | Delete | Warning | `This cannot be undone.` | `এটি ফিরিয়ে আনা যাবে না।` |
| `delete.type_confirm` | Delete | Confirmation | `Type DELETE to confirm.` | `নিশ্চিত করতে DELETE লিখুন।` |
| `delete.cancelled` | Delete | Cancel | `Deletion cancelled. Your account is unchanged.` | Direct Bangla |

---

## Final Copy QA Checklist

Before shipping any Pocketa string, check:

- [ ] Does it state a fact instead of a feeling?
- [ ] Does it avoid blame, shame, and panic?
- [ ] Does it include a number when the user needs one?
- [ ] Does it make counted vs not-counted money clear?
- [ ] Does it avoid financial advice claims?
- [ ] Does it avoid hype, emoji, exclamation marks, and gamification?
- [ ] Does it explain what the next tap will do?
- [ ] Does it respect Bangladeshi money formatting?
- [ ] Does it work in Bangla without becoming taller than the layout can handle?
- [ ] Does it belong in the localization layer, not inside a component?

---

## Final Principle

Pocketa should never sound like it is trying to motivate the user.

It should sound like it is protecting the truth of the number.
