import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/student/student_lessonlist_tile.dart';

class StudentDayScheduleTile extends StatefulWidget {
  final StudentScheduleModel _schedule;
  final StudentModel _student;
  final DateTime _date;

  const StudentDayScheduleTile(this._schedule, this._student, this._date, {Key? key}) : super(key: key);

  @override
  State<StudentDayScheduleTile> createState() => _StudentDayScheduleTileState();
}

class _StudentDayScheduleTileState extends State<StudentDayScheduleTile> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<LessonModel>>(
      future: widget._schedule.studentLessons(widget._student, date: widget._date),
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
            ...snap.data!.map((les) => StudentLessonListTile(widget._student, les, widget._date)),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
