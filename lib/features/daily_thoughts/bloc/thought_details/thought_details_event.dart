part of 'thought_details_bloc.dart';

sealed class ThoughtDetailsEvent extends Equatable {
  const ThoughtDetailsEvent();

  const factory ThoughtDetailsEvent.loadRequested() =
      ThoughtDetailsLoadRequested;

  @override
  List<Object?> get props => [];
}

final class ThoughtDetailsLoadRequested extends ThoughtDetailsEvent {
  const ThoughtDetailsLoadRequested();
}
