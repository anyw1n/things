import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:things/i18n/translations.g.dart';
import 'package:things/router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            routerConfig: appRouter,
            locale: TranslationProvider.of(context).flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            theme: .new(
              useMaterial3: true,
              brightness: .dark,
              colorSchemeSeed: Colors.deepPurple,
              fontFamily: 'Manrope',
              textTheme: const .new(
                displayMedium: .new(
                  fontSize: 36,
                  fontVariations: [.weight(800)],
                ),
                displaySmall: .new(
                  fontSize: 18,
                  fontVariations: [.weight(500)],
                ),
                labelLarge: .new(
                  fontVariations: [.weight(600)],
                ),
                bodyLarge: .new(
                  fontVariations: [.weight(400)],
                ),
                bodyMedium: .new(
                  fontVariations: [.weight(400)],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
