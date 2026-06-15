// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Helm';

  @override
  String get appTagline => 'How much BDT can you actually spend right now?';

  @override
  String get continueSetupSafeToSpend =>
      'Continue — sets up your Safe-to-Spend';

  @override
  String get setUpLater => 'Set up later';

  @override
  String get signInToHelm => 'Sign in to Helm';

  @override
  String get magicLinkSubtitle =>
      'Enter your email — we\'ll send you a magic link to sign in instantly.';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get sendMagicLink => 'Send Magic Link';

  @override
  String get sending => 'Sending...';

  @override
  String get checkYourInbox => 'Check your inbox';

  @override
  String magicLinkSentSubtitle(String email) {
    return 'We sent a link to $email.\nEnter the code below, or tap the link in your email.';
  }

  @override
  String get pasteVerificationCode => 'Paste verification code';

  @override
  String get verifyAndSignIn => 'Verify & Sign In';

  @override
  String get verifying => 'Verifying...';

  @override
  String get useDifferentEmail => '← Use a different email';

  @override
  String get errorEnterEmail => 'Please enter your email address';

  @override
  String get errorTooManyRequests =>
      'Too many requests. Please wait before requesting another link.';

  @override
  String get errorEnterCode =>
      'Please enter the verification code or paste the link';

  @override
  String get errorInvalidCode =>
      'Invalid or expired verification code. Request a new one.';

  @override
  String get qualifyingQuestion =>
      'Have you ever spent money thinking a\npayment cleared, then realized it hadn\'t?';

  @override
  String get qualifyingSubtext =>
      'If you earn in USD and spend in BDT — through\nUpwork, Fiverr, or Payoneer — this happens a lot.';

  @override
  String get qualifyingRephraseBn =>
      'আপনি কি কখনো টাকা খরচ করে ফেলেছেন ভেবে যে\nপেমেন্ট ক্লিয়ার হয়েছে, পরে দেখেছেন হয়নি?';

  @override
  String get doesThatSoundFamiliar => 'Does that sound familiar?';

  @override
  String get yesHappenedToMe => 'Yes, that happens to me';

  @override
  String get noAlwaysKnow => 'No, I always know exactly what cleared';

  @override
  String get disqualifyHeading =>
      'Helm is built for USD-earning freelancers in Bangladesh.';

  @override
  String get disqualifySubtext =>
      'Come back when you start billing internationally.';

  @override
  String get close => 'Close';

  @override
  String get liquidBalanceQuestion => 'Roughly how much do you have right now?';

  @override
  String get liquidBalanceSubtext =>
      'bKash, bank, and cash — combined. A rough number is fine. You can refine it later.';

  @override
  String get liquidBalanceFieldLabel => 'Current liquid balance in BDT';

  @override
  String get liquidBalanceError =>
      'Enter your current liquid BDT to calculate Safe-to-Spend.';

  @override
  String get fixedCostsQuestion => 'What are your fixed monthly costs?';

  @override
  String get fixedCostsSubtext =>
      'Monthly costs due in the next 30 days. Tap any that apply.';

  @override
  String get fixedCostsNoneSelected => 'No fixed monthly costs selected.';

  @override
  String get fixedCostsNoneExplainer =>
      'Fixed costs reduce Safe-to-Spend. You can add them in Settings later.';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get letMeAddSome => 'Let me add some';

  @override
  String get firstPipelineQuestion => 'Any money coming in soon?';

  @override
  String get firstPipelineSubtext =>
      'Adding expected income helps Safe-to-Spend show you the full picture from day one.';

  @override
  String get clientOrSource => 'Client or source';

  @override
  String get clientOrSourceHint => 'e.g. Upwork, Client X';

  @override
  String get whoIsThisFrom => 'Who is this from?';

  @override
  String get pipelineEntryNote =>
      'This will be marked as \"Expected\". You can update the status later.';

  @override
  String get addToMyPipeline => 'Add to my pipeline';

  @override
  String get skipAddLater => 'Skip — I\'ll add it later';

  @override
  String get safeToSpendLabel => 'SAFE-TO-SPEND';

  @override
  String get safeToSpendSubLabel => 'after fixed costs + safety buffer';

  @override
  String get receivedOnly => 'Received only';

  @override
  String get tapToSeeMath => 'Tap the number to see the math';

  @override
  String get addPipelineEntry => 'Add income entry';

  @override
  String get fixedCostsSectionTitle => 'Fixed costs';

  @override
  String get fixedCostsSectionSubtitle =>
      'Monthly costs due in the next 30 days';

  @override
  String get fixedCostsEmpty =>
      'No fixed costs added yet. Add them to improve Safe-to-Spend accuracy.';

  @override
  String get addFixedCostsLink => 'Add fixed costs →';

  @override
  String get safetyBufferTitle => 'Safety buffer';

  @override
  String get safetyBufferSubtitle =>
      'Not locked — a safety margin inside the calculation';

  @override
  String get safetyBufferEmpty =>
      'No safety buffer set. Safe-to-Spend uses your full liquid BDT.';

  @override
  String get notCountedTitle => 'Not counted yet';

  @override
  String get notCountedSubtitle => 'Not counted yet — expected payments';

  @override
  String get notCountedEmpty =>
      'Add an expected payment when you invoice or expect money.';

  @override
  String get addExpectedPaymentLink => 'Add expected payment →';

  @override
  String get pending => 'Pending';

  @override
  String get expected => 'Expected';

  @override
  String get received => 'Received';

  @override
  String get ifAllCounted => 'If all counted:';

  @override
  String get incomePipeline => 'Income Pipeline';

  @override
  String get addIncome => 'Add Income';

  @override
  String get editIncome => 'Edit Income';

  @override
  String get updateIncome => 'Update Income';

  @override
  String get saveIncome => 'Save Income';

  @override
  String get clientName => 'Client Name';

  @override
  String get clientNameHint => 'e.g. Upwork, Client X';

  @override
  String get clientNameRequired => 'Client name is required';

  @override
  String get projectName => 'Project Name';

  @override
  String get projectNameHint => 'e.g. Website Redesign';

  @override
  String get projectNameRequired => 'Project name is required';

  @override
  String get amount => 'Amount';

  @override
  String get amountRequired => 'Amount is required';

  @override
  String get amountInvalid => 'Enter a valid amount greater than 0';

  @override
  String get fxRateLabel => 'FX Rate (BDT per USD)';

  @override
  String get fxRateHint => 'e.g. 110.5';

  @override
  String get fxRateRequired => 'FX rate required';

  @override
  String get statusLabel => 'Status';

  @override
  String get expectedDate => 'Expected Date';

  @override
  String get receivedDate => 'Received Date';

  @override
  String get selectDate => 'Select date';

  @override
  String get selectReceivedDate => 'Select received date';

  @override
  String get pleaseSelectReceivedDate => 'Please select a received date.';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get addANote => 'Add a note…';

  @override
  String get paymentSourceOptional => 'Payment Source (optional)';

  @override
  String get paymentSourceHint => 'e.g. Upwork, Fiverr, Direct client';

  @override
  String get excludeFromSafeToSpend => 'Exclude from Safe-to-Spend';

  @override
  String get excludeFromSafeToSpendSubtitle =>
      'Use when this payment shouldn\'t affect your numbers';

  @override
  String get incomeUpdatedSuccess => 'Income updated successfully';

  @override
  String get incomeSavedSuccess => 'Income saved successfully';

  @override
  String get incomeFailedToSave => 'Failed to save income. Please try again.';

  @override
  String get incomeEntryNotFound => 'Income entry not found';

  @override
  String get incomeEntryDeleted => 'This income entry may have been deleted.';

  @override
  String get goBack => 'Go Back';

  @override
  String get filterAll => 'All';

  @override
  String get excluded => 'Excluded';

  @override
  String get trackIncomePipeline => 'Track your income pipeline';

  @override
  String get addFirstExpectedPayment =>
      'Add your first expected payment to see\nwhen money is coming in.';

  @override
  String get noExpectedPayments => 'No expected payments';

  @override
  String get noPaymentsInTransit => 'No payments in transit';

  @override
  String get noReceivedPaymentsYet => 'No received payments yet';

  @override
  String get nothingHere => 'Nothing here';

  @override
  String get addOneForNewProject => 'Add one when you start a new project.';

  @override
  String get noPaymentsInTransitNow => 'No payments in transit right now.';

  @override
  String get noPaymentsReceivedThisMonth =>
      'No payments received this month yet.';

  @override
  String get useButtonToAdd => 'Use the + button to add an income entry.';

  @override
  String get undo => 'Undo';

  @override
  String get confirmReceived => 'Confirm — adds to liquid';

  @override
  String get notYet => 'Not yet';

  @override
  String get amountReceived => 'Amount received';

  @override
  String get fxRateBdtPerUsd => 'FX rate (BDT per USD)';

  @override
  String get dateReceived => 'Date received';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get notifications => 'Notifications';

  @override
  String get clearAll => 'Clear all';

  @override
  String get allNotificationsCleared => 'All notifications cleared';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get notificationsWillShowHere =>
      'Nudges and updates will show here when available.';

  @override
  String get notificationRemoved => 'Notification removed';

  @override
  String get dateGroupToday => 'Today';

  @override
  String get dateGroupYesterday => 'Yesterday';

  @override
  String get dateGroupThisWeek => 'This Week';

  @override
  String get dateGroupOlder => 'Older';

  @override
  String get notificationPreferences => 'Notification preferences';

  @override
  String get checkInFrequency => 'Check-in Frequency';

  @override
  String get notificationPrefsSaved => 'Notification preferences saved';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get settings => 'Settings';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get devResetOnboarding => 'Reset onboarding (dev only)';

  @override
  String get safeToSpendSettingsTitle => 'Safe-to-Spend Settings';

  @override
  String get taxReserveRate => 'Tax Reserve Rate';

  @override
  String get taxReserveRateDescription =>
      'Estimated percentage of income to reserve for taxes.';

  @override
  String get breathingRoom => 'Breathing room';

  @override
  String get breathingRoomDescription =>
      'Reserve this % of expected income as a buffer';

  @override
  String breathingRoomPercentOfExpected(String percent) {
    return '$percent% of expected income';
  }

  @override
  String get fixedCosts => 'Fixed Costs';

  @override
  String get fixedCostsDescription =>
      'Fixed costs deducted from Safe-to-Spend each month.';

  @override
  String get noFixedCostsYet => 'No fixed costs added yet.';

  @override
  String get addFixedCost => 'Add Fixed Cost';

  @override
  String get saveFixedCost => 'Save Fixed Cost';

  @override
  String get editFixedCost => 'Edit Fixed Cost';

  @override
  String get exportMyData => 'Export my data';

  @override
  String get changeHistory => 'Change history';

  @override
  String get deleteAllData => 'Delete all data';
}
