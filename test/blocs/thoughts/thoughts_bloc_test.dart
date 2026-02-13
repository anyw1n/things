import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:things/blocs/thoughts/thoughts_bloc.dart';
import 'package:things/data/database/app_database.dart';
import 'package:things/data/repository/thoughts_repository.dart';
import 'package:things/data/services/ai_service.dart';
import 'package:things/utils.dart';

class MockThoughtsRepository extends Mock implements ThoughtsRepository {}

class MockAiService extends Mock implements AiService {}

void main() {
  group('ThoughtsBloc', () {
    late ThoughtsRepository repository;
    late AiService aiService;
    late ThoughtsBloc bloc;

    final date = DateTime(2024);
    final prevDate = date.subtract(const .new(days: 1));
    final nextDate = date.add(const .new(days: 1));

    final thought = Thought(
      id: 1,
      icon: '💡',
      title: 'Idea',
      content: 'A great idea',
      createdAt: date,
    );

    setUp(() {
      repository = MockThoughtsRepository();
      aiService = MockAiService();
      bloc = .new(repository, aiService);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is correct', () {
      expect(bloc.state, const ThoughtsState());
    });

    group('ThoughtsLoadRequested', () {
      blocTest<ThoughtsBloc, ThoughtsState>(
        'subscribes to thoughts for the requested date, previous day, '
        'and next day',
        build: () {
          when(
            () => repository.watchThoughtsForDate(any()),
          ).thenAnswer((_) => .value([thought]));
          return bloc;
        },
        act: (bloc) => bloc.add(ThoughtsLoadRequested(date: date)),
        verify: (_) {
          verify(
            () => repository.watchThoughtsForDate(date.onlyDate),
          ).called(1);
          verify(
            () => repository.watchThoughtsForDate(prevDate.onlyDate),
          ).called(1);
          verify(
            () => repository.watchThoughtsForDate(nextDate.onlyDate),
          ).called(1);
        },
      );
    });

    group('ThoughtsAddPressed', () {
      const icon = '📝';
      const title = 'New Note';
      const content = 'Content';
      const reaction = 'Saved';
      const ThoughtMetadata metadata = (
        icon: icon,
        title: title,
        reaction: reaction,
      );

      blocTest<ThoughtsBloc, ThoughtsState>(
        'calls aiService.generateMetadata and repository.addThought',
        build: () {
          when(
            () => aiService.generateMetadata(content),
          ).thenAnswer((_) async => metadata);
          when(
            () => repository.addThought(
              icon: any(named: 'icon'),
              title: any(named: 'title'),
              content: any(named: 'content'),
            ),
          ).thenAnswer((_) async => 1);
          return bloc;
        },
        act: (bloc) => bloc.add(
          const ThoughtsAddPressed(content: content),
        ),
        verify: (_) {
          verify(() => aiService.generateMetadata(content)).called(1);
          verify(
            () => repository.addThought(
              icon: icon,
              title: title,
              content: content,
            ),
          ).called(1);
        },
      );

      blocTest<ThoughtsBloc, ThoughtsState>(
        'emits failure when adding thought fails',
        build: () {
          when(
            () => aiService.generateMetadata(content),
          ).thenAnswer((_) async => metadata);
          when(
            () => repository.addThought(
              icon: any(named: 'icon'),
              title: any(named: 'title'),
              content: any(named: 'content'),
            ),
          ).thenThrow(Exception('Failed'));
          return bloc;
        },
        act: (bloc) => bloc.add(
          const ThoughtsAddPressed(content: content),
        ),
        expect: () => [
          isA<ThoughtsState>().having(
            (s) => s.statesByDate.values.whereType<ThoughtsByDateLoadFailure>(),
            'has failure state',
            isNotEmpty,
          ),
        ],
      );
    });
  });
}
