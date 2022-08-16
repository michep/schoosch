import 'package:flutter/material.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/teacher/class_homework_completions.dart';
import 'package:schoosch/widgets/teacher/students_absences.dart';
import 'package:schoosch/widgets/teacher/students_homework_completions.dart';
import 'package:schoosch/widgets/teacher/students_marks.dart';
import 'package:schoosch/widgets/utils.dart';

class TeacherLessonPage extends StatelessWidget {
  final DateTime _date;
  final LessonModel _lesson;
  final CurriculumModel _curiculum;
  final VenueModel _venue;
  final LessontimeModel _time;
  final TeacherModel _teacher;

  const TeacherLessonPage(this._lesson, this._curiculum, this._venue, this._time, this._date, this._teacher, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: MAppBar(_curiculum.aliasOrName),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_lesson.aclass.name),
                Text('${_lesson.order} урок'),
                Text(Utils.formatDatetime(_date)),
                Text(_time.formatPeriod()),
                const TabBar(
                  labelPadding: EdgeInsets.all(16),
                  isScrollable: true,
                  tabs: [
                    Text('Задание классу на этот урок'),
                    Text('Персональные задания на этот урок'),
                    Text('Отсутствующие'),
                    Text('Оценки'),
                    Text('Задание классу на следующий урок'),
                    Text('Персональные задания на следующий урок'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ClassTaskWithCompetionsPage(_date, _lesson, _lesson.homeworkThisLessonForClass, readOnly: true),
                      StudentsTasksWithCompetionsPage(_date, _lesson, _lesson.homeworkThisLessonForClassAndAllStudents, readOnly: true),
                      StudentsAbsencePage(_date, _lesson),
                      StudentsMarksPage(_date, _lesson),
                      ClassTaskWithCompetionsPage(_date, _lesson, _lesson.homeworkNextLessonForClass),
                      StudentsTasksWithCompetionsPage(_date, _lesson, _lesson.homeworkNextLessonForClassAndAllStudents),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
