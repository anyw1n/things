import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:things/data/database/app_database.dart';
import 'package:things/data/repository/thoughts_repository.dart';

void main() {
  late AppDatabase db;
  late ThoughtsRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = ThoughtsRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ThoughtsRepository', () {
    test('addThought saves thought to database', () async {
      await repository.addThought(
        icon: '🚀',
        title: 'My Title',
        content: 'Hello World',
      );

      final thoughts = await repository.getThoughtsForDate(DateTime.now());
      expect(thoughts.length, 1);
      expect(thoughts.first.icon, '🚀');
      expect(thoughts.first.title, 'My Title');
      expect(thoughts.first.content, 'Hello World');
    });

    test('getThoughtsForDate filters by date correctly', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      // We need to insert directly to manipulate createdAt
      await db
          .into(db.thoughts)
          .insert(
            ThoughtsCompanion.insert(
              createdAt: Value(yesterday),
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

      final todayThoughts = await repository.getThoughtsForDate(DateTime.now());
      expect(todayThoughts.length, 1);
      expect(todayThoughts.first.content, 'Today');

      final yesterdayThoughts = await repository.getThoughtsForDate(yesterday);
      expect(yesterdayThoughts.length, 1);
      expect(yesterdayThoughts.first.content, 'Yesterday');
    });

    test('deleteThought removes thought', () async {
      await repository.addThought(
        icon: '❌',
        title: 'Del',
        content: 'To Delete',
      );
      final thoughts = await repository.getThoughtsForDate(DateTime.now());
      final id = thoughts.first.id;

      await repository.deleteThought(id);

      final afterDelete = await repository.getThoughtsForDate(DateTime.now());
      expect(afterDelete.isEmpty, true);
    });

    test('deleteThought throws Exception if id not found', () async {
      await expectLater(
        () => repository.deleteThought(999),
        throwsA(isA<Exception>()),
      );
    });
  });
}
