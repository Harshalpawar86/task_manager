import 'dart:developer';
import 'dart:convert';
class TaskModel {
  String taskName;
  String taskId;
  String? taskDescription;
  String date;
  Map<int, String>? timeMap;
  int isDone;

  TaskModel({
    required this.taskName,
    required this.taskId,
    required this.isDone,
    required this.date,
    this.timeMap,
    required this.taskDescription,
  });

  Map<String, dynamic> taskMap() {
    log("Time Map: -------- $timeMap");
    log("Date: ------- $date");

    return {
      "task_id": taskId,
      "task_title": taskName,
      "is_completed": isDone,
      "task_description": taskDescription,
      "task_date": date,
      "notify_time": timeMap != null
          ? timeMapToJson()
          : null, // Convert map to JSON string
    };
  }

  /// Convert `Map<int, String>` to JSON string
  String timeMapToJson() {
    String string = timeMap != null
        ? timeMap!.entries.map((e) => '"${e.key}":"${e.value}"').join(',')
        : '{}';
        log("Converting map to json string : $string");
    return string;
  }

  /// Convert JSON string back to `Map<int, String>`
static Map<int, String> jsonToTimeMap(String jsonString) {
  Map<int, String> map = {};
  try {
    // ✅ Decode JSON string into a Map
    Map<String, dynamic> decoded = jsonDecode("{$jsonString}");

    // ✅ Convert String keys to int and store in the final map
    decoded.forEach((key, value) {
      int? parsedKey = int.tryParse(key);
      if (parsedKey != null && value is String) {
        map[parsedKey] = value;
      }
    });

  } catch (e) {
    log("Error parsing JSON: $e");
  }
  return map;
}

}
