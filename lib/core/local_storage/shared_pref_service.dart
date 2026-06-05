import 'package:pocketa_v2/core/constants/app_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  static SharedPreferences? _prefs;
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _userCurrencyKey = 'user_currency';
  static const String _userLanguageKey = 'user_language';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUserLanguage(AppLanguage language) async {
    await _prefs?.setString(_userLanguageKey, language.name);
  }

  static String? getUserLanguageCode() {
    return _prefs?.getString(_userLanguageKey) ?? 'en';
  }

  static Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs?.setBool(_onboardingCompletedKey, completed ? true : false);
  }

  static bool getOnboardingCompleted() {
    return _prefs?.getBool(_onboardingCompletedKey) ?? false;
  }

  static Future<void> setIsDarkMode(bool isDarkMode) async {
    await _prefs?.setBool(_isDarkModeKey, isDarkMode ? true : false);
  }

  static bool getIsDarkMode() {
    return _prefs?.getBool(_isDarkModeKey) ?? false;
  }

  static Future<void> setUserCurrency(String currency) async {
    await _prefs?.setString(_userCurrencyKey, currency);
  }

  static String getUserCurrency() {
    return _prefs?.getString(_userCurrencyKey) ?? 'BDT';
  }

  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  static const String _liquidBalanceBdtKey = 'liquid_balance_bdt';
  static const String _incomePatternKey = 'income_pattern';

  static Future<void> setLiquidBalanceBdt(double amount) async {
    await _prefs?.setDouble(_liquidBalanceBdtKey, amount);
  }

  static double getLiquidBalanceBdt() {
    return _prefs?.getDouble(_liquidBalanceBdtKey) ?? 0.0;
  }

  static Future<void> setIncomePattern(String pattern) async {
    await _prefs?.setString(_incomePatternKey, pattern);
  }

  static String getIncomePattern() {
    return _prefs?.getString(_incomePatternKey) ?? 'marketplace';
  }
}
