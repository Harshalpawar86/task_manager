import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:slideable/slideable.dart";
import "package:task_manager/Controller/tasks_controller.dart";
import "package:task_manager/Controller/theme_controller.dart";
import "package:task_manager/Model/task_model.dart";
import "package:task_manager/View/Widgets/my_bottomsheet.dart";
import "package:task_manager/View/Widgets/task_tile.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    TasksController taskController = Provider.of<TasksController>(context);
    ThemeController themeController = Provider.of<ThemeController>(context);
    List<TaskModel> taskList = taskController.getTasksList();
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
                forEdit: false, taskController: taskController);
            // priority = 0;
            // await displayBottomSheet(
            //     width: width, forEdit: false, taskController: taskController);
            // _clearControllers();
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView.builder(
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
                                  taskKey: taskList[index].key,
                                  title: taskList[index].taskName,
                                  prevPriority: taskList[index].priority,
                                  description:
                                      taskList[index].taskDescription ?? "",
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
                              dynamic taskKey = taskList[index].key;
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
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              await taskController
                                                  .deleteTaskData(key: taskKey);
                                              if (context.mounted) {
                                                if (Navigator.canPop(context)) {
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
                                              if (Navigator.canPop(context)) {
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
              }),
        ));
  }

  Future<void> displayBottomSheet(
      {required bool forEdit,
      required TasksController taskController,
      String title = '',
      String description = '',
      String date = '',
      dynamic taskKey = '',
      int prevPriority = 0}) async {
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
            taskKey: taskKey,
            prevPriority: prevPriority,
          );
        } else {
          return MyBottomsheet(
              forEdit: forEdit, taskController: taskController);
        }
      },
    );
  }
}
