import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helm/core/local_storage/shared_pref_service.dart';

import '../../core/constants/app_language.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((
  ref,
) {
  final langCode = SharedPrefServices.getUserLanguageCode();
  final lang = AppLanguageParser.fromCode(langCode);
  return LanguageNotifier(lang);
});

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier(super.savedLang);

  void changeLanguage(AppLanguage lang) {
    state = lang;
    SharedPrefServices.setUserLanguage(lang);
  }
}

