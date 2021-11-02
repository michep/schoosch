import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/fire_store.dart';
import 'package:schoosch/data/lesson_model.dart';
import 'package:schoosch/data/schedule_model.dart';
import 'package:schoosch/data/weekday_model.dart';
import 'package:schoosch/widgets/lesson_list_tile.dart';

class ClassScheduleTile extends StatelessWidget {
  final ScheduleModel _schedule;

  const ClassScheduleTile(this._schedule, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fs = Get.find<FStore>();
    return FutureBuilder<List<LessonModel>>(
        future: _schedule.lessons,
        builder: (context, lessons) {
          return lessons.hasData
              ? ExpansionTile(
                  title: FutureBuilder<WeekdaysModel>(
                    future: fs.getWeekdayNameModel(_schedule.day),
                    builder: (context, weekday) {
                      return weekday.hasData
                          ? Text(
                              weekday.data!.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )
                          : const Text('');
                    },
                  ),
                  children: [
                    ...lessons.data!.map((_les) => LessonListTile(_les)),
                  ],
                )
              : Container();
        });
  }
}
