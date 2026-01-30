// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ThoughtsTable extends Thoughts with TableInfo<$ThoughtsTable, Thought> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThoughtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, content, createdAt, icon, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'thoughts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Thought> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Thought map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Thought(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
    );
  }

  @override
  $ThoughtsTable createAlias(String alias) {
    return $ThoughtsTable(attachedDatabase, alias);
  }
}

class Thought extends DataClass implements Insertable<Thought> {
  final int id;
  final String content;
  final DateTime createdAt;
  final String? icon;
  final String? title;
  const Thought({
    required this.id,
    required this.content,
    required this.createdAt,
    this.icon,
    this.title,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    return map;
  }

  ThoughtsCompanion toCompanion(bool nullToAbsent) {
    return ThoughtsCompanion(
      id: Value(id),
      content: Value(content),
      createdAt: Value(createdAt),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
    );
  }

  factory Thought.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Thought(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      icon: serializer.fromJson<String?>(json['icon']),
      title: serializer.fromJson<String?>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'icon': serializer.toJson<String?>(icon),
      'title': serializer.toJson<String?>(title),
    };
  }

  Thought copyWith({
    int? id,
    String? content,
    DateTime? createdAt,
    Value<String?> icon = const Value.absent(),
    Value<String?> title = const Value.absent(),
  }) => Thought(
    id: id ?? this.id,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    icon: icon.present ? icon.value : this.icon,
    title: title.present ? title.value : this.title,
  );
  Thought copyWithCompanion(ThoughtsCompanion data) {
    return Thought(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      icon: data.icon.present ? data.icon.value : this.icon,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Thought(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('icon: $icon, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, createdAt, icon, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Thought &&
          other.id == this.id &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.icon == this.icon &&
          other.title == this.title);
}

class ThoughtsCompanion extends UpdateCompanion<Thought> {
  final Value<int> id;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<String?> icon;
  final Value<String?> title;
  const ThoughtsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.icon = const Value.absent(),
    this.title = const Value.absent(),
  });
  ThoughtsCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    this.createdAt = const Value.absent(),
    this.icon = const Value.absent(),
    this.title = const Value.absent(),
  }) : content = Value(content);
  static Insertable<Thought> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<String>? icon,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (icon != null) 'icon': icon,
      if (title != null) 'title': title,
    });
  }

  ThoughtsCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<String?>? icon,
    Value<String?>? title,
  }) {
    return ThoughtsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      icon: icon ?? this.icon,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThoughtsCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('icon: $icon, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ThoughtsTable thoughts = $ThoughtsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [thoughts];
}

typedef $$ThoughtsTableCreateCompanionBuilder =
    ThoughtsCompanion Function({
      Value<int> id,
      required String content,
      Value<DateTime> createdAt,
      Value<String?> icon,
      Value<String?> title,
    });
typedef $$ThoughtsTableUpdateCompanionBuilder =
    ThoughtsCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<String?> icon,
      Value<String?> title,
    });

class $$ThoughtsTableFilterComposer
    extends Composer<_$AppDatabase, $ThoughtsTable> {
  $$ThoughtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ThoughtsTableOrderingComposer
    extends Composer<_$AppDatabase, $ThoughtsTable> {
  $$ThoughtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ThoughtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThoughtsTable> {
  $$ThoughtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);
}

class $$ThoughtsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThoughtsTable,
          Thought,
          $$ThoughtsTableFilterComposer,
          $$ThoughtsTableOrderingComposer,
          $$ThoughtsTableAnnotationComposer,
          $$ThoughtsTableCreateCompanionBuilder,
          $$ThoughtsTableUpdateCompanionBuilder,
          (Thought, BaseReferences<_$AppDatabase, $ThoughtsTable, Thought>),
          Thought,
          PrefetchHooks Function()
        > {
  $$ThoughtsTableTableManager(_$AppDatabase db, $ThoughtsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThoughtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThoughtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThoughtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> title = const Value.absent(),
              }) => ThoughtsCompanion(
                id: id,
                content: content,
                createdAt: createdAt,
                icon: icon,
                title: title,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> title = const Value.absent(),
              }) => ThoughtsCompanion.insert(
                id: id,
                content: content,
                createdAt: createdAt,
                icon: icon,
                title: title,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ThoughtsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThoughtsTable,
      Thought,
      $$ThoughtsTableFilterComposer,
      $$ThoughtsTableOrderingComposer,
      $$ThoughtsTableAnnotationComposer,
      $$ThoughtsTableCreateCompanionBuilder,
      $$ThoughtsTableUpdateCompanionBuilder,
      (Thought, BaseReferences<_$AppDatabase, $ThoughtsTable, Thought>),
      Thought,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ThoughtsTableTableManager get thoughts =>
      $$ThoughtsTableTableManager(_db, _db.thoughts);
}
