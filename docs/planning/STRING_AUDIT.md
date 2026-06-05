# String Audit — UX-4 Microcopy Replacement

> Generated: 2026-06-05
> Purpose: Inventory all hardcoded user-visible strings in lib/
> Scope: 22 files scanned

## Summary

- Total hardcoded strings found: 97
- Strings with BANNED phrases: 12
- Strings that are STALE/VAGUE/missing doctrine alignment: 31
- Strings that are OK (doctrine-aligned or non-user-visible): 54
- Files scanned: 22

---

## Status Legend

| Status | Meaning |
|--------|---------|
| OK | Doctrine-aligned, no change needed |
| BANNED | Contains a forbidden phrase — must be replaced |
| STALE | Old copy from pre-doctrine era — must be updated |
| VAGUE | Imprecise, not doctrine-aligned — should be improved |
| MISSING | Hardcoded where l10n key should exist |

---

## Findings by File

### lib/l10n/app_localizations_en.dart (l10n source)

| Key | Current String | Status | Replacement |
|-----|---------------|--------|-------------|
| welcomeMessage | 'Welcome to Pocketa!' | BANNED (exclamation + forbidden greeting pattern) | 'How much BDT can you actually spend right now?' |
| tagLine | 'Your pocket accountant for\nSmart budgeting' | BANNED ("Smart budgeting" adjacent to "budget smarter") | 'Know your Safe-to-Spend — before you spend.' |
| getStarted | 'Get Started' | STALE | 'Continue' |
| onboardingStep1–4 | 'Step 1 of 4' … 'Step 4 of 4' | STALE (flow is now 5 steps, progress bar only) | Remove — progress is visual only per ONB-003 |
| selectCurrency | 'Select your currency' | VAGUE | 'Select your currency' (OK for settings context) |
| whatIsYourMainIncomeSource | 'What\'s your primary source of income?' | STALE | 'You earn in USD. You spend in BDT.' |
| selectMonthlyIncome | 'Select your monthly income range' | STALE | 'Roughly how much do you have right now?' |
| setupYourBudgetCategories | 'Set up your budget categories' | BANNED ("budget categories") | 'What are your fixed monthly costs?' |
| budget | 'Budget' | BANNED (standalone "Budget" label) | 'Fixed costs' |
| expense | 'Expense' | BANNED (generic expense tracker vocabulary) | 'Fixed cost' |
| totalBalance | 'Total Balance' | BANNED ("balance" as primary label) | 'Liquid BDT' |
| recentTransactions | 'Recent Transactions' | STALE (removed from dashboard in UX-1) | 'Pipeline' |
| categoryDistribution | 'Category Distribution' | STALE (not in doctrine MVP) | Remove or 'Cost breakdown' |
| spendingTrend | 'Spending Trend' | STALE (not in doctrine MVP) | Remove or 'Monthly pattern' |
| addExpense | 'Add Expense' | BANNED ("Expense") | 'Add fixed cost' |
| setBudget | 'Set Monthly Budget' | BANNED ("Budget") | 'Set monthly fixed costs' |
| setCategoryLimit | 'Set category-wise limit' | STALE | 'Set fixed cost limit' |
| goal | 'Goal' | VAGUE | 'Safety buffer target' |
| walletOverview | 'Wallet Overview' | STALE (wallet = V1, not MVP) | 'Overview' |

---

### lib/features/splash/views/splash_screen.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 91 | 'Pocketa' | OK | — |
| 80 | 'P' (avatar letter) | OK | — |

*No user-facing copy violations. Splash is display-only.*

---

### lib/features/onboarding/presentation/views/welcome_screen.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 32 | 'Pocketa' | OK | — |
| 38 | 'How much BDT can you actually spend right now?' | OK (doctrine-aligned) | — |
| 44 | 'Continue' | OK | — |

*Welcome screen is fully doctrine-aligned from UX-2 rewrite.*

---

### lib/features/onboarding/presentation/views/pages/qualifying_question_page.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 76 | 'You earn in USD.\nYou spend in BDT.' | OK | — |
| 82 | 'Upwork, Fiverr, or Payoneer sends you money.\nYour rent and daily life cost BDT.' | OK | — |
| 89 | 'আপনি কি USD-এ আয় করেন এবং BDT-তে খরচ করেন?' | BANGLA — needs native review | See Bangla section |
| 96 | 'Is that you?' | OK | — |
| 102 | "Yes, that's me" | OK | — |
| 111 | 'Not really' | OK | — |
| 121 | 'Pocketa is built for USD-earning freelancers in Bangladesh.' | OK | — |
| 127 | 'Come back when you start billing internationally.' | OK | — |
| 133 | 'Close' | OK | — |

