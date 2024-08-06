// settings_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'export_import_stub.dart';
import '../../database/database.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final ValueChanged<bool> onSaveNotificationPreference;
  final ValueChanged<bool> onThemeChanged;

  SettingsPage({required this.onSaveNotificationPreference, required this.onThemeChanged});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class _SettingsPageState extends ConsumerState<SettingsPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _darkMode = false;
  bool _notifications = false;
  late AppDatabase database;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _loadPreferences();
  }

  Future<void> showPuzzleExpiredNotification() async {
  if (!_notifications) {
    return;
  }
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      importance: Importance.max, priority: Priority.high, showWhen: false);
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'Puzzle Expired', 'puzzleName has expired.', platformChannelSpecifics,
      payload: 'item x');
  }

  Future<void> showPuzzleExpiryReminderRepeatedNotification() async {
  if (!_notifications) {
    return;
  }
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      importance: Importance.max, priority: Priority.high, showWhen: false);
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      1, 'Reminder', 'puzzleName will expire today at deadline', platformChannelSpecifics,
      payload: 'item x');
  }


  Future<void> _loadPreferences() async {
    try {
      final SharedPreferences prefs = await _prefs;
      setState(() {
        _notifications = (prefs.getBool('notifications') ?? false);
        _darkMode = (prefs.getBool('darkMode') ?? false);
      });
    } catch (e) {
      print("Error loading preferences: $e");
    }
  }

  Future<void> _savePreferences(String key, bool value) async {
    SharedPreferences prefs = await _prefs;
    prefs.setBool(key, value);
  }

  Future<void> _importData() async {
    try {
      final data = await importData();
      if (data.isEmpty || data['puzzles'] == null || data['taskList'] == null || data['categories'] == null) {
        print("Error: Imported data is null or incomplete");
        return;
      }
      final database = ref.read(databaseProvider);
      bool shouldOverwrite = await _showOverwriteDialog();

      if (shouldOverwrite) {
        await database.transaction(() async {
          await database.delete(database.puzzles).go();
          await database.delete(database.taskList).go();
          await database.delete(database.categories).go();

          for (var puzzleJson in data['puzzles']) {
            final puzzle = Puzzle.fromJson(puzzleJson);
            await database.into(database.puzzles).insert(puzzle);
          }
          for (var taskListJson in data['taskList']) {
            final task = TaskListData.fromJson(taskListJson);
            await database.into(database.taskList).insert(task);
          }
          for (var categoryJson in data['categories']) {
            final category = Category.fromJson(categoryJson);
            await database.into(database.categories).insert(category);
          }
        });
        ref.invalidate(databaseProvider);
        ref.invalidate(puzzlesDataProvider);
        ref.invalidate(tasksDataProvider);
        ref.invalidate(puzzleCategoriesDataProvider);
      }
    } catch (e) {
      print("Error importing data: $e");
    }
  }

  Future<bool> _showOverwriteDialog() async {
    return (await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Overwrite Data'),
        content: Text('Do you want to overwrite the existing data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
              await _showSuccessfulOverwriteDialog();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  Future<void> _showSuccessfulOverwriteDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Data Imported'),
        content: Text('The puzzle data has been updated successfully.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
          )
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          if (!kIsWeb)
          FutureBuilder(
            future: _prefs,
            builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SwitchListTile(
                  title: Text('Push Notifications'),
                  value: _notifications,
                  onChanged: (bool value) {
                    setState(() {
                      _notifications = value;
                    });
                    if (value && kIsWeb) {
                      //js.context.callMethod('requestNotificationPermission');
                    }
                    widget.onSaveNotificationPreference(value);
                    _savePreferences('notifications', value);
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          FutureBuilder(
            future: _prefs,
            builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SwitchListTile(
                  title: Text('Dark Mode'),
                  value: _darkMode,
                  onChanged: (bool value) {
                    setState(() {
                      _darkMode = value;
                    });
                    widget.onThemeChanged(value);
                    _savePreferences('darkMode', value);
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final database = ref.watch(databaseProvider);
              return ListTile(
                onTap: () => exportData(database, context),
                title: Text('Export Data'),
              );
            },
          ),
          ListTile(
            title: Text('Import Data'),
            onTap: _importData,
          ),
        ],
      ),
    );
  }
}