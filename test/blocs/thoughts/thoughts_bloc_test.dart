import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:things/blocs/thoughts/thoughts_bloc.dart';
import 'package:things/blocs/thoughts/thoughts_event.dart';
import 'package:things/blocs/thoughts/thoughts_state.dart';
import 'package:things/data/database/app_database.dart';
import 'package:things/data/repository/thoughts_repository.dart';

class MockThoughtsRepository extends Mock implements ThoughtsRepository {}

void main() {
  group('ThoughtsBloc', () {
    late ThoughtsRepository repository;
    final date = DateTime(2023);

    setUp(() {
      repository = MockThoughtsRepository();
    });

    test('initial state is ThoughtsInitial', () {
      expect(ThoughtsBloc(repository: repository).state, ThoughtsInitial());
    });

    blocTest<ThoughtsBloc, ThoughtsState>(
      'emits [ThoughtsLoading, ThoughtsLoaded] when LoadThoughts is added and '
      'repository returns empty list',
      build: () {
        when(
          () => repository.getThoughtsForDate(date),
        ).thenAnswer((_) async => const []);
        return ThoughtsBloc(repository: repository);
      },
      act: (bloc) => bloc.add(LoadThoughts(date: date)),
      expect: () => [
        ThoughtsLoading(),
        ThoughtsLoaded(thoughts: const [], date: date),
      ],
    );

    blocTest<ThoughtsBloc, ThoughtsState>(
      'emits [ThoughtsLoading, ThoughtsLoaded] when LoadThoughts is added and '
      'repository returns thoughts',
      build: () {
        final thoughts = [
          Thought(
            id: 1,
            icon: '👋',
            title: 'Title',
            content: 'Content',
            createdAt: date,
          ),
        ];
        when(
          () => repository.getThoughtsForDate(date),
        ).thenAnswer((_) async => thoughts);
        return ThoughtsBloc(repository: repository);
      },
      act: (bloc) => bloc.add(LoadThoughts(date: date)),
      expect: () => [
        ThoughtsLoading(),
        ThoughtsLoaded(
          thoughts: [
            Thought(
              id: 1,
              icon: '👋',
              title: 'Title',
              content: 'Content',
              createdAt: date,
            ),
          ],
          date: date,
        ),
      ],
    );

    DateTime? addThoughtLoadedDate;
    blocTest<ThoughtsBloc, ThoughtsState>(
      'emits [ThoughtsLoading, ThoughtsLoaded] with new thought after '
      'AddThought event',
      build: () {
        final newThought = Thought(
          id: 2,
          icon: '📝',
          title: 'Title',
          content: 'New Content',
          createdAt: date,
        );
        when(
          () => repository.addThought(
            content: 'New Content',
            title: 'Title',
            icon: '📝',
          ),
        ).thenAnswer((_) async {});
        when(
          () => repository.getThoughtsForDate(any()),
        ).thenAnswer((invocation) async {
          addThoughtLoadedDate = invocation.positionalArguments[0] as DateTime;
          return [newThought];
        });
        return ThoughtsBloc(repository: repository);
      },
      act: (bloc) => bloc.add(
        const AddThought(
          icon: '📝',
          title: 'Title',
          content: 'New Content',
        ),
      ),
      expect: () => [
        ThoughtsLoading(),
        ThoughtsLoaded(
          thoughts: [
            Thought(
              id: 2,
              icon: '📝',
              title: 'Title',
              content: 'New Content',
              createdAt: date,
            ),
          ],
          date: addThoughtLoadedDate!,
        ),
      ],
      verify: (bloc) {
        verify(
          () => repository.addThought(
            content: 'New Content',
            title: 'Title',
            icon: '📝',
          ),
        ).called(1);
      },
    );

    blocTest<ThoughtsBloc, ThoughtsState>(
      'emits [ThoughtsLoading, ThoughtsLoaded] after DeleteThought event',
      build: () {
        when(() => repository.deleteThought(1)).thenAnswer((_) async {});
        when(
          () => repository.getThoughtsForDate(date),
        ).thenAnswer((_) async => []);
        return ThoughtsBloc(repository: repository);
      },
      seed: () => ThoughtsLoaded(
        thoughts: [
          Thought(
            id: 1,
            icon: '👋',
            title: 'Title',
            content: 'Content',
            createdAt: date,
          ),
        ],
        date: date,
      ),
      act: (bloc) => bloc.add(const DeleteThought(id: 1)),
      expect: () => [
        ThoughtsLoading(),
        ThoughtsLoaded(thoughts: const [], date: date),
      ],
      verify: (bloc) {
        verify(() => repository.deleteThought(1)).called(1);
      },
    );

    blocTest<ThoughtsBloc, ThoughtsState>(
      'emits [ThoughtsError] when repository fails',
      build: () {
        when(
          () => repository.getThoughtsForDate(date),
        ).thenThrow(Exception('Database error'));
        return ThoughtsBloc(repository: repository);
      },
      act: (bloc) => bloc.add(LoadThoughts(date: date)),
      expect: () => [
        ThoughtsLoading(),
        const ThoughtsError('Exception: Database error'),
      ],
    );
  });
}
