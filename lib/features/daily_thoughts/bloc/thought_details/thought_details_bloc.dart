import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:thoughts/core/database/app_database.dart';
import 'package:thoughts/core/repository/thoughts_repository.dart';

part 'thought_details_event.dart';
part 'thought_details_state.dart';

/// Loads a single thought by id for the details screen.
@injectable
class ThoughtDetailsBloc
    extends Bloc<ThoughtDetailsEvent, ThoughtDetailsState> {
  ThoughtDetailsBloc(@factoryParam this._thoughtId, this._repository)
    : super(const .initial()) {
    on<ThoughtDetailsEvent>(
      (event, emit) => switch (event) {
        ThoughtDetailsLoadRequested() => _onLoadRequested(emit),
      },
      transformer: droppable(),
    );
  }

  final int _thoughtId;
  final ThoughtsRepository _repository;

  /// Retrieves the thought and emits `notFound` when the record is missing.
  ///
  /// `droppable` prevents concurrent lookups for the same bloc instance.
  Future<void> _onLoadRequested(Emitter<ThoughtDetailsState> emit) async {
    emit(const .loadInProgress());
    try {
      final thought = await _repository.getThoughtById(_thoughtId);
      emit(
        thought == null ? const .notFound() : .loadSuccess(thought: thought),
      );
    } catch (e) {
      emit(.loadFailure(message: e.toString()));
    }
  }
}
