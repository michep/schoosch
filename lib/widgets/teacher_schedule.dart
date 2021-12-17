import 'package:flutter/material.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/widgets/student_dayschedule_tile.dart';
import 'package:schoosch/widgets/teacher_dayschedule_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class TeacherScheduleWidget extends StatelessWidget {
  const TeacherScheduleWidget(this._teacher, this._week, {Key? key}) : super(key: key);

  final TeacherModel _teacher;
  final Week _week;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TeacherScheduleModel>>(
      future: _teacher.getSchedulesWeek(_week),
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
        return ListView(
          children: [
            ...schedules.data!.map((schedule) => TeacherDayScheduleTile(schedule)),
          ],
        );
      },
    );
  }
}
