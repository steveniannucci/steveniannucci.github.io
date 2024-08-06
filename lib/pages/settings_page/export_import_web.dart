// export_import_web.dart
// The import feature works fine with web platforms but needs some adjustments to work on mobile platforms.

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../database/database.dart';

Future<void> exportData(AppDatabase database, BuildContext context) async {
  if (kIsWeb) {
    // Fetch data from the database
    final puzzles = await database.select(database.puzzles).get();
    final taskList = await database.select(database.taskList).get();
    final categories = await database.select(database.categories).get();
    final data = {
      'puzzles': puzzles.map((puzzle) => puzzle.toJson()).toList(),
      'taskList': taskList.map((taskList) => taskList.toJson()).toList(),
      'categories': categories.map((category) => category.toJson()).toList(),
    };
    final bytes = utf8.encode(jsonEncode(data));
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'puzzleData.json')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}

Future<Map<String, dynamic>> importData() async {
  final completer = Completer<Map<String, dynamic>>();
  final uploadInput = html.FileUploadInputElement();
  uploadInput.accept = '.json';
  uploadInput.click();
  uploadInput.onChange.listen((event) async {
    final file = uploadInput.files!.first;
    if (!file.name.endsWith('.json')) {
      completer.complete({});
      return;
    }
    final reader = html.FileReader();
    reader.readAsText(file);
    reader.onLoadEnd.listen((event) {
      try {
        final data = jsonDecode(reader.result as String);
        if (data == null ||
            data['puzzles'] == null || !(data['puzzles'] is List) ||
            data['taskList'] == null || !(data['taskList'] is List) ||
            data['categories'] == null || !(data['categories'] is List)) {
          print('Error: Imported data is null or incomplete');
          completer.complete({});
        } else {
          print('Data imported successfully.');
          completer.complete(data);
        }
      } catch (e) {
        print('Error reading file: $e');
        completer.complete({});
      }
    });
  });
  return completer.future;
}