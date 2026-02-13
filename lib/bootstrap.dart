import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:things/di.dart' as di;
import 'package:things/firebase_options.dart';
import 'package:things/i18n/translations.g.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.configureDependencies();
  await [
    LocaleSettings.useDeviceLocale(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ].wait;
}
