# Tester Onboarding Script

> Message template for onboarding beta testers. Copy/adapt for WhatsApp or Telegram.
> Tone: Direct, respectful, no hype.

---

## Initial Invitation Message

```
Hi [Name],

I'm building Helm -- a simple app that answers one question for freelancers:
"How much BDT can I actually spend right now?"

It tracks your income pipeline (Expected / Pending / Received), subtracts your
fixed costs and a safety buffer, and shows one number: Safe-to-Spend.

I need 4 weeks of honest feedback from freelancers who earn USD and spend BDT.

What you'd do:
- Install the APK (Android only for now)
- Use it as your daily money check (2-3 minutes/day)
- Reply to brief check-ins at Day 1, 3, 7, 14, 21, 28

What I need from you:
- Honesty. If it's confusing, broken, or useless -- tell me.
- Consistency. Check the app at least once daily.
- One CSV export at Day 14 and Day 28 (takes 10 seconds).

Your data stays 100% on your phone. Nothing is sent anywhere.
You can delete everything from Settings at any time.

Interested?
```

---

## Post-Acceptance: Installation Instructions

```
Thanks for joining.

Here's the APK: [link]

Installation steps:
1. Download the APK file
2. Open it -- you may need to allow "Install from unknown sources" in Settings
3. Open Helm
4. Complete the onboarding (takes ~3 minutes):
   - Answer the qualifier question
   - Enter your current usable BDT balance
   - Add your monthly fixed costs (rent, internet, etc.)
   - Select your income pattern
   - Set your comfort buffer (15% is a good default)
5. Set up a 4-digit PIN

After that, you'll see your Safe-to-Spend number on the dashboard.

Quick start:
- Tap the + button to add an expected payment
- When money arrives, update it to "Received"
- Add expenses as you spend
- Check the dashboard daily

If anything crashes or confuses you, screenshot it and send here.
```

---

## Day 1 Check-in

```
Quick check-in:

1. Did you install and complete setup?
2. How long did onboarding take?
3. Anything confusing during setup?
4. Did you set your PIN?
5. Have you added any income entries yet?

No wrong answers. Short replies are fine.
```

---

## Day 3 Check-in

```
Day 3 check-in:

1. Are you opening Helm daily?
2. Have you added any expected or received payments?
3. Have you recorded any expenses?
4. What does the big number on the home screen mean to you?

One-line answers are fine.
```

---

## Day 7 Check-in

```
Week 1 check-in:

1. In your own words: what does "Safe-to-Spend" mean?
2. How many income entries have you created so far?
3. Have any payments arrived? Did you mark them as "Received" in the app?
4. What's the most confusing part of Helm?
5. What would you change if you could change one thing?
```

---

## Day 14 Check-in (Export Required)

```
Day 14 check-in:

Can you do a quick export?
Settings > Export my data > Share to me via WhatsApp

Then 3 questions:
1. Has Helm stopped you from overspending? When?
2. Did any payments arrive that you didn't mark in the app?
3. Are you still checking Helm daily, or has it dropped off?
```

---

## Day 21 Check-in

```
Day 21 check-in:

1. Any crashes or bugs this week?
2. Has the Safe-to-Spend number ever been wrong?
3. Did you try the audit log (Settings > View change history)?
4. Would you trust Helm enough to stop your spreadsheet?
5. If Helm disappeared tomorrow, would you miss it?
```

---

## Day 28 Final Check-in (Export Required)

```
Final check-in -- thank you for 4 weeks.

One last export please:
Settings > Export my data > Share to me

Final questions:
1. Would you recommend Helm to a freelancer friend? Why / why not?
2. What single feature would make Helm essential for you?
3. Rate your trust in the Safe-to-Spend number: 1 (don't trust) to 5 (fully trust)
4. What did Helm get wrong?
5. Will you keep using it after the beta?

Your feedback directly decides whether this product ships or gets killed.
Thank you for your time.
```

---

## Handling Common Tester Questions

**"What is Safe-to-Spend?"**
> It's how much BDT you can spend right now without touching money reserved for
> fixed costs, taxes, or your safety buffer. It only counts money you've actually
> received, not money that's pending or expected.

**"Why doesn't it show my Payoneer balance?"**
> Helm doesn't connect to any bank or payment service. You manually enter
> payments as Expected, then mark them Received when the money arrives in BDT.
> This is intentional -- it keeps your data private and on-device only.

**"Can I use it on iPhone?"**
> Not yet. Android only for this beta.

**"Is my data safe?"**
> Your data stays 100% on your phone. Nothing is sent to any server. You can
> delete all data from Settings > Delete Account at any time.

**"The app crashed."**
> Screenshot the error if possible. Tell me what you were doing right before it
> crashed. I'll investigate.
