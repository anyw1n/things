part of 'day_thoughts_bloc.dart';

/// Base state type for day-thoughts loading workflow.
sealed class DayThoughtsState extends Equatable {
  const DayThoughtsState();

  /// Initial state before loading starts.
  const factory DayThoughtsState.initial() = DayThoughtsInitial;

  /// Loading state while the stream subscription is being established.
  const factory DayThoughtsState.loadInProgress() = DayThoughtsLoadInProgress;

  /// Success state containing current thoughts for the selected day.
  const factory DayThoughtsState.loadSuccess({
    required List<Thought> thoughts,
  }) = DayThoughtsStateLoadSuccess;

  /// Failure state containing stream/load error details.
  const factory DayThoughtsState.loadFailure({required String message}) =
      DayThoughtsLoadFailure;

  @override
  List<Object?> get props => [];
}

/// Idle state before the first load request.
final class DayThoughtsInitial extends DayThoughtsState {
  const DayThoughtsInitial();
}

/// State emitted during loading.
final class DayThoughtsLoadInProgress extends DayThoughtsState {
  const DayThoughtsLoadInProgress();
}

/// State emitted whenever repository stream publishes a thought list.
final class DayThoughtsStateLoadSuccess extends DayThoughtsState {
  const DayThoughtsStateLoadSuccess({required this.thoughts});

  /// Thoughts belonging to the currently selected day.
  final List<Thought> thoughts;

  @override
  List<Object?> get props => [thoughts];
}

/// State emitted when loading stream fails.
final class DayThoughtsLoadFailure extends DayThoughtsState {
  const DayThoughtsLoadFailure({required this.message});

  /// Human-readable error message.
  final String message;

  @override
  List<Object?> get props => [message];
}
