import 'package:flutter/material.dart';
import 'package:pocketa_v2/l10n/app_localizations.dart';
export 'package:pocketa_v2/l10n/app_localizations.dart';

extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}