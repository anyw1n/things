import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thoughts/core/database/app_database.dart';
import 'package:thoughts/core/repository/thoughts_repository.dart';
import 'package:thoughts/core/utils/utils.dart';
import 'package:thoughts/features/daily_thoughts/bloc/day_thoughts/day_thoughts_bloc.dart';

class MockThoughtsRepository extends Mock implements ThoughtsRepository {}

void main() {
  group('DayThoughtsBloc', () {
    late ThoughtsRepository repository;
    late DayThoughtsBloc bloc;

    final date = DateTime(2024);

    final thought = Thought(
      id: 1,
      icon: '💡',
      title: 'Idea',
      content: 'A great idea',
      createdAt: date,
    );

    setUp(() {
      repository = MockThoughtsRepository();
      bloc = .new(date, repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is correct', () {
      expect(bloc.state, const DayThoughtsInitial());
    });

    group('DayThoughtsLoadRequested', () {
      blocTest<DayThoughtsBloc, DayThoughtsState>(
        'subscribes to thoughts for the requested date',
        build: () {
          when(
            () => repository.watchThoughtsForDate(any()),
          ).thenAnswer((_) => .value([thought]));
          return bloc;
        },
        act: (bloc) => bloc.add(const .loadRequested()),
        verify: (_) {
          verify(
            () => repository.watchThoughtsForDate(date.onlyDate),
          ).called(1);
        },
        expect: () => [
          const DayThoughtsLoadInProgress(),
          DayThoughtsStateLoadSuccess(thoughts: [thought]),
        ],
      );

      blocTest<DayThoughtsBloc, DayThoughtsState>(
        'emits failure when repository throws',
        build: () {
          when(
            () => repository.watchThoughtsForDate(any()),
          ).thenAnswer((_) => .error(Exception('oops')));
          return bloc;
        },
        act: (bloc) => bloc.add(const .loadRequested()),
        expect: () => [
          const DayThoughtsLoadInProgress(),
          isA<DayThoughtsLoadFailure>().having(
            (s) => s.message,
            'message',
            contains('oops'),
          ),
        ],
      );
    });
  });
}
