// database.dart

import 'database_stub.dart'
    if (dart.library.io) 'database_native.dart'
    if (dart.library.html) 'database_web.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'database.g.dart';

class Puzzles extends Table {
  TextColumn get id => text()();
  TextColumn get puzzleName => text()();
  TextColumn get puzzleCategory => text()();
  DateTimeColumn get deadline => dateTime()();
  DateTimeColumn get startingTime => dateTime()();
  IntColumn get taskNum => integer()();
  IntColumn get gems => integer()();
  IntColumn get completedTasks => integer()();
  TextColumn get rewardImagePath => text().nullable()();
}

class TaskList extends Table {
  TextColumn get id => text()();
  TextColumn get puzzleId => text().customConstraint('REFERENCES puzzles(id) NOT NULL')();
  IntColumn get index => integer().nullable()();
  TextColumn get textField => text().nullable()();
  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();
}

class Categories extends Table {
  TextColumn get name => text()();
}

class AppDatabaseSingleton {
  static AppDatabase? _instance;

  AppDatabaseSingleton._();

  static AppDatabase getInstance(QueryExecutor e) {
    _instance ??= AppDatabase(e);
    return _instance!;
  }
}

@DriftDatabase(tables: [Puzzles, TaskList, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        // Provide a migration strategy for schema changes
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            // Assuming version 2 is where you added the 'gems' column
            await migrator.addColumn(puzzles, puzzles.gems);
          }
          if (from < 3) {
            // Drop the TaskList table
            await customStatement('DROP TABLE IF EXISTS task_list');

            // Recreate the TaskList table with the correct schema
            await migrator.createTable(taskList);

            print('TaskList table recreated successfully.');
          }
        },
      );

  // Puzzle queries
  Future<List<Puzzle>> getAllPuzzles() => select(puzzles).get();

  Future<Puzzle?> getPuzzleById(String id) async {
    return (select(puzzles)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<void> addPuzzle(Puzzle puzzle) async {
    await into(puzzles).insert(puzzle);

    List<TaskListCompanion> tasks = List.generate(8, (index) {
      return TaskListCompanion.insert(
        id: Uuid().v4(),
        puzzleId: (puzzle.id),
        index: Value(index),
        textField: Value(''),
        isChecked: Value(false),
      );
    });

    await batch((batch) {
      batch.insertAll(taskList, tasks);
    });
  }

  Future<void> deletePuzzle(String id) async {
    await (delete(taskList)..where((tbl) => tbl.puzzleId.equals(id))).go();
    await (delete(puzzles)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> updatePuzzle(Puzzle puzzle) =>
      (update(puzzles)..where((tbl) => tbl.id.equals(puzzle.id))).write(puzzle);

  Future<void> updatePuzzleName(String id, String newName) {
    return (update(puzzles)..where((tbl) => tbl.id.equals(id)))
        .write(PuzzlesCompanion(puzzleName: Value(newName)));
  }

  Future<void> updatePuzzleCategory(String id, String newCategory) {
    return (update(puzzles)..where((tbl) => tbl.id.equals(id)))
        .write(PuzzlesCompanion(puzzleCategory: Value(newCategory)));
  }

  Future<void> updatePuzzleDeadline(String id, DateTime newDeadline) {
    return (update(puzzles)..where((tbl) => tbl.id.equals(id)))
        .write(PuzzlesCompanion(deadline: Value(newDeadline)));
  }

  Future<void> updatePuzzleStartingTime(String id, DateTime newStartingTime) {
    return (update(puzzles)..where((tbl) => tbl.id.equals(id)))
        .write(PuzzlesCompanion(startingTime: Value(newStartingTime)));
  }

  Future<void> updatePuzzleTaskNum(String id, int newTaskNum) {
    return (update(puzzles)..where((tbl) => tbl.id.equals(id)))
        .write(PuzzlesCompanion(taskNum: Value(newTaskNum)));
  }

  Future<void> updatePuzzleGems(String id, int newGems) {
    return (update(puzzles)..where((tbl) => tbl.id.equals(id)))
        .write(PuzzlesCompanion(gems: Value(newGems)));
  }

  Future<void> updatePuzzleCompletedTasks(String id, int completedTasks) {
    return (update(puzzles)..where((tbl) => tbl.id.equals(id)))
        .write(PuzzlesCompanion(completedTasks: Value(completedTasks)));
  }

  // TaskList queries
  Future<List<TaskListData>> getTasksByPuzzleId(String puzzleId) =>
      (select(taskList)
      ..where((tbl) => tbl.puzzleId.equals(puzzleId))).get();

  Future<void> updateTaskText(String puzzleId, int index, String newText) {
  return (update(taskList)..where((tbl) => tbl.puzzleId.equals(puzzleId) & tbl.index.equals(index)))
      .write(TaskListCompanion(textField: Value(newText)));
  }

  Future<void> updateTaskCheckedState(String puzzleId, int index, bool isChecked) {
    return (update(taskList)..where((tbl) => tbl.puzzleId.equals(puzzleId) & tbl.index.equals(index)))
      .write(TaskListCompanion(isChecked: Value(isChecked)));
  }

  Future<void> resetTaskCheckedStates(String puzzleId) {
    return (update(taskList)..where((tbl) => tbl.puzzleId.equals(puzzleId)))
      .write(TaskListCompanion(isChecked: Value(false)));
  }

  // Category queries
  Future<List<String>> getAllCategories() =>
      select(categories).map((row) => row.name).get();

  Future<void> addCategory(String category) =>
      into(categories).insert(CategoriesCompanion(name: Value(category)));

  Future<void> deleteCategory(String category) =>
      (delete(categories)..where((tbl) => tbl.name.equals(category))).go();

  Future<void> updateCategory(String category, String newCategory) =>
      (update(categories)..where((tbl) => tbl.name.equals(category)))
          .write(CategoriesCompanion(name: Value(newCategory)));
}

final databaseProvider = Provider<AppDatabase>((ref) {
  return constructDb();
});

final puzzlesDataProvider = FutureProvider<List<Puzzle>>((ref) async {
  final database = ref.watch(databaseProvider);
  return database.getAllPuzzles();
});

final tasksDataProvider = FutureProvider.family<List<TaskListData>, String>((ref, puzzleId) async {
  final database = ref.watch(databaseProvider);
  return database.getTasksByPuzzleId(puzzleId);
});

final puzzleCategoriesDataProvider = FutureProvider<List<String>>((ref) async {
  final database = ref.watch(databaseProvider);
  return database.getAllCategories();
});
