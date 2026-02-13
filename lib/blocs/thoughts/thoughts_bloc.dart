import 'dart:async';
import 'dart:math';

import 'package:characters/characters.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:things/data/database/app_database.dart';
import 'package:things/data/repository/thoughts_repository.dart';
import 'package:things/data/services/ai_service.dart';
import 'package:things/utils.dart';

part 'thoughts_event.dart';
part 'thoughts_state.dart';

@injectable
class ThoughtsBloc extends Bloc<ThoughtsEvent, ThoughtsState> {
  ThoughtsBloc(this._repository, this._aiService) : super(const .new()) {
    on<ThoughtsEvent>(
      (event, emit) => switch (event) {
        ThoughtsLoadRequested() => _onThoughtsLoadRequested(event, emit),
        ThoughtsAddPressed() => _onThoughtsAddPressed(event, emit),
      },
    );
  }

  final ThoughtsRepository _repository;
  final AiService? _aiService;
  final Set<DateTime> _activeStreams = {};

  Future<void> _onThoughtsLoadRequested(
    ThoughtsLoadRequested event,
    Emitter<ThoughtsState> emit,
  ) async {
    final date = event.date.onlyDate;
    await [
      date,
      date.subtract(const .new(days: 1)),
      date.add(const .new(days: 1)),
    ].map((date) => _listenForThoughts(date, emit)).wait;
  }

  Future<void> _listenForThoughts(
    DateTime date,
    Emitter<ThoughtsState> emit,
  ) async {
    if (!_activeStreams.add(date)) {
      return;
    }
    // print('active streams add: $_activeStreams');
    emit(state.newStateForDate(date: date, state: const .loadInProgress()));
    await emit.forEach(
      _repository.watchThoughtsForDate(date),
      onData: (thoughts) => state.newStateForDate(
        date: date,
        state: .loadSuccess(thoughts: thoughts),
      ),
      onError: (e, _) => state.newStateForDate(
        date: date,
        state: .loadFailure(message: e.toString()),
      ),
    );
    _activeStreams.remove(date);
    // print('active streams remove: $_activeStreams');
  }

  ThoughtMetadata _getFallbackMetadata(String content) {
    final emojis = ['📝', '💭', '💡', '✨', '📌', '🗓️', '✅'];
    return (
      icon: emojis[Random().nextInt(emojis.length)],
      title: '${content.characters.take(25)}...',
      reaction: null,
    );
  }

  Future<void> _onThoughtsAddPressed(
    ThoughtsAddPressed event,
    Emitter<ThoughtsState> emit,
  ) async {
    try {
      final content = event.content;
      final metadata =
          await _aiService?.generateMetadata(content).catchError((e) {
            // handle error
            print(e);
            return _getFallbackMetadata(content);
          }) ??
          _getFallbackMetadata(content);

      await _repository.addThought(
        icon: metadata.icon,
        title: metadata.title,
        content: content,
      );

      // We could show the reaction here, but for now we just handle success
      // via stream update
    } catch (e) {
      emit(
        state.newStateForDate(
          date: .now(),
          state: .loadFailure(message: e.toString()),
        ),
      );
    }
  }

  // @override
  // void onTransition(Transition<ThoughtsEvent, ThoughtsState> transition) {
  //   print(transition);
  //   super.onTransition(transition);
  // }
}
