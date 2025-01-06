import "package:hive/hive.dart";
part "task_model.g.dart";

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String taskName;

  @HiveField(1)
  String? taskDescription;

  @HiveField(2)
  String? date;

  @HiveField(3)
  int priority;

  @HiveField(4)
  bool isDone;
  TaskModel(
      {required this.taskName,
      required this.priority,
      required this.isDone,
      required this.date,
      required this.taskDescription});
}
