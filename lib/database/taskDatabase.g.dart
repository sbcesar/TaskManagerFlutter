// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taskDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $TaskdatabaseBuilderContract {
  /// Adds migrations to the builder.
  $TaskdatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $TaskdatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<Taskdatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorTaskdatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $TaskdatabaseBuilderContract databaseBuilder(String name) =>
      _$TaskdatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $TaskdatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$TaskdatabaseBuilder(null);
}

class _$TaskdatabaseBuilder implements $TaskdatabaseBuilderContract {
  _$TaskdatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $TaskdatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $TaskdatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<Taskdatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$Taskdatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$Taskdatabase extends Taskdatabase {
  _$Taskdatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TaskDao? _taskDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Task` (`id` INTEGER NOT NULL, `task` TEXT NOT NULL, `selected` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TaskDao get taskDao {
    return _taskDaoInstance ??= _$TaskDao(database, changeListener);
  }
}

class _$TaskDao extends TaskDao {
  _$TaskDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _taskInsertionAdapter = InsertionAdapter(
            database,
            'Task',
            (Task item) => <String, Object?>{
                  'id': item.id,
                  'task': item.task,
                  'selected': item.selected ? 1 : 0
                }),
        _taskUpdateAdapter = UpdateAdapter(
            database,
            'Task',
            ['id'],
            (Task item) => <String, Object?>{
                  'id': item.id,
                  'task': item.task,
                  'selected': item.selected ? 1 : 0
                }),
        _taskDeletionAdapter = DeletionAdapter(
            database,
            'Task',
            ['id'],
            (Task item) => <String, Object?>{
                  'id': item.id,
                  'task': item.task,
                  'selected': item.selected ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Task> _taskInsertionAdapter;

  final UpdateAdapter<Task> _taskUpdateAdapter;

  final DeletionAdapter<Task> _taskDeletionAdapter;

  @override
  Future<List<Task>> getAllTasks() async {
    return _queryAdapter.queryList('SELECT * FROM Task',
        mapper: (Map<String, Object?> row) => Task(
            id: row['id'] as int?,
            task: row['task'] as String,
            selected: (row['selected'] as int) != 0));
  }

  @override
  Future<void> insertTask(Task task) async {
    await _taskInsertionAdapter.insert(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTask(Task task) async {
    await _taskUpdateAdapter.update(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTask(Task task) async {
    await _taskDeletionAdapter.delete(task);
  }
}
