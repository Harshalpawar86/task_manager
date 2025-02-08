import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:slideable/slideable.dart";
import "package:task_manager/Controller/notification_service.dart";
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
    // ThemeController themeController = Provider.of<ThemeController>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ));
            })
          ],
          title: Text(
            "My Task Manager",
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await displayBottomSheet(
                taskid: getUniqueId(),
                forEdit: false,
                notifyMap: {},
                taskController: taskController);
          },
          child: const Icon(Icons.add),
        ),
        endDrawer: Drawer(
            width: MediaQuery.of(context).size.width / 2,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                      child: Text("Dark Mode",
                          style: Theme.of(context).textTheme.displayMedium)),
                  TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                      child: Text("Clear Data",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium)),
                  TextButton(
                      onPressed: () async {
                        await NotificationService().requestExactPermission();
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                      child: Text("Grant Notifications",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium)),
                  const Spacer(),
                  TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                      child: Text("About",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium)),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
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
                                    date = taskList[index].date;
                                    await displayBottomSheet(
                                        forEdit: true,
                                        taskController: taskController,
                                        taskid: taskList[index].taskId,
                                        title: taskList[index].taskName,
                                        notifyMap:
                                            taskList[index].timeMap ?? {},
                                        description:
                                            taskList[index].taskDescription ??
                                                "",
                                        date: date);
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
    required Map<int,String> notifyMap,
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
            notifyMap: notifyMap,
            description: description,
            date: date,
            taskid: taskid,
          );
        } else {
          return MyBottomsheet(
              notifyMap: notifyMap,
              taskid: taskid,
              forEdit: forEdit,
              taskController: taskController);
        }
      },
    );
  }
}
