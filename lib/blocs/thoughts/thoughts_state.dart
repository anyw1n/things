// ignore_for_file: prefer-immutable-bloc-state

import 'package:equatable/equatable.dart';
import 'package:things/data/database/app_database.dart';

sealed class ThoughtsState extends Equatable {
  const ThoughtsState();
  
  @override
  List<Object?> get props => [];
}

final class ThoughtsInitial extends ThoughtsState {}

final class ThoughtsLoading extends ThoughtsState {}

final class ThoughtsLoaded extends ThoughtsState {
  const ThoughtsLoaded({
    required this.thoughts,
    required this.date,
  });

  final List<Thought> thoughts;
  final DateTime date;

  @override
  List<Object?> get props => [thoughts, date];
}

final class ThoughtsError extends ThoughtsState {
  const ThoughtsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
