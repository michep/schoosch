import 'package:flutter/material.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/widgets/class_scedule_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentScheduleWidget extends StatelessWidget {
  const StudentScheduleWidget(this._class, this._week, {Key? key}) : super(key: key);

  final ClassModel _class;
  final Week _week;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DayScheduleModel>>(
      future: _class.getSchedulesWeek(_week),
      builder: (context, schedules) {
        if (!schedules.hasData) {
          return Utils.progressIndicator();
        }
        return ListView(
          children: [
            ...schedules.data!.map((schedule) => ClassScheduleTile(schedule)),
          ],
        );
      },
    );
  }
}
