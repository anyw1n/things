import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:things/di.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
