import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:things/core/di/di.dart' as di;
import 'package:things/core/i18n/translations.g.dart';
import 'package:things/firebase_options.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.configureDependencies();
  await [
    SystemChrome.setPreferredOrientations([.portraitUp]),
    LocaleSettings.useDeviceLocale(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ].wait;
}
