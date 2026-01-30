import 'package:drift/drift.dart';
import 'package:things/data/database/app_database.dart';

abstract class ThoughtsRepository {
  Future<List<Thought>> getThoughtsForDate(DateTime date);
  Future<void> addThought({
    required String icon,
    required String title,
    required String content,
  });
  Future<void> deleteThought(int id);
}

class ThoughtsRepositoryImpl implements ThoughtsRepository {
  ThoughtsRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<Thought>> getThoughtsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (_db.select(_db.thoughts)..where(
          (t) =>
              t.createdAt.isBiggerOrEqualValue(startOfDay) &
              t.createdAt.isSmallerThanValue(endOfDay),
        ))
        .get();
  }

  @override
  Future<void> addThought({
    required String icon,
    required String title,
    required String content,
  }) => _db
      .into(_db.thoughts)
      .insert(
        ThoughtsCompanion.insert(
          icon: icon,
          title: title,
          content: content,
        ),
      );

  @override
  Future<void> deleteThought(int id) async {
    final count = await (_db.delete(
      _db.thoughts,
    )..where((t) => t.id.equals(id))).go();

    if (count == 0) {
      throw Exception('Thought not found with id: $id');
    }
  }
}
