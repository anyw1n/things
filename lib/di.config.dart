// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:things/blocs/add_thoughts/add_thoughts_bloc.dart' as _i251;
import 'package:things/blocs/day_thoughts/day_thoughts_bloc.dart' as _i893;
import 'package:things/data/database/app_database.dart' as _i909;
import 'package:things/data/repository/thoughts_repository.dart' as _i554;
import 'package:things/data/services/ai_service.dart' as _i680;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i909.AppDatabase>(() => _i909.AppDatabase());
    gh.lazySingleton<_i680.AiService>(() => const _i680.FirebaseAiService());
    gh.lazySingleton<_i554.ThoughtsRepository>(
      () => _i554.ThoughtsRepositoryImpl(gh<_i909.AppDatabase>()),
    );
    gh.factory<_i251.AddThoughtsBloc>(
      () => _i251.AddThoughtsBloc(
        gh<_i554.ThoughtsRepository>(),
        gh<_i680.AiService>(),
      ),
    );
    gh.factoryParam<_i893.DayThoughtsBloc, DateTime, dynamic>(
      (date, _) => _i893.DayThoughtsBloc(date, gh<_i554.ThoughtsRepository>()),
    );
    return this;
  }
}
