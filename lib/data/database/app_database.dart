import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';

part 'app_database.g.dart';

@singleton
@DriftDatabase(tables: [Thoughts])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
    : super(
        e ??
            driftDatabase(
              name: 'app_db',
              web: .new(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ),
      );

  @factoryMethod
  static AppDatabase create() => .new();

  @override
  int get schemaVersion => 1;
}

class Thoughts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get icon => text().withLength(min: 1)();
  TextColumn get title => text().withLength(min: 1)();
  TextColumn get content => text().withLength(min: 1)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
