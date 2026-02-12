import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:things/app.dart';
import 'package:things/blocs/thoughts/thoughts_bloc.dart';
import 'package:things/data/repository/thoughts_repository.dart';
import 'package:things/di.dart';
import 'package:things/ui/screens/screens.dart';

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
      ..registerFactory(() => ThoughtsBloc(repository));

    // Pump MainApp
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Verify DailyScreen is displayed (meaning route '/' was loaded)
    expect(find.byType(DailyScreen), findsOneWidget);
    await getIt.popScope();
  });
}
