import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:things/data/database/app_database.dart';

void main() {
  // ignore: avoid-late-keyword, just a test
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('can create and read a thought', () async {
    await database
        .into(database.thoughts)
        .insert(
          ThoughtsCompanion.insert(
            content: 'Hello World',
            title: const Value('My Title'),
            icon: const Value('🚀'),
          ),
        );

    final allThoughts = await database.select(database.thoughts).get();
    expect(allThoughts.length, 1);
    expect(allThoughts.first.content, 'Hello World');
    expect(allThoughts.first.title, 'My Title');
    expect(allThoughts.first.icon, '🚀');
  });

  test('can delete a thought', () async {
    final id = await database
        .into(database.thoughts)
        .insert(
          ThoughtsCompanion.insert(
            content: 'To be deleted',
          ),
        );

    await (database.delete(
      database.thoughts,
    )..where((t) => t.id.equals(id))).go();

    final allThoughts = await database.select(database.thoughts).get();
    expect(allThoughts.isEmpty, true);
  });
}
