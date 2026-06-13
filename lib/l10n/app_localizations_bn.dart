// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'পকেটা';

  @override
  String get appTagline => 'এখন আপনি আসলে কত টাকা খরচ করতে পারবেন?';

  @override
  String get continueSetupSafeToSpend =>
      'এগিয়ে যান — নিরাপদ ব্যয়সীমা সেট করুন';

  @override
  String get setUpLater => 'পরে সেট করব';

  @override
  String get signInToPocketa => 'পকেটায় সাইন ইন করুন';

  @override
  String get magicLinkSubtitle =>
      'আপনার ইমেইল দিন — আমরা সাথে সাথে সাইন ইনের একটি ম্যাজিক লিংক পাঠাব।';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get sendMagicLink => 'ম্যাজিক লিংক পাঠান';

  @override
  String get sending => 'পাঠানো হচ্ছে...';

  @override
  String get checkYourInbox => 'আপনার ইনবক্স দেখুন';

  @override
  String magicLinkSentSubtitle(String email) {
    return '$email-এ একটি লিংক পাঠানো হয়েছে।\nনিচে কোড দিন, অথবা ইমেইলের লিংকে ট্যাপ করুন।';
  }

  @override
  String get pasteVerificationCode => 'ভেরিফিকেশন কোড পেস্ট করুন';

  @override
  String get verifyAndSignIn => 'যাচাই করুন এবং সাইন ইন করুন';

  @override
  String get verifying => 'যাচাই হচ্ছে...';

  @override
  String get useDifferentEmail => '← অন্য ইমেইল ব্যবহার করুন';

  @override
  String get errorEnterEmail => 'আপনার ইমেইল ঠিকানা দিন';

  @override
  String get errorTooManyRequests =>
      'অনেকবার চেষ্টা করা হয়েছে। একটু পরে আবার লিংক চান।';

  @override
  String get errorEnterCode => 'ভেরিফিকেশন কোড দিন বা লিংক পেস্ট করুন';

  @override
  String get errorInvalidCode =>
      'কোডটি ভুল বা মেয়াদ শেষ হয়ে গেছে। নতুন কোড চান।';

  @override
  String get qualifyingQuestion =>
      'আপনি কি কখনো মনে করে টাকা খরচ করেছেন যে পেমেন্ট ক্লিয়ার হয়েছে,\nপরে দেখেছেন হয়নি?';

  @override
  String get qualifyingSubtext =>
      'যদি আপনি USD-এ আয় করেন এবং BDT-তে খরচ করেন — Upwork, Fiverr বা Payoneer-এর মাধ্যমে — এটা প্রায়ই হয়।';

  @override
  String get qualifyingRephraseBn =>
      'আপনি কি কখনো টাকা খরচ করে ফেলেছেন ভেবে যে\nপেমেন্ট ক্লিয়ার হয়েছে, পরে দেখেছেন হয়নি?';

  @override
  String get doesThatSoundFamiliar => 'এটা কি আপনার সাথে মেলে?';

  @override
  String get yesHappenedToMe => 'হ্যাঁ, আমার সাথে এটা হয়';

  @override
  String get noAlwaysKnow => 'না, আমি সবসময় জানি কতটুকু ক্লিয়ার হয়েছে';

  @override
  String get disqualifyHeading =>
      'পকেটা বাংলাদেশের USD-আয়কারী ফ্রিল্যান্সারদের জন্য তৈরি।';

  @override
  String get disqualifySubtext =>
      'যখন আন্তর্জাতিক কাজ শুরু করবেন, তখন ফিরে আসুন।';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get liquidBalanceQuestion => 'এখন আপনার কাছে মোটামুটি কত টাকা আছে?';

  @override
  String get liquidBalanceSubtext =>
      'বিকাশ, ব্যাংক, এবং নগদ — সব মিলিয়ে। একটা আনুমানিক সংখ্যাই যথেষ্ট, পরে ঠিক করা যাবে।';

  @override
  String get liquidBalanceFieldLabel => 'বর্তমান লিকুইড ব্যালেন্স (BDT)';

  @override
  String get liquidBalanceError =>
      'নিরাপদ ব্যয়সীমা হিসাব করতে বর্তমান BDT ব্যালেন্স দিন।';

  @override
  String get fixedCostsQuestion => 'আপনার মাসিক নির্দিষ্ট খরচ কী কী?';

  @override
  String get fixedCostsSubtext =>
      'আগামী ৩০ দিনে যে খরচগুলো আসবে। যেগুলো প্রযোজ্য সেগুলো ট্যাপ করুন।';

  @override
  String get fixedCostsNoneSelected =>
      'কোনো মাসিক নির্দিষ্ট খরচ নির্বাচন করা হয়নি।';

  @override
  String get fixedCostsNoneExplainer =>
      'নির্দিষ্ট খরচ নিরাপদ ব্যয়সীমা কমায়। পরে সেটিংস থেকে যোগ করতে পারবেন।';

  @override
  String get skipForNow => 'এখন বাদ দিন';

  @override
  String get letMeAddSome => 'যোগ করতে চাই';

  @override
  String get firstPipelineQuestion => 'শীঘ্রই কোনো টাকা আসছে?';

  @override
  String get firstPipelineSubtext =>
      'প্রত্যাশিত আয় যোগ করলে নিরাপদ ব্যয়সীমা প্রথম দিন থেকেই পুরো চিত্র দেখাবে।';

  @override
  String get clientOrSource => 'ক্লায়েন্ট বা সোর্স';

  @override
  String get clientOrSourceHint => 'যেমন: Upwork, Client X';

  @override
  String get whoIsThisFrom => 'এটা কার কাছ থেকে?';

  @override
  String get pipelineEntryNote =>
      'এটা \"প্রত্যাশিত\" হিসেবে রাখা হবে। পরে স্ট্যাটাস পরিবর্তন করতে পারবেন।';

  @override
  String get addToMyPipeline => 'পাইপলাইনে যোগ করুন';

  @override
  String get skipAddLater => 'এখন বাদ দিন — পরে যোগ করব';

  @override
  String get safeToSpendLabel => 'নিরাপদ ব্যয়সীমা';

  @override
  String get safeToSpendSubLabel => 'নির্দিষ্ট খরচ ও বাফার বাদে';

  @override
  String get receivedOnly => 'শুধু প্রাপ্ত';

  @override
  String get tapToSeeMath => 'হিসাব দেখতে নম্বরে ট্যাপ করুন';

  @override
  String get addPipelineEntry => 'আয় যোগ করুন';

  @override
  String get fixedCostsSectionTitle => 'নির্দিষ্ট খরচ';

  @override
  String get fixedCostsSectionSubtitle => 'আগামী ৩০ দিনে দেয় মাসিক খরচ';

  @override
  String get fixedCostsEmpty =>
      'এখনো কোনো নির্দিষ্ট খরচ যোগ করা হয়নি। যোগ করলে নিরাপদ ব্যয়সীমা আরও নির্ভুল হবে।';

  @override
  String get addFixedCostsLink => 'নির্দিষ্ট খরচ যোগ করুন →';

  @override
  String get safetyBufferTitle => 'সেফটি বাফার';

  @override
  String get safetyBufferSubtitle =>
      'লক করা নয় — হিসাবের ভেতরে একটি নিরাপত্তা মার্জিন';

  @override
  String get safetyBufferEmpty =>
      'কোনো সেফটি বাফার সেট করা নেই। পুরো লিকুইড BDT দিয়ে নিরাপদ ব্যয়সীমা হিসাব হবে।';

  @override
  String get notCountedTitle => 'এখনো গণনায় নেই';

  @override
  String get notCountedSubtitle => 'এখনো গণনায় নেই — প্রত্যাশিত পেমেন্ট';

  @override
  String get notCountedEmpty =>
      'যখন ইনভয়েস করবেন বা টাকা আশা করবেন তখন প্রত্যাশিত পেমেন্ট যোগ করুন।';

  @override
  String get addExpectedPaymentLink => 'প্রত্যাশিত পেমেন্ট যোগ করুন →';

  @override
  String get pending => 'পেন্ডিং';

  @override
  String get expected => 'প্রত্যাশিত';

  @override
  String get received => 'প্রাপ্ত';

  @override
  String get ifAllCounted => 'সব গণনায় ধরলে:';

  @override
  String get incomePipeline => 'আয়ের পাইপলাইন';

  @override
  String get addIncome => 'আয় যোগ করুন';

  @override
  String get editIncome => 'আয় সম্পাদনা করুন';

  @override
  String get updateIncome => 'আয় আপডেট করুন';

  @override
  String get saveIncome => 'আয় সংরক্ষণ করুন';

  @override
  String get clientName => 'ক্লায়েন্টের নাম';

  @override
  String get clientNameHint => 'যেমন: Upwork, Client X';

  @override
  String get clientNameRequired => 'ক্লায়েন্টের নাম দেওয়া আবশ্যক';

  @override
  String get projectName => 'প্রজেক্টের নাম';

  @override
  String get projectNameHint => 'যেমন: Website Redesign';

  @override
  String get projectNameRequired => 'প্রজেক্টের নাম দেওয়া আবশ্যক';

  @override
  String get amount => 'পরিমাণ';

  @override
  String get amountRequired => 'পরিমাণ দেওয়া আবশ্যক';

  @override
  String get amountInvalid => '০-এর বেশি একটি সঠিক পরিমাণ দিন';

  @override
  String get fxRateLabel => 'FX রেট (প্রতি USD-এ BDT)';

  @override
  String get fxRateHint => 'যেমন: ১১০.৫';

  @override
  String get fxRateRequired => 'FX রেট দেওয়া আবশ্যক';

  @override
  String get statusLabel => 'স্ট্যাটাস';

  @override
  String get expectedDate => 'প্রত্যাশিত তারিখ';

  @override
  String get receivedDate => 'প্রাপ্তির তারিখ';

  @override
  String get selectDate => 'তারিখ বেছে নিন';

  @override
  String get selectReceivedDate => 'প্রাপ্তির তারিখ বেছে নিন';

  @override
  String get pleaseSelectReceivedDate => 'প্রাপ্তির তারিখ নির্বাচন করুন।';

  @override
  String get notesOptional => 'নোট (ঐচ্ছিক)';

  @override
  String get addANote => 'একটি নোট লিখুন…';

  @override
  String get paymentSourceOptional => 'পেমেন্ট সোর্স (ঐচ্ছিক)';

  @override
  String get paymentSourceHint => 'যেমন: Upwork, Fiverr, সরাসরি ক্লায়েন্ট';

  @override
  String get excludeFromSafeToSpend => 'নিরাপদ ব্যয়সীমা থেকে বাদ দিন';

  @override
  String get excludeFromSafeToSpendSubtitle =>
      'যখন এই পেমেন্ট আপনার হিসাবে প্রভাব ফেলবে না';

  @override
  String get incomeUpdatedSuccess => 'আয় সফলভাবে আপডেট হয়েছে';

  @override
  String get incomeSavedSuccess => 'আয় সফলভাবে সংরক্ষিত হয়েছে';

  @override
  String get incomeFailedToSave => 'আয় সংরক্ষণ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get incomeEntryNotFound => 'আয়ের এন্ট্রি পাওয়া যায়নি';

  @override
  String get incomeEntryDeleted =>
      'এই আয়ের এন্ট্রিটি মুছে ফেলা হয়ে থাকতে পারে।';

  @override
  String get goBack => 'ফিরে যান';

  @override
  String get filterAll => 'সব';

  @override
  String get excluded => 'বাদ দেওয়া হয়েছে';

  @override
  String get trackIncomePipeline => 'আপনার আয়ের পাইপলাইন ট্র্যাক করুন';

  @override
  String get addFirstExpectedPayment =>
      'প্রথম প্রত্যাশিত পেমেন্ট যোগ করুন — কখন টাকা আসবে দেখতে পাবেন।';

  @override
  String get noExpectedPayments => 'কোনো প্রত্যাশিত পেমেন্ট নেই';

  @override
  String get noPaymentsInTransit => 'ট্রানজিটে কোনো পেমেন্ট নেই';

  @override
  String get noReceivedPaymentsYet => 'এখনো কোনো পেমেন্ট প্রাপ্ত হয়নি';

  @override
  String get nothingHere => 'এখানে কিছু নেই';

  @override
  String get addOneForNewProject => 'নতুন প্রজেক্ট শুরু করলে একটি যোগ করুন।';

  @override
  String get noPaymentsInTransitNow => 'এখন ট্রানজিটে কোনো পেমেন্ট নেই।';

  @override
  String get noPaymentsReceivedThisMonth => 'এই মাসে এখনো কোনো পেমেন্ট পাননি।';

  @override
  String get useButtonToAdd => '+ বোতাম ব্যবহার করে আয় যোগ করুন।';

  @override
  String get undo => 'পূর্বাবস্থায় ফেরান';

  @override
  String get confirmReceived => 'নিশ্চিত করুন — লিকুইডে যোগ হবে';

  @override
  String get notYet => 'এখনো না';

  @override
  String get amountReceived => 'প্রাপ্ত পরিমাণ';

  @override
  String get fxRateBdtPerUsd => 'FX রেট (প্রতি USD-এ BDT)';

  @override
  String get dateReceived => 'প্রাপ্তির তারিখ';

  @override
  String get enterValidAmount => 'সঠিক পরিমাণ দিন';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get clearAll => 'সব মুছুন';

  @override
  String get allNotificationsCleared => 'সব নোটিফিকেশন মুছে ফেলা হয়েছে';

  @override
  String get noNotificationsYet => 'এখনো কোনো নোটিফিকেশন নেই';

  @override
  String get notificationsWillShowHere =>
      'নাজ ও আপডেটগুলো পাওয়া গেলে এখানে দেখা যাবে।';

  @override
  String get notificationRemoved => 'নোটিফিকেশন সরানো হয়েছে';

  @override
  String get dateGroupToday => 'আজ';

  @override
  String get dateGroupYesterday => 'গতকাল';

  @override
  String get dateGroupThisWeek => 'এই সপ্তাহ';

  @override
  String get dateGroupOlder => 'আগের';

  @override
  String get notificationPreferences => 'নোটিফিকেশন পছন্দ';

  @override
  String get checkInFrequency => 'চেক-ইন ফ্রিকোয়েন্সি';

  @override
  String get notificationPrefsSaved => 'নোটিফিকেশন পছন্দ সংরক্ষিত হয়েছে';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get cancel => 'বাতিল';

  @override
  String get settings => 'সেটিংস';

  @override
  String get dashboard => 'ড্যাশবোর্ড';

  @override
  String get devResetOnboarding => 'অনবোর্ডিং রিসেট করুন (শুধু ডেভ)';
}
