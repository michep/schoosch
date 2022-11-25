import 'package:flutter/material.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/student/student_dayschedule_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentWeekScheduleWidget extends StatefulWidget {
  final ClassModel _class;
  final Week _week;
  final StudentModel _student;

  const StudentWeekScheduleWidget(this._student, this._class, this._week, {Key? key}) : super(key: key);

  @override
  State<StudentWeekScheduleWidget> createState() => _StudentWeekScheduleWidgetState();
}

class _StudentWeekScheduleWidgetState extends State<StudentWeekScheduleWidget> {
  bool forceRefresh = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StudentScheduleModel>>(
      future: widget._class.getStudentSchedulesWeek(widget._week, widget._student, forceRefresh: forceRefresh),
      builder: (context, schedules) {
        if (!schedules.hasData) {
          return Utils.progressIndicator();
        }
        if (schedules.data!.isEmpty) {
          return const Center(
            child: Text(
              'нет расписания на эту неделю',
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        forceRefresh = false;
        return RefreshIndicator(
          onRefresh: () async {
            forceRefresh = true;
            setState(() {});
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...schedules.data!.map((schedule) => StudentDayScheduleTile(schedule, widget._student, widget._week.day(schedule.day - 1))),
              ],
            ),
          ),
        );
      },
    );
  }
}
