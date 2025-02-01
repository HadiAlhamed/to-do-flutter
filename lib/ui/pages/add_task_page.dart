import 'dart:developer';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/services/notification_services.dart';
import 'package:to_do_app/ui/themes.dart';
import 'package:to_do_app/ui/widgets/button.dart';
import 'package:to_do_app/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => AddTaskPageState();
}

class AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat.Hm().format(DateTime.now()).toString();
  String _endTime = DateFormat.Hm()
      .format(
        DateTime.now().add(
          const Duration(
            hours: 1,
          ),
        ),
      )
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20, 25, 30, 45, 60];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add A Task",
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: "Enter A Title",
                controller: _titleController,
              ),
              const SizedBox(
                height: 20,
              ),
              InputField(
                title: 'Note',
                hint: "Enter A Note",
                controller: _noteController,
              ),
              const SizedBox(
                height: 20,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () async {
                    DateTime? ChosenDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(DateTime.now().year + 100),
                    );
                    setState(() {
                      _selectedDate = ChosenDate ?? _selectedDate;
                    });
                  },
                  icon: const Icon(
                    Icons.date_range,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () async {
                          TimeOfDay chosenTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now()) ??
                              TimeOfDay.now();

                          DateTime dt = DateTime(
                              0, 0, 0, chosenTime.hour, chosenTime.minute);
                          setState(
                            () => _startTime =
                                DateFormat('HH:mm').format(dt).toString(),
                          );
                          log(_startTime);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () async {
                          TimeOfDay chosenTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                  DateTime.now().add(
                                    const Duration(
                                      hours: 1,
                                    ),
                                  ),
                                ),
                              ) ??
                              TimeOfDay.now();

                          DateTime dt = DateTime(
                              0, 0, 0, chosenTime.hour, chosenTime.minute);
                          setState(
                            () => _endTime =
                                DateFormat('HH:mm').format(dt).toString(),
                          );
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InputField(
                title: 'Remind',
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  dropdownColor: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(15),
                  items: remindList
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (selectedItem) {
                    setState(() {
                      _selectedRemind = selectedItem ?? _selectedRemind;
                    });
                  },
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  underline: Container(
                    height: 0,
                  ),
                  elevation: 5,
                  style: subTitleStyle,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: DropdownButton(
                  borderRadius: BorderRadius.circular(15),
                  dropdownColor: Colors.blueGrey,
                  items: repeatList
                      .map<DropdownMenuItem<String>>(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (selectedItem) {
                    setState(() {
                      _selectedRepeat = selectedItem ?? _selectedRepeat;
                    });
                  },
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  underline: Container(
                    height: 0,
                  ),
                  elevation: 5,
                  style: subTitleStyle,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _colorPalette(),
                  MyButton(
                    label: "Create Task",
                    onTap: () {
                      log(_startTime);
                      log(_endTime);
                      _checkValid();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _checkValid() {
    bool flag = true;
    for (int i = 0; i < _startTime.length; i++) {
      if (_startTime[i] == ':') continue;
      if (int.parse(_startTime[i]) > int.parse(_endTime[i])) {
        flag = false;
        break;
      } else if (int.parse(_startTime[i]) < int.parse(_endTime[i])) {
        break;
      }
    }
    if (!flag ||
        _titleController.text.isEmpty ||
        _noteController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All Fields Are Required and Start Time Must Be Less Than End Time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    } else {
      _addTaskToDb();
      Get.back();
    }
  }

  _addTaskToDb() async {
    log("hi");
    try {
      int value = await _taskController.addTask(
        task: Task(
          title: _titleController.text,
          note: _noteController.text,
          isCompleted: 0,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
        ),
      );
      log(value.toString());
    } catch (err) {
      log('${err}addTask problem');
    }
  }

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle),
        Wrap(
          children: List.generate(
            3,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsetsDirectional.all(8.0),
                child: CircleAvatar(
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                  child: _selectedColor == index
                      ? Icon(Icons.done, size: 20, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 24, color: primaryClr),
        onPressed: () {
          Get.back();
        },
      ),
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      actions: [
        CircleAvatar(
          child: const Icon(Icons.person, size: 30),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
