import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:things/core/repository/thoughts_repository.dart';
import 'package:things/core/services/ai_service.dart';
import 'package:things/features/daily_thoughts/bloc/add_thoughts/add_thoughts_bloc.dart';

class MockThoughtsRepository extends Mock implements ThoughtsRepository {}

class MockAiService extends Mock implements AiService {}

void main() {
  group('AddThoughtsBloc', () {
    late ThoughtsRepository repository;
    late AiService aiService;
    late AddThoughtsBloc bloc;

    setUp(() {
      repository = MockThoughtsRepository();
      aiService = MockAiService();
      bloc = .new(repository, aiService);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is correct', () {
      expect(bloc.state, const AddThoughtsInitial());
    });

    group('AddThoughtsAddRequested', () {
      const content = 'New thought content';
      const icon = '📝';
      const title = 'New thought';
      const reaction = 'Saved!';
      
      const ThoughtMetadata metadata = (
        icon: icon,
        title: title,
        reaction: reaction,
      );

      blocTest<AddThoughtsBloc, AddThoughtsState>(
        'calls aiService.generateMetadata and repository.addThought on success',
        build: () {
          when(() => aiService.generateMetadata(any()))
              .thenAnswer((_) async => metadata);
          when(
            () => repository.addThought(
              icon: any(named: 'icon'),
              title: any(named: 'title'),
              content: any(named: 'content'),
            ),
          ).thenAnswer((_) async => 1);
          return bloc;
        },
        act: (bloc) => bloc.add(const .addRequested(content: content)),
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
        expect: () => [
          const AddThoughtsInProgress(),
          const AddThoughtsSuccess(reaction: reaction),
        ],
      );

      blocTest<AddThoughtsBloc, AddThoughtsState>(
        'uses fallback metadata when AI service fails',
        build: () {
          when(() => aiService.generateMetadata(any()))
              .thenAnswer((_) => .error(Exception('AI Error')));
          when(
            () => repository.addThought(
              icon: any(named: 'icon'),
              title: any(named: 'title'),
              content: any(named: 'content'),
            ),
          ).thenAnswer((_) async => 1);
          return bloc;
        },
        act: (bloc) => bloc.add(const .addRequested(content: content)),
        verify: (_) {
           verify(
            () => repository.addThought(
              icon: any(named: 'icon'),
              title: any(named: 'title'),
              content: content,
            ),
          ).called(1);
        },
        expect: () => [
          const AddThoughtsInProgress(),
          const AddThoughtsSuccess(reaction: null),
        ],
      );

      blocTest<AddThoughtsBloc, AddThoughtsState>(
        'emits failure when repository fails',
        build: () {
          when(() => aiService.generateMetadata(any()))
              .thenAnswer((_) async => metadata);
          when(
            () => repository.addThought(
              icon: any(named: 'icon'),
              title: any(named: 'title'),
              content: any(named: 'content'),
            ),
          ).thenThrow(Exception('DB Error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const .addRequested(content: content)),
        expect: () => [
          const AddThoughtsInProgress(),
          isA<AddThoughtsFailure>().having(
            (s) => s.message,
            'message',
            contains('DB Error'),
          ),
        ],
      );
    });
  });
}
