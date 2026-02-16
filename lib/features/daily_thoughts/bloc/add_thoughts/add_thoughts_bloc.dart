import 'dart:async';
import 'dart:math';

import 'package:characters/characters.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:things/core/repository/thoughts_repository.dart';
import 'package:things/core/services/ai_service.dart';

part 'add_thoughts_event.dart';
part 'add_thoughts_state.dart';

@injectable
class AddThoughtsBloc extends Bloc<AddThoughtsEvent, AddThoughtsState> {
  AddThoughtsBloc(this._repository, this._aiService) : super(const .initial()) {
    on<AddThoughtsEvent>(
      (event, emit) => switch (event) {
        AddThoughtsAddRequested() => _onAddRequested(event, emit),
      },
    );
  }

  final ThoughtsRepository _repository;
  final AiService? _aiService;

  Future<void> _onAddRequested(
    AddThoughtsAddRequested event,
    Emitter<AddThoughtsState> emit,
  ) async {
    if (state is AddThoughtsInProgress) return;
    try {
      emit(const .inProgress());
      final content = event.content;
      final metadata =
          await _aiService?.generateMetadata(content).catchError((e) {
            // handle error
            return _getFallbackMetadata(content);
          }) ??
          _getFallbackMetadata(content);

      await _repository.addThought(
        icon: metadata.icon,
        title: metadata.title,
        content: content,
      );

      emit(.success(reaction: metadata.reaction));
    } catch (e) {
      emit(.failure(message: e.toString()));
    }
  }

  ThoughtMetadata _getFallbackMetadata(String content) {
    final emojis = ['📝', '💭', '💡', '✨', '📌', '🗓️', '✅'];
    return (
      icon: emojis[Random().nextInt(emojis.length)],
      title: content.length > 25
          ? '${content.characters.take(25)}...'
          : content,
      reaction: null,
    );
  }
}
