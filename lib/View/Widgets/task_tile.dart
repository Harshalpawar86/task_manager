import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/Controller/tasks_controller.dart';
import 'package:task_manager/Model/task_model.dart';

class TaskTile extends StatefulWidget {
  final TaskModel taskModel;
  final TasksController taskController;
  const TaskTile(
      {super.key, required this.taskModel, required this.taskController});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(5),
            width: width,
            decoration: BoxDecoration(
                color: (widget.taskModel.isDone == 1)
                    ? Colors.lightGreen[500]
                    : Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color.fromRGBO(49, 49, 49, 0.7))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/task_photo.png",
                                    ),
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.fitHeight),
                                color: Colors.blueAccent,
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.taskModel.date,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              widget.taskModel.taskName,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            (widget.taskModel.taskDescription != null)
                                ? Text(
                                    widget.taskModel.taskDescription!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      Checkbox(
                          value: (widget.taskModel.isDone == 1) ? true : false,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          onChanged: (value) async {
                            bool isChecked = value ?? false;
                            await widget.taskController.completeTask(
                                taskId: widget.taskModel.taskId,
                                isDone: isChecked);
                          }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                (widget.taskModel.timeList == null ||
                        widget.taskModel.timeList!.isEmpty)
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () async {
                          await showNotificationDialog();
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text("Notifications",
                                style: GoogleFonts.merriweather(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .fontSize,
                                  color: Colors.white,
                                  fontWeight: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .fontWeight,
                                )),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showNotificationDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).canvasColor,
              title: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text("Notifications",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.merriweather(
                      fontSize:
                          Theme.of(context).textTheme.displayLarge!.fontSize,
                      color: Colors.white,
                      fontWeight:
                          Theme.of(context).textTheme.displayLarge!.fontWeight,
                    )),
              ),
              content: NotificationDialog(taskModel: widget.taskModel));
        });
  }
}

class NotificationDialog extends StatefulWidget {
  final TaskModel taskModel;
  const NotificationDialog({super.key, required this.taskModel});

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      width: MediaQuery.of(context).size.width / 1.5,
      child: ListView.builder(
          itemCount: (widget.taskModel.timeList != null)
              ? widget.taskModel.timeList!.length
              : 0,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Text(widget.taskModel.timeList![index],
                        textAlign: TextAlign.left,
                        style: GoogleFonts.merriweather(
                          fontSize: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .fontSize,
                          color: Colors.white,
                          fontWeight: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .fontWeight,
                        )),
                    const Spacer(),
                    IconButton(
                        onPressed: () async {
                          await TasksController().removeNotificationTime(
                              taskId: widget.taskModel.taskId,
                              time: widget.taskModel.timeList![index]);
                          widget.taskModel.timeList!.removeAt(index);

                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                        ))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
