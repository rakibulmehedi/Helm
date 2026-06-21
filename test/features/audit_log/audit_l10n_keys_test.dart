import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:helm/l10n/app_localizations.dart';

void main() {
  testWidgets('new History/audit l10n keys resolve in en', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialAppL10nProbe(onBuilt: (value) => l10n = value),
    );
    expect(l10n.ledgerVerified(3), contains('3'));
    expect(l10n.ledgerIntegrityIssue, isNotEmpty);
    expect(l10n.historyRetentionNote(90), contains('90'));
    expect(l10n.historyGroupToday, isNotEmpty);
    expect(l10n.auditDetailBefore, isNotEmpty);
    expect(l10n.auditRelativeMinutesAgo(5), contains('5'));
  });
}

class MaterialAppL10nProbe extends StatelessWidget {
  const MaterialAppL10nProbe({super.key, required this.onBuilt});
  final void Function(AppLocalizations) onBuilt;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xFF000000),
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('bn')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, _) {
        onBuilt(AppLocalizations.of(context)!);
        return const SizedBox.shrink();
      },
    );
  }
}
