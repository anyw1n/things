part of 'add_thoughts_bloc.dart';

/// Base state type for add-thought interactions.
sealed class AddThoughtsState extends Equatable {
  const AddThoughtsState();

  /// Initial idle state.
  const factory AddThoughtsState.initial() = AddThoughtsInitial;

  /// State emitted after a successful save.
  const factory AddThoughtsState.success({required String? reaction}) =
      AddThoughtsSuccess;

  /// State emitted when saving fails.
  const factory AddThoughtsState.failure({required String message}) =
      AddThoughtsFailure;

  /// State emitted while save request is in progress.
  const factory AddThoughtsState.inProgress() = AddThoughtsInProgress;

  @override
  List<Object?> get props => [];
}

/// Idle state before the first add request.
final class AddThoughtsInitial extends AddThoughtsState {
  const AddThoughtsInitial();
}

/// Success state optionally containing AI reaction text.
final class AddThoughtsSuccess extends AddThoughtsState {
  const AddThoughtsSuccess({required this.reaction});

  /// Optional AI-generated reaction shown to the user.
  final String? reaction;

  @override
  List<Object?> get props => [reaction];
}

/// Failure state containing error message for UI feedback.
final class AddThoughtsFailure extends AddThoughtsState {
  const AddThoughtsFailure({required this.message});

  /// Human-readable error details.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Loading state while thought metadata and persistence are processed.
final class AddThoughtsInProgress extends AddThoughtsState {
  const AddThoughtsInProgress();
}
