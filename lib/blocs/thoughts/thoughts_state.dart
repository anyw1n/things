part of 'thoughts_bloc.dart';

final class ThoughtsState extends Equatable {
  const ThoughtsState([this.statesByDate = const {}]);

  final Map<DateTime, ThoughtsByDateState> statesByDate;

  @override
  List<Object?> get props => [statesByDate];

  ThoughtsState newStateForDate({
    required DateTime date,
    required ThoughtsByDateState state,
  }) => .new({...statesByDate, date.onlyDate: state});
}

sealed class ThoughtsByDateState extends Equatable {
  const ThoughtsByDateState();

  const factory ThoughtsByDateState.loadInProgress() =
      ThoughtsByDateLoadInProgress;

  const factory ThoughtsByDateState.loadSuccess({
    required List<Thought> thoughts,
  }) = ThoughtsByDateLoadSuccess;

  const factory ThoughtsByDateState.loadFailure({
    required String message,
  }) = ThoughtsByDateLoadFailure;

  @override
  List<Object?> get props => [];
}

final class ThoughtsByDateLoadInProgress extends ThoughtsByDateState {
  const ThoughtsByDateLoadInProgress();
}

final class ThoughtsByDateLoadSuccess extends ThoughtsByDateState {
  const ThoughtsByDateLoadSuccess({required this.thoughts});

  final List<Thought> thoughts;

  @override
  List<Object?> get props => [thoughts];
}

final class ThoughtsByDateLoadFailure extends ThoughtsByDateState {
  const ThoughtsByDateLoadFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
