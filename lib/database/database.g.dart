// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PuzzlesTable extends Puzzles with TableInfo<$PuzzlesTable, Puzzle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PuzzlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _puzzleNameMeta =
      const VerificationMeta('puzzleName');
  @override
  late final GeneratedColumn<String> puzzleName = GeneratedColumn<String>(
      'puzzle_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _puzzleCategoryMeta =
      const VerificationMeta('puzzleCategory');
  @override
  late final GeneratedColumn<String> puzzleCategory = GeneratedColumn<String>(
      'puzzle_category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deadlineMeta =
      const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
      'deadline', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _startingTimeMeta =
      const VerificationMeta('startingTime');
  @override
  late final GeneratedColumn<DateTime> startingTime = GeneratedColumn<DateTime>(
      'starting_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _taskNumMeta =
      const VerificationMeta('taskNum');
  @override
  late final GeneratedColumn<int> taskNum = GeneratedColumn<int>(
      'task_num', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _gemsMeta = const VerificationMeta('gems');
  @override
  late final GeneratedColumn<int> gems = GeneratedColumn<int>(
      'gems', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedTasksMeta =
      const VerificationMeta('completedTasks');
  @override
  late final GeneratedColumn<int> completedTasks = GeneratedColumn<int>(
      'completed_tasks', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rewardImagePathMeta =
      const VerificationMeta('rewardImagePath');
  @override
  late final GeneratedColumn<String> rewardImagePath = GeneratedColumn<String>(
      'reward_image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        puzzleName,
        puzzleCategory,
        deadline,
        startingTime,
        taskNum,
        gems,
        completedTasks,
        rewardImagePath
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'puzzles';
  @override
  VerificationContext validateIntegrity(Insertable<Puzzle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('puzzle_name')) {
      context.handle(
          _puzzleNameMeta,
          puzzleName.isAcceptableOrUnknown(
              data['puzzle_name']!, _puzzleNameMeta));
    } else if (isInserting) {
      context.missing(_puzzleNameMeta);
    }
    if (data.containsKey('puzzle_category')) {
      context.handle(
          _puzzleCategoryMeta,
          puzzleCategory.isAcceptableOrUnknown(
              data['puzzle_category']!, _puzzleCategoryMeta));
    } else if (isInserting) {
      context.missing(_puzzleCategoryMeta);
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta,
          deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    } else if (isInserting) {
      context.missing(_deadlineMeta);
    }
    if (data.containsKey('starting_time')) {
      context.handle(
          _startingTimeMeta,
          startingTime.isAcceptableOrUnknown(
              data['starting_time']!, _startingTimeMeta));
    } else if (isInserting) {
      context.missing(_startingTimeMeta);
    }
    if (data.containsKey('task_num')) {
      context.handle(_taskNumMeta,
          taskNum.isAcceptableOrUnknown(data['task_num']!, _taskNumMeta));
    } else if (isInserting) {
      context.missing(_taskNumMeta);
    }
    if (data.containsKey('gems')) {
      context.handle(
          _gemsMeta, gems.isAcceptableOrUnknown(data['gems']!, _gemsMeta));
    } else if (isInserting) {
      context.missing(_gemsMeta);
    }
    if (data.containsKey('completed_tasks')) {
      context.handle(
          _completedTasksMeta,
          completedTasks.isAcceptableOrUnknown(
              data['completed_tasks']!, _completedTasksMeta));
    } else if (isInserting) {
      context.missing(_completedTasksMeta);
    }
    if (data.containsKey('reward_image_path')) {
      context.handle(
          _rewardImagePathMeta,
          rewardImagePath.isAcceptableOrUnknown(
              data['reward_image_path']!, _rewardImagePathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Puzzle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Puzzle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      puzzleName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}puzzle_name'])!,
      puzzleCategory: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}puzzle_category'])!,
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deadline'])!,
      startingTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}starting_time'])!,
      taskNum: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}task_num'])!,
      gems: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gems'])!,
      completedTasks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_tasks'])!,
      rewardImagePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reward_image_path']),
    );
  }

  @override
  $PuzzlesTable createAlias(String alias) {
    return $PuzzlesTable(attachedDatabase, alias);
  }
}

class Puzzle extends DataClass implements Insertable<Puzzle> {
  final String id;
  final String puzzleName;
  final String puzzleCategory;
  final DateTime deadline;
  final DateTime startingTime;
  final int taskNum;
  final int gems;
  final int completedTasks;
  final String? rewardImagePath;
  const Puzzle(
      {required this.id,
      required this.puzzleName,
      required this.puzzleCategory,
      required this.deadline,
      required this.startingTime,
      required this.taskNum,
      required this.gems,
      required this.completedTasks,
      this.rewardImagePath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['puzzle_name'] = Variable<String>(puzzleName);
    map['puzzle_category'] = Variable<String>(puzzleCategory);
    map['deadline'] = Variable<DateTime>(deadline);
    map['starting_time'] = Variable<DateTime>(startingTime);
    map['task_num'] = Variable<int>(taskNum);
    map['gems'] = Variable<int>(gems);
    map['completed_tasks'] = Variable<int>(completedTasks);
    if (!nullToAbsent || rewardImagePath != null) {
      map['reward_image_path'] = Variable<String>(rewardImagePath);
    }
    return map;
  }

  PuzzlesCompanion toCompanion(bool nullToAbsent) {
    return PuzzlesCompanion(
      id: Value(id),
      puzzleName: Value(puzzleName),
      puzzleCategory: Value(puzzleCategory),
      deadline: Value(deadline),
      startingTime: Value(startingTime),
      taskNum: Value(taskNum),
      gems: Value(gems),
      completedTasks: Value(completedTasks),
      rewardImagePath: rewardImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(rewardImagePath),
    );
  }

  factory Puzzle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Puzzle(
      id: serializer.fromJson<String>(json['id']),
      puzzleName: serializer.fromJson<String>(json['puzzleName']),
      puzzleCategory: serializer.fromJson<String>(json['puzzleCategory']),
      deadline: serializer.fromJson<DateTime>(json['deadline']),
      startingTime: serializer.fromJson<DateTime>(json['startingTime']),
      taskNum: serializer.fromJson<int>(json['taskNum']),
      gems: serializer.fromJson<int>(json['gems']),
      completedTasks: serializer.fromJson<int>(json['completedTasks']),
      rewardImagePath: serializer.fromJson<String?>(json['rewardImagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'puzzleName': serializer.toJson<String>(puzzleName),
      'puzzleCategory': serializer.toJson<String>(puzzleCategory),
      'deadline': serializer.toJson<DateTime>(deadline),
      'startingTime': serializer.toJson<DateTime>(startingTime),
      'taskNum': serializer.toJson<int>(taskNum),
      'gems': serializer.toJson<int>(gems),
      'completedTasks': serializer.toJson<int>(completedTasks),
      'rewardImagePath': serializer.toJson<String?>(rewardImagePath),
    };
  }

  Puzzle copyWith(
          {String? id,
          String? puzzleName,
          String? puzzleCategory,
          DateTime? deadline,
          DateTime? startingTime,
          int? taskNum,
          int? gems,
          int? completedTasks,
          Value<String?> rewardImagePath = const Value.absent()}) =>
      Puzzle(
        id: id ?? this.id,
        puzzleName: puzzleName ?? this.puzzleName,
        puzzleCategory: puzzleCategory ?? this.puzzleCategory,
        deadline: deadline ?? this.deadline,
        startingTime: startingTime ?? this.startingTime,
        taskNum: taskNum ?? this.taskNum,
        gems: gems ?? this.gems,
        completedTasks: completedTasks ?? this.completedTasks,
        rewardImagePath: rewardImagePath.present
            ? rewardImagePath.value
            : this.rewardImagePath,
      );
  @override
  String toString() {
    return (StringBuffer('Puzzle(')
          ..write('id: $id, ')
          ..write('puzzleName: $puzzleName, ')
          ..write('puzzleCategory: $puzzleCategory, ')
          ..write('deadline: $deadline, ')
          ..write('startingTime: $startingTime, ')
          ..write('taskNum: $taskNum, ')
          ..write('gems: $gems, ')
          ..write('completedTasks: $completedTasks, ')
          ..write('rewardImagePath: $rewardImagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, puzzleName, puzzleCategory, deadline,
      startingTime, taskNum, gems, completedTasks, rewardImagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Puzzle &&
          other.id == this.id &&
          other.puzzleName == this.puzzleName &&
          other.puzzleCategory == this.puzzleCategory &&
          other.deadline == this.deadline &&
          other.startingTime == this.startingTime &&
          other.taskNum == this.taskNum &&
          other.gems == this.gems &&
          other.completedTasks == this.completedTasks &&
          other.rewardImagePath == this.rewardImagePath);
}

class PuzzlesCompanion extends UpdateCompanion<Puzzle> {
  final Value<String> id;
  final Value<String> puzzleName;
  final Value<String> puzzleCategory;
  final Value<DateTime> deadline;
  final Value<DateTime> startingTime;
  final Value<int> taskNum;
  final Value<int> gems;
  final Value<int> completedTasks;
  final Value<String?> rewardImagePath;
  final Value<int> rowid;
  const PuzzlesCompanion({
    this.id = const Value.absent(),
    this.puzzleName = const Value.absent(),
    this.puzzleCategory = const Value.absent(),
    this.deadline = const Value.absent(),
    this.startingTime = const Value.absent(),
    this.taskNum = const Value.absent(),
    this.gems = const Value.absent(),
    this.completedTasks = const Value.absent(),
    this.rewardImagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PuzzlesCompanion.insert({
    required String id,
    required String puzzleName,
    required String puzzleCategory,
    required DateTime deadline,
    required DateTime startingTime,
    required int taskNum,
    required int gems,
    required int completedTasks,
    this.rewardImagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        puzzleName = Value(puzzleName),
        puzzleCategory = Value(puzzleCategory),
        deadline = Value(deadline),
        startingTime = Value(startingTime),
        taskNum = Value(taskNum),
        gems = Value(gems),
        completedTasks = Value(completedTasks);
  static Insertable<Puzzle> custom({
    Expression<String>? id,
    Expression<String>? puzzleName,
    Expression<String>? puzzleCategory,
    Expression<DateTime>? deadline,
    Expression<DateTime>? startingTime,
    Expression<int>? taskNum,
    Expression<int>? gems,
    Expression<int>? completedTasks,
    Expression<String>? rewardImagePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (puzzleName != null) 'puzzle_name': puzzleName,
      if (puzzleCategory != null) 'puzzle_category': puzzleCategory,
      if (deadline != null) 'deadline': deadline,
      if (startingTime != null) 'starting_time': startingTime,
      if (taskNum != null) 'task_num': taskNum,
      if (gems != null) 'gems': gems,
      if (completedTasks != null) 'completed_tasks': completedTasks,
      if (rewardImagePath != null) 'reward_image_path': rewardImagePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PuzzlesCompanion copyWith(
      {Value<String>? id,
      Value<String>? puzzleName,
      Value<String>? puzzleCategory,
      Value<DateTime>? deadline,
      Value<DateTime>? startingTime,
      Value<int>? taskNum,
      Value<int>? gems,
      Value<int>? completedTasks,
      Value<String?>? rewardImagePath,
      Value<int>? rowid}) {
    return PuzzlesCompanion(
      id: id ?? this.id,
      puzzleName: puzzleName ?? this.puzzleName,
      puzzleCategory: puzzleCategory ?? this.puzzleCategory,
      deadline: deadline ?? this.deadline,
      startingTime: startingTime ?? this.startingTime,
      taskNum: taskNum ?? this.taskNum,
      gems: gems ?? this.gems,
      completedTasks: completedTasks ?? this.completedTasks,
      rewardImagePath: rewardImagePath ?? this.rewardImagePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (puzzleName.present) {
      map['puzzle_name'] = Variable<String>(puzzleName.value);
    }
    if (puzzleCategory.present) {
      map['puzzle_category'] = Variable<String>(puzzleCategory.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (startingTime.present) {
      map['starting_time'] = Variable<DateTime>(startingTime.value);
    }
    if (taskNum.present) {
      map['task_num'] = Variable<int>(taskNum.value);
    }
    if (gems.present) {
      map['gems'] = Variable<int>(gems.value);
    }
    if (completedTasks.present) {
      map['completed_tasks'] = Variable<int>(completedTasks.value);
    }
    if (rewardImagePath.present) {
      map['reward_image_path'] = Variable<String>(rewardImagePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PuzzlesCompanion(')
          ..write('id: $id, ')
          ..write('puzzleName: $puzzleName, ')
          ..write('puzzleCategory: $puzzleCategory, ')
          ..write('deadline: $deadline, ')
          ..write('startingTime: $startingTime, ')
          ..write('taskNum: $taskNum, ')
          ..write('gems: $gems, ')
          ..write('completedTasks: $completedTasks, ')
          ..write('rewardImagePath: $rewardImagePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskListTable extends TaskList
    with TableInfo<$TaskListTable, TaskListData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskListTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _puzzleIdMeta =
      const VerificationMeta('puzzleId');
  @override
  late final GeneratedColumn<String> puzzleId = GeneratedColumn<String>(
      'puzzle_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES puzzles(id) NOT NULL');
  static const VerificationMeta _indexMeta = const VerificationMeta('index');
  @override
  late final GeneratedColumn<int> index = GeneratedColumn<int>(
      'index', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _textFieldMeta =
      const VerificationMeta('textField');
  @override
  late final GeneratedColumn<String> textField = GeneratedColumn<String>(
      'text_field', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCheckedMeta =
      const VerificationMeta('isChecked');
  @override
  late final GeneratedColumn<bool> isChecked = GeneratedColumn<bool>(
      'is_checked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_checked" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, puzzleId, index, textField, isChecked];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_list';
  @override
  VerificationContext validateIntegrity(Insertable<TaskListData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('puzzle_id')) {
      context.handle(_puzzleIdMeta,
          puzzleId.isAcceptableOrUnknown(data['puzzle_id']!, _puzzleIdMeta));
    } else if (isInserting) {
      context.missing(_puzzleIdMeta);
    }
    if (data.containsKey('index')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['index']!, _indexMeta));
    }
    if (data.containsKey('text_field')) {
      context.handle(_textFieldMeta,
          textField.isAcceptableOrUnknown(data['text_field']!, _textFieldMeta));
    }
    if (data.containsKey('is_checked')) {
      context.handle(_isCheckedMeta,
          isChecked.isAcceptableOrUnknown(data['is_checked']!, _isCheckedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  TaskListData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskListData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      puzzleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}puzzle_id'])!,
      index: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}index']),
      textField: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_field']),
      isChecked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_checked'])!,
    );
  }

  @override
  $TaskListTable createAlias(String alias) {
    return $TaskListTable(attachedDatabase, alias);
  }
}

class TaskListData extends DataClass implements Insertable<TaskListData> {
  final String id;
  final String puzzleId;
  final int? index;
  final String? textField;
  final bool isChecked;
  const TaskListData(
      {required this.id,
      required this.puzzleId,
      this.index,
      this.textField,
      required this.isChecked});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['puzzle_id'] = Variable<String>(puzzleId);
    if (!nullToAbsent || index != null) {
      map['index'] = Variable<int>(index);
    }
    if (!nullToAbsent || textField != null) {
      map['text_field'] = Variable<String>(textField);
    }
    map['is_checked'] = Variable<bool>(isChecked);
    return map;
  }

  TaskListCompanion toCompanion(bool nullToAbsent) {
    return TaskListCompanion(
      id: Value(id),
      puzzleId: Value(puzzleId),
      index:
          index == null && nullToAbsent ? const Value.absent() : Value(index),
      textField: textField == null && nullToAbsent
          ? const Value.absent()
          : Value(textField),
      isChecked: Value(isChecked),
    );
  }

  factory TaskListData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskListData(
      id: serializer.fromJson<String>(json['id']),
      puzzleId: serializer.fromJson<String>(json['puzzleId']),
      index: serializer.fromJson<int?>(json['index']),
      textField: serializer.fromJson<String?>(json['textField']),
      isChecked: serializer.fromJson<bool>(json['isChecked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'puzzleId': serializer.toJson<String>(puzzleId),
      'index': serializer.toJson<int?>(index),
      'textField': serializer.toJson<String?>(textField),
      'isChecked': serializer.toJson<bool>(isChecked),
    };
  }

  TaskListData copyWith(
          {String? id,
          String? puzzleId,
          Value<int?> index = const Value.absent(),
          Value<String?> textField = const Value.absent(),
          bool? isChecked}) =>
      TaskListData(
        id: id ?? this.id,
        puzzleId: puzzleId ?? this.puzzleId,
        index: index.present ? index.value : this.index,
        textField: textField.present ? textField.value : this.textField,
        isChecked: isChecked ?? this.isChecked,
      );
  @override
  String toString() {
    return (StringBuffer('TaskListData(')
          ..write('id: $id, ')
          ..write('puzzleId: $puzzleId, ')
          ..write('index: $index, ')
          ..write('textField: $textField, ')
          ..write('isChecked: $isChecked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, puzzleId, index, textField, isChecked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskListData &&
          other.id == this.id &&
          other.puzzleId == this.puzzleId &&
          other.index == this.index &&
          other.textField == this.textField &&
          other.isChecked == this.isChecked);
}

class TaskListCompanion extends UpdateCompanion<TaskListData> {
  final Value<String> id;
  final Value<String> puzzleId;
  final Value<int?> index;
  final Value<String?> textField;
  final Value<bool> isChecked;
  final Value<int> rowid;
  const TaskListCompanion({
    this.id = const Value.absent(),
    this.puzzleId = const Value.absent(),
    this.index = const Value.absent(),
    this.textField = const Value.absent(),
    this.isChecked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskListCompanion.insert({
    required String id,
    required String puzzleId,
    this.index = const Value.absent(),
    this.textField = const Value.absent(),
    this.isChecked = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        puzzleId = Value(puzzleId);
  static Insertable<TaskListData> custom({
    Expression<String>? id,
    Expression<String>? puzzleId,
    Expression<int>? index,
    Expression<String>? textField,
    Expression<bool>? isChecked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (puzzleId != null) 'puzzle_id': puzzleId,
      if (index != null) 'index': index,
      if (textField != null) 'text_field': textField,
      if (isChecked != null) 'is_checked': isChecked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskListCompanion copyWith(
      {Value<String>? id,
      Value<String>? puzzleId,
      Value<int?>? index,
      Value<String?>? textField,
      Value<bool>? isChecked,
      Value<int>? rowid}) {
    return TaskListCompanion(
      id: id ?? this.id,
      puzzleId: puzzleId ?? this.puzzleId,
      index: index ?? this.index,
      textField: textField ?? this.textField,
      isChecked: isChecked ?? this.isChecked,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (puzzleId.present) {
      map['puzzle_id'] = Variable<String>(puzzleId.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (textField.present) {
      map['text_field'] = Variable<String>(textField.value);
    }
    if (isChecked.present) {
      map['is_checked'] = Variable<bool>(isChecked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskListCompanion(')
          ..write('id: $id, ')
          ..write('puzzleId: $puzzleId, ')
          ..write('index: $index, ')
          ..write('textField: $textField, ')
          ..write('isChecked: $isChecked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String name;
  const Category({required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      name: Value(name),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
    };
  }

  Category copyWith({String? name}) => Category(
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => name.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Category && other.name == this.name);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> name;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String name,
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({Value<String>? name, Value<int>? rowid}) {
    return CategoriesCompanion(
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $PuzzlesTable puzzles = $PuzzlesTable(this);
  late final $TaskListTable taskList = $TaskListTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [puzzles, taskList, categories];
}

typedef $$PuzzlesTableInsertCompanionBuilder = PuzzlesCompanion Function({
  required String id,
  required String puzzleName,
  required String puzzleCategory,
  required DateTime deadline,
  required DateTime startingTime,
  required int taskNum,
  required int gems,
  required int completedTasks,
  Value<String?> rewardImagePath,
  Value<int> rowid,
});
typedef $$PuzzlesTableUpdateCompanionBuilder = PuzzlesCompanion Function({
  Value<String> id,
  Value<String> puzzleName,
  Value<String> puzzleCategory,
  Value<DateTime> deadline,
  Value<DateTime> startingTime,
  Value<int> taskNum,
  Value<int> gems,
  Value<int> completedTasks,
  Value<String?> rewardImagePath,
  Value<int> rowid,
});

class $$PuzzlesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PuzzlesTable,
    Puzzle,
    $$PuzzlesTableFilterComposer,
    $$PuzzlesTableOrderingComposer,
    $$PuzzlesTableProcessedTableManager,
    $$PuzzlesTableInsertCompanionBuilder,
    $$PuzzlesTableUpdateCompanionBuilder> {
  $$PuzzlesTableTableManager(_$AppDatabase db, $PuzzlesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PuzzlesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PuzzlesTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$PuzzlesTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            Value<String> puzzleName = const Value.absent(),
            Value<String> puzzleCategory = const Value.absent(),
            Value<DateTime> deadline = const Value.absent(),
            Value<DateTime> startingTime = const Value.absent(),
            Value<int> taskNum = const Value.absent(),
            Value<int> gems = const Value.absent(),
            Value<int> completedTasks = const Value.absent(),
            Value<String?> rewardImagePath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PuzzlesCompanion(
            id: id,
            puzzleName: puzzleName,
            puzzleCategory: puzzleCategory,
            deadline: deadline,
            startingTime: startingTime,
            taskNum: taskNum,
            gems: gems,
            completedTasks: completedTasks,
            rewardImagePath: rewardImagePath,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String id,
            required String puzzleName,
            required String puzzleCategory,
            required DateTime deadline,
            required DateTime startingTime,
            required int taskNum,
            required int gems,
            required int completedTasks,
            Value<String?> rewardImagePath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PuzzlesCompanion.insert(
            id: id,
            puzzleName: puzzleName,
            puzzleCategory: puzzleCategory,
            deadline: deadline,
            startingTime: startingTime,
            taskNum: taskNum,
            gems: gems,
            completedTasks: completedTasks,
            rewardImagePath: rewardImagePath,
            rowid: rowid,
          ),
        ));
}

class $$PuzzlesTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $PuzzlesTable,
    Puzzle,
    $$PuzzlesTableFilterComposer,
    $$PuzzlesTableOrderingComposer,
    $$PuzzlesTableProcessedTableManager,
    $$PuzzlesTableInsertCompanionBuilder,
    $$PuzzlesTableUpdateCompanionBuilder> {
  $$PuzzlesTableProcessedTableManager(super.$state);
}

class $$PuzzlesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PuzzlesTable> {
  $$PuzzlesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get puzzleName => $state.composableBuilder(
      column: $state.table.puzzleName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get puzzleCategory => $state.composableBuilder(
      column: $state.table.puzzleCategory,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get deadline => $state.composableBuilder(
      column: $state.table.deadline,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get startingTime => $state.composableBuilder(
      column: $state.table.startingTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get taskNum => $state.composableBuilder(
      column: $state.table.taskNum,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get gems => $state.composableBuilder(
      column: $state.table.gems,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get completedTasks => $state.composableBuilder(
      column: $state.table.completedTasks,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get rewardImagePath => $state.composableBuilder(
      column: $state.table.rewardImagePath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter taskListRefs(
      ComposableFilter Function($$TaskListTableFilterComposer f) f) {
    final $$TaskListTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.taskList,
        getReferencedColumn: (t) => t.puzzleId,
        builder: (joinBuilder, parentComposers) =>
            $$TaskListTableFilterComposer(ComposerState(
                $state.db, $state.db.taskList, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$PuzzlesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PuzzlesTable> {
  $$PuzzlesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get puzzleName => $state.composableBuilder(
      column: $state.table.puzzleName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get puzzleCategory => $state.composableBuilder(
      column: $state.table.puzzleCategory,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get deadline => $state.composableBuilder(
      column: $state.table.deadline,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get startingTime => $state.composableBuilder(
      column: $state.table.startingTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get taskNum => $state.composableBuilder(
      column: $state.table.taskNum,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get gems => $state.composableBuilder(
      column: $state.table.gems,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get completedTasks => $state.composableBuilder(
      column: $state.table.completedTasks,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get rewardImagePath => $state.composableBuilder(
      column: $state.table.rewardImagePath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TaskListTableInsertCompanionBuilder = TaskListCompanion Function({
  required String id,
  required String puzzleId,
  Value<int?> index,
  Value<String?> textField,
  Value<bool> isChecked,
  Value<int> rowid,
});
typedef $$TaskListTableUpdateCompanionBuilder = TaskListCompanion Function({
  Value<String> id,
  Value<String> puzzleId,
  Value<int?> index,
  Value<String?> textField,
  Value<bool> isChecked,
  Value<int> rowid,
});

class $$TaskListTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskListTable,
    TaskListData,
    $$TaskListTableFilterComposer,
    $$TaskListTableOrderingComposer,
    $$TaskListTableProcessedTableManager,
    $$TaskListTableInsertCompanionBuilder,
    $$TaskListTableUpdateCompanionBuilder> {
  $$TaskListTableTableManager(_$AppDatabase db, $TaskListTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TaskListTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TaskListTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$TaskListTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> id = const Value.absent(),
            Value<String> puzzleId = const Value.absent(),
            Value<int?> index = const Value.absent(),
            Value<String?> textField = const Value.absent(),
            Value<bool> isChecked = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskListCompanion(
            id: id,
            puzzleId: puzzleId,
            index: index,
            textField: textField,
            isChecked: isChecked,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String id,
            required String puzzleId,
            Value<int?> index = const Value.absent(),
            Value<String?> textField = const Value.absent(),
            Value<bool> isChecked = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskListCompanion.insert(
            id: id,
            puzzleId: puzzleId,
            index: index,
            textField: textField,
            isChecked: isChecked,
            rowid: rowid,
          ),
        ));
}

class $$TaskListTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $TaskListTable,
    TaskListData,
    $$TaskListTableFilterComposer,
    $$TaskListTableOrderingComposer,
    $$TaskListTableProcessedTableManager,
    $$TaskListTableInsertCompanionBuilder,
    $$TaskListTableUpdateCompanionBuilder> {
  $$TaskListTableProcessedTableManager(super.$state);
}

class $$TaskListTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TaskListTable> {
  $$TaskListTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get index => $state.composableBuilder(
      column: $state.table.index,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get textField => $state.composableBuilder(
      column: $state.table.textField,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isChecked => $state.composableBuilder(
      column: $state.table.isChecked,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$PuzzlesTableFilterComposer get puzzleId {
    final $$PuzzlesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.puzzleId,
        referencedTable: $state.db.puzzles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$PuzzlesTableFilterComposer(
            ComposerState(
                $state.db, $state.db.puzzles, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$TaskListTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TaskListTable> {
  $$TaskListTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get index => $state.composableBuilder(
      column: $state.table.index,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get textField => $state.composableBuilder(
      column: $state.table.textField,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isChecked => $state.composableBuilder(
      column: $state.table.isChecked,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$PuzzlesTableOrderingComposer get puzzleId {
    final $$PuzzlesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.puzzleId,
        referencedTable: $state.db.puzzles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$PuzzlesTableOrderingComposer(ComposerState(
                $state.db, $state.db.puzzles, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$CategoriesTableInsertCompanionBuilder = CategoriesCompanion Function({
  required String name,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> name,
  Value<int> rowid,
});

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableProcessedTableManager,
    $$CategoriesTableInsertCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CategoriesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CategoriesTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$CategoriesTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            name: name,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required String name,
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            name: name,
            rowid: rowid,
          ),
        ));
}

class $$CategoriesTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableProcessedTableManager,
    $$CategoriesTableInsertCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder> {
  $$CategoriesTableProcessedTableManager(super.$state);
}

class $$CategoriesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer(super.$state);
  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CategoriesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$PuzzlesTableTableManager get puzzles =>
      $$PuzzlesTableTableManager(_db, _db.puzzles);
  $$TaskListTableTableManager get taskList =>
      $$TaskListTableTableManager(_db, _db.taskList);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
}
