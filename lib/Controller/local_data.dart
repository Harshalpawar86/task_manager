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
      List<Map<String, dynamic>> map = await localDb.query("TaskTable");
      log("After inserting data ::::::::::::::$map");
    } catch (e) {
      log("Error Occured While Inserted : ${e.toString()}");
      inserted = false;
    }
    log("Time Map ----------${obj.timeMap}");

    return inserted;
  }

  static Future<List<TaskModel>> getTasks() async {
    List<TaskModel> modelList = [];
    try {
      final sqflite.Database localDb = await database;
      List<Map<String, dynamic>> taskList = await localDb.query("TaskTable");
      log("Total tasks fetched: ${taskList.length}");

      for (var task in taskList) {
        String taskName = task['task_title'];
        String date = task['task_date'];
        String description = task['task_description'] ?? "";
        int isDone = task['is_completed'];
        String taskId = task['task_id'];

        // Convert notify_time string to Map<int, String>
        String notifyTimeString = task['notify_time'] ?? "{}";
        log("After retrieving :::::::::::::::::::$notifyTimeString");
        Map<int, String> timeMap = TaskModel.jsonToTimeMap(notifyTimeString);
        log("After retrieving & converting to map:::::::::::::::::::$timeMap");
        log("Map While retrieving : $timeMap");

        TaskModel obj = TaskModel(
          taskName: taskName,
          taskId: taskId,
          isDone: isDone,
          date: date,
          timeMap: timeMap,
          taskDescription: description,
        );

        modelList.add(obj);
      }
    } catch (e) {
      log("Error in getTasks: $e");
    }
    return modelList;
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
