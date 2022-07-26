import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/class_task_competions.dart';
import 'package:schoosch/widgets/students_tasks_completion.dart';
import 'package:schoosch/widgets/teacher_student_tile.dart';
import 'package:schoosch/widgets/utils.dart';
import '../../widgets/addhomeworksheet.dart';

class TeacherLessonPageNew extends StatelessWidget {
  final DateTime _date;
  final LessonModel _lesson;
  final CurriculumModel _curiculum;
  final VenueModel _venue;
  final LessontimeModel _time;
  final TeacherModel _teacher;

  const TeacherLessonPageNew(this._lesson, this._curiculum, this._venue, this._time, this._date, this._teacher, {Key? key}) : super(key: key);

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
                      ClassTaskWithCompetionsView(_date, _lesson.homeworkThisLessonForClass),
                      StudentsTasksWithCompetionView(),
                      Container(),
                      Container(),
                      ClassTaskWithCompetionsView(_date, _lesson.homeworkNextLessonForClass),
                      Container(),
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
