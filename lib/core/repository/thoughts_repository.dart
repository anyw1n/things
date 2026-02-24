import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:thoughts/core/database/app_database.dart';

/// Repository contract for reading and mutating persisted thoughts.
abstract interface class ThoughtsRepository {
  /// Watches thoughts created during the calendar day of [date].
  Stream<List<Thought>> watchThoughtsForDate(DateTime date);

  /// Returns a thought by [id], or `null` when no record exists.
  Future<Thought?> getThoughtById(int id);

  /// Persists a new thought and returns the inserted row id.
  Future<int> addThought({
    required String icon,
    required String title,
    required String content,
  });

  /// Deletes a thought by [id].
  Future<void> deleteThought(int id);
}

/// Drift-backed implementation of [ThoughtsRepository].
@LazySingleton(as: ThoughtsRepository)
class DriftThoughtsRepository implements ThoughtsRepository {
  DriftThoughtsRepository(this._db);

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
