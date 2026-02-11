part of 'thoughts_bloc.dart';

sealed class ThoughtsEvent extends Equatable {
  const ThoughtsEvent();

  const factory ThoughtsEvent.loadRequested({required DateTime date}) =
      ThoughtsLoadRequested;

  const factory ThoughtsEvent.addPressed({
    required String icon,
    required String title,
    required String content,
  }) = ThoughtsAddPressed;

  @override
  List<Object?> get props => [];
}

final class ThoughtsLoadRequested extends ThoughtsEvent {
  const ThoughtsLoadRequested({required this.date});

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class ThoughtsAddPressed extends ThoughtsEvent {
  const ThoughtsAddPressed({
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
