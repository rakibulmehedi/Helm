import 'package:flutter/material.dart';
import 'package:helm/l10n/app_localizations.dart';
export 'package:helm/l10n/app_localizations.dart';

extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}