import 'package:flutter/material.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/teacher/teacher_dayschedule_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class TeacherScheduleWidget extends StatefulWidget {
  final TeacherModel _teacher;
  final Week _week;

  const TeacherScheduleWidget(this._teacher, this._week, {Key? key}) : super(key: key);

  @override
  State<TeacherScheduleWidget> createState() => _TeacherScheduleWidgetState();
}

class _TeacherScheduleWidgetState extends State<TeacherScheduleWidget> {
  bool forceRefresh = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TeacherScheduleModel>>(
      future: widget._teacher.getSchedulesWeek(widget._week, forceRefresh: forceRefresh),
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
                (schedule) => TeacherDayScheduleTile(
                  schedule,
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
