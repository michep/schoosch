import 'package:flutter/material.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/widgets/student_dayschedule_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class TeacherScheduleWidget extends StatelessWidget {
  const TeacherScheduleWidget(this._teacher, this._week, {Key? key}) : super(key: key);

  final Week _week;
  final PeopleModel _teacher;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DayScheduleModel>>(
      future: _teacher.getTeacherDaySchedules(_week),
      builder: (context, schedules) {
        if (!schedules.hasData) {
          return Utils.progressIndicator();
        }
        return ListView(
          children: [
            ...schedules.data!.map((schedule) => ClassDayScheduleTile(schedule)),
          ],
        );
      },
    );
  }
}
