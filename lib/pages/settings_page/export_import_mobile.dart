// export_import_mobile.dart
// The export feature needs some adjustments so that it can also work on mobile platforms.

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import '../../database/database.dart';

Future<String?> convertImageToBase64(String? imagePath) async {
  if (imagePath == null) return null;
  
  // Check if the path is an asset
  if (imagePath.startsWith('assets/')) {
    final bytes = await rootBundle.load(imagePath);
    return base64Encode(bytes.buffer.asUint8List());
  }

  final bytes = await File(imagePath).readAsBytes();
  return base64Encode(bytes);
}

Future<bool> _requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    status = await Permission.storage.request();
  }
  return status.isGranted;
}

Future<void> exportData(AppDatabase database, BuildContext context) async {
  try {
    Directory directory;
    if (Platform.isAndroid) {
      // Request storage permissions
      if (await _requestStoragePermission()) {
        directory = Directory('/storage/emulated/0/Download');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final file = File('${directory.path}/puzzleData.json');

    // Fetch data from the database
    final puzzles = await database.select(database.puzzles).get();
    final taskList = await database.select(database.taskList).get();
    final categories = await database.select(database.categories).get();

    final data = {
      'puzzles': await Future.wait(puzzles.map((puzzle) async {
        return {
          ...puzzle.toJson(),
          'rewardImageBase64': await convertImageToBase64(puzzle.rewardImagePath),
        };
      }).toList()),
      'taskList': taskList.map((task) => task.toJson()).toList(),
      'categories': categories.map((category) => category.toJson()).toList(),
    };

    await file.writeAsString(jsonEncode(data));
    print('Data exported to ${file.path}');

    // Show Snackbar to inform the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data exported successfully to ${file.path}')),
    );
  } catch (e) {
    print('Error exporting data: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to export data: $e')),
    );
  }
}

Future<Map<String, dynamic>> importData() async {
  if (!await _requestStoragePermission()) {
    print('Storage permission denied');
    return {};
  }
  
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final data = jsonDecode(await file.readAsString());

      if (data == null ||
          data['puzzles'] == null || !(data['puzzles'] is List) ||
          data['taskList'] == null || !(data['taskList'] is List) ||
          data['categories'] == null || !(data['categories'] is List)) {
        print('Error: Imported data is null or incomplete');
        return {};
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final puzzles = data['puzzles'] as List;

        for (var puzzle in puzzles) {
          if (puzzle['rewardImageBase64'] != null) {
            puzzle['rewardImagePath'] = await saveBase64Image(
              puzzle['rewardImageBase64'],
              path.join(directory.path, '${puzzle['id']}.png'),
            );
          }
        }
        print('Data imported successfully.');
        return data;
      }
    } else {
      print('File selection canceled.');
      return {};
    }
  } catch (e) {
    print('Error reading file: $e');
    return {};
  }
}

Future<String?> saveBase64Image(String? base64String, String filePath) async {
  if (base64String == null) return null;
  final bytes = base64Decode(base64String);
  final file = File(filePath);
  await file.writeAsBytes(bytes);
  return file.path;
}