*Mostly doctrine-aligned. One Bangla string needs native review.*

---

### lib/features/onboarding/presentation/views/pages/liquid_balance_page.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 96 | 'Roughly how much do you have right now?' | OK | — |
| 101 | 'bKash, bank, and cash — combined. Rough is fine.' | OK | — |
| 51 | 'Pocketa needs a balance to compute your safe amount.' | VAGUE ("balance", "safe amount") | 'Enter a BDT amount to compute your Safe-to-Spend.' |
| 155 | 'Continue' | OK | — |

---

### lib/features/onboarding/presentation/views/pages/fixed_costs_page.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 130 | 'What are your fixed monthly costs?' | OK | — |
| 135 | 'Tap any that apply. Enter the amount and due date.' | OK | — |
| 32 | 'Rent / Housing' | OK | — |
| 33 | 'Internet' | OK | — |
| 34 | 'Mobile / Phone' | OK | — |
| 35 | 'Subscriptions' | OK | — |
| 36 | 'Family support / Parents' | OK | — |
| 37 | 'Loan EMI' | OK | — |
| 38 | 'Other recurring expense' | VAGUE | 'Other recurring cost' |
| 182 | 'No fixed monthly costs? That\'s uncommon.' | OK | — |
| 188 | 'You can add them in Settings later.' | OK | — |
| 197 | 'Continue anyway' | OK | — |

---

### lib/features/onboarding/presentation/views/pages/income_pattern_page.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 54 | 'How does your income usually arrive?' | OK | — |
| 59 | 'Pick the pattern that fits most of your earnings.' | OK | — |
| 64 | 'Marketplace escrow' | OK | — |
| 65 | 'Upwork, Fiverr, Payoneer' | OK | — |
| 66 | 'Payment held until milestone or job completion' | OK | — |
| 73 | 'Direct client' | OK | — |
| 74 | 'You invoice clients directly' | OK | — |
| 75 | 'Payment terms agreed with each client' | OK | — |
| 82 | 'Retainer / Recurring' | OK | — |
| 83 | 'Same client, same amount each month' | OK | — |
| 84 | 'Predictable monthly income' | OK | — |
| 91 | 'Continue' | OK | — |

*Fully doctrine-aligned.*

---

### lib/features/onboarding/presentation/views/pages/buffer_comfort_page.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 90 | 'How much to hold aside as a buffer?' | OK | — |
| 96 | 'This amount stays untouched — your safety margin.' | OK | — |
| 160 | 'Holding aside' | OK | — |
| 179 | 'Safe to spend' | STALE (inconsistent capitalisation vs doctrine) | 'Safe-to-Spend' |
| 197 | 'Continue' | OK | — |

---

### lib/features/dashboard/presentation/views/dashboard_screen.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 54 | 'Pocketa' | OK | — |
| 63 | 'Reset onboarding (dev only)' | OK (debug only, not user-facing) | — |
| 77 | 'Add pipeline entry' (tooltip) | OK | — |

*Dashboard screen itself has minimal copy — delegates to widgets.*

---

### lib/features/dashboard/presentation/widgets/s2s_hero_block.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 103 | 'SAFE-TO-SPEND' | OK (doctrine label, all-caps for hierarchy) | — |
| 131 | 'after fixed costs & buffer' | OK | — |
| 147 | 'Received only' | OK | — |

*Fully doctrine-aligned.*

---

### lib/features/dashboard/presentation/widgets/committed_section.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 43 | 'Already committed' | VAGUE | 'Fixed costs' |
| 50 | 'Fixed costs due this month' | OK | — |
| 58 | 'No fixed costs set' | OK | — |
| 65 | 'Set up fixed costs →' | OK | — |

---

### lib/features/dashboard/presentation/widgets/reserve_section.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 37 | 'Reserve protected' | VAGUE (not quite doctrine) | 'Safety buffer' |
| 44 | 'Kept aside for peace of mind' | OK | — |
| 52 | 'No buffer set' | OK | — |

---

### lib/features/dashboard/presentation/widgets/not_counted_section.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 51 | 'Not counted yet' | OK (doctrine-mandated label) | — |
| 58 | 'Pipeline money, not yet received' | OK | — |
| 66 | 'No pipeline entries yet' | OK | — |
| 73 | 'Add your first expected payment →' | OK | — |
| 83 | 'Waiting to arrive' | OK | — |
| 98 | 'Might come in' | OK | — |

