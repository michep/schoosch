import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/lesson_model.dart';

class ObserverDayTile extends StatelessWidget {
  final DayScheduleModel _schedule;
  final DateTime _date;
  const ObserverDayTile(this._schedule, this._date, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LessonModel>>(
      future: _schedule.allLessons(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const SizedBox.shrink();
        }
        return ExpansionTile(
          title: Text(
            DateFormat('EEEE, d MMMM', 'ru').format(_date).capitalizeFirst!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            ...snap.data!.map(
              (les) => ListTile(
                title: Text(
                  les.id!,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}