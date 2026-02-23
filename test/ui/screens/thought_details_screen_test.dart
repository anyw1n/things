import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thoughts/core/database/app_database.dart';
import 'package:thoughts/core/di/di.dart';
import 'package:thoughts/core/repository/thoughts_repository.dart';
import 'package:thoughts/features/daily_thoughts/bloc/thought_details/thought_details_bloc.dart';
import 'package:thoughts/features/daily_thoughts/ui/thought_details_screen.dart';

class MockThoughtsRepository extends Mock implements ThoughtsRepository {}

void main() {
  late ThoughtsRepository repository;

  setUpAll(configureDependencies);

  setUp(() {
    repository = MockThoughtsRepository();
    getIt
      ..pushNewScope()
      ..registerFactoryParam<ThoughtDetailsBloc, int, void>(
        (thoughtId, _) => ThoughtDetailsBloc(thoughtId, repository),
      );
  });

  tearDown(() async {
    await getIt.popScope();
  });

  Widget createWidgetUnderTest({required int thoughtId}) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: ThoughtDetailsScreen(thoughtId: thoughtId),
    );
  }

  testWidgets('shows thought icon, title, date with minutes, and content', (
    tester,
  ) async {
    final createdAt = DateTime(2026, 2, 23, 14, 37);
    final thought = Thought(
      id: 1,
      icon: '💡',
      title: 'Idea Title',
      content: 'Long thought content',
      createdAt: createdAt,
    );

    when(() => repository.getThoughtById(1)).thenAnswer((_) async => thought);

    await tester.pumpWidget(createWidgetUnderTest(thoughtId: 1));
    await tester.pumpAndSettle();

    final expectedDate = DateFormat('MMM d, HH:mm').format(createdAt);

    expect(
      find.text('💡 Idea Title\n$expectedDate', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Long thought content'), findsOneWidget);
  });

  testWidgets('shows not found state', (tester) async {
    when(() => repository.getThoughtById(999)).thenAnswer((_) async => null);

    await tester.pumpWidget(createWidgetUnderTest(thoughtId: 999));
    await tester.pumpAndSettle();

    expect(find.text('Thought not found'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
  });
}
