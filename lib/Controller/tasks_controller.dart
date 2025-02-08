import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_manager/Controller/local_data.dart';
import 'package:task_manager/Model/task_model.dart';

class TasksController extends ChangeNotifier {
  Future<void> removeNotificationTime(
      {required String taskId,
      required int notificationId,
      required String time}) async {
    bool removed = await LocalData.removeNotificationTimeFromDatabase(
        taskId: taskId, timeToRemove: time);
    if (removed) {
      notifyListeners();
    } else {
      //show delightful toast
    }
  }

  Future<void> addTask({required TaskModel taskModelObj}) async {
    bool added = await LocalData.insertData(taskModelObj);
    if (added) {
      notifyListeners();
    } else {
      //show delightful toast
    }
  }

  Future<List<TaskModel>> getTasksList() async {
    List<TaskModel> taskModelList = await LocalData.getTasks();
    return taskModelList;
  }

  Future<void> updateTaskData({required TaskModel taskModelObj}) async {
    bool updated = await LocalData.updateTask(taskModelObj);
    if (updated) {
      notifyListeners();
    } else {
      //show delightful toast
    }
  }

  Future<void> deleteTaskData({required TaskModel taskModelObj}) async {
    bool deleted = await LocalData.deleteTask(taskModelObj);
    if (deleted) {
      notifyListeners();
    } else {
      //show delightful toast
    }
  }

  Future<void> completeTask(
      {required String taskId, required bool isDone}) async {
    bool completed = await LocalData.finishTask(taskId: taskId, isDone: isDone);
    if (completed) {
      notifyListeners();
    } else {
      //show delightful toast
    }
  }
}
