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
              task_date TEXT,
              notify_time TEXT
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
        String taskName = await taskList[i]['task_title'];
        String date = await taskList[i]['task_date'];
        String description = await taskList[i]['task_description'];
        int isDone = await taskList[i]['is_completed'];
        String taskId = await taskList[i]['task_id'];
        String notifyTimeString = await taskList[i]['notify_time'] ?? "";
        TaskModel obj = TaskModel(
            taskName: taskName,
            taskId: taskId,
            isDone: isDone,
            date: date,
            timeList: convertTextToTimeList(notifyTimeString),
            taskDescription: description);
        modelList.add(obj);
      }
    } catch (e) {
      log("$e");
    }
    return modelList;
  }

  static List<String> convertTextToTimeList(String? timeListString) {
    if (timeListString == null || timeListString.isEmpty) {
      return [];
    }
    return timeListString.split(',').map((e) => e.trim()).toList();
  }

  static Future<bool> updateTask(TaskModel obj) async {
    bool updated = false;
    try {
      log("${obj.taskMap()}");
      final sqflite.Database localDb = await database;
      int ans = await localDb.update("TaskTable", obj.taskMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
          where: "task_id = ?",
          whereArgs: [obj.taskId]);
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

  static Future<bool> finishTask(
      {required String taskId, required bool isDone}) async {
    bool updated = false;
    try {
      final sqflite.Database localDb = await database;
      int ans = await localDb.update("TaskTable", {"is_completed": isDone},
          where: "task_id = ?",
          whereArgs: [taskId],
          conflictAlgorithm: ConflictAlgorithm.replace);
      log("Updated Data return value : $ans");
      updated = true;
    } catch (e) {
      log("Error Occured While Updating : ${e.toString()}");
      updated = false;
    }
    return updated;
  }

  static Future<bool> removeNotificationTimeFromDatabase({
    required String taskId,
    required String timeToRemove,
  }) async {
    try {
      final sqflite.Database localDb = await database;

      // Step 1: Fetch the current notify_time string
      List<Map<String, dynamic>> result = await localDb.query(
        "TaskTable",
        columns: ["notify_time"],
        where: "task_id = ?",
        whereArgs: [taskId],
      );

      if (result.isEmpty) return false; // No task found

      String? notifyTimeString = result.first["notify_time"];
      if (notifyTimeString == null || notifyTimeString.isEmpty) return false;

      // Step 2: Convert the stored string into a list
      List<String> timeList =
          notifyTimeString.split(',').map((e) => e.trim()).toList();

      // Step 3: Remove the specific time if it exists
      if (!timeList.contains(timeToRemove)) return false; // Time not found

      timeList.remove(timeToRemove);

      // Step 4: Convert the list back to a string
      String updatedTimeString = timeList.join(',');

      // Step 5: Update the database with the new notify_time string
      int updated = await localDb.update(
        "TaskTable",
        {"notify_time": updatedTimeString},
        where: "task_id = ?",
        whereArgs: [taskId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return updated > 0;
    } catch (e) {
      log("Error while removing notification time: ${e.toString()}");
      return false;
    }
  }
}
