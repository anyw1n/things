import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:things/blocs/thoughts/thoughts_event.dart';
import 'package:things/blocs/thoughts/thoughts_state.dart';
import 'package:things/data/repository/thoughts_repository.dart';

class ThoughtsBloc extends Bloc<ThoughtsEvent, ThoughtsState> {
  ThoughtsBloc({required ThoughtsRepository repository})
    : _repository = repository,
      super(ThoughtsInitial()) {
    on<ThoughtsEvent>(
      (event, emit) => switch (event) {
        LoadThoughts() => _onLoadThoughts(event, emit),
        AddThought() => _onAddThought(event, emit),
        DeleteThought() => _onDeleteThought(event, emit),
      },
    );
  }

  final ThoughtsRepository _repository;

  Future<void> _onLoadThoughts(
    LoadThoughts event,
    Emitter<ThoughtsState> emit,
  ) async {
    emit(ThoughtsLoading());
    try {
      final thoughts = await _repository.getThoughtsForDate(event.date);
      emit(ThoughtsLoaded(thoughts: thoughts, date: event.date));
    } catch (e) {
      emit(ThoughtsError(e.toString()));
    }
  }

  Future<void> _onAddThought(
    AddThought event,
    Emitter<ThoughtsState> emit,
  ) async {
    try {
      await _repository.addThought(
        icon: event.icon,
        title: event.title,
        content: event.content,
      );
      add(LoadThoughts(date: DateTime.now()));
    } catch (e) {
      emit(ThoughtsError(e.toString()));
    }
  }

  Future<void> _onDeleteThought(
    DeleteThought event,
    Emitter<ThoughtsState> emit,
  ) async {
    try {
      await _repository.deleteThought(event.id);
      if (state is ThoughtsLoaded) {
        add(LoadThoughts(date: (state as ThoughtsLoaded).date));
      }
    } catch (e) {
      emit(ThoughtsError(e.toString()));
    }
  }
}
