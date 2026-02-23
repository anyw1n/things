import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:thoughts/core/di/di.dart' as di;
import 'package:thoughts/core/i18n/translations.g.dart';
import 'package:thoughts/firebase_options.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.configureDependencies();
  await [
    SystemChrome.setPreferredOrientations([.portraitUp]),
    LocaleSettings.useDeviceLocale(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ].wait;
}
