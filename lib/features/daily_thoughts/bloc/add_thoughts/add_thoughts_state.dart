part of 'add_thoughts_bloc.dart';

sealed class AddThoughtsState extends Equatable {
  const AddThoughtsState();

  const factory AddThoughtsState.initial() = AddThoughtsInitial;

  const factory AddThoughtsState.success({required String? reaction}) =
      AddThoughtsSuccess;

  const factory AddThoughtsState.failure({required String message}) =
      AddThoughtsFailure;

  const factory AddThoughtsState.inProgress() = AddThoughtsInProgress;

  @override
  List<Object?> get props => [];
}

final class AddThoughtsInitial extends AddThoughtsState {
  const AddThoughtsInitial();
}

final class AddThoughtsSuccess extends AddThoughtsState {
  const AddThoughtsSuccess({required this.reaction});

  final String? reaction;

  @override
  List<Object?> get props => [reaction];
}

final class AddThoughtsFailure extends AddThoughtsState {
  const AddThoughtsFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

final class AddThoughtsInProgress extends AddThoughtsState {
  const AddThoughtsInProgress();
}
