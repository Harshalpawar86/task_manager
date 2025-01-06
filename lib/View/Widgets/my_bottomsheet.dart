import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/Controller/tasks_controller.dart';
import 'package:task_manager/Model/task_model.dart';

class MyBottomsheet extends StatefulWidget {
  final bool forEdit;
  final TasksController taskController;
  final String title;
  final String description;
  final String date;
  final dynamic taskKey;
  final int prevPriority;
  const MyBottomsheet(
      {super.key,
      required this.forEdit,
      required this.taskController,
      this.title = '',
      this.description = '',
      this.date = '',
      this.taskKey = '',
      this.prevPriority = 0});

  @override
  State<MyBottomsheet> createState() => _MyBottomsheetState();
}

class _MyBottomsheetState extends State<MyBottomsheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  int priority = 3;

  void _clearControllers() {
    _titleController.clear();
    _descriptionController.clear();
    _dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (widget.forEdit) {
      _titleController.text = widget.title;
      _descriptionController.text = widget.description;
      _dateController.text = widget.date;
      priority = widget.prevPriority;
    }
    return BottomSheet(
      enableDrag: false,
      showDragHandle: false,
      backgroundColor: Colors.white,
      onClosing: () {
        _clearControllers();
      },
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Create Task",
                      style: GoogleFonts.merriweather(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    "Title",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Color.fromRGBO(49, 49, 49, 0.5))),
                    child: Center(
                      child: TextFormField(
                        controller: _titleController,
                        keyboardType: TextInputType.name,
                        showCursor: true,
                        cursorColor: Color.fromRGBO(49, 49, 49, 0.5),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter title";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Color.fromRGBO(49, 49, 49, 0.5))),
                    child: Center(
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: _descriptionController,
                        maxLines: 5,
                        showCursor: true,
                        cursorColor: Color.fromRGBO(49, 49, 49, 0.5),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Due Date",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Color.fromRGBO(49, 49, 49, 0.5))),
                    child: TextFormField(
                      controller: _dateController,
                      keyboardType: TextInputType.none,
                      onTap: () async {
                        DateTime? selectedDate = await _selectDate();
                        log("Selected Date : ${selectedDate.toString()}");
                        if (selectedDate != null) {
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(selectedDate);
                          _dateController.text = formattedDate;
                        }
                      },
                      readOnly: true,
                      cursorHeight: 0,
                      showCursor: true,
                      cursorColor: Color.fromRGBO(49, 49, 49, 0.5),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () async {
                              DateTime? selectedDate = await _selectDate();
                              if (selectedDate != null) {
                                String formattedDate = DateFormat('dd/MM/yyyy')
                                    .format(selectedDate);
                                _dateController.text = formattedDate;
                              }
                            },
                            icon: const Icon(Icons.calendar_month)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  (widget.forEdit)
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<String>(
                              iconDisabledColor: Colors.black,
                              dropdownColor: Theme.of(context).canvasColor,
                              hint: Text(
                                "Set Priority",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: "High",
                                  child: Text("High",
                                      style: GoogleFonts.merriweather(
                                          fontSize: 15,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w800)),
                                ),
                                DropdownMenuItem(
                                  value: "Medium",
                                  child: Text("Medium",
                                      style: GoogleFonts.merriweather(
                                          fontSize: 15,
                                          color: Colors.amber,
                                          fontWeight: FontWeight.w800)),
                                ),
                                DropdownMenuItem(
                                  value: "Low",
                                  child: Text("Low",
                                      style: GoogleFonts.merriweather(
                                          fontSize: 15,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w800)),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  if (value == "High") {
                                    priority = 1;
                                  } else if (value == "Medium") {
                                    priority = 2;
                                  } else {
                                    priority = 3;
                                  }
                                  setState(() {});
                                }
                              },
                            ),
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  color: (priority == 1)
                                      ? Colors.red
                                      : (priority == 2)
                                          ? Colors.amber
                                          : Colors.green,
                                  shape: BoxShape.circle),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                      onTap: () async {
                        if (_key.currentState!.validate()) {
                          if (widget.forEdit) {
                            TaskModel taskModelObj = TaskModel(
                                taskName: _titleController.text,
                                priority: priority,
                                isDone: false,
                                date: _dateController.text,
                                taskDescription: _descriptionController.text);
                            widget.taskController.updateTaskData(
                                key: widget.taskKey,
                                taskModelObj: taskModelObj);
                          } else {
                            TaskModel taskModelObj = TaskModel(
                                taskName: _titleController.text,
                                priority: priority,
                                isDone: false,
                                date: _dateController.text,
                                taskDescription: _descriptionController.text);
                            await widget.taskController
                                .addTask(taskModelObj: taskModelObj);
                          }
                          if (context.mounted) {
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                          }
                        }
                      },
                      child: Container(
                        width: width,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          (widget.forEdit) ? "Update" : "Submit",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<DateTime?> _selectDate() async {
    return await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(primary: Colors.blueAccent),
            datePickerTheme: Theme.of(context).datePickerTheme,
          ),
          child: child!,
        );
      },
    );
  }
}
/**
 * 
 * Future<void> displayBottomSheet(
      ) async {
    showModalBottomSheet(
      
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, sheetState) {
           
            
          },
        );
      },
    );
  }
 */
