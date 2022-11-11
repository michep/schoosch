import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/student/student_lessonlist_tile.dart';

class ClassDayScheduleTile extends StatelessWidget {
  final StudentScheduleModel _schedule;
  final StudentModel _student;
  final DateTime _date;

  const ClassDayScheduleTile(this._schedule, this._student, this._date, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LessonModel>>(
      future: _schedule.studentLessons(_student, date: _date),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const SizedBox.shrink();
        }
        return ExpansionTile(
          key: PageStorageKey(_date),
          title: Text(
            DateFormat('EEEE, d MMMM', 'ru').format(_date).capitalizeFirst!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            ...snap.data!.map((les) => StudentLessonListTile(_student, les, _date)),
          ],
        );
      },
    );
  }
}