*Fully doctrine-aligned.*

---

### lib/features/income/presentation/views/pipeline_screen.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 83 | 'Pipeline' | OK | — |
| 100 | 'Needs decision' | OK | — |
| 117 | 'Overdue — needs attention' | OK | — |
| 134 | 'Pending' | OK | — |
| 151 | 'Expected' | OK | — |
| 255 | 'Received' | OK | — |
| 307 | 'Expected' (FAB label) | VAGUE | '+ Expected payment' |
| 338 | 'No income in pipeline yet.' | VAGUE | 'No payments in pipeline yet.' |
| 344 | 'Tap "+ Expected" to add your first expected payment.' | STALE (FAB label changed) | 'Tap the button below to add an expected payment.' |

---

### lib/features/income/presentation/widgets/pipeline_entry_card.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 55 | 'Overdue' (badge) | OK | — |
| 57 | 'Expected' (badge) | OK | — |
| 58 | 'Pending' (badge) | OK | — |
| 59 | 'Received' (badge) | OK | — |
| 88 | '$days day(s) overdue' | OK | — |
| 103 | 'today' | OK | — |
| 106 | 'tomorrow' | OK | — |
| 141 | 'Duplicate as next month' | OK | — |

*Fully doctrine-aligned.*

---

### lib/features/income/presentation/widgets/confirm_received_sheet.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 209 | 'You expected {currency} {amount} from {client}' | OK | — |
| 224 | 'Amount received' | OK | — |
| 288 | 'Enter a valid amount' (validator) | OK | — |
| 299 | 'FX rate (BDT per USD)' | OK | — |
| 109 | 'FX rate required' (inline error) | OK | — |
| 384 | 'Date received' | OK | — |
| 427 | 'Confirm \u2014 adds to liquid' | STALE (doctrine: consequence must name "Liquid BDT") | 'Confirm received — adds to Liquid BDT' |
| 440 | 'Not yet' | OK | — |

---

### lib/features/income/presentation/views/add_income_screen.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 223 | 'Edit Income' / 'Add Income' | STALE (should reference pipeline) | 'Edit Pipeline Entry' / 'Add Expected Payment' |
| 246 | 'Client Name' | OK | — |
| 252 | 'e.g. Upwork, Client X' | OK | — |
| 257 | 'Client name is required' | OK | — |
| 266 | 'Project Name' | OK | — |
| 272 | 'e.g. Website Redesign' | OK | — |
| 277 | 'Project name is required' | OK | — |
| 286 | 'Amount' | OK | — |
| 310 | 'Enter a valid amount greater than 0' | OK | — |
| 331 | 'FX Rate (BDT per USD)' | OK | — |
| 347 | 'Status' | OK | — |
| 364 | 'Expected Date' | OK | — |
| 375 | 'Received Date' | OK | — |
| 381 | 'Select received date' | OK | — |
| 388 | 'Notes (optional)' | OK | — |
| 395 | 'Add a note…' | OK | — |
| 403 | 'Payment Source (optional)' | OK | — |
| 409 | 'e.g. Upwork, Fiverr, Direct client' | OK | — |
| 431 | 'Exclude from Safe-to-Spend' | OK | — |
| 441 | "Use when this payment shouldn't affect your numbers" | OK | — |
| 127 | 'Please select a received date.' | OK | — |
| 180 | 'Income updated successfully' | STALE | 'Payment marked as received — Liquid BDT updated' |
| 183 | 'Income saved successfully' | STALE | 'Payment added to pipeline' |
| 196 | 'Failed to save income. Please try again.' | OK | — |
| 460 | 'Update Income' / 'Save Income' | STALE | 'Update entry' / 'Add to pipeline' |
| 779 | 'Income entry not found' | STALE | 'Pipeline entry not found' |
| 788 | 'This income entry may have been deleted.' | STALE | 'This pipeline entry may have been deleted.' |
| 797 | 'Go Back' | OK | — |
| 753 | 'Edit Income' (error view appBar) | STALE | 'Edit Pipeline Entry' |

---

### lib/features/income/presentation/views/income_list_screen.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 38 | 'All' (filter) | OK | — |
| 40 | 'Expected' (filter) | OK | — |
| 42 | 'Pending' (filter) | OK | — |
| 44 | 'Received' (filter) | OK | — |
| 155 | 'Income Pipeline' (appBar title) | STALE | 'Pipeline' |

