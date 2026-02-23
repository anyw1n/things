import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:thoughts/core/di/di.config.dart';

final getIt = GetIt.instance;

@injectableInit
void configureDependencies() => getIt.init();
