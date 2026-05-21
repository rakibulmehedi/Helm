# Subscription Leakage Radar — Future Phase Spec

> Status: FUTURE PHASE — NOT IMPLEMENTATION READY
> Depends on: Recurring transaction detection, Transaction categorization
> Phase: 9 (candidate, per ROADMAP.md)
> Last Updated: 2026-05-22

---

## 1. Problem Statement

Freelancers unknowingly accumulate SaaS subscription costs through behavioral patterns that actively prevent awareness and action:

- **"Death by a thousand cuts":** Micro-SaaS charges ($10-20/month) accumulate into massive hidden annual costs. A $20/month tool is perceived as trivial but costs $240/year.
- **Duration neglect:** Monthly billing obscures annual impact. The brain categorizes auto-debited subscriptions as "background noise" rather than active purchasing decisions.
- **Tool stacking:** Modern freelancer workflows fragment across 2-3 LLMs (ChatGPT, Claude), design tools (Canva, Figma), hosting (DigitalOcean, Vercel), and productivity apps (Notion, Linear).
- **"Future usefulness" justification (option value):** Freelancers retain unused subscriptions because the option to use the tool feels like a safety net against unpredictable client demands.
- **Subscription guilt + sunk cost fallacy:** Acknowledging a $120+ waste on an unused tool causes psychological pain, so users keep the subscription active hoping to "use it enough this month to make up for it."
- **Software dependency (hostage psychology):** Tools like Adobe Creative Cloud hold data hostage, creating anxiety around migration and justifying permanent retention of under-utilized subscriptions.

**Result:** Freelancers cannot accurately answer "What is my actual software operational cost?" or "Which subscriptions actively contribute to my business?"

**Research backing:** SAAS_LEAKAGE_RESEARCH.md — behavioral economics of subscriptions, tool stacking patterns, cancellation psychology

---

## 2. Target Behavior

This feature enables freelancers to:

1. **Discover their subscription ecosystem** — Surface all recurring SaaS charges
2. **Understand true operational cost** — See annualized subscription burn in a non-judgmental, business-focused context
3. **Review quarterly** — Frame subscription auditing as a positive "Quarterly Tech Stack Review" rather than a stressful daily budgeting chore
4. **Make informed retention decisions** — Decide which tools are still valuable without shame or guilt
5. **Separate operational from personal subscriptions** — Distinguish business SaaS (AWS, Claude API) from personal subscriptions (Netflix, Spotify)

---

## 3. MVP Approach

### Phase 1 (MVP) — Manual Stack Builder

- No bank API integration
- Offline-first compatible (no external service calls)
- No privacy concerns
- User selects tools from a pre-populated grid of popular freelancer SaaS providers
- User inputs monthly cost and billing cycle manually
- Dashboard widget displays "SaaS Burn Rate" metric
- Option to mark subscriptions as active/paused/cancelled

### Phase 2 (Future) — Recurring Transaction Detection

- Leverage existing transaction history
- Detect patterns: transactions with similar amounts and merchant names occurring ~30 days apart
- Suggest recurring charges detected from history
- User approves/rejects suggestions

### Phase 3 (Future) — Bank API Sync

- Plaid/Teller integration for ongoing transaction monitoring
- Automatic detection of new recurring charges
- Background processing via Dart Isolate to avoid UI blocking

---

## 4. Data Model Draft

### Subscription Entity

```
Subscription {
  id: String (IdGenerator.uniqueId())
  name: String (e.g., "ChatGPT Plus", "Figma Pro")
  monthlyAmount: Double (normalized to monthly cost)
  billingCycle: Enum (MONTHLY, QUARTERLY, ANNUAL, WEEKLY)
  category: Enum (BUSINESS, PERSONAL)
  status: Enum (ACTIVE, PAUSED, CANCELLED)
  dateAdded: DateTime
  lastReviewedDate: DateTime
  nextBillingDate: DateTime? (calculated from billingCycle)
  notes: String? (optional user notes)
  isAutoDetected: Boolean (true if from transaction detection, false if manual)
  createdAt: DateTime
  updatedAt: DateTime
}
```

### Dashboard Summary (Calculated)

```
SaasBurnSummary {
  totalMonthlyBurn: Double (sum of ACTIVE BUSINESS subscriptions, normalized to monthly)
  totalAnnualizedBurn: Double (monthlyBurn * 12)
  activeCount: Int
  pausedCount: Int
  lastReviewDate: DateTime?
}
```

---

## 5. Detection Strategy

### Phase 1: Manual Entry + Pre-populated Tool List

- User navigates to "SaaS Stack" or "Subscriptions" screen
- Grid of popular tools with logos (ChatGPT, Claude, Figma, AWS, Canva, etc.)
- User taps tool, enters monthly cost, billing cycle, category
- Stores in local Hive database
- No automated detection

**Hypothesis:** A pre-populated list of 50-75 tools covers 80%+ of common freelancer subscriptions. User can also add custom entries.

### Phase 2: Recurring Transaction Pattern Matching

- Group transactions by normalized merchant name
- For each group with 2+ transactions, calculate average days between charges
- If average is 27-33 days and amounts are similar (within 2 BDT variance), flag as potential subscription
- Present detected subscriptions to user for approval/rejection
- Run asynchronously via Dart Isolate to avoid blocking main UI thread
- Cache known SaaS merchant name signatures locally

### Phase 3: Bank API Sync

- Plaid/Teller integration for continuous monitoring
- Not in Phase 9 scope — deferred to post-v1.0

