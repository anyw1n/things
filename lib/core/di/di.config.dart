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
import 'package:thoughts/core/database/app_database.dart' as _i517;
import 'package:thoughts/core/repository/thoughts_repository.dart' as _i348;
import 'package:thoughts/core/services/ai_service.dart' as _i990;
import 'package:thoughts/features/daily_thoughts/bloc/add_thoughts/add_thoughts_bloc.dart'
    as _i359;
import 'package:thoughts/features/daily_thoughts/bloc/day_thoughts/day_thoughts_bloc.dart'
    as _i595;
import 'package:thoughts/features/daily_thoughts/bloc/thought_details/thought_details_bloc.dart'
    as _i483;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i517.AppDatabase>(() => _i517.AppDatabase());
    gh.lazySingleton<_i348.ThoughtsRepository>(
      () => _i348.ThoughtsRepositoryImpl(gh<_i517.AppDatabase>()),
    );
    gh.lazySingleton<_i990.AiService>(() => const _i990.FirebaseAiService());
    gh.factoryParam<_i483.ThoughtDetailsBloc, int, dynamic>(
      (_thoughtId, _) =>
          _i483.ThoughtDetailsBloc(_thoughtId, gh<_i348.ThoughtsRepository>()),
    );
    gh.factoryParam<_i595.DayThoughtsBloc, DateTime, dynamic>(
      (date, _) => _i595.DayThoughtsBloc(date, gh<_i348.ThoughtsRepository>()),
    );
    gh.factory<_i359.AddThoughtsBloc>(
      () => _i359.AddThoughtsBloc(
        gh<_i348.ThoughtsRepository>(),
        gh<_i990.AiService>(),
      ),
    );
    return this;
  }
}
