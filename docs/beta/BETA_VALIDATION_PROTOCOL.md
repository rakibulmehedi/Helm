# Beta Validation Protocol

> Structured protocol for Helm closed beta validation.
> Duration: 4 weeks | Cohort: 15-25 Bangladeshi freelancers
> Authority: Final Product Doctrine S16

---

## Beta Parameters

| Parameter | Value |
|-----------|-------|
| Duration | 4 weeks (28 days) |
| Cohort size | 15-25 testers |
| Profile | Bangladeshi USD-earning freelancers, $800-$3,000/month |
| Distribution | Sideloaded APK (debug or release build) |
| Instrumentation | Local analytics (debugPrint), manual observation |
| Feedback channel | WhatsApp group or Telegram (low-friction, familiar) |
| Check-in cadence | Day 1, Day 3, Day 7, Day 14, Day 21, Day 28 |

---

## Tester Selection Criteria

### Must Have
- Active freelancer earning USD (Upwork, Fiverr, direct clients)
- Uses Payoneer, nsave, or ElevatePay for USD receipt
- Converts USD to BDT regularly
- Has Android phone (any)
- Willing to use app daily for 4 weeks
- Has experienced at least 1 overspend incident from pipeline confusion

### Nice to Have
- Maintains Google Sheet or mental ledger currently
- Has 2+ income sources
- Has recurring fixed monthly costs
- Comfortable giving honest negative feedback

### Disqualify
- Does not earn in USD
- Uses iPhone only (Flutter cross-platform, but beta targets Android first)
- Not willing to commit to 4 weeks
- Works for a single employer with fixed salary (not freelancer)

---

## Validation Metrics (Doctrine S16 - Mandatory)

### 5 Go/No-Go Thresholds

| # | Metric | Target | Kill Threshold | Measurement |
|---|--------|--------|----------------|-------------|
| M1 | Pipeline update compliance | >= 85% | < 85% | % of income entries that reach Received state within 7 days of actual receipt |
| M2 | Override-equivalent rate | < 5% | >= 5% | % of times user edits S2S-affecting data without corresponding real-world event |
| M3 | 30-day retention | >= 60% | < 60% | % of testers still using app at Day 28 (opened in last 3 days) |
| M4 | Onboarding completion | >= 70% | < 70% | % of installs that complete all onboarding steps + PIN setup |
| M5 | S2S comprehension | >= 80% | < 80% | % of testers who can explain what S2S means (Day 7 check-in) |

**Decision Rule**: If 2+ thresholds miss target, KILL product. Do not ship V1.

---

## Measurement Methods

### M1: Pipeline Update Compliance
- **How**: Review audit log CSV exports at Day 14 and Day 28
- **Count**: Income entries created as Expected/Pending that eventually reach Received
- **Exclude**: Entries cancelled (legitimate business event)
- **Manual check**: Ask in check-in "Did any payments arrive that you didn't mark in Helm?"

### M2: Override-Equivalent Rate
- **How**: Review audit log for rapid edit-then-revert patterns
- **Count**: Edits to amount/date/status without a corresponding real event
- **Proxy**: If user edits same entry 3+ times in 24 hours, flag as override-equivalent
- **Manual check**: Ask "Did you ever change a number just to make S2S look different?"

### M3: 30-Day Retention
- **How**: WhatsApp check-in at Day 28 + audit log timestamp review
- **Active**: User opened app at least once in last 3 days (check audit log latest timestamp)
- **Churned**: No app opens in 7+ days with no explanation

### M4: Onboarding Completion
- **How**: Count installs vs successful first dashboard views
- **Manual**: Ask Day 1 "Did you finish setup? Any step where you got stuck?"
- **Proxy**: User has PIN set + at least 1 fixed cost entered

### M5: S2S Comprehension
- **How**: Day 7 check-in question: "In your own words, what does Safe-to-Spend mean?"
- **Pass**: Answer includes concept of "money I can spend without risk" or "after removing commitments"
- **Fail**: Answer is "my balance" or "total money" or confused with income

