import 'package:flutter/material.dart';
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
          color: (widget.taskModel.isDone)
              ? Colors.greenAccent[100]
              : Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color.fromRGBO(49, 49, 49, 0.7))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              (widget.taskModel.date != null)
                  ? Text(
                      widget.taskModel.date!,
                      style: Theme.of(context).textTheme.displaySmall,
                    )
                  : const SizedBox(),
              Row(
                spacing: 5,
                children: [
                  Text(
                    "Priority :",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                        color: (widget.taskModel.priority == 1)
                            ? Colors.red
                            : (widget.taskModel.priority == 2)
                                ? Colors.amber
                                : Colors.green,
                        shape: BoxShape.circle),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
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
              value: widget.taskModel.isDone,
              activeColor: Colors.green,
              checkColor: Colors.white,
              onChanged: (value) async {
                bool isChecked = value ?? false;
                await widget.taskController.completeTask(
                    key: widget.taskModel.key,
                    isChecked: isChecked,
                    taskModelObj: widget.taskModel);

                widget.taskModel.isDone = isChecked;

              }),
        ],
      ),
    );
  }
}
