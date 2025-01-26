class TaskModel {
  String taskName;
  String taskId;
  String? taskDescription;
  String date;
  List<String>? timeList;
  int isDone;
  TaskModel(
      {required this.taskName,
      required this.taskId,
      required this.isDone,
      required this.date,
      this.timeList,
      required this.taskDescription});
  Map<String, dynamic> taskMap() {
    return {
      "task_id": taskId,
      "task_title": taskName,
      "is_completed": isDone,
      "task_description": taskDescription,
      "task_date": date,
      "notify_time": timeList != null ? timeListToJson() : null,
    };
  }

  String timeListToJson() {
    return timeList != null ? timeList!.join(',') : '';
  }
}
