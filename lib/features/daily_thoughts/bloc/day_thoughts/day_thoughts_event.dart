part of 'day_thoughts_bloc.dart';

/// Base event type for [DayThoughtsBloc].
sealed class DayThoughtsEvent extends Equatable {
  const DayThoughtsEvent();

  /// Requests subscription to thoughts for the bloc date.
  const factory DayThoughtsEvent.loadRequested() = DayThoughtsLoadRequested;

  @override
  List<Object?> get props => [];
}

/// Event that triggers loading and watching day thoughts.
final class DayThoughtsLoadRequested extends DayThoughtsEvent {
  const DayThoughtsLoadRequested();
}
