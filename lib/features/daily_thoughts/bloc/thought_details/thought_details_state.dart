part of 'thought_details_bloc.dart';

sealed class ThoughtDetailsState extends Equatable {
  const ThoughtDetailsState();

  const factory ThoughtDetailsState.initial() = ThoughtDetailsInitial;

  const factory ThoughtDetailsState.loadInProgress() =
      ThoughtDetailsLoadInProgress;

  const factory ThoughtDetailsState.loadSuccess({required Thought thought}) =
      ThoughtDetailsLoadSuccess;

  const factory ThoughtDetailsState.notFound() = ThoughtDetailsNotFound;

  const factory ThoughtDetailsState.loadFailure({required String message}) =
      ThoughtDetailsLoadFailure;

  @override
  List<Object?> get props => [];
}

final class ThoughtDetailsInitial extends ThoughtDetailsState {
  const ThoughtDetailsInitial();
}

final class ThoughtDetailsLoadInProgress extends ThoughtDetailsState {
  const ThoughtDetailsLoadInProgress();
}

final class ThoughtDetailsLoadSuccess extends ThoughtDetailsState {
  const ThoughtDetailsLoadSuccess({required this.thought});

  final Thought thought;

  @override
  List<Object?> get props => [thought];
}

final class ThoughtDetailsNotFound extends ThoughtDetailsState {
  const ThoughtDetailsNotFound();
}

final class ThoughtDetailsLoadFailure extends ThoughtDetailsState {
  const ThoughtDetailsLoadFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
