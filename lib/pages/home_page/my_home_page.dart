// my_home_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../image_picker/image_picker_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:procrastination_puzzle_pie/providers.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:math';

import 'puzzle.dart';
import '../puzzle_page/puzzle_page.dart';
import '../../database/database.dart' as db;

class MyHomePage extends ConsumerStatefulWidget {
  final ThemeMode themeMode;

  const MyHomePage({Key? key, required this.title, required this.themeMode}) : super(key: key);

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> with WidgetsBindingObserver {
  String currentPuzzleId = '';
  String selectedCategory = 'All';
  List<String> categories = [''];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final rewardImagePath = ValueNotifier<String>('assets/rewards/default_reward.png');
  final rewardImageName = ValueNotifier<String>('');

  Future<bool> requestStoragePermission(BuildContext context) async {
  if (kIsWeb) {
    return true;
  }
  var status = await Permission.storage.status;
  if (status.isGranted) {
    return true;
  } else if (status.isPermanentlyDenied) {
    // Show a dialog or a custom UI to guide the user to the app settings
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Storage Permission'),
        content: Text('This app requires storage access to function properly. Please enable storage access in the app settings.'),
        actions: <Widget>[
          TextButton(
            child: Text('Open Settings'),
            onPressed: () {
              openAppSettings(); // Open app settings
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      ),
    );
    return false;
  } else {
    status = await Permission.storage.request();
    return status.isGranted;
  }
}

  Future getImage() async {
    bool hasPermission = await requestStoragePermission(context);
    if (!hasPermission) {
      return;
    }
    try {
      final pickedFile = await ImagePickerHelper.pickImage();
      if (pickedFile != null) {
        final fileName = pickedFile.fileName;
        String mimeType = 'image/jpg';
        if (fileName != null) {
          if (fileName.endsWith('.png')) {
            mimeType = 'image/png';
          } else if (fileName.endsWith('.jpeg')) {
            mimeType = 'image/jpeg';
          } else if (fileName.endsWith('.webp')) {
            mimeType = 'image/jpeg';
          } else if (fileName.endsWith('.gif')) {
            mimeType = 'image/gif';
          } else {
            mimeType = 'image/jpg';
          }
        }
        if (kIsWeb) {
          // Web Platforms
          String base64Data = base64Encode(pickedFile.data!);
          String dataUrl = 'data:$mimeType;base64,$base64Data';
          rewardImagePath.value = dataUrl;
          rewardImageName.value = fileName!;
        } else {
          // Mobile Platforms
          rewardImagePath.value = pickedFile.path!;
          rewardImageName.value = fileName!;
        } 
      } else {
        rewardImagePath.value = 'assets/rewards/default_reward.png';
      }
    } catch (e) {
      print('Error: Failed to pick image: $e');
      rewardImagePath.value = 'assets/rewards/default_reward.png';
    }
  }

  void _addNewPuzzle(String puzzleName, String puzzleCategory, int taskNum, int gems, String rewardImagePath) {
    setState(() {
      DateTime deadline = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      
      String id = Uuid().v4();
      currentPuzzleId = id;
      DateTime startingTime = DateTime.now();

      int completedTasks = ref.read(completedTasksProvider(id));
      
      Puzzle newPuzzle = Puzzle(
        id: id,
        puzzleName: puzzleName,
        puzzleCategory: puzzleCategory,
        deadline: deadline,
        startingTime: startingTime,
        taskNum: taskNum,
        gems: gems,
        completedTasks: completedTasks,
        rewardImagePath: rewardImagePath,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PuzzlePage(id: id, puzzleName: puzzleName, puzzleCategory: puzzleCategory, deadline: deadline, startingTime: startingTime, taskNum: taskNum, gems: gems, rewardImagePath: rewardImagePath, deletePuzzle: deletePuzzle),
            ),
          ).then((_) {
            refreshPuzzles();
            refreshGems();
          });
        },
      );
      db.Puzzle newPuzzleModel = db.Puzzle(
        id: id,
        puzzleName: puzzleName,
        puzzleCategory: puzzleCategory,
        deadline: deadline,
        startingTime: startingTime,
        taskNum: taskNum,
        gems: gems,
        completedTasks: completedTasks,
        rewardImagePath: rewardImagePath,
      );
      ref.read(db.databaseProvider).addPuzzle(newPuzzleModel).then((_) {
        ref.invalidate(db.puzzlesDataProvider);
      });

      if (newPuzzle.deadline.isBefore(DateTime.now())) {
        ref.read(expiredPuzzlesProvider.notifier).update((state) {
        state.add(newPuzzleModel);
        state.sort((a, b) => a.deadline.compareTo(b.deadline));
        return state;
      });
    } else {
      ref.read(activePuzzlesProvider.notifier).update((state) {
        state.add(newPuzzleModel);
        state.sort((a, b) => a.deadline.compareTo(b.deadline));
        return state;
      });
    }
  });
}

