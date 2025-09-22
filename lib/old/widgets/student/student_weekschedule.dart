import 'package:flutter/material.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/old/generated/l10n.dart';
import 'package:schoosch/old/model/class_model.dart';
import 'package:schoosch/old/model/dayschedule_model.dart';
import 'package:schoosch/old/model/person_model.dart';
import 'package:schoosch/old/widgets/student/student_dayschedule_tile.dart';
import 'package:schoosch/old/widgets/utils.dart';

class StudentWeekScheduleWidget extends StatefulWidget {
  final ClassModel _class;
  final Week _week;
  final StudentModel _student;

  const StudentWeekScheduleWidget(this._student, this._class, this._week, {super.key});

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
          return Center(
            child: Text(
              S.of(context).noWeekSchedule,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }
        forceRefresh = false;
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              forceRefresh = true;
            });
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ...schedules.data!.map(
                (schedule) => StudentDayScheduleTile(
                  schedule,
                  widget._student,
                  widget._week.day(schedule.day - 1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
