import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/day_schedule_model.dart';
import 'package:schoosch/widgets/lesson_list_tile.dart';

class ClassScheduleTile extends StatelessWidget {
  final DayScheduleModel _schedule;

  const ClassScheduleTile(this._schedule, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cw = Get.find<CurrentWeek>();

    return FutureBuilder<List<LessonModel>>(
        future: _schedule.lessons(cw.currentWeek.order),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Container();
          }
          return ExpansionTile(
            title: Text(
              DateFormat('EEEE, d MMMM', 'ru').format(_schedule.date).capitalizeFirst!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              ...snap.data!.map((_les) => LessonListTile(_les, _schedule.date)),
            ],
          );
        });
  }
}
