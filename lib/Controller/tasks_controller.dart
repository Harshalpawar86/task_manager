import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task_manager/Model/task_model.dart';
import 'package:uuid/uuid.dart';

class TasksController extends ChangeNotifier {
  Future<void> addTask({required TaskModel taskModelObj}) async {
    Box<TaskModel> taskBox = Hive.box<TaskModel>("Tasks");
    final String key = Uuid().v1();
    await taskBox.put(key, taskModelObj);
    notifyListeners();
  }

  List<TaskModel> getTasksList() {
    Box<TaskModel> taskBox = Hive.box<TaskModel>("Tasks");
    return taskBox.values.cast<TaskModel>().toList();
  }

  Future<void> updateTaskData(
      {required dynamic key, required TaskModel taskModelObj}) async {
    Box<TaskModel> taskBox = Hive.box<TaskModel>("Tasks");
    await taskBox.put(key, taskModelObj);
    notifyListeners();
  }

  Future<void> deleteTaskData({required dynamic key}) async {
    Box<TaskModel> taskBox = Hive.box<TaskModel>("Tasks");
    await taskBox.delete(key);
    notifyListeners();
  }

  Future<void> completeTask(
      {required dynamic key,
      required bool isChecked,
      required TaskModel taskModelObj}) async {
    Box<TaskModel> taskBox = Hive.box<TaskModel>("Tasks");
    TaskModel obj = TaskModel(
        taskName: taskModelObj.taskName,
        priority: taskModelObj.priority,
        isDone: isChecked,
        date: taskModelObj.date,
        taskDescription: taskModelObj.taskDescription);
    await taskBox.put(key, obj);
    notifyListeners();
  }
}
