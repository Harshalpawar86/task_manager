class TaskModel {
  String taskName;
  String taskId;
  String? taskDescription;
  String date;
  int isDone;
  TaskModel(
      {required this.taskName,
      required this.taskId,
      required this.isDone,
      required this.date,
      required this.taskDescription});
  Map<String, dynamic> taskMap() {
    return {
      "task_id": taskId,
      "task_title": taskName,
      "is_completed": isDone,
      "task_description": taskDescription,
      "task_date": date
    };
  }
}
