import 'package:equatable/equatable.dart';

sealed class ThoughtsEvent extends Equatable {
  const ThoughtsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadThoughts extends ThoughtsEvent {
  const LoadThoughts({required this.date});

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class AddThought extends ThoughtsEvent {
  const AddThought({
    required this.icon,
    required this.title,
    required this.content,
  });

  final String icon;
  final String title;
  final String content;

  @override
  List<Object?> get props => [icon, title, content];
}

final class DeleteThought extends ThoughtsEvent {
  const DeleteThought({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}
