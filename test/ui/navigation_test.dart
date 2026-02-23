import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:things/app/app.dart';
import 'package:things/core/database/app_database.dart';
import 'package:things/core/di/di.dart';
import 'package:things/core/repository/thoughts_repository.dart';
import 'package:things/features/daily_thoughts/bloc/add_thoughts/add_thoughts_bloc.dart';
import 'package:things/features/daily_thoughts/bloc/day_thoughts/day_thoughts_bloc.dart';
import 'package:things/features/daily_thoughts/bloc/thought_details/thought_details_bloc.dart';
import 'package:things/features/daily_thoughts/ui/daily_screen.dart';
import 'package:things/features/daily_thoughts/ui/thought_details_screen.dart';

class MockThoughtsRepository extends Mock implements ThoughtsRepository {}

void main() {
  late ThoughtsRepository repository;

  setUpAll(configureDependencies);

  setUp(() {
    repository = MockThoughtsRepository();
    getIt
      ..pushNewScope()
      ..registerFactoryParam<DayThoughtsBloc, DateTime, void>(
        (date, _) => DayThoughtsBloc(date, repository),
      )
      ..registerFactoryParam<ThoughtDetailsBloc, int, void>(
        (thoughtId, _) => ThoughtDetailsBloc(thoughtId, repository),
      )
      ..registerFactory<AddThoughtsBloc>(
        () => AddThoughtsBloc(repository, null),
      );
  });

  tearDown(() async {
    await getIt.popScope();
  });

  testWidgets('App starts on Daily route using GoRouter', (tester) async {
    when(
      () => repository.watchThoughtsForDate(any()),
    ).thenAnswer((_) => .value([]));

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.byType(DailyScreen), findsOneWidget);
  });

  testWidgets('navigates to thought details from list item tap', (
    tester,
  ) async {
    final thought = Thought(
      id: 1,
      icon: '💡',
      title: 'Idea',
      content: 'Content',
      createdAt: DateTime(2026, 2, 23, 14, 37),
    );

    when(
      () => repository.watchThoughtsForDate(any()),
    ).thenAnswer((_) => .value([thought]));
    when(() => repository.getThoughtById(1)).thenAnswer((_) async => thought);

    await tester.pumpWidget(const App());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Switch from bubbles to list.
    await tester.tap(find.text('Switch view'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Open details.
    await tester.tap(find.text('Idea'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ThoughtDetailsScreen), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
  });
}
