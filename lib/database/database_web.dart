// database_web.dart

import 'package:drift/web.dart';
import 'database.dart';

AppDatabase constructDb() {
  return AppDatabaseSingleton.getInstance(WebDatabase('puzzle_pie.db'));
}