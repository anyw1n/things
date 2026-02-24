part of 'thought_details_bloc.dart';

/// Base state type for thought details loading workflow.
sealed class ThoughtDetailsState extends Equatable {
  const ThoughtDetailsState();

  /// Initial idle state.
  const factory ThoughtDetailsState.initial() = ThoughtDetailsInitial;

  /// Loading state while thought is being fetched.
  const factory ThoughtDetailsState.loadInProgress() =
      ThoughtDetailsLoadInProgress;

  /// Success state containing a loaded thought.
  const factory ThoughtDetailsState.loadSuccess({required Thought thought}) =
      ThoughtDetailsLoadSuccess;

  /// State emitted when the thought id does not exist.
  const factory ThoughtDetailsState.notFound() = ThoughtDetailsNotFound;

  /// Failure state containing error details.
  const factory ThoughtDetailsState.loadFailure({required String message}) =
      ThoughtDetailsLoadFailure;

  @override
  List<Object?> get props => [];
}

/// Idle state before the first load request.
final class ThoughtDetailsInitial extends ThoughtDetailsState {
  const ThoughtDetailsInitial();
}

/// State emitted during asynchronous loading.
final class ThoughtDetailsLoadInProgress extends ThoughtDetailsState {
  const ThoughtDetailsLoadInProgress();
}

/// Loaded state with the requested [thought].
final class ThoughtDetailsLoadSuccess extends ThoughtDetailsState {
  const ThoughtDetailsLoadSuccess({required this.thought});

  /// Persisted thought shown on the details screen.
  final Thought thought;

  @override
  List<Object?> get props => [thought];
}

/// State used when no row exists for the requested id.
final class ThoughtDetailsNotFound extends ThoughtDetailsState {
  const ThoughtDetailsNotFound();
}

/// Failure state containing an error message.
final class ThoughtDetailsLoadFailure extends ThoughtDetailsState {
  const ThoughtDetailsLoadFailure({required this.message});

  /// Human-readable error details.
  final String message;

  @override
  List<Object?> get props => [message];
}
