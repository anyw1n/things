import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';

part 'app_database.g.dart';

@lazySingleton
@DriftDatabase(tables: [Thoughts])
class AppDatabase extends _$AppDatabase {
  AppDatabase([@ignoreParam QueryExecutor? e])
    : super(
        e ??
            driftDatabase(
              name: 'app_db',
              web: .new(
                sqlite3Wasm: .parse('sqlite3.wasm'),
                driftWorker: .parse('drift_worker.js'),
              ),
            ),
      );

  @override
  int get schemaVersion => 1;
}

/// Table storing user thoughts.
class Thoughts extends Table {
  /// Auto-incremented thought id.
  IntColumn get id => integer().autoIncrement()();

  /// Emoji representing the thought.
  TextColumn get icon => text().withLength(min: 1)();

  /// Short title.
  TextColumn get title => text().withLength(min: 1)();

  /// Full thought body.
  TextColumn get content => text().withLength(min: 1)();

  /// Date when thought was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
