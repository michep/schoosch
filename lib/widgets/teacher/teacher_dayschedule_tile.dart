import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/teacher/teacher_lessonlist_tile.dart';

class TeacherDayScheduleTile extends StatefulWidget {
  final TeacherScheduleModel _schedule;
  final DateTime _date;

  const TeacherDayScheduleTile(this._schedule, this._date, {super.key});

  @override
  State<TeacherDayScheduleTile> createState() => _TeacherDayScheduleTileState();
}

class _TeacherDayScheduleTileState extends State<TeacherDayScheduleTile> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var cw = Get.find<CurrentWeek>();

    return FutureBuilder<List<LessonModel>>(
        future: widget._schedule.teacherLessons(PersonModel.currentTeacher!, cw.currentWeek),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const SizedBox.shrink();
          }
          return ExpansionTile(
            key: PageStorageKey(widget._date),
            maintainState: true,
            title: Text(
              DateFormat('EEEE, d MMMM', 'ru').format(widget._date).capitalizeFirst!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              ...snap.data!.map((les) => TeacherLessonListTile(les, widget._date)),
            ],
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
