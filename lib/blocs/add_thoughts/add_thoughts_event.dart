part of 'add_thoughts_bloc.dart';

sealed class AddThoughtsEvent extends Equatable {
  const AddThoughtsEvent();

  const factory AddThoughtsEvent.addRequested({required String content}) =
      AddThoughtsAddRequested;

  @override
  List<Object?> get props => [];
}

final class AddThoughtsAddRequested extends AddThoughtsEvent {
  const AddThoughtsAddRequested({required this.content});

  final String content;

  @override
  List<Object?> get props => [content];
}