void deletePuzzle(String id) {
  if (!mounted) return;
  ref.read(db.databaseProvider).deletePuzzle(id).then((_) {
    ref.invalidate(db.puzzlesDataProvider);
  });
}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshPuzzles();
      refreshGems();
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshPuzzles();
      refreshGems();
    }
  }

 void refreshPuzzles() {
  if (!mounted) return;
  final puzzlesAsyncValue = ref.read(db.puzzlesDataProvider);
  puzzlesAsyncValue.when(
    data: (allPuzzles) {
      List<db.Puzzle> filteredPuzzles = allPuzzles;
      if (selectedCategory != 'All') {
        filteredPuzzles = allPuzzles.where((puzzle) => puzzle.puzzleCategory == selectedCategory).toList();
      }
      final activePuzzles = filteredPuzzles.where((puzzle) => !puzzle.deadline.isBefore(DateTime.now())).toList()
        ..sort((a, b) => a.deadline.compareTo(b.deadline));
      final expiredPuzzles = filteredPuzzles.where((puzzle) => puzzle.deadline.isBefore(DateTime.now())).toList()
        ..sort((a, b) => a.deadline.compareTo(b.deadline));
      
      ref.read(activePuzzlesProvider.notifier).state = activePuzzles;
      ref.read(expiredPuzzlesProvider.notifier).state = expiredPuzzles;
    },
    loading: () {},
    error: (error, stack) {},
  );
}

  void refreshGems() {
    final puzzlesAsyncValue = ref.watch(db.puzzlesDataProvider);
    puzzlesAsyncValue.when(
      data: (allPuzzles) {
        allPuzzles.forEach((puzzle) async {
          final currentTime = DateTime.now();
          if (puzzle.deadline.isBefore(currentTime) && puzzle.taskNum != puzzle.completedTasks) {
            await ref.read(db.databaseProvider).updatePuzzleGems(puzzle.id, 0).then((_) {
              if (mounted) {
                ref.invalidate(db.puzzlesDataProvider);
              }
            });
          }
          final remainingMilliseconds = puzzle.deadline.difference(currentTime).inMilliseconds;
          final totalDuration = puzzle.deadline.difference(puzzle.startingTime).inMilliseconds;
          final interval = totalDuration ~/ 7;
          final elapsedIntervals = (totalDuration - remainingMilliseconds) ~/ interval;
          final newGems = max(0, 7 - elapsedIntervals);
          if (puzzle.gems != newGems && puzzle.taskNum != puzzle.completedTasks) {
            if (newGems > 0 && newGems < 7) {
            await ref.read(db.databaseProvider).updatePuzzleGems(puzzle.id, newGems).then((_) { 
              if (mounted) {
                ref.invalidate(db.puzzlesDataProvider);
              }
            });
            }
          }
        });
      },
      loading: () {},
      error: (error, stack) {},
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    String puzzleName = '';
    String puzzleCategory = categories.isNotEmpty ? categories.first : '';
    bool addNewCategory = false;
    int taskNum = 1;
    int gems = 7;
    final TextEditingController newCategoryController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController timeController = TextEditingController();
    
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    dateController.text = DateFormat.yMd().format(DateTime.now());
    timeController.text = DateFormat('h:mm a').format(DateTime.now());

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final categoriesAsyncValue = ref.watch(db.puzzleCategoriesDataProvider);
            return AlertDialog(
              title: Text('Create Puzzle'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextFormField(
                      onChanged: (value) {
                        puzzleName = value;
                      },
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
                            initialValue: selectedDate,
                            onChanged: (DateTime? date) {
                              if (date != null) {
                                selectedDate = date;
                                dateController.text = DateFormat.yMd().format(selectedDate);
                              } else {
                                selectedDate = DateTime.now();
                                dateController.text = DateFormat.yMd().format(selectedDate);
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
                            initialValue: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, selectedTime.hour, selectedTime.minute),
                            onChanged: (DateTime? time) {
                              if (time != null) {
                                selectedTime = TimeOfDay.fromDateTime(time);
                                timeController.text = selectedTime.format(context);
                              } else {
                                selectedTime = TimeOfDay.now();
                                timeController.text = selectedTime.format(context);
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
                          child: Slider(
                            value: taskNum.toDouble(),
                            min: 1,
                            max: 8,
                            divisions: 7,
                            label: '$taskNum',
                            onChanged: (double value) {
                              setState(() {
                                taskNum = value.toInt();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Reward Image:'),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: getImage,
                          child: Text('Upload Image'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ValueListenableBuilder<String>(
                      valueListenable: rewardImageName,
                      builder: (context, value, child) {
                        return Text(value);
                        },
                      ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    rewardImagePath.value = 'assets/rewards/default_reward.png';
                    rewardImageName.value = '';
                  },
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    if (addNewCategory && newCategoryController.text.isNotEmpty) {
                      ref.read(db.databaseProvider).addCategory(newCategoryController.text).then((_) {
                        ref.invalidate(db.puzzleCategoriesDataProvider);
                      });
                      puzzleCategory = newCategoryController.text;
                    }
                    _addNewPuzzle(puzzleName, puzzleCategory, taskNum, gems, rewardImagePath.value);
                    rewardImagePath.value = 'assets/rewards/default_reward.png';
                    rewardImageName.value = '';
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<db.Puzzle>>>(db.puzzlesDataProvider, (_, __) {
      refreshPuzzles();
    });
    final categoriesAsyncValue = ref.watch(db.puzzleCategoriesDataProvider);
    
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        title: Row(
          children: <Widget> [
            Image.asset(
              'assets/containers/todopuzzles.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            Text(
              ' : ',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return categoriesAsyncValue.when(
                    data: (categoriesData) {
                      return DropdownButtonFormField<String>(
                        dropdownColor: Color.fromARGB(255, 30, 30, 30),
                        value: selectedCategory.isEmpty ? 'All' : selectedCategory,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.white),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                          refreshPuzzles();
                        },
                        items: ['All', ...(categoriesData.where((category) => category != 'All').toSet())].map<DropdownMenuItem<String>>((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Container(
                              width: constraints.maxWidth * 0.8,
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                    loading: () => CircularProgressIndicator(),
                    error: (err, stack) => Text('Error: $err'),
                  );
                }
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
            PopupMenuItem(
              value: 'Option 1',
              child: Text('Create Puzzle'),
            ),
            PopupMenuItem(
              value: 'Option 2',
              child: Text('Manage Categories'),
            ),
            PopupMenuItem(
              value: 'Option 3',
              child: Text('Settings'),
            ),
            PopupMenuItem(
              value: 'Option 4',
              child: Text('Help'),
            )
            // Add more options here
          ],
          onSelected: (value) {
            switch (value) {
              case 'Option 1':
                _showConfirmationDialog(context);
                break;
              case 'Option 2':
                setState(() {
                  selectedCategory = 'All';
                });
                Navigator.pushNamed(context, '/categories');
                break;
              case 'Option 3':
                Navigator.pushNamed(context, '/settings');
                break;
              case 'Option 4':
                Navigator.pushNamed(context, '/help');
                break;
            }
          },
        ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Consumer(builder: (context, ref, child) {
            final puzzlesAsyncValue = ref.watch(db.puzzlesDataProvider);
            return puzzlesAsyncValue.when(
              loading: () => CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
              data: (puzzles) {
                final expiredPuzzles = ref.watch(expiredPuzzlesProvider);
                final activePuzzles = ref.watch(activePuzzlesProvider);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    if (expiredPuzzles.isNotEmpty) ...[
                      Text(
                        "Expired Puzzles",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: expiredPuzzles.length,
                        itemBuilder: (context, index) {
                          final puzzle = expiredPuzzles[index];
                          return Puzzle(
                            id: puzzle.id,
                            puzzleName: puzzle.puzzleName,
                            puzzleCategory: puzzle.puzzleCategory,
                            deadline: puzzle.deadline,
                            startingTime: puzzle.startingTime,
                            taskNum: puzzle.taskNum,
                            gems: puzzle.gems,
                            completedTasks: puzzle.completedTasks,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PuzzlePage(
                                    id: puzzle.id,
                                    puzzleName: puzzle.puzzleName,
                                    puzzleCategory: puzzle.puzzleCategory,
                                    deadline: puzzle.deadline,
                                    startingTime: puzzle.startingTime,
                                    taskNum: puzzle.taskNum,
                                    gems: puzzle.gems,
                                    rewardImagePath: puzzle.rewardImagePath,
                                    deletePuzzle: deletePuzzle,
                                  ),
                                ),
                              ).then((_) => refreshPuzzles());
                            },
                            rewardImagePath: puzzle.rewardImagePath ?? 'assets/rewards/default_reward.png',
                          );
                        },
                      ),
                    ],
                    if (activePuzzles.isNotEmpty) ...[
                      Text(
                        "Active Puzzles",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: activePuzzles.length,
                        itemBuilder: (context, index) {
                          final puzzle = activePuzzles[index];
                          return Puzzle(
                            id: puzzle.id,
                            puzzleName: puzzle.puzzleName,
                            puzzleCategory: puzzle.puzzleCategory,
                            deadline: puzzle.deadline,
                            startingTime: puzzle.startingTime,
                            taskNum: puzzle.taskNum,
                            gems: puzzle.gems,
                            completedTasks: puzzle.completedTasks,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PuzzlePage(
                                    id: puzzle.id,
                                    puzzleName: puzzle.puzzleName,
                                    puzzleCategory: puzzle.puzzleCategory,
                                    deadline: puzzle.deadline,
                                    startingTime: puzzle.startingTime,
                                    taskNum: puzzle.taskNum,
                                    gems: puzzle.gems,
                                    rewardImagePath: puzzle.rewardImagePath,
                                    deletePuzzle: deletePuzzle,
                                  ),
                                ),
                              ).then((_) => refreshPuzzles());
                            },
                            rewardImagePath: puzzle.rewardImagePath ?? 'assets/rewards/default_reward.png',
                          );
                        },
                      ),
                    ],
                    if (activePuzzles.isEmpty && expiredPuzzles.isEmpty) ...[
                      Text(
                        "You don't seem to have anything that needs to be done.",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          fontSize: kIsWeb ? 16 : 12,
                        ),
                      ),
                      Text(
                        "Do you want to start a new puzzle?",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          fontSize: kIsWeb ? 16 : 12,
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () => _showConfirmationDialog(context),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 30, 30, 30)),
                          foregroundColor: WidgetStateProperty.all(Colors.white),
                          padding: WidgetStateProperty.all(EdgeInsets.all(30)),
                        ),
                        child: Text(
                          'Create Puzzle',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }),
        ),
      ),
    );
  }
}