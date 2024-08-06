// my_app.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/home_page/my_home_page.dart';
import 'pages/categories_page/categories_page.dart';
import 'pages/settings_page/settings.dart';
import 'pages/help_page/help_page.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _notifications = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadNotificationPreference();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('darkMode') ?? false;
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notificationsEnabled = prefs.getBool('notifications') ?? false;
    setState(() {
      _notifications = notificationsEnabled;
    });
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', isDarkMode);
  }

  Future<void> _saveNotificationPreference(bool notificationsEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications', notificationsEnabled);
  }

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      _saveThemePreference(isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do Puzzles',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.light(primary: Colors.green),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.dark(primary: Colors.green),
      ),
      themeMode: _themeMode,
      home: MyHomePage(title: 'Home Page', themeMode: _themeMode),
      routes: {
        '/categories': (context) => CategoriesPage(),
        '/settings': (context) => SettingsPage(
          onSaveNotificationPreference: _saveNotificationPreference,
          onThemeChanged: _toggleTheme,
          ),
        '/help': (context) => HelpPage(),
      },
    );
  }
}