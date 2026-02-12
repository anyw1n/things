import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:things/data/database/app_database.dart';
import 'package:things/data/repository/thoughts_repository.dart';

void main() {
  late AppDatabase db;
  late ThoughtsRepository repository;

  setUp(() {
    db = .new(NativeDatabase.memory());
    repository = ThoughtsRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ThoughtsRepository', () {
    test('addThought saves thought to database', () async {
      expectLater(
        repository.watchThoughtsForDate(.now()),
        emitsInOrder([
          <Thought>[],
          [
            isA<Thought>()
                .having((t) => t.icon, 'icon', '🚀')
                .having((t) => t.title, 'title', 'My Title')
                .having((t) => t.content, 'content', 'Hello World'),
          ],
        ]),
      );
      await pumpEventQueue();
      await repository.addThought(
        icon: '🚀',
        title: 'My Title',
        content: 'Hello World',
      );
    });

    test('getThoughtsForDate filters by date correctly', () async {
      final yesterday = DateTime.now().subtract(const .new(days: 1));
      // We need to insert directly to manipulate createdAt
      await db
          .into(db.thoughts)
          .insert(
            ThoughtsCompanion.insert(
              createdAt: .new(yesterday),
              icon: 'Old',
              title: 'Old Title',
              content: 'Yesterday',
            ),
          );

      await repository.addThought(
        icon: 'New',
        title: 'New Title',
        content: 'Today',
      );

      final todayThoughts = await repository.watchThoughtsForDate(.now()).first;
      expect(todayThoughts.length, 1);
      expect(todayThoughts.first.content, 'Today');

      final yesterdayThoughts = await repository
          .watchThoughtsForDate(yesterday)
          .first;
      expect(yesterdayThoughts.length, 1);
      expect(yesterdayThoughts.first.content, 'Yesterday');
    });

    test('deleteThought removes thought', () async {
      final id = await repository.addThought(
        icon: '❌',
        title: 'Del',
        content: 'To Delete',
      );

      expectLater(
        repository.watchThoughtsForDate(.now()),
        emitsInOrder([
          [isA<Thought>().having((t) => t.content, 'content', 'To Delete')],
          <Thought>[],
        ]),
      );

      await repository.deleteThought(id);
    });

    test('deleteThought throws Exception if id not found', () async {
      await expectLater(
        () => repository.deleteThought(999),
        throwsA(isA<Exception>()),
      );
    });
  });
}
