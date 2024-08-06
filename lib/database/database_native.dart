// database_native.dart

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'database.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'puzzle_pie.db'));
    return NativeDatabase(file);
  });
}

AppDatabase constructDb() {
  return AppDatabaseSingleton.getInstance(_openConnection());
}