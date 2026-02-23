import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thoughts/core/di/di.dart';
import 'package:thoughts/core/repository/thoughts_repository.dart';
import 'package:thoughts/features/daily_thoughts/bloc/add_thoughts/add_thoughts_bloc.dart';
import 'package:thoughts/features/daily_thoughts/bloc/day_thoughts/day_thoughts_bloc.dart';
import 'package:thoughts/features/daily_thoughts/ui/daily_screen.dart';
import 'package:thoughts/features/daily_thoughts/ui/widgets/widgets.dart';

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
      ..registerFactory<AddThoughtsBloc>(
        () => AddThoughtsBloc(repository, null),
      );
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
