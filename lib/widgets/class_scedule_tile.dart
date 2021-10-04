import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/datasource_interface.dart';
import 'package:schoosch/data/schedule_model.dart';
import 'package:schoosch/data/weekday_model.dart';
import 'package:schoosch/widgets/lesson_list_tile.dart';

class ClassScheduleTile extends StatelessWidget {
  final ScheduleModel _schedule;

  const ClassScheduleTile(this._schedule, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fs = Get.find<SchooschDatasource>();
    return ExpansionTile(
      title: FutureBuilder<WeekdaysModel>(
        future: fs.getWeekdayNameModel(_schedule.day),
        builder: (context, weekday) {
          return weekday.hasData
              ? Text(
                  weekday.data!.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : Container();
        },
      ),
      children: [..._schedule.lessons.map((_les) => LessonListTile(_les))],
    );
  }
}
