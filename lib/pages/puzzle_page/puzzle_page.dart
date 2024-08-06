// puzzle_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

import '../../providers.dart';
import 'puzzle_image.dart';
import '../../database/database.dart';

bool notificationShown = false;

class PuzzlePage extends ConsumerStatefulWidget {
  final String id;
  final String puzzleName;
  final String puzzleCategory;
  final DateTime deadline;
  final DateTime startingTime;
  final int taskNum;
  final int gems;
  final String? rewardImagePath;
  final Function(String) deletePuzzle;

  PuzzlePage({Key? key, required this.id, required this.puzzleName, required this.puzzleCategory, required this.deadline, required this.startingTime, required this.taskNum, required this.gems, required this.rewardImagePath, required this.deletePuzzle}) : super(key: key);
  
  @override
  ConsumerState<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends ConsumerState<PuzzlePage> {
  List<ValueNotifier<bool>> taskStatus = [];
  List<String> tasks = [];
  List<TextEditingController> controllers = [];
  String puzzleName = '';
  String puzzleCategory = '';
  String rewardImagePath = 'assets/rewards/default_reward.png';
  DateTime deadline = DateTime.now();
  DateTime startingTime = DateTime.now();
  int taskNum = 0;
  int maxTasks = 8;
  int gems = 7;
  int completedTasks = 0;
  bool isLoading = true;

  void loadPuzzleData() async {
  final puzzleId = widget.id; // Assuming the puzzle ID is passed to the widget
  final puzzle = await ref.read(databaseProvider).getPuzzleById(puzzleId);
  if (puzzle != null) {
    if (!mounted) return;
    // Update your state with the fetched puzzle data
    setState(() {
      puzzleName = puzzle.puzzleName;
      puzzleCategory = puzzle.puzzleCategory;
      deadline = puzzle.deadline;
      startingTime = puzzle.startingTime;
      taskNum = puzzle.taskNum;
      gems = puzzle.gems;
      completedTasks = puzzle.completedTasks;
      rewardImagePath = puzzle.rewardImagePath ?? 'assets/rewards/default_reward.png';
    });
  }
}

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      loadPuzzleData();
      setState(() {
        isLoading = false;
      });
      await initControllers();
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(taskListProvider(widget.id).notifier).initTasks(maxTasks);
  });
}

  Future<void> initControllers() async {
  final tasks = await ref.read(databaseProvider).getTasksByPuzzleId(widget.id);
  controllers = List.generate(
    maxTasks,
    (index) => TextEditingController(text: tasks.length > index ? tasks[index].textField : ''),
  );
  taskStatus = List.generate(
    maxTasks,
    (index) => ValueNotifier<bool>(tasks.length > index ? tasks[index].isChecked : false),
  );
}

  @override
  Widget build(BuildContext context) {
    ref.listen(puzzlesDataProvider, (previous, next) {
      setState(() {
        loadPuzzleData();
      });
    });

    double imageSize = widget.rewardImagePath == 'assets/rewards/default_reward.png' ? 280.0 : 225.0;

      ImageProvider imageProvider;
      if (kIsWeb) {
        if (rewardImagePath.startsWith('assets/')) {
          imageProvider = AssetImage(rewardImagePath);
        } else {
          imageProvider = NetworkImage(rewardImagePath);
        }
      } else {
        if (rewardImagePath.startsWith('assets/')) {
          imageProvider = AssetImage(rewardImagePath);
        } else {
          imageProvider = FileImage(File(rewardImagePath));
        }
      }

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm'),
                    content: Text('Are you sure you want to delete this puzzle?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.deletePuzzle(widget.id);
                          Navigator.pop(context);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
            PopupMenuItem(
              value: 'Option 1',
              child: Text('Edit Puzzle'),
            ),
            // Add more options here
          ],
          onSelected: (value) {
            switch (value) {
              case 'Option 1':
                _showEditDialog(context, widget.id, puzzleName, puzzleCategory, deadline, taskNum);
                break;
              case 'Option 2':
                // Handle option 2
                break;
            }
          },
        ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(20),
                width: 350,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 30, 30, 30),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color.fromARGB(255, 30, 30, 30),
                    width: 1,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref, child) {
                          return RichText(
                            text: TextSpan(
                              text: 'Name: ',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white),
                              children: <TextSpan>[
                                TextSpan(text: puzzleName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white)),
                              ],
                            ),
                          );
                        },
                      ),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref, child) {
                          return RichText(
                            text: TextSpan(
                              text: 'Category: ',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white),
                              children: <TextSpan>[
                                TextSpan(text: puzzleCategory, style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white)),
                              ],
                            ),
                          );
                      },
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      ),
                    width: imageSize,
                    height: imageSize,
                  ),
                  PuzzleImage(
                    taskNum: taskNum,
                    completedTasks: completedTasks,
                  ),
                  Image.asset(
                    'assets/containers/default_frame.png',
                    width: 280,
                    height: 280,
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    'assets/gems/7_$gems.png',
                    width: 280,
                    height: 280,
                    fit: BoxFit.cover,
                  ),
                  ],
              ),
              CountdownTimer(
                endTime: deadline.millisecondsSinceEpoch,
                widgetBuilder: (_, time) {
                  if (time == null && taskNum != completedTasks) {
                    Future.delayed(Duration.zero, () {
                    if (mounted) {
                        gems = 0;
                        ref.read(databaseProvider).updatePuzzleGems(widget.id, gems).then((_) {
                          if (mounted) {
                            ref.invalidate(puzzlesDataProvider);
                          }
                        });
                      }
                    });
                  }
                  if(time == null && taskNum == completedTasks) {
                    Future.delayed(Duration.zero, () {
                      if (mounted) {
                        setState(() {});
                      }
                    });
                  }
                  if (taskNum == completedTasks) {
                    return Text('Completed', style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold));
                  }
                  if (time == null) {
                    return Text('Expired', style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold));
                  } else {
                    final currentTime = DateTime.now();
                    final remainingMilliseconds = deadline.difference(currentTime).inMilliseconds;
                    final totalDuration = deadline.difference(startingTime).inMilliseconds;
                    final interval = totalDuration ~/ 7;
                    final elapsedIntervals = (totalDuration - remainingMilliseconds) ~/ interval;
                    final newGems = 7 - elapsedIntervals;

                    if (gems != newGems && taskNum != completedTasks) {
                      Future.delayed(Duration.zero, () {
                        ref.read(databaseProvider).updatePuzzleGems(widget.id, newGems).then((_) {
                          if (mounted) {
                            ref.invalidate(puzzlesDataProvider);
                          }
                        });
                      });
                    }
                  }
                  return RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 20, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                      children: <TextSpan>[
                        TextSpan(text: 'Time Left: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '${time.days != null && time.days! > 0 ? "${time.days}d " : ""}'
                          '${time.hours != null && time.hours! > 0 ? "${time.hours}h " : ""}'
                          '${time.min != null && time.min! > 0 ? "${time.min}m " : ""}'
                          '${time.sec != null && time.sec! > 0 ? "${time.sec}s" : ""}'),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              if (!deadline.isBefore(DateTime.now()))
              SingleChildScrollView(
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Task List',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Column(
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                final tasksAsyncValue = ref.watch(tasksDataProvider(widget.id));
                                return tasksAsyncValue.when(
                                  data: (tasks) {
                                    return Column(
                                      children: List.generate(taskNum, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Checkbox(
                                                activeColor: Colors.green,
                                                checkColor: Colors.white,
                                                value: tasks[index].isChecked,
                                                onChanged: (bool? newValue) async {
                                                  if (newValue != null) {
                                                    await ref.read(databaseProvider).updateTaskCheckedState(widget.id, index, newValue).then((_) {
                                                      ref.invalidate(tasksDataProvider(widget.id));
                                                    });
                                                    if (newValue == true) {
                                                      completedTasks++;
                                                    } else {
                                                      completedTasks--;
                                                    }
                                                    final database = ref.read(databaseProvider);
                                                    await database.updatePuzzleCompletedTasks(widget.id, completedTasks).then((_) {
                                                      ref.invalidate(puzzlesDataProvider);
                                                    });
                                                  }
                                                },
                                              ),
                                              Expanded(
                                                child: Focus(
                                                  onFocusChange: (hasFocus) {
                                                    if (!hasFocus) {
                                                      ref.read(databaseProvider).updateTaskText(widget.id, index, controllers[index].text).then((_) {
                                                        ref.invalidate(tasksDataProvider(widget.id));
                                                      });
                                                    }
                                                  },
                                                  child: TextField(
                                                    maxLines: null,
                                                    keyboardType: TextInputType.multiline,
                                                    controller: controllers[index],
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Task ${index + 1}',
                                                    ),
                                                    style: TextStyle(
                                                      decoration: tasks[index].isChecked
                                                          ? TextDecoration.lineThrough
                                                          : TextDecoration.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                  loading: () => CircularProgressIndicator(),
                                  error: (err, stack) => Text('Error: $err'),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 30, 30, 30)),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(EdgeInsets.all(30)),
                ),
                child: Text('Back To Puzzles'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
void _showEditDialog(BuildContext context, String id, String puzzleName, String puzzleCategory, DateTime deadline, int taskNum) {
  TextEditingController nameController = TextEditingController(text: puzzleName);
  TextEditingController newCategoryController = TextEditingController();
  TextEditingController dateController = TextEditingController(text: DateFormat.yMd().format(deadline));
  TextEditingController timeController = TextEditingController(text: DateFormat('h:mm a').format(deadline));

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer(
        builder: (BuildContext context, WidgetRef ref, child) {

          nameController.text = puzzleName;
          nameController.selection = TextSelection.fromPosition(TextPosition(offset: nameController.text.length));
          dateController.text = DateFormat.yMd().format(deadline);
          timeController.text = DateFormat('h:mm a').format(deadline);

          bool addNewCategory = false;
          bool isChecked = false;

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              final categoriesAsyncValue = ref.watch(puzzleCategoriesDataProvider);
              return AlertDialog(
                title: Text('Edit Puzzle'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: categoriesAsyncValue.when(
                                data: (categories) {
                                  return DropdownButtonFormField<String>(
                                    value: categories.isNotEmpty ? (categories.contains(puzzleCategory) ? puzzleCategory : categories.first) : null,
                                    onChanged: (String? newValue) {
                                      if (newValue == 'Add New Category') {
                                        setState(() {
                                          addNewCategory = true;
                                        });
                                      } else if (newValue != null) {
                                        setState(() {
                                          puzzleCategory = newValue;
                                          addNewCategory = false;
                                        });
                                      }
                                    },
                                    items: [
                                      ...categories.map<DropdownMenuItem<String>>((String category) {
                                        return DropdownMenuItem<String>(
                                          value: category,
                                          child: Container(
                                            width: 225,
                                            child: Text(
                                              category,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              maxLines: 1,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      DropdownMenuItem<String>(
                                        value: 'Add New Category',
                                        child: Text('+ Add Category'),
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Category',
                                    ),
                                  );
                                },
                                loading: () => CircularProgressIndicator(),
                                error: (err, stack) => Text('Error: $err'),
                              ),
                            ),
                          ],
                        ),
                        if (addNewCategory)
                        TextFormField(
                          controller: newCategoryController,
                          decoration: InputDecoration(
                            labelText: 'New Category',
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderDateTimePicker(
                                name: 'date',
                                inputType: InputType.date,
                                format: DateFormat.yMd(),
                                decoration: InputDecoration(
                                  labelText: 'Deadline Date',
                                ),
                                initialValue: deadline,
                                onChanged: (DateTime? date) {
                                  if (date != null) {
                                    deadline = DateTime(date.year, date.month, date.day, deadline.hour, deadline.minute);
                                    dateController.text = DateFormat.yMd().format(deadline);
                                    
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: FormBuilderDateTimePicker(
                                name: 'time',
                                inputType: InputType.time,
                                format: DateFormat('h:mm a'),
                                decoration: InputDecoration(
                                  labelText: 'Deadline Time',
                                ),
                                initialValue: deadline,
                                onChanged: (DateTime? time) {
                                  if (time != null) {
                                    deadline = DateTime(deadline.year, deadline.month, deadline.day, time.hour, time.minute);
                                    timeController.text = DateFormat.Hm().format(deadline);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text('Number of Pieces: '),
                            SizedBox(width: 10),
                              Expanded(
                                child: Consumer(
                                  builder: (BuildContext context, WidgetRef ref, child) {
                                    return Slider(
                                      value: taskNum.toDouble(),
                                      min: 1,
                                      max: 8,
                                      divisions: 7,
                                      label: '$taskNum',
                                      onChanged: (double value) async {
                                        setState(() {
                                          taskNum = value.toInt();
                                        });
                                        final database = ref.read(databaseProvider);
                                        await database.updatePuzzleCompletedTasks(id, 0).then((_) {
                                          ref.invalidate(puzzlesDataProvider);
                                        });
                                        await database.resetTaskCheckedStates(id).then((_) {
                                          ref.invalidate(tasksDataProvider(id));
                                        });
                                        ref.read(taskNumProvider(id).notifier).updateTaskNum(taskNum);
                                        ref.read(taskStatusProvider(id).notifier).reset();
                                        ref.read(completedTasksProvider(id).notifier).reset();
                                      },
                                    );
                                  }
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('Reset Starting Time:'),
                            SizedBox(width: 10),
                            Checkbox(
                              value: isChecked,
                              activeColor: Colors.green,
                                checkColor: Colors.white,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                        ],
                      ),
                      ],
                    ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, child) {
                      return TextButton(
                        onPressed: () async {
                          final database = ref.read(databaseProvider);
                          // Update puzzleName in database
                          if (nameController.text.isNotEmpty) {
                            await database.updatePuzzleName(id, nameController.text).then((_) {
                              ref.invalidate(puzzlesDataProvider);
                            });
                          }
                          // Update puzzleCategory in database
                          if (addNewCategory && newCategoryController.text.isNotEmpty) {
                            ref.read(databaseProvider).addCategory(newCategoryController.text).then((_) {
                              ref.invalidate(puzzleCategoriesDataProvider);
                            });
                          } else {
                            await database.updatePuzzleCategory(id, puzzleCategory).then((_) {
                              ref.invalidate(puzzlesDataProvider);
                            });
                          }
                          // Update deadline in database
                          await database.updatePuzzleDeadline(id, deadline).then((_) {
                            ref.invalidate(puzzlesDataProvider);
                          });
                          // Update taskNum in database
                          await database.updatePuzzleTaskNum(id, taskNum).then((_) {
                            ref.invalidate(puzzlesDataProvider);
                          });
                          // Update startingTime in database
                          if (isChecked) {
                            await database.updatePuzzleStartingTime(id, DateTime.now()).then((_) {
                              ref.invalidate(puzzlesDataProvider);
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text('Save'),
                      );
                    }
                  ),
                ],
              );
            }
          );
        }
      );
    },
  );
}