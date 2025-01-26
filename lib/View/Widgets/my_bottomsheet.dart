import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/Controller/tasks_controller.dart';
import 'package:task_manager/Model/task_model.dart';
import 'package:uuid/uuid.dart';

class MyBottomsheet extends StatefulWidget {
  final bool forEdit;
  final TasksController taskController;
  final String title;
  final String description;
  final String date;
  final String taskid;
  const MyBottomsheet({
    super.key,
    required this.forEdit,
    required this.taskController,
    this.title = '',
    this.description = '',
    this.date = '',
    required this.taskid,
  });

  @override
  State<MyBottomsheet> createState() => _MyBottomsheetState();
}

class _MyBottomsheetState extends State<MyBottomsheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  void _clearControllers() {
    _titleController.clear();
    _descriptionController.clear();
    _dateController.clear();
  }

  String getUniqueId() {
    var uuid = Uuid();
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return '${uuid.v4()}_$timestamp';
  }

  TimeOfDay? prevTime;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String taskid;
    if (widget.forEdit) {
      _titleController.text = widget.title;
      _descriptionController.text = widget.description;
      _dateController.text = widget.date;
      taskid = widget.taskid;
    } else {
      taskid = getUniqueId();
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
                  TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.name,
                    showCursor: true,
                    cursorColor: Color.fromRGBO(49, 49, 49, 0.5),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(49, 49, 49, 0.5))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(49, 49, 49, 0.5))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(49, 49, 49, 0.5))),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter title";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Description (Optional)",
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
                  TextFormField(
                    controller: _dateController,
                    validator: (value) {
                      log("Value ---------$value");
                      if (value == '' || value == null) {
                        return "Please enter date";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                          onPressed: () async {
                            DateTime? selectedDate = await _selectDate();
                            log("Selected Date : $selectedDate");
                            if (selectedDate != null) {
                              String formattedDate =
                                  DateFormat('dd/MM/yyyy').format(selectedDate);
                              _dateController.text = formattedDate;
                            }
                          },
                          icon: const Icon(Icons.calendar_month)),
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(49, 49, 49, 0.5))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(49, 49, 49, 0.5))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(49, 49, 49, 0.5))),
                    ),
                    keyboardType: TextInputType.none,
                    onTap: () async {
                      DateTime? selectedDate = await _selectDate();
                      log("Selected Date : ${selectedDate.toString()}");
                      if (selectedDate != null) {
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                        _dateController.text = formattedDate;
                      } else {
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(DateTime.now());
                        _dateController.text = formattedDate;
                      }
                    },
                    readOnly: true,
                    cursorHeight: 0,
                    showCursor: true,
                    cursorColor: Color.fromRGBO(49, 49, 49, 0.5),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Notification Time (Optional)",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  TextFormField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                          onPressed: () async {
                            TimeOfDay? selectedTime = await _selectTime();
                            prevTime = selectedTime;
                            log("Selected Date : $selectedTime");
                            if (selectedTime != null) {
                              if (context.mounted) {
                                String formattedTime =
                                    MaterialLocalizations.of(context)
                                        .formatTimeOfDay(selectedTime);
                                _timeController.text = formattedTime;
                              }
                            }
                          },
                          icon: const Icon(Icons.alarm_sharp)),
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(49, 49, 49, 0.5))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(49, 49, 49, 0.5))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(49, 49, 49, 0.5))),
                    ),
                    keyboardType: TextInputType.none,
                    onTap: () async {
                      TimeOfDay? selectedTime = await _selectTime();
                      prevTime = selectedTime;
                      log("Selected Date : $selectedTime");
                      if (selectedTime != null) {
                        if (context.mounted) {
                          String formattedTime =
                              MaterialLocalizations.of(context)
                                  .formatTimeOfDay(selectedTime);
                          _timeController.text = formattedTime;
                        }
                      }
                    },
                    readOnly: true,
                    cursorHeight: 0,
                    showCursor: true,
                    cursorColor: Color.fromRGBO(49, 49, 49, 0.5),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                      onTap: () async {
                        if (_key.currentState!.validate()) {
                          if (widget.forEdit) {
                            TaskModel taskModelObj = TaskModel(
                                taskId: taskid,
                                taskName: _titleController.text,
                                isDone: 0, //false
                                date: _dateController.text,
                                taskDescription: _descriptionController.text);
                            await widget.taskController
                                .updateTaskData(taskModelObj: taskModelObj);
                          } else {
                            TaskModel taskModelObj = TaskModel(
                                taskId: taskid,
                                taskName: _titleController.text,
                                isDone: 0, //false
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

  Future<TimeOfDay?> _selectTime() async {
    return await showTimePicker(
      context: context,
      initialTime: (_timeController.text == '')
          ? TimeOfDay.now()
          : (prevTime == null)
              ? TimeOfDay.now()
              : prevTime!,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(primary: Colors.blueAccent),
            timePickerTheme: Theme.of(context).timePickerTheme,
          ),
          child: child!,
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
