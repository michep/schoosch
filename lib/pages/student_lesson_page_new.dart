import 'package:flutter/material.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/student/homeworks_page.dart';
import 'package:schoosch/widgets/student/marks_page.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentLessonPageNew extends StatelessWidget {
  final StudentModel _student;
  final DateTime _date;
  final LessonModel _lesson;
  final CurriculumModel _curiculum;
  final VenueModel _venue;
  final LessontimeModel _time;
  const StudentLessonPageNew(this._student, this._lesson, this._curiculum, this._venue, this._time, this._date, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const MAppBar('Урок'),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_curiculum.aliasOrName} ${_lesson.type == LessonType.replacment ? '(замена)' : ''}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${_lesson.order} урок'),
                Text(Utils.formatDatetime(_date)),
                Text(_time.formatPeriod()),
                const TabBar(
                  isScrollable: false,
                  labelPadding: EdgeInsets.all(16),
                  tabs: [Text('ДЗ на этот урок'), Text('Оценки')],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      HomeworksForStudentPage(_lesson, _date, _student),
                      MarksForStudentPage(_lesson, _date, _student),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
