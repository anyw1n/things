part of 'add_thoughts_bloc.dart';

/// Base event type for [AddThoughtsBloc].
sealed class AddThoughtsEvent extends Equatable {
  const AddThoughtsEvent();

  /// Requests creation of a new thought from raw text content.
  const factory AddThoughtsEvent.addRequested({required String content}) =
      AddThoughtsAddRequested;

  @override
  List<Object?> get props => [];
}

/// Concrete event carrying text to be persisted as a thought.
final class AddThoughtsAddRequested extends AddThoughtsEvent {
  const AddThoughtsAddRequested({required this.content});

  /// User-provided thought text.
  final String content;

  @override
  List<Object?> get props => [content];
}