---

## Weekly Protocol

### Week 0: Pre-Beta (Before Distribution)

- [ ] Complete MANUAL_QA_SCRIPT.md on reference device
- [ ] Verify release build runs without crashes
- [ ] Recruit 15-25 testers matching criteria
- [ ] Create WhatsApp/Telegram feedback group
- [ ] Prepare TESTER_ONBOARDING_SCRIPT.md as message template
- [ ] Distribute APK with installation instructions

### Week 1: Activation (Days 1-7)

**Day 1 Check-in:**
- Did you install successfully?
- Did you complete onboarding? How long did it take?
- What was confusing (if anything)?
- Did you set up your PIN?
- Record: M4 (onboarding completion)

**Day 3 Check-in:**
- Have you added any income entries?
- Have you added any expenses?
- Do you check Helm daily?
- What does the main number on the dashboard mean to you?

**Day 7 Check-in:**
- "In your own words, what does Safe-to-Spend mean?" (M5 measurement)
- How many pipeline entries have you created?
- Have any payments arrived? Did you mark them as Received?
- What is the most confusing part of the app?
- What would you change?
- Record: M5 (S2S comprehension)

### Week 2: Habit Formation (Days 8-14)

**Day 14 Check-in:**
- Are you still using Helm daily?
- Request CSV export: Settings > Export > share to WhatsApp/email
- Review audit log for pipeline compliance (M1)
- Review for override-equivalent patterns (M2)
- Ask: "Has Helm prevented you from overspending?"
- Ask: "Did any payments arrive that you didn't mark in Helm?"
- Record: M1 (pipeline compliance, interim), M2 (override rate, interim)

### Week 3: Stress Test (Days 15-21)

**Day 21 Check-in:**
- Any crashes or bugs encountered?
- Has the S2S number ever been wrong? When?
- Did you try exporting your data?
- Did you explore the audit log?
- Would you trust Helm enough to stop your Google Sheet?
- Ask: "If Helm disappeared tomorrow, would you miss it?"

### Week 4: Final Assessment (Days 22-28)

**Day 28 Final Check-in:**
- Request final CSV export
- Full metric calculation (M1-M5)
- Ask: "Would you recommend Helm to a freelancer friend?"
- Ask: "What single feature would make Helm essential?"
- Ask: "Rate your trust in the S2S number: 1 (don't trust) to 5 (fully trust)"
- Record: M1, M2, M3 (retention), reconfirm M4, M5

---

## Data Collection Template

### Per-Tester Tracking

| Tester | Install Date | Onboarding Done | PIN Set | Day 7 S2S Answer | Day 14 Export | Day 28 Active | Pipeline Entries | Received Entries | Notes |
|--------|-------------|-----------------|---------|-------------------|---------------|---------------|-----------------|-----------------|-------|
| T01 | | | | | | | | | |
| T02 | | | | | | | | | |
| ... | | | | | | | | | |

### Aggregate Metrics (Calculate at Day 28)

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| M1: Pipeline compliance | >= 85% | | |
| M2: Override rate | < 5% | | |
| M3: 30-day retention | >= 60% | | |
| M4: Onboarding completion | >= 70% | | |
| M5: S2S comprehension | >= 80% | | |
| Thresholds missed | < 2 | | |

---

## Post-Beta Decision Matrix

| Thresholds Met | Decision | Action |
|----------------|----------|--------|
| 5/5 | STRONG GO | Proceed to V1 development |
| 4/5 | CONDITIONAL GO | Fix weak metric, re-validate in 2-week patch beta |
| 3/5 | WEAK | Deep analysis required, founder decision |
| 2/5 or fewer | KILL | Do not ship V1. Pivot or sunset. |

---

## Privacy Commitments to Testers

1. All data stays on their device only (offline-first)
2. No data is transmitted to any server
3. CSV exports are initiated by user only
4. Analytics are local (debugPrint), not transmitted
5. Testers can delete all data at any time via Settings
6. No personal identifiers collected beyond what they voluntarily share in chat
