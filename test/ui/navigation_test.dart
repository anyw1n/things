import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:things/app/app.dart';
import 'package:things/core/di/di.dart';
import 'package:things/core/repository/thoughts_repository.dart';
import 'package:things/features/daily_thoughts/bloc/add_thoughts/add_thoughts_bloc.dart';
import 'package:things/features/daily_thoughts/bloc/day_thoughts/day_thoughts_bloc.dart';
import 'package:things/features/daily_thoughts/ui/daily_screen.dart';

class MockThoughtsRepository extends Mock implements ThoughtsRepository {}

void main() {
  setUpAll(configureDependencies);

  testWidgets('App starts on Daily route using GoRouter', (tester) async {
    // Setup
    final repository = MockThoughtsRepository();
    when(
      () => repository.watchThoughtsForDate(any()),
    ).thenAnswer((_) => .value([]));

    getIt
      ..pushNewScope()
      ..registerFactoryParam<DayThoughtsBloc, DateTime, void>(
        (date, _) => DayThoughtsBloc(date, repository),
      )
      ..registerFactory<AddThoughtsBloc>(
        () => AddThoughtsBloc(repository, null),
      );

    // Pump MainApp
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Verify DailyScreen is displayed (meaning route '/' was loaded)
    expect(find.byType(DailyScreen), findsOneWidget);
    await getIt.popScope();
  });
}
