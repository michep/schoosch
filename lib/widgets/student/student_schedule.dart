import 'package:flutter/material.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/widgets/student/student_dayschedule_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentScheduleWidget extends StatelessWidget {
  final ClassModel _class;
  final Week _week;
  final StudentModel _student;

  const StudentScheduleWidget(this._student, this._class, this._week, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StudentScheduleModel>>(
      future: _class.getSchedulesWeek(_week),
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
            ...schedules.data!.map((schedule) => ClassDayScheduleTile(schedule, _student)),
          ],
        );
      },
    );
  }
}
