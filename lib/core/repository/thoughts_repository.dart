import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:things/core/database/app_database.dart';

abstract interface class ThoughtsRepository {
  Stream<List<Thought>> watchThoughtsForDate(DateTime date);
  Future<Thought?> getThoughtById(int id);
  Future<int> addThought({
    required String icon,
    required String title,
    required String content,
  });
  Future<void> deleteThought(int id);
}

@LazySingleton(as: ThoughtsRepository)
class ThoughtsRepositoryImpl implements ThoughtsRepository {
  ThoughtsRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Thought>> watchThoughtsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const .new(days: 1));

    return (_db.select(_db.thoughts)..where(
          (t) =>
              t.createdAt.isBiggerOrEqualValue(startOfDay) &
              t.createdAt.isSmallerThanValue(endOfDay),
        ))
        .watch();
  }

  @override
  Future<Thought?> getThoughtById(int id) => (_db.select(
    _db.thoughts,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  @override
  Future<int> addThought({
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
