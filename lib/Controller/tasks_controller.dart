import 'package:flutter/material.dart';
import 'package:task_manager/Controller/local_data.dart';
import 'package:task_manager/Model/task_model.dart';

class TasksController extends ChangeNotifier {
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

  Future<void> completeTask({required TaskModel taskModelObj}) async {
    bool completed = await LocalData.finishTask(taskModelObj);
    if (completed) {
      notifyListeners();
    } else {
      //show delightful toast
    }
  }
}