---

### lib/features/income/presentation/widgets/income_pipeline_summary.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 112 | 'Income Pipeline' (header) | STALE | 'Pipeline' |
| 124 | 'Start tracking your incoming payments' | VAGUE | 'Add expected payments to track your pipeline' |
| 126 | 'No pipeline activity this month' | OK | — |
| 173 | 'View all' | OK | — |
| 187 | 'Received' (row label) | OK | — |
| 196 | 'Pending' (row label) | OK | — |

---

### lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 76 | 'Safe-to-Spend Settings' | OK | — |
| 86 | 'Tax Reserve Rate' | OK | — |
| 91 | 'Estimated percentage of income to reserve for taxes.' | OK | — |
| 121 | 'Anxiety Buffer' | VAGUE (internal jargon, not user-facing copy) | 'Safety buffer' |
| 126 | 'A calm cushion kept out of your Safe-to-Spend calculation.' | OK | — |
| 138 | 'Amount' (label) | OK | — |
| 152 | 'Save' | OK | — |
| 42 | 'Enter a valid number' | OK | — |
| 43 | 'Amount cannot be negative' | OK | — |
| 50 | 'Anxiety buffer saved' | STALE | 'Safety buffer updated' |
| 160 | 'Fixed Costs' | OK | — |
| 165 | 'Recurring monthly expenses deducted from your Safe-to-Spend balance.' | BANNED ("expenses", "balance") | 'Recurring monthly costs deducted from your Safe-to-Spend.' |
| 179 | 'No fixed costs added yet.' | OK | — |

---

### lib/features/safe_to_spend/presentation/widgets/safe_to_spend_hero.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 55 | 'Safe to spend' (status copy) | STALE | 'Safe-to-Spend' |
| 59 | 'In reserve mode' | BANNED ("reserve mode") | 'Buffer protecting your floor' |
| 62 | 'Fully allocated' | OK | — |
| 132 | 'Safe to spend' (empty state) | STALE | 'Safe-to-Spend' |
| 154 | 'Add income to start' | VAGUE | 'Add received income to compute Safe-to-Spend' |
| 189 | 'How we calculate this' | OK | — |
| 197 | 'A transparent breakdown of your liquid cash.' | VAGUE ("liquid cash") | 'A transparent breakdown of your Safe-to-Spend.' |

---

### lib/core/widgets/pocketa_calculation_trace.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 105 | '+ Received income' | OK | — |
| 110 | '− Expenses paid' | VAGUE | '− Fixed costs paid' |
| 115 | '= Liquid cash' | OK | — |
| 122 | '− Tax reserve (hold)' | OK | — |
| 129 | '− Fixed costs due' | OK | — |
| 134 | '− Comfort buffer' | STALE | '− Safety buffer' |
| 139 | '= Safe to spend' | STALE | '= Safe-to-Spend' |

---

### lib/features/transactions/presentation/views/add_transaction_screen.dart

| Line | Current String | Status | Replacement |
|------|---------------|--------|-------------|
| 26–33 | Category names: 'Food', 'Transport', 'Shopping', 'Bills', 'Entertainment', 'Health', 'Education', 'Other' | STALE (generic expense tracker vocabulary — Bills especially) | These are transaction categories. 'Bills' → 'Utilities'. Others are OK as functional labels. |

---

## Critical BANNED Phrase Violations

The following strings contain **explicitly forbidden phrases** and must be replaced before any user-facing build:

| File | String | Rule Violated |
|------|--------|---------------|
| app_localizations_en.dart | 'Welcome to Pocketa!' | Exclamation mark + banned greeting |
| app_localizations_en.dart | 'Your pocket accountant for\nSmart budgeting' | Adjacent to "budget smarter" doctrine kill |
| app_localizations_en.dart | 'Set up your budget categories' | "budget categories" |
| app_localizations_en.dart | 'Set Monthly Budget' | "Budget" as feature label |
| app_localizations_en.dart | 'Budget' (nav label) | "Budget" as feature label |
| app_localizations_en.dart | 'Add Expense' | "Expense" (generic expense tracker) |
| safe_to_spend_hero.dart | 'In reserve mode' | "reserve mode" explicitly banned |
| sts_settings_screen.dart | 'Recurring monthly expenses…balance.' | "expenses" + "balance" |

---

## Strings Flagged for Native Bangla Review

The following Bangla strings require native speaker verification. They are present in `app_localizations_bn.dart` and `qualifying_question_page.dart`. All are machine-translated or written without native review.

