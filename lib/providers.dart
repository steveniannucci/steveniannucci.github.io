// providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'database/database.dart' as db;

final puzzlesProvider = StateNotifierProvider<PuzzlesNotifier, List<db.Puzzle>>((ref) => PuzzlesNotifier());

final puzzleNameProvider = StateNotifierProvider.family<PuzzleNameNotifier, String, String>((ref, id) => PuzzleNameNotifier(id));
final puzzleCategoryProvider = StateNotifierProvider.family<PuzzleCategoryNotifier, String, String>((ref, id) => PuzzleCategoryNotifier(id));
final puzzleCategoriesProvider = StateNotifierProvider<PuzzleCategoriesNotifier, List<String>>((ref) => PuzzleCategoriesNotifier());
final deadlineProvider = StateNotifierProvider.family<DeadlineNotifier, DateTime, String>((ref, id) => DeadlineNotifier(DateTime.now()));
final startingTimeProvider = StateNotifierProvider.family<StartingTimeNotifier, DateTime, String>((ref, id) => StartingTimeNotifier(DateTime.now()));
final taskNumProvider = StateNotifierProvider.family<TaskNumNotifier, int, String>((ref, id) => TaskNumNotifier());
final gemsProvider = StateNotifierProvider.family<GemsNotifier, int, String>((ref, id) => GemsNotifier());
final completedTasksProvider = StateNotifierProvider.family<CompletedTasksNotifier, int, String>((ref, id) => CompletedTasksNotifier());

final expiredPuzzlesProvider = StateProvider<List<db.Puzzle>>((ref) => []);
final activePuzzlesProvider = StateProvider<List<db.Puzzle>>((ref) => []);

final taskListProvider = StateNotifierProvider.family<TaskListNotifier, List<Task>, String>((ref, id) => TaskListNotifier());
final taskStatusProvider = StateNotifierProvider.family<TaskStatusNotifier, List<ValueNotifier<bool>>, String>((ref, id) => TaskStatusNotifier(id));

class PuzzlesNotifier extends StateNotifier<List<db.Puzzle>> {
  PuzzlesNotifier() : super([]);

  void addPuzzle(db.Puzzle puzzle) {
    state = [...state, puzzle];
  }

  void deletePuzzle(String id) {
    state = state.where((puzzle) => puzzle.id != id).toList();
  }

  void updatePuzzleCategories(String category, String newCategory) {
    state = state.map((puzzle) {
      if (puzzle.puzzleCategory == category) {
        return puzzle.copyWith(puzzleCategory: newCategory);
      } else {
        return puzzle;
      }
    }).toList();
  }
}

class PuzzleNameNotifier extends StateNotifier<String> {
  PuzzleNameNotifier(String name) : super(name);

  void updatePuzzleName(String newName) {
    state = newName;
  }
}

class PuzzleCategoryNotifier extends StateNotifier<String> {
  PuzzleCategoryNotifier(String category) : super(category);

  void updatePuzzleCategory(String newCategory) {
    state = newCategory;
  }
}

class PuzzleCategoriesNotifier extends StateNotifier<List<String>> {
  PuzzleCategoriesNotifier() : super([]);

  void addCategory(String category) {
    if (!state.contains(category)) {
      state = [...state, category];
    }
  }

  void removeCategory(String category) {
    state = state.where((item) => item != category).toList();
  }

  void updateCategory(String category, String newCategory) {
    state = state.map((item) => item == category ? newCategory : item).toList();
  }
}

class DeadlineNotifier extends StateNotifier<DateTime> {
  DeadlineNotifier(DateTime date) : super(date);

  void updateDeadline(DateTime newDate) {
    state = newDate;
  }
}

class StartingTimeNotifier extends StateNotifier<DateTime> {
  StartingTimeNotifier(DateTime date) : super(date);

  void updateStartingTime(DateTime newDate) {
    state = newDate;
  }
}

class TaskNumNotifier extends StateNotifier<int> {
  TaskNumNotifier() : super(1);

  void updateTaskNum(int value) {
    state = value;
  }
}

class Task {
  String text;
  bool isCompleted;

  Task({required this.text, required this.isCompleted});
}

class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier() : super([]);

  void initTasks(int maxTasks) {
    state = List.generate(maxTasks, (index) => Task(text: '', isCompleted: false));
  }

  void updateTask(int index, String text) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          Task(text: text, isCompleted: state[i].isCompleted)
        else
          state[i]
    ];
  }

  void toggleTaskCompletion(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          Task(text: state[i].text, isCompleted: !state[i].isCompleted)
        else
          state[i]
    ];
  }
}

class TaskStatusNotifier extends StateNotifier<List<ValueNotifier<bool>>> {
  TaskStatusNotifier(String id) : super(_initTaskStatus(id));

  void reset() {
    state = List<ValueNotifier<bool>>.generate(8, (_) => ValueNotifier<bool>(false));
  }

  static List<ValueNotifier<bool>> _initTaskStatus(String id) {
    return List<ValueNotifier<bool>>.generate(8, (_) => ValueNotifier<bool>(false));
  }
}

class GemsNotifier extends StateNotifier<int> {
  GemsNotifier() : super(7);

  void decrease() {
    if (state > 0) {
      state--;
    }
  }

  void update(int newGems) {
    state = newGems;
  }

  void empty() {
    state = 0;
  }

  void reset() {
    state = 7;
  }
}

class CompletedTasksNotifier extends StateNotifier<int> {
  CompletedTasksNotifier() : super(0);

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }

  void reset() {
    state = 0;
  }
}