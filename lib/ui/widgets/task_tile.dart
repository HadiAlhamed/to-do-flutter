import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/ui/size_config.dart';
import 'package:to_do_app/ui/themes.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: getProportionateScreenWidth(
            SizeConfig.orientation == Orientation.landscape ? 4 : 20),
      ),
      margin:
          EdgeInsetsDirectional.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: const EdgeInsetsDirectional.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(task.color),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title ?? "Title",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_alarm_rounded,
                          size: 18,
                          color: Colors.grey[200],
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          "${task.startTime!} - ${task.endTime!}",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[100],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      task.note ?? "Note",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted == 1 ? "Completed" : "ToDo",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getBGClr(int? color) {
    switch (color) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return orangeClr;
    }
  }
}
