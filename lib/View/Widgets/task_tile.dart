import 'dart:developer';

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

    return Container(
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
        children: [
          Row(
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
                  Text(
                    widget.taskModel.date,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  (widget.taskModel.timeList == null)
                      ? const SizedBox()
                      : Text(
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.taskModel.taskName,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    (widget.taskModel.taskDescription != null)
                        ? Text(
                            widget.taskModel.taskDescription!,
                            style: Theme.of(context).textTheme.displaySmall,
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
                    // log("Value Checkbox:$isChecked");
                    await widget.taskController.completeTask(
                        taskId: widget.taskModel.taskId, isDone: isChecked);
                  }),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 30,
            child: ListView.builder(
              itemCount: 6,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "12:00 PM",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.merriweather(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
