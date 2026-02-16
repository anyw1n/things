import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:things/data/database/app_database.dart';
import 'package:things/data/repository/thoughts_repository.dart';
import 'package:things/utils.dart';

part 'day_thoughts_event.dart';
part 'day_thoughts_state.dart';

@injectable
class DayThoughtsBloc extends Bloc<DayThoughtsEvent, DayThoughtsState> {
  DayThoughtsBloc(@factoryParam DateTime date, this._repository)
    : _date = date.onlyDate,
      super(const .initial()) {
    on<DayThoughtsEvent>(
      (event, emit) => switch (event) {
        DayThoughtsLoadRequested() => _onLoadRequested(event, emit),
      },
      transformer: droppable(),
    );
  }

  final ThoughtsRepository _repository;
  final DateTime _date;

  Future<void> _onLoadRequested(
    DayThoughtsLoadRequested event,
    Emitter<DayThoughtsState> emit,
  ) async {
    emit(const .loadInProgress());
    await emit.forEach(
      _repository.watchThoughtsForDate(_date),
      onData: (thoughts) => .loadSuccess(thoughts: thoughts),
      onError: (e, _) => .loadFailure(message: e.toString()),
    );
  }
}
