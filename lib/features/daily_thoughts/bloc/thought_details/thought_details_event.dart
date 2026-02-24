part of 'thought_details_bloc.dart';

/// Base event type for [ThoughtDetailsBloc].
sealed class ThoughtDetailsEvent extends Equatable {
  const ThoughtDetailsEvent();

  /// Requests loading of a single thought by the configured bloc id.
  const factory ThoughtDetailsEvent.loadRequested() =
      ThoughtDetailsLoadRequested;

  @override
  List<Object?> get props => [];
}

/// Event that starts thought details loading.
final class ThoughtDetailsLoadRequested extends ThoughtDetailsEvent {
  const ThoughtDetailsLoadRequested();
}
