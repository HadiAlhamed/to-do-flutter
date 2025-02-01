import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:datetime_loop/datetime_loop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/services/notification_services.dart';
import 'package:to_do_app/services/theme_services.dart';
import 'package:to_do_app/ui/pages/add_task_page.dart';
import 'package:to_do_app/ui/size_config.dart';
import 'package:to_do_app/ui/themes.dart';
import 'package:to_do_app/ui/widgets/button.dart';
import 'package:to_do_app/ui/widgets/input_field.dart';
import 'dart:developer';
import 'package:to_do_app/ui/widgets/task_tile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.find();
  @override
  initState() {
    super.initState();
    _taskController.getTasks();
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 10,
          ),
          _showTask(),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
          size: 24,
        ),
        onPressed: () {
          // NotificationServices.showRepeatedNotification();
          ThemeServices().switchTheme();
        },
      ),
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      actions: [
        IconButton(
          tooltip: "clear all tasks",
          icon: Icon(
            Icons.cleaning_services_sharp,
            size: 24,
          ),
          onPressed: () async {
            // NotificationServices.showRepeatedNotification();
            Get.dialog(
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: 0.9 * SizeConfig.screenWidth,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(15),
                    height: (SizeConfig.orientation == Orientation.landscape)
                        ? SizeConfig.screenHeight * 0.7
                        : SizeConfig.screenHeight * 0.2,
                    color: Get.isDarkMode ? darkHeaderClr : Colors.white,
                    child: DefaultTextStyle(
                      style: titleStyle,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Are You Sure That You Want To Delete All Tasks?",
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  NotificationServices.cancelAllNotification();
                                  _taskController.deleteAll();
                                  Get.back();
                                },
                                child: Text("Clear All"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const CircleAvatar(
          child: Icon(Icons.person, size: 30),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsetsDirectional.only(
        start: 20,
        end: 10,
        top: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()).toString(),
                style: subHeadingStyle,
              ),
              Text("Today", style: headingStyle),
            ],
          ),
          MyButton(
            label: " + Add Task",
            onTap: () async {
              await Get.to(() => const AddTaskPage());
            },
          ),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 6, start: 20),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: _selectedDate,
        width: 80,
        height: 100,
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _refresh() async {
    return await _taskController.getTasks();
  }

  _showTask() {
    return Expanded(
      // child: _noTaskmsg(),
      child: Obx(
        () {
          if (_taskController.taskList.isEmpty) {
            return _noTaskmsg();
          } else {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                scrollDirection: SizeConfig.orientation == Orientation.portrait
                    ? Axis.vertical
                    : Axis.horizontal,
                itemCount: _taskController.taskList.length,
                itemBuilder: (context, index) {
                  Task task = _taskController.taskList[index];
                  int hour = int.parse(task.startTime!.split(':')[0]);
                  int minutes = int.parse(task.startTime!.split(':')[1]);

                  log(task.date!);
                  DateTime dt = DateFormat("MM/dd/yyyy").parse(task.date!);
                  if (task.date == DateFormat.yMd().format(_selectedDate) ||
                      task.repeat == 'Daily' ||
                      (task.repeat == 'Weekly' &&
                          _selectedDate.weekday == dt.weekday) ||
                      (task.repeat == 'Monthly' &&
                          _selectedDate.day == dt.day)) {
                    NotificationServices.showScheduledNotification(
                      hour,
                      minutes,
                      task,
                      dt,
                    );
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 1300),
                      child: SlideAnimation(
                        horizontalOffset: 400,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                context,
                                task,
                              );
                            },
                            child: TaskTile(
                              task: task,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  _noTaskmsg() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: SizeConfig.orientation == Orientation.portrait
                ? Axis.vertical
                : Axis.horizontal,
            children: [
              SizedBox(
                height:
                    SizeConfig.orientation == Orientation.portrait ? 220 : 6,
              ),
              SvgPicture.asset(
                "assets/images/task.svg",
                height: 90,
                semanticsLabel: 'Task',
                color: primaryClr.withOpacity(0.6),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 30, vertical: 10),
                child: Text(
                  "You Don't Have Any Tasks Yet!\nAdd New Tasks To Make Your Day Productive.",
                  style: subTitleStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height:
                    SizeConfig.orientation == Orientation.portrait ? 180 : 120,
              ),
            ],
          ),
        )
      ],
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? SizeConfig.screenHeight * 0.7
              : SizeConfig.screenHeight * 0.39,
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    color:
                        Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildBottomSheet(
                onTap: () {
                  _taskController.flipTaskCompleted(task.id!, task.isCompleted);
                  Get.back();
                },
                label: task.isCompleted == 0 ? "Check" : "UnCheck",
                clr: primaryClr,
              ),
              _buildBottomSheet(
                onTap: () {
                  NotificationServices.cancelNotification(task.id!);
                  _taskController.deleteTask(task);
                  Get.back();
                },
                label: "Delete Task",
                clr: Colors.red[300]!,
              ),
              Divider(
                color: Get.isDarkMode ? Colors.grey : darkGreyClr,
              ),
              _buildBottomSheet(
                onTap: () {
                  Get.back();
                },
                label: "Cancel",
                clr: primaryClr,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomSheet({
    required Function() onTap,
    required String label,
    required Color clr,
    bool isClosed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsetsDirectional.symmetric(vertical: 6),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: !isClosed
                ? clr
                : Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(17),
          color: isClosed ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClosed
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
