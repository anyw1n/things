import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:things/core/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = .new(NativeDatabase.memory());
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
            title: 'My Title',
            icon: '🚀',
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
            title: 'My Title',
            icon: '🚀',
          ),
        );

    await (database.delete(
      database.thoughts,
    )..where((t) => t.id.equals(id))).go();

    final allThoughts = await database.select(database.thoughts).get();
    expect(allThoughts.isEmpty, true);
  });
}
