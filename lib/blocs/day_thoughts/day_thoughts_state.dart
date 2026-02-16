part of 'day_thoughts_bloc.dart';

sealed class DayThoughtsState extends Equatable {
  const DayThoughtsState();

  const factory DayThoughtsState.initial() = DayThoughtsInitial;

  const factory DayThoughtsState.loadInProgress() = DayThoughtsLoadInProgress;

  const factory DayThoughtsState.loadSuccess({
    required List<Thought> thoughts,
  }) = DayThoughtsStateLoadSuccess;

  const factory DayThoughtsState.loadFailure({required String message}) =
      DayThoughtsLoadFailure;

  @override
  List<Object?> get props => [];
}

final class DayThoughtsInitial extends DayThoughtsState {
  const DayThoughtsInitial();
}

final class DayThoughtsLoadInProgress extends DayThoughtsState {
  const DayThoughtsLoadInProgress();
}

final class DayThoughtsStateLoadSuccess extends DayThoughtsState {
  const DayThoughtsStateLoadSuccess({required this.thoughts});

  final List<Thought> thoughts;

  @override
  List<Object?> get props => [thoughts];
}

final class DayThoughtsLoadFailure extends DayThoughtsState {
  const DayThoughtsLoadFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