---

## 6. UX Requirements

### Non-Judgmental Framing

- "Optimization opportunity found" not "You wasted $200 this year"
- Never use red warning text or shame-inducing copy
- Neutral, business-focused language focusing on operational clarity
- Frame unused subscriptions as potential savings, not failures

### Quarterly Review Pattern

- Frame as "Quarterly Tech Stack Review" — seasonal, positive, optional
- Not a daily budgeting chore
- Prompt: "Time for your Q2 tech stack review? You have 12 active subscriptions."

### Annualized View with Context

- Show annualized burn to break duration neglect: "Your AI tools cost 10,080 BDT/year"
- Always pair with actionable steps: "Pause for 3 months?" or "Consider alternatives?"
- Never show overwhelming totals without context or next steps

### Separate Business vs Personal

- Tab or filter: Business SaaS vs Personal Subscriptions
- Dashboard widget shows only Business SaaS burn (operational cost)
- Personal subscriptions tracked but not mixed into business metrics

### Dashboard Widget

- Card: "SaaS Burn Rate: X BDT/month (Business)"
- Tap to drill into subscription list
- Hypothesis: Position alongside Income Pipeline summary as an operational metric

---

## 7. Monetization Potential

### Free Tier

- Manual stack builder (add/edit/remove subscriptions)
- Basic subscription list with status tracking
- Annualized view
- Quarterly review prompts

### Pro Features (Future, post-Phase 9)

- **Cancellation Concierge Alerts:** "You've paid for Vercel for 3 months without active deployments. Would you like to pause?" Hypothesis: High perceived value, directly saves user money.
- **Alternative Recommendations:** "You spend 6,000 BDT/mo on Adobe. 80% of users with your profile use Affinity Photo for a one-time payment." Hypothesis: Affiliate revenue potential.
- **Tool ROI Tracking:** Link specific invoices/clients to specific tools to calculate per-tool ROI. Hypothesis: Answers "Did paying for Midjourney actually make me money this month?"

---

## 8. Dependencies

### Required Before Phase 9

| Dependency | Status | Why Required |
|-----------|--------|-------------|
| Transaction categorization | Basic (Phase 1-6) | Need to categorize charges to detect recurring patterns |
| Hive database structure | Complete | New TypeAdapter for SubscriptionModel |
| Dashboard layout | Complete | Space needed for SaaS Burn Rate widget |

### Dependencies on Earlier Phases

| Phase | Relationship |
|-------|-------------|
| Phase 7 (Income Pipeline) | Should be stable; SaaS burn contextualizes income |
| Phase 8 (Safe-to-Spend) | Optional integration; subscriptions are fixed costs in the formula |

---

## 9. Out of Scope

- **Bank API integration (Plaid/Teller)** — Phase 3 of this feature, not Phase 9 MVP
- **Email receipt parsing** — High privacy concerns, not worth the friction
- **Automated cancellation** — Too risky; user must approve all actions
- **ML-driven categorization** — Start with predefined list + manual
- **Notification scheduling / smart reminders** — Added post-launch
- **Price comparison across tools** — Requires external data source
- **Team/shared subscription tracking** — Single-user only

---

## 10. Open Questions

1. **Minimum pre-populated tool list size?**
   Hypothesis: 50-75 tools covering LLMs, design, hosting, productivity, payment processors, analytics. Validate with 10 freelancers — ask "What tools do you pay for monthly?" and check coverage.

2. **How to handle annual vs monthly billing in the model?**
   Hypothesis: Store `billingCycle` enum. Calculate `monthlyAmount` by normalizing (annual / 12, quarterly / 3). Display both monthly and annualized views. Track `nextBillingDate` as actual upcoming charge date.

3. **Should the radar auto-detect from transaction history on Phase 9 launch?**
   Hypothesis: Manual-first for MVP (lower risk, no algorithmic errors, privacy-respecting). Add transaction detection in Phase 2 once manual flow is validated with users.

4. **Dashboard prominence?**
   Hypothesis: Primary card for Business SaaS burn, alongside Income Pipeline summary. These are the two operational metrics that define "How is my freelance business doing?"

5. **Category definitions — user-editable or preset?**
   Hypothesis: User-editable per subscription. Default category suggested based on tool name (AWS = Business, Netflix = Personal), but user can override.

6. **Should cancelled subscriptions be archived or deleted?**
   Hypothesis: Archived (separate tab). Historical record useful for "I used to pay for X" and prevents re-adding cancelled tools accidentally.

---

## 11. Success Criteria (Hypothesis)

- [ ] User can add 10+ subscriptions in under 2 minutes via pre-populated list
- [ ] Annualized view produces "surprise" reaction (users didn't realize total annual cost)
- [ ] No shame-inducing language in any UI copy (verified via copy review)
- [ ] Dashboard SaaS Burn Rate widget visible and useful
- [ ] Quarterly review prompts have meaningful engagement
- [ ] Business vs Personal separation provides operational clarity

---

## 12. References

- `docs/research/SAAS_LEAKAGE_RESEARCH.md` — Full behavioral and technical research
- `docs/core/ROADMAP.md` — Phase 9 positioning
- `docs/core/ARCHITECTURE_RULES.md` — Dart/Flutter patterns and constraints
- `docs/specs/PHASE_7_FREELANCER_INCOME_TRACKING.md` — Income Pipeline (contextual dependency)
- `docs/specs/SAFE_TO_SPEND_MODEL.md` — Fixed cost integration point
