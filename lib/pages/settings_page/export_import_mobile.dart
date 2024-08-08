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
  if (Platform.isAndroid && await _isAndroid11OrAbove()) {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }
    return status.isGranted;
  } else {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }
}

Future<bool> _isAndroid11OrAbove() async {
  if (Platform.isAndroid) {
    final version = await _getAndroidVersion();
    return version >= 30; // Android 11 is API level 30
  }
  return false;
}

Future<int> _getAndroidVersion() async {
  final version = await MethodChannel('your_channel_name').invokeMethod<int>('getAndroidVersion');
  return version ?? 0;
}

Future<void> exportData(AppDatabase database, BuildContext context) async {
  try {
    Directory directory;
    if (Platform.isAndroid) {
      // Request storage permissions
      if (await _requestStoragePermission()) {
        directory = Directory('/storage/emulated/0/Puzzles');
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

    String fileName = 'puzzleData.json';
    File file = File('${directory.path}/$fileName');
    int counter = 1;

    // Check if file already exists and generate a new name if necessary
    while (file.existsSync()) {
      fileName = 'puzzleData ($counter).json';
      file = File('${directory.path}/$fileName');
      counter++;
    }

    // Fetch data from the database
    final puzzles = await database.select(database.puzzles).get();
    final taskList = await database.select(database.taskList).get();
    final categories = await database.select(database.categories).get();

    final data = {
      'puzzles': await Future.wait(puzzles.map((puzzle) async {
        return {
          ...puzzle.toJson(),
        };
      }).toList()),
      'taskList': await Future.wait(taskList.map((task) async {
        return {
          ...task.toJson(),
        };
      }).toList()),
      'categories': await Future.wait(categories.map((category) async {
        return {
          ...category.toJson(),
        };
      }).toList()),
    };

    // Write data to the file
    await file.writeAsString(jsonEncode(data));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data exported to ${file.path}')),
    );
  } catch (e) {
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