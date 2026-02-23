import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:things/core/database/app_database.dart';
import 'package:things/core/repository/thoughts_repository.dart';
import 'package:things/features/daily_thoughts/bloc/thought_details/thought_details_bloc.dart';

class MockThoughtsRepository extends Mock implements ThoughtsRepository {}

void main() {
  group('ThoughtDetailsBloc', () {
    late ThoughtsRepository repository;

    const thoughtId = 1;
    final thought = Thought(
      id: thoughtId,
      icon: '💡',
      title: 'Idea',
      content: 'A great idea',
      createdAt: DateTime(2024),
    );

    setUp(() {
      repository = MockThoughtsRepository();
    });

    blocTest<ThoughtDetailsBloc, ThoughtDetailsState>(
      'emits success when thought exists',
      build: () {
        when(
          () => repository.getThoughtById(thoughtId),
        ).thenAnswer((_) async => thought);
        return ThoughtDetailsBloc(thoughtId, repository);
      },
      act: (bloc) => bloc.add(const ThoughtDetailsEvent.loadRequested()),
      expect: () => [
        const ThoughtDetailsLoadInProgress(),
        ThoughtDetailsLoadSuccess(thought: thought),
      ],
    );

    blocTest<ThoughtDetailsBloc, ThoughtDetailsState>(
      'emits notFound when thought does not exist',
      build: () {
        when(
          () => repository.getThoughtById(thoughtId),
        ).thenAnswer((_) async => null);
        return ThoughtDetailsBloc(thoughtId, repository);
      },
      act: (bloc) => bloc.add(const ThoughtDetailsEvent.loadRequested()),
      expect: () => [
        const ThoughtDetailsLoadInProgress(),
        const ThoughtDetailsNotFound(),
      ],
    );

    blocTest<ThoughtDetailsBloc, ThoughtDetailsState>(
      'emits failure when repository throws',
      build: () {
        when(
          () => repository.getThoughtById(thoughtId),
        ).thenThrow(Exception('oops'));
        return ThoughtDetailsBloc(thoughtId, repository);
      },
      act: (bloc) => bloc.add(const ThoughtDetailsEvent.loadRequested()),
      expect: () => [
        const ThoughtDetailsLoadInProgress(),
        isA<ThoughtDetailsLoadFailure>().having(
          (state) => state.message,
          'message',
          contains('oops'),
        ),
      ],
    );
  });
}
