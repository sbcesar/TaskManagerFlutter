import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../model/taskDao.dart';
import '../model/taskModel.dart';

part 'taskDatabase.g.dart'; // Generado automáticamente

@Database(version: 1, entities: [Task])
abstract class Taskdatabase extends FloorDatabase {
  TaskDao get taskDao;
}
