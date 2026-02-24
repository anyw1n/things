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
import 'package:thoughts/core/database/app_database.dart' as _i33;
import 'package:thoughts/core/repository/thoughts_repository.dart' as _i485;
import 'package:thoughts/core/services/ai_service.dart' as _i1031;
import 'package:thoughts/features/daily_thoughts/bloc/add_thoughts/add_thoughts_bloc.dart'
    as _i286;
import 'package:thoughts/features/daily_thoughts/bloc/day_thoughts/day_thoughts_bloc.dart'
    as _i361;
import 'package:thoughts/features/daily_thoughts/bloc/thought_details/thought_details_bloc.dart'
    as _i613;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i33.AppDatabase>(() => _i33.AppDatabase());
    gh.lazySingleton<_i485.ThoughtsRepository>(
      () => _i485.DriftThoughtsRepository(gh<_i33.AppDatabase>()),
    );
    gh.lazySingleton<_i1031.AiService>(() => const _i1031.FirebaseAiService());
    gh.factory<_i286.AddThoughtsBloc>(
      () => _i286.AddThoughtsBloc(
        gh<_i485.ThoughtsRepository>(),
        gh<_i1031.AiService>(),
      ),
    );
    gh.factoryParam<_i613.ThoughtDetailsBloc, int, dynamic>(
      (_thoughtId, _) =>
          _i613.ThoughtDetailsBloc(_thoughtId, gh<_i485.ThoughtsRepository>()),
    );
    gh.factoryParam<_i361.DayThoughtsBloc, DateTime, dynamic>(
      (date, _) => _i361.DayThoughtsBloc(date, gh<_i485.ThoughtsRepository>()),
    );
    return this;
  }
}
