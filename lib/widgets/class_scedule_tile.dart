import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/day_schedule_model.dart';
import 'package:schoosch/model/weekday_model.dart';
import 'package:schoosch/widgets/lesson_list_tile.dart';

class ClassScheduleTile extends StatelessWidget {
  final DayScheduleModel _schedule;

  const ClassScheduleTile(this._schedule, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = Get.find<FStore>();
    var cw = Get.find<CurrentWeek>();

    return FutureBuilder<List<LessonModel>>(
        future: _schedule.lessons(cw.currentWeek.order),
        builder: (context, lessons) {
          return lessons.hasData
              ? ExpansionTile(
                  title: FutureBuilder<WeekdaysModel>(
                    future: store.getWeekdayNameModel(_schedule.day),
                    builder: (context, weekday) {
                      if (!weekday.hasData) {
                        return const Text('');
                      }
                      var dd = cw.currentWeek.start.add(Duration(days: weekday.data!.order - 1));
                      var dat = DateFormat('dd MMMM', 'ru').format(dd);
                      return Text(
                        weekday.data!.name + ', ' + dat,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      );
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
