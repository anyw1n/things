import 'package:flutter/widgets.dart';
import 'package:things/di.dart' as di;
import 'package:things/i18n/translations.g.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  di.configureDependencies();
}
