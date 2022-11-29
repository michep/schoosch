import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/teacher/teacher_lessonlist_tile.dart';

class TeacherDayScheduleTile extends StatelessWidget {
  final TeacherScheduleModel _schedule;
  final DateTime _date;

  const TeacherDayScheduleTile(this._schedule, this._date, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cw = Get.find<CurrentWeek>();

    return FutureBuilder<List<LessonModel>>(
        future: _schedule.teacherLessons(PersonModel.currentTeacher!, cw.currentWeek),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const SizedBox.shrink();
          }
          return ExpansionTile(
            key: PageStorageKey(_date),
            maintainState: true,
            title: Text(
              DateFormat('EEEE, d MMMM', 'ru').format(_date).capitalizeFirst!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              ...snap.data!.map((les) => TeacherLessonListTile(les, _date)),
            ],
          );
        });
  }
}
