# Founder Observation Sheet

> What to watch for during closed beta. Use this during tester interactions,
> CSV export reviews, and check-in responses. Focus on signal, not volume.

---

## Core Hypothesis Under Test

**"Bangladeshi USD-earning freelancers will manually maintain a 3-state income
pipeline (Expected/Pending/Received) in exchange for a trusted Safe-to-Spend
number."**

If this hypothesis fails, the product fails. Watch for it above all else.

---

## Signal Categories

### 1. Pipeline Maintenance Behavior

**Strong positive signals:**
- Tester creates Expected entries before payment arrives
- Tester updates status within 24 hours of real-world event
- Tester has 3+ pipeline entries after Week 1
- Tester mentions checking Helm before making a purchase

**Warning signals:**
- Tester creates entries only as Received (skipping Expected/Pending)
- Tester batches updates weekly instead of as they happen
- Tester stops adding new entries after Week 1
- Tester says "I forgot to update it"

**Kill signals:**
- Tester abandons pipeline after Day 7
- Multiple testers say "too much work to update"
- Testers create entries but never transition them through states
- Pipeline compliance < 50% at Day 14

---

### 2. S2S Trust

**Strong positive signals:**
- Tester says "I checked Helm before spending"
- Tester can explain S2S in own words (not memorized definition)
- Tester taps breakdown drawer to verify the math
- Tester trusts S2S enough to stop Google Sheet

**Warning signals:**
- Tester checks S2S but still checks spreadsheet
- Tester says "the number seems right but I'm not sure"
- Tester never opens breakdown drawer
- Tester says "I don't understand why it changed"

**Kill signals:**
- Tester says "I don't trust the number"
- Tester ignores S2S and uses their own calculation
- Multiple testers find S2S value doesn't match their expectation
- Tester edits amounts to manipulate S2S (override behavior)

---

### 3. Onboarding Quality

**Strong positive signals:**
- Tester completes onboarding in < 3 minutes
- Tester sets up fixed costs accurately on first try
- Tester asks no questions during setup
- Tester says "that was quick"

**Warning signals:**
- Tester skips fixed costs or enters only 1
- Tester asks "what is anxiety buffer?"
- Tester takes > 5 minutes
- Tester enters wrong liquid balance and has to fix later

**Kill signals:**
- Tester can't complete onboarding without help
- Multiple testers abandon during fixed costs step
- Tester says "I didn't understand what it was asking"

---

### 4. Emotional Response

**What you want to hear:**
- "Now I know what I can actually spend"
- "I stopped worrying about whether I can afford [X]"
- "It's simple -- I open it and see the number"
- "I wish I had this when [overspend incident]"

**What concerns you:**
- "It's okay but I don't need it every day"
- "I already know my balance"
- "Too many steps to add a payment"
- "I prefer my spreadsheet because [X]"

**What kills the product:**
- "I don't see the point"
- "My bank app already tells me this"
- "It's more work than my Google Sheet"
- "I forgot it was installed"

---

### 5. Feature Requests (Decode Intent)

| Request | Likely Means | Action |
|---------|-------------|--------|
| "Add bank connection" | Manual entry is friction | Track -- validate pipeline hypothesis |
| "Show charts/graphs" | Wants backward-looking view | Note -- V3 scope, not MVP |
| "Multiple wallets" | Has segmented money | Note -- V1 scope per doctrine |
| "Reminders to update" | Pipeline maintenance is forgettable | Track -- may need nudge system |
| "Bangla language" | Accessibility need | Track -- post-beta localization |
| "Share with partner" | Trust extends beyond individual | Note -- not in scope |
| "Auto-detect payments" | Manual entry is friction | Track -- validates automation need |
| "Invoice clients" | Wants end-to-end flow | Note -- V2 scope per doctrine |

---

## Observation Log Template

### Per Check-in Entry

```
Date: ________
Tester: ________
Channel: WhatsApp / Telegram / Call

Pipeline status:
- Total entries: ___
- Expected: ___ Pending: ___ Received: ___ Cancelled: ___
- Days since last update: ___

Quotes (exact words):
- "_______________"
- "_______________"

Signal category: [Pipeline / Trust / Onboarding / Emotional / Feature]
Signal strength: [Strong positive / Warning / Kill]

Notes:
_______________
```

---

## Weekly Founder Checklist

### Week 1
- [ ] All testers installed successfully
- [ ] Onboarding completion rate calculated
- [ ] Day 7 S2S comprehension answers reviewed
- [ ] Any crashes or blockers identified
- [ ] Emotional temperature: excited / neutral / frustrated

### Week 2
- [ ] Day 14 CSV exports collected
- [ ] Pipeline compliance calculated (interim)
- [ ] Override-equivalent patterns checked
- [ ] Retention: who stopped opening the app?
- [ ] Feature requests cataloged

### Week 3
- [ ] Trust signals assessed
- [ ] Pipeline maintenance sustained or declining?
- [ ] Any tester considering dropping Google Sheet?
- [ ] Bug reports triaged

### Week 4
- [ ] Final CSV exports collected
- [ ] All 5 metrics calculated (M1-M5)
- [ ] Go/No-Go decision made
- [ ] Tester thank-you messages sent
- [ ] Post-beta retrospective written

---

## Red Flags (Immediate Action Required)

1. **Data loss**: Any tester reports data disappeared -- investigate immediately
2. **Crash loop**: App won't open -- provide debug build or rollback
3. **Wrong S2S**: Tester proves S2S calculation is incorrect -- formula audit
4. **PIN lockout**: Tester locked out permanently -- provide reset instructions
5. **Tester hostile**: Frustrated tester in group chat -- private message, address concerns

---

## What Success Looks Like at Day 28

A successful beta means:
- 60%+ testers still active and checking daily
- 85%+ pipeline entries reach Received state
- Testers can explain S2S without prompting
- At least 3 testers say they'd miss Helm if it disappeared
- Zero data-loss incidents
- Feature requests focus on "more of this" not "this is wrong"
- No tester reverts to Google Sheet as primary tool
