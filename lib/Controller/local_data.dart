import 'dart:developer';

import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart' as path;
import 'package:sqflite/sql.dart';
import 'package:task_manager/Model/task_model.dart';

class LocalData {
  static dynamic database;
  static Future<void> startDatabase() async {
    database = sqflite.openDatabase(
      path.join(await sqflite.getDatabasesPath(), "TaskDatabase"),
      version: 1,
      onCreate: (db, version) async {
        db.execute('''
          CREATE TABLE TaskTable(
              task_id TEXT PRIMARY KEY,
              task_title TEXT,
              is_completed INT,
              task_description TEXT,
              task_date TEXT
          )
        ''');
      },
    );
  }

  static Future<bool> insertData(TaskModel obj) async {
    bool inserted = false;
    try {
      final sqflite.Database localDb = await database;
      int ans = await localDb.insert("TaskTable", obj.taskMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      log("Inserting Data return value : $ans");
      inserted = true;
    } catch (e) {
      log("Error Occured While Inserted : ${e.toString()}");
      inserted = false;
    }
    return inserted;
  }

  static Future<List<TaskModel>> getTasks() async {
    List<TaskModel> modelList = [];
    try {
      final sqflite.Database localDb = await database;
      List<Map<String, dynamic>> taskList = await localDb.query("TaskTable");
      log("${taskList.length}");
      for (int i = 0; i < taskList.length; i++) {
        TaskModel obj = TaskModel(
            taskName: await taskList[i]['task_title'],
            taskId: await taskList[i]['task_id'],
            isDone: await taskList[i]['is_completed'],
            date: await taskList[i]['task_date'],
            taskDescription: await taskList[i]['task_description']);
        modelList.add(obj);
      }
    } catch (e) {
      log(e.toString());
    }
    return modelList;
  }

  static Future<bool> updateTask(TaskModel obj) async {
    bool updated = false;
    try {
      final sqflite.Database localDb = await database;
      int ans = await localDb.update("TaskTable", obj.taskMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      log("Updated Data return value : $ans");
      updated = true;
    } catch (e) {
      log("Error Occured While Updating : ${e.toString()}");
      updated = false;
    }
    return updated;
  }

  static Future<bool> deleteTask(TaskModel obj) async {
    bool deleted = false;
    try {
      final sqflite.Database localDb = await database;
      int ans = await localDb
          .delete("TaskTable", where: "task_id = ?", whereArgs: [obj.taskId]);
      log("Deleted Data return value : $ans");
      deleted = true;
    } catch (e) {
      log("Error Occured While Deleting : ${e.toString()}");
      deleted = false;
    }
    return deleted;
  }

  static Future<bool> finishTask(TaskModel obj) async {
    bool updated = false;
    try {
      final sqflite.Database localDb = await database;
      int ans = await localDb.update("TaskTable", {"is_completed": obj.isDone},
          where: "task_id = ?",
          whereArgs: [obj.taskId],
          conflictAlgorithm: ConflictAlgorithm.replace);
      log("Updated Data return value : $ans");
      updated = true;
    } catch (e) {
      log("Error Occured While Updating : ${e.toString()}");
      updated = false;
    }
    return updated;
  }
}
