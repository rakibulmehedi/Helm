// lib/main.dart
import 'package:flutter/material.dart';
import 'package:helm/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helm/config/router/app_router.dart';
import 'package:helm/core/security/widgets/app_lifecycle_lock.dart';
import 'package:helm/core/themes/app_theme.dart';

import 'application/providers/language_provider.dart';
import 'core/constants/app_language.dart';
import 'core/local_storage/hive_service.dart';
import 'core/local_storage/shared_pref_service.dart';
import 'core/nudge/notifications/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await SharedPrefServices.init();

  // Initialize local notifications (Group 3A)
  final notificationService = FlutterNotificationService();
  await notificationService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    return AppLifecycleLock(
      child: MaterialApp.router(
        title: 'Helm',
        // ── Localisation ─────────────────────────────────────────────────────
        locale: lang.local,
        supportedLocales: const [Locale('en'), Locale('bn')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // ── Theme ────────────────────────────────────────────────────────────
        theme: AppThemeData.lightTheme(context, lang),
        darkTheme: AppThemeData.darkTheme(context, lang),
        themeMode: ThemeMode.system,
        // ── Router ───────────────────────────────────────────────────────────
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
