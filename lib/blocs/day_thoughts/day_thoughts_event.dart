part of 'day_thoughts_bloc.dart';

sealed class DayThoughtsEvent extends Equatable {
  const DayThoughtsEvent();

  const factory DayThoughtsEvent.loadRequested() = DayThoughtsLoadRequested;

  @override
  List<Object?> get props => [];
}

final class DayThoughtsLoadRequested extends DayThoughtsEvent {
  const DayThoughtsLoadRequested();
}
