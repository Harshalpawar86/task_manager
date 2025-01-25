import "dart:developer";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:slideable/slideable.dart";
import "package:task_manager/Controller/tasks_controller.dart";
import "package:task_manager/Controller/theme_controller.dart";
import "package:task_manager/Model/task_model.dart";
import "package:task_manager/View/Widgets/my_bottomsheet.dart";
import "package:task_manager/View/Widgets/task_tile.dart";
import "package:uuid/uuid.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String getUniqueId() {
    var uuid = Uuid();
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return '${uuid.v4()}_$timestamp'; // Combine UUID and timestamp
  }

  @override
  Widget build(BuildContext context) {
    TasksController taskController = Provider.of<TasksController>(context);
    ThemeController themeController = Provider.of<ThemeController>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                themeController.changeTheme();
              },
              icon: Icon(
                Icons.lightbulb,
                color:
                    (themeController.darkTheme) ? Colors.white : Colors.yellow,
              )),
          title: Text(
            "My Task Manager",
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await displayBottomSheet(
                taskid: getUniqueId(),
                forEdit: false,
                taskController: taskController);
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: FutureBuilder<List<TaskModel>>(
              future: taskController.getTasksList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  log("Error while loading data : ${snapshot.error.toString()}");
                  return Center(
                    child: Text("Something went wrong"),
                  );
                }
                List<TaskModel> taskList = snapshot.data ?? [];
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Slideable(
                            backgroundColor: Colors.white,
                            items: [
                              ActionItems(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPress: () async {
                                    String? date;
                                    if (taskList[index].date != null) {
                                      date = taskList[index].date!;
                                    }
                                    await displayBottomSheet(
                                        forEdit: true,
                                        taskController: taskController,
                                        taskid: taskList[index].taskId,
                                        title: taskList[index].taskName,
                                        description:
                                            taskList[index].taskDescription ??
                                                "",
                                        date: date ?? "");
                                    // Scaffold.of(context).showBottomSheet((context) =>
                                    //     MyBottomsheet
                                  },
                                  backgroudColor: Colors.white),
                              ActionItems(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPress: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: Center(
                                            child: Text("Delete Task ?",
                                                style: GoogleFonts.merriweather(
                                                    fontSize: 25,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    await taskController
                                                        .deleteTaskData(
                                                            taskModelObj:
                                                                taskList[
                                                                    index]);
                                                    if (context.mounted) {
                                                      if (Navigator.canPop(
                                                          context)) {
                                                        Navigator.pop(context);
                                                      }
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                              Theme.of(context)
                                                                  .canvasColor)),
                                                  child: Text(
                                                    "Yes",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall,
                                                  )),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    if (Navigator.canPop(
                                                        context)) {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                              Theme.of(context)
                                                                  .canvasColor)),
                                                  child: Text(
                                                    "No",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall,
                                                  )),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  backgroudColor: Colors.white)
                            ],
                            child: TaskTile(
                                taskModel: taskList[index],
                                taskController: taskController)),
                      );
                    });
              }),
        ));
  }

  Future<void> displayBottomSheet({
    required bool forEdit,
    required TasksController taskController,
    String title = '',
    String description = '',
    required String taskid,
    String date = '',
  }) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        if (forEdit) {
          return MyBottomsheet(
            forEdit: forEdit,
            taskController: taskController,
            title: title,
            description: description,
            date: date,
            taskid: taskid,
          );
        } else {
          return MyBottomsheet(
              taskid: taskid, forEdit: forEdit, taskController: taskController);
        }
      },
    );
  }
}
