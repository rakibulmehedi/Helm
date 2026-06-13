import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Pocketa'**
  String get appName;

  /// Welcome screen tagline
  ///
  /// In en, this message translates to:
  /// **'How much BDT can you actually spend right now?'**
  String get appTagline;

  /// Welcome screen primary CTA
  ///
  /// In en, this message translates to:
  /// **'Continue — sets up your Safe-to-Spend'**
  String get continueSetupSafeToSpend;

  /// Onboarding skip button
  ///
  /// In en, this message translates to:
  /// **'Set up later'**
  String get setUpLater;

  /// Magic link screen heading
  ///
  /// In en, this message translates to:
  /// **'Sign in to Pocketa'**
  String get signInToPocketa;

  /// Magic link email step subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter your email — we\'ll send you a magic link to sign in instantly.'**
  String get magicLinkSubtitle;

  /// Email field hint text
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// Button to send magic link
  ///
  /// In en, this message translates to:
  /// **'Send Magic Link'**
  String get sendMagicLink;

  /// Loading state for send magic link button
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// Magic link verify step heading
  ///
  /// In en, this message translates to:
  /// **'Check your inbox'**
  String get checkYourInbox;

  /// Magic link sent confirmation text
  ///
  /// In en, this message translates to:
  /// **'We sent a link to {email}.\nEnter the code below, or tap the link in your email.'**
  String magicLinkSentSubtitle(String email);

  /// Token field hint text
  ///
  /// In en, this message translates to:
  /// **'Paste verification code'**
  String get pasteVerificationCode;

  /// Verify token button label
  ///
  /// In en, this message translates to:
  /// **'Verify & Sign In'**
  String get verifyAndSignIn;

  /// Loading state for verify button
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// Back to email step link
  ///
  /// In en, this message translates to:
  /// **'← Use a different email'**
  String get useDifferentEmail;

  /// Validation: email empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get errorEnterEmail;

  /// Rate-limited error message
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait before requesting another link.'**
  String get errorTooManyRequests;

  /// Validation: token empty
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code or paste the link'**
  String get errorEnterCode;

  /// Invalid token error message
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired verification code. Request a new one.'**
  String get errorInvalidCode;

  /// Onboarding qualifying question heading
  ///
  /// In en, this message translates to:
  /// **'Have you ever spent money thinking a\npayment cleared, then realized it hadn\'t?'**
  String get qualifyingQuestion;

  /// Qualifying question supporting text
  ///
  /// In en, this message translates to:
  /// **'If you earn in USD and spend in BDT — through\nUpwork, Fiverr, or Payoneer — this happens a lot.'**
  String get qualifyingSubtext;

  /// Bangla rephrase shown after 12s inactivity
  ///
  /// In en, this message translates to:
  /// **'আপনি কি কখনো টাকা খরচ করে ফেলেছেন ভেবে যে\nপেমেন্ট ক্লিয়ার হয়েছে, পরে দেখেছেন হয়নি?'**
  String get qualifyingRephraseBn;

  /// Qualifying question follow-up
  ///
  /// In en, this message translates to:
  /// **'Does that sound familiar?'**
  String get doesThatSoundFamiliar;

  /// Qualifying: affirm button
  ///
  /// In en, this message translates to:
  /// **'Yes, that happens to me'**
  String get yesHappenedToMe;

  /// Qualifying: disqualify button
  ///
  /// In en, this message translates to:
  /// **'No, I always know exactly what cleared'**
  String get noAlwaysKnow;

  /// Disqualify state heading
  ///
  /// In en, this message translates to:
  /// **'Pocketa is built for USD-earning freelancers in Bangladesh.'**
  String get disqualifyHeading;

  /// Disqualify state supporting text
  ///
  /// In en, this message translates to:
  /// **'Come back when you start billing internationally.'**
  String get disqualifySubtext;

  /// Close / disqualify button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Onboarding liquid balance heading
  ///
  /// In en, this message translates to:
  /// **'Roughly how much do you have right now?'**
  String get liquidBalanceQuestion;

  /// Liquid balance supporting text
  ///
  /// In en, this message translates to:
  /// **'bKash, bank, and cash — combined. A rough number is fine. You can refine it later.'**
  String get liquidBalanceSubtext;

  /// Semantics label for balance field
  ///
  /// In en, this message translates to:
  /// **'Current liquid balance in BDT'**
  String get liquidBalanceFieldLabel;

  /// Validation error for empty balance
  ///
  /// In en, this message translates to:
  /// **'Enter your current liquid BDT to calculate Safe-to-Spend.'**
  String get liquidBalanceError;

  /// Fixed costs onboarding heading
  ///
  /// In en, this message translates to:
  /// **'What are your fixed monthly costs?'**
  String get fixedCostsQuestion;

  /// Fixed costs supporting text
  ///
  /// In en, this message translates to:
  /// **'Monthly costs due in the next 30 days. Tap any that apply.'**
  String get fixedCostsSubtext;

  /// Zero state reask heading
  ///
  /// In en, this message translates to:
  /// **'No fixed monthly costs selected.'**
  String get fixedCostsNoneSelected;

  /// Zero state reask body
  ///
  /// In en, this message translates to:
  /// **'Fixed costs reduce Safe-to-Spend. You can add them in Settings later.'**
  String get fixedCostsNoneExplainer;

  /// Skip fixed costs button
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// Return to fixed costs list button
  ///
  /// In en, this message translates to:
  /// **'Let me add some'**
  String get letMeAddSome;

  /// First pipeline page heading
  ///
  /// In en, this message translates to:
  /// **'Any money coming in soon?'**
  String get firstPipelineQuestion;

  /// First pipeline supporting text
  ///
  /// In en, this message translates to:
  /// **'Adding expected income helps Safe-to-Spend show you the full picture from day one.'**
  String get firstPipelineSubtext;

  /// Pipeline client name field label
  ///
  /// In en, this message translates to:
  /// **'Client or source'**
  String get clientOrSource;

  /// Pipeline client name field hint
  ///
  /// In en, this message translates to:
  /// **'e.g. Upwork, Client X'**
  String get clientOrSourceHint;

  /// Validation: client name empty
  ///
  /// In en, this message translates to:
  /// **'Who is this from?'**
  String get whoIsThisFrom;

  /// Info note on first pipeline entry
  ///
  /// In en, this message translates to:
  /// **'This will be marked as \"Expected\". You can update the status later.'**
  String get pipelineEntryNote;

  /// Submit first pipeline entry button
  ///
  /// In en, this message translates to:
  /// **'Add to my pipeline'**
  String get addToMyPipeline;

  /// Skip first pipeline entry
  ///
  /// In en, this message translates to:
  /// **'Skip — I\'ll add it later'**
  String get skipAddLater;

  /// Hero block label above the S2S number
  ///
  /// In en, this message translates to:
  /// **'SAFE-TO-SPEND'**
  String get safeToSpendLabel;

  /// Hero block subtitle under the S2S number
  ///
  /// In en, this message translates to:
  /// **'after fixed costs + safety buffer'**
  String get safeToSpendSubLabel;

  /// Trust strip source label
  ///
  /// In en, this message translates to:
  /// **'Received only'**
  String get receivedOnly;

  /// One-time S2S hint shown on first dashboard view
  ///
  /// In en, this message translates to:
  /// **'Tap the number to see the math'**
  String get tapToSeeMath;

  /// FAB tooltip on dashboard and income list
  ///
  /// In en, this message translates to:
  /// **'Add income entry'**
  String get addPipelineEntry;

  /// Committed section heading
  ///
  /// In en, this message translates to:
  /// **'Fixed costs'**
  String get fixedCostsSectionTitle;

  /// Committed section sub-label
  ///
  /// In en, this message translates to:
  /// **'Monthly costs due in the next 30 days'**
  String get fixedCostsSectionSubtitle;

  /// Committed section empty state
  ///
  /// In en, this message translates to:
  /// **'No fixed costs added yet. Add them to improve Safe-to-Spend accuracy.'**
  String get fixedCostsEmpty;

  /// Committed section CTA link
  ///
  /// In en, this message translates to:
  /// **'Add fixed costs →'**
  String get addFixedCostsLink;

  /// Reserve section heading
  ///
  /// In en, this message translates to:
  /// **'Safety buffer'**
  String get safetyBufferTitle;

  /// Reserve section sub-label
  ///
  /// In en, this message translates to:
  /// **'Not locked — a safety margin inside the calculation'**
  String get safetyBufferSubtitle;

  /// Reserve section empty state
  ///
  /// In en, this message translates to:
  /// **'No safety buffer set. Safe-to-Spend uses your full liquid BDT.'**
  String get safetyBufferEmpty;

  /// Not counted section heading
  ///
  /// In en, this message translates to:
  /// **'Not counted yet'**
  String get notCountedTitle;

  /// Not counted section sub-label
  ///
  /// In en, this message translates to:
  /// **'Not counted yet — expected payments'**
  String get notCountedSubtitle;

  /// Not counted section empty state
  ///
  /// In en, this message translates to:
  /// **'Add an expected payment when you invoice or expect money.'**
  String get notCountedEmpty;

  /// Not counted section CTA link
  ///
  /// In en, this message translates to:
  /// **'Add expected payment →'**
  String get addExpectedPaymentLink;

  /// Pipeline status: pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Pipeline status: expected
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get expected;

  /// Pipeline status: received
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// Horizon number label in not-counted section
  ///
  /// In en, this message translates to:
  /// **'If all counted:'**
  String get ifAllCounted;

  /// Income list screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Income Pipeline'**
  String get incomePipeline;

  /// Add income screen title and empty state button
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get addIncome;

  /// Edit income screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Income'**
  String get editIncome;

  /// Update button in edit income screen
  ///
  /// In en, this message translates to:
  /// **'Update Income'**
  String get updateIncome;

  /// Save button in add income screen
  ///
  /// In en, this message translates to:
  /// **'Save Income'**
  String get saveIncome;

  /// Income form: client name label
  ///
  /// In en, this message translates to:
  /// **'Client Name'**
  String get clientName;

  /// Income form: client name hint
  ///
  /// In en, this message translates to:
  /// **'e.g. Upwork, Client X'**
  String get clientNameHint;

  /// Validation: client name empty
  ///
  /// In en, this message translates to:
  /// **'Client name is required'**
  String get clientNameRequired;

  /// Income form: project name label
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get projectName;

  /// Income form: project name hint
  ///
  /// In en, this message translates to:
  /// **'e.g. Website Redesign'**
  String get projectNameHint;

  /// Validation: project name empty
  ///
  /// In en, this message translates to:
  /// **'Project name is required'**
  String get projectNameRequired;

  /// Income form: amount label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Validation: amount empty
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get amountRequired;

  /// Validation: amount invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount greater than 0'**
  String get amountInvalid;

  /// Income form: FX rate label
  ///
  /// In en, this message translates to:
  /// **'FX Rate (BDT per USD)'**
  String get fxRateLabel;

  /// Income form: FX rate hint
  ///
  /// In en, this message translates to:
  /// **'e.g. 110.5'**
  String get fxRateHint;

  /// Validation: FX rate empty for USD
  ///
  /// In en, this message translates to:
  /// **'FX rate required'**
  String get fxRateRequired;

  /// Income form: status section label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// Income form: expected date label
  ///
  /// In en, this message translates to:
  /// **'Expected Date'**
  String get expectedDate;

  /// Income form: received date label
  ///
  /// In en, this message translates to:
  /// **'Received Date'**
  String get receivedDate;

  /// Date picker placeholder
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// Received date picker placeholder
  ///
  /// In en, this message translates to:
  /// **'Select received date'**
  String get selectReceivedDate;

  /// Validation: received date missing
  ///
  /// In en, this message translates to:
  /// **'Please select a received date.'**
  String get pleaseSelectReceivedDate;

  /// Income form: notes label
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// Income form: notes hint
  ///
  /// In en, this message translates to:
  /// **'Add a note…'**
  String get addANote;

  /// Income form: payment source label
  ///
  /// In en, this message translates to:
  /// **'Payment Source (optional)'**
  String get paymentSourceOptional;

  /// Income form: payment source hint
  ///
  /// In en, this message translates to:
  /// **'e.g. Upwork, Fiverr, Direct client'**
  String get paymentSourceHint;

  /// Income form: exclude toggle title
  ///
  /// In en, this message translates to:
  /// **'Exclude from Safe-to-Spend'**
  String get excludeFromSafeToSpend;

  /// Income form: exclude toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Use when this payment shouldn\'t affect your numbers'**
  String get excludeFromSafeToSpendSubtitle;

  /// Toast on successful income update
  ///
  /// In en, this message translates to:
  /// **'Income updated successfully'**
  String get incomeUpdatedSuccess;

  /// Toast on successful income save
  ///
  /// In en, this message translates to:
  /// **'Income saved successfully'**
  String get incomeSavedSuccess;

  /// Toast on income save failure
  ///
  /// In en, this message translates to:
  /// **'Failed to save income. Please try again.'**
  String get incomeFailedToSave;

  /// Error heading when income entity is missing
  ///
  /// In en, this message translates to:
  /// **'Income entry not found'**
  String get incomeEntryNotFound;

  /// Error body when income entity is missing
  ///
  /// In en, this message translates to:
  /// **'This income entry may have been deleted.'**
  String get incomeEntryDeleted;

  /// Go back button in error state
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Income list filter chip: all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// Badge on excluded income card
  ///
  /// In en, this message translates to:
  /// **'Excluded'**
  String get excluded;

  /// Income list first-time empty state title
  ///
  /// In en, this message translates to:
  /// **'Track your income pipeline'**
  String get trackIncomePipeline;

  /// Income list first-time empty state body
  ///
  /// In en, this message translates to:
  /// **'Add your first expected payment to see\nwhen money is coming in.'**
  String get addFirstExpectedPayment;

  /// Income list filter empty: expected
  ///
  /// In en, this message translates to:
  /// **'No expected payments'**
  String get noExpectedPayments;

  /// Income list filter empty: pending
  ///
  /// In en, this message translates to:
  /// **'No payments in transit'**
  String get noPaymentsInTransit;

  /// Income list filter empty: received
  ///
  /// In en, this message translates to:
  /// **'No received payments yet'**
  String get noReceivedPaymentsYet;

  /// Income list filter empty: all
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get nothingHere;

  /// Empty state subtitle: expected
  ///
  /// In en, this message translates to:
  /// **'Add one when you start a new project.'**
  String get addOneForNewProject;

  /// Empty state subtitle: pending
  ///
  /// In en, this message translates to:
  /// **'No payments in transit right now.'**
  String get noPaymentsInTransitNow;

  /// Empty state subtitle: received
  ///
  /// In en, this message translates to:
  /// **'No payments received this month yet.'**
  String get noPaymentsReceivedThisMonth;

  /// Empty state subtitle: all
  ///
  /// In en, this message translates to:
  /// **'Use the + button to add an income entry.'**
  String get useButtonToAdd;

  /// Undo action label in toasts and snackbars
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Confirm received sheet primary button
  ///
  /// In en, this message translates to:
  /// **'Confirm — adds to liquid'**
  String get confirmReceived;

  /// Dismiss confirm received sheet
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get notYet;

  /// Confirm received sheet: amount field label
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get amountReceived;

  /// Confirm received sheet: FX rate label
  ///
  /// In en, this message translates to:
  /// **'FX rate (BDT per USD)'**
  String get fxRateBdtPerUsd;

  /// Confirm received sheet: date label
  ///
  /// In en, this message translates to:
  /// **'Date received'**
  String get dateReceived;

  /// Validation: amount in confirm sheet
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// Notification center screen title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notification center: clear all button
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// Toast after clearing all notifications
  ///
  /// In en, this message translates to:
  /// **'All notifications cleared'**
  String get allNotificationsCleared;

  /// Notification center empty state title
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// Notification center empty state body
  ///
  /// In en, this message translates to:
  /// **'Nudges and updates will show here when available.'**
  String get notificationsWillShowHere;

  /// Toast after dismissing a notification
  ///
  /// In en, this message translates to:
  /// **'Notification removed'**
  String get notificationRemoved;

  /// Notification center date group: today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateGroupToday;

  /// Notification center date group: yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateGroupYesterday;

  /// Notification center date group: this week
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get dateGroupThisWeek;

  /// Notification center date group: older
  ///
  /// In en, this message translates to:
  /// **'Older'**
  String get dateGroupOlder;

  /// Cadence sheet title
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// Cadence sheet: frequency section label
  ///
  /// In en, this message translates to:
  /// **'Check-in Frequency'**
  String get checkInFrequency;

  /// Toast after saving notification preferences
  ///
  /// In en, this message translates to:
  /// **'Notification preferences saved'**
  String get notificationPrefsSaved;

  /// Generic save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Generic cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Settings screen title / nav label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Dashboard nav label
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Dev-only reset tooltip on dashboard
  ///
  /// In en, this message translates to:
  /// **'Reset onboarding (dev only)'**
  String get devResetOnboarding;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
