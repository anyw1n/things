import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:things/blocs/thoughts/thoughts_bloc.dart';
import 'package:things/data/repository/thoughts_repository.dart';
import 'package:things/di.dart';
import 'package:things/ui/screens/daily_screen.dart';
import 'package:things/ui/widgets/widgets.dart';

class MockThoughtsRepository extends Mock implements ThoughtsRepository {}

void main() {
  late ThoughtsRepository repository;

  setUpAll(configureDependencies);

  setUp(() {
    repository = MockThoughtsRepository();
    getIt
      ..pushNewScope()
      ..registerFactory(() => ThoughtsBloc(repository));
  });

  tearDown(() async {
    await getIt.popScope();
  });

  Widget createWidgetUnderTest() => const MaterialApp(
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: DailyScreen(),
  );

  group('DailyScreen', () {
    testWidgets('shows today date and input initially', (tester) async {
      when(
        () => repository.watchThoughtsForDate(any()),
      ).thenAnswer((_) => .value([]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(DateHeaderWidget), findsOneWidget);
      expect(find.byType(ThoughtInputWidget), findsOneWidget);
    });

    testWidgets('swiping left shows yesterday without input', (tester) async {
      when(
        () => repository.watchThoughtsForDate(any()),
      ).thenAnswer((_) => .value([]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Swipe right to go to left page (Yesterday)
      await tester.drag(find.byType(PageView), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(find.byType(DateHeaderWidget), findsOneWidget);
      // Should NOT find input widget
      expect(find.byType(ThoughtInputWidget).hitTestable(), findsNothing);
    });
  });
}