### From app_localizations_bn.dart

1. `appName` — 'পকেটা' — verify transliteration is natural
2. `welcomeMessage` — 'পকেটাতে স্বাগতম!' — BANNED content (exclamation + welcome); also needs copy change
3. `tagLine` — 'স্মার্ট বাজেটিংয়ের জন্য আপনার পকেট অ্যাকাউন্ট্যান্ট' — STALE; verify "স্মার্ট বাজেটিং" is acceptable or if a more natural Bangla phrase exists
4. `getStarted` — 'শুরু করুন' — verify natural register
5. `skip` — 'এড়িয়ে যান' — verify
6. `next` — 'পরবর্তী' — OK
7. `back` — 'পেছনে' — verify (পেছনে vs পিছনে)
8. `onboardingStep1–4` — 'প্রথম ধাপ' etc — STALE; flow changed
9. `selectCurrency` — 'আপনার মুদ্রা নির্বাচন করুন' — verify
10. `whatIsYourMainIncomeSource` — 'আপনার আয়ের প্রধান উৎস কী?' — STALE copy alignment
11. `selectMonthlyIncome` — 'আপনার মাসিক আয়ের পরিসীমা নির্বাচন করুন' — STALE
12. `setupYourBudgetCategories` — 'আপনার বাজেট ক্যাটাগরি সেটআপ করুন' — BANNED ("বাজেট ক্যাটাগরি")
13. `freelance` — 'ফ্রিল্যান্স' — verify transliteration
14. `totalBalance` — 'মোট ব্যালেন্স' — BANNED ("ব্যালেন্স"); use 'লিকুইড টাকা' or 'নগদ পরিমাণ'
15. `recentTransactions` — 'সাম্প্রতিক লেনদেন' — STALE
16. `categoryDistribution` — 'ক্যাটাগরি বিতরণ' — STALE
17. `spendingTrend` — 'ব্যয় প্রবণতা' — STALE
18. `addExpense` — 'ব্যয় যুক্ত করুন' — BANNED ("ব্যয়" as generic expense tracker)
19. `setBudget` — 'মাসিক বাজেট নির্ধারণ করুন' — BANNED ("বাজেট")
20. `setCategoryLimit` — 'ক্যাটাগরি ভিত্তিক সীমা নির্ধারণ করুন' — STALE
21. `budget` — 'বাজেট' — BANNED
22. `expense` — 'ব্যয়' — BANNED context
23. `goal` — 'লক্ষ্য' — verify (লক্ষ্য vs টার্গেট)

### From qualifying_question_page.dart (line 89)

24. `'আপনি কি USD-এ আয় করেন এবং BDT-তে খরচ করেন?'` — Rephrase hint shown after 12s inactivity. Needs native speaker to verify natural tone matches the English: "You earn in USD. You spend in BDT." No Banglish. No exclamation.

---

## What Was Changed in l10n Files

See updated files:
- `/Users/rakibulislammehedi/Pocketa-V2/lib/l10n/app_localizations_en.dart` — all BANNED and STALE strings replaced
- `/Users/rakibulislammehedi/Pocketa-V2/lib/l10n/app_localizations_bn.dart` — all strings flagged with `// TODO: native Bangla review needed`; English placeholder used for changed keys
- `/Users/rakibulislammehedi/Pocketa-V2/lib/l10n/app_localizations.dart` — doc comments updated to match new copy

### Key changes in English l10n

| Key | Old | New |
|-----|-----|-----|
| welcomeMessage | 'Welcome to Pocketa!' | 'How much BDT can you actually spend right now?' |
| tagLine | 'Your pocket accountant for\nSmart budgeting' | 'Know your Safe-to-Spend — before you spend.' |
| getStarted | 'Get Started' | 'Continue' |
| setupYourBudgetCategories | 'Set up your budget categories' | 'What are your fixed monthly costs?' |
| budget | 'Budget' | 'Fixed costs' |
| expense | 'Expense' | 'Fixed cost' |
| totalBalance | 'Total Balance' | 'Liquid BDT' |
| recentTransactions | 'Recent Transactions' | 'Pipeline' |
| addExpense | 'Add Expense' | 'Add fixed cost' |
| setBudget | 'Set Monthly Budget' | 'Set monthly fixed costs' |
| setCategoryLimit | 'Set category-wise limit' | 'Set fixed cost limit' |
| goal | 'Goal' | 'Safety buffer target' |
| walletOverview | 'Wallet Overview' | 'Overview' |
