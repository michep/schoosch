import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
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
  final DateTime date;
  final LessonModel lesson;
  final CurriculumModel curiculum;
  final VenueModel venue;
  final LessontimeModel time;
  final TeacherModel teacher;

  const TeacherLessonPage(this.lesson, this.curiculum, this.venue, this.time, this.date, this.teacher, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: MAppBar(curiculum.aliasOrName),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lesson.aclass.name),
                Text('${lesson.order} ${S.of(context).lesson}'),
                Text(Utils.formatDatetime(date)),
                Text(time.formatPeriod()),
                TabBar(
                  labelPadding: const EdgeInsets.all(16),
                  isScrollable: true,
                  tabs: [
                    Text(S.of(context).currentLessonClassTask),
                    Text(S.of(context).currentLessonPersonalTasks),
                    Text(S.of(context).currentLessonAbsences),
                    Text(S.of(context).currentLessonMarks),
                    Text(S.of(context).nextLessonClassTask),
                    Text(S.of(context).nextLessonPersonalTasks),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ClassTaskWithCompetionsPage(teacher, curiculum, date, lesson, (d, f) => lesson.homeworkThisLessonForClass(d, forceRefresh: f),
                          readOnly: true),
                      StudentsTasksWithCompetionsPage(
                          teacher, curiculum, date, lesson, (d, f) => lesson.homeworkThisLessonForClassAndAllStudents(d, forceRefresh: f),
                          readOnly: true),
                      StudentsAbsencePage(date, lesson),
                      StudentsMarksPage(date, lesson),
                      ClassTaskWithCompetionsPage(teacher, curiculum, date, lesson, (d, f) => lesson.homeworkNextLessonForClass(d, forceRefresh: f)),
                      StudentsTasksWithCompetionsPage(
                          teacher, curiculum, date, lesson, (d, f) => lesson.homeworkNextLessonForClassAndAllStudents(d, forceRefresh: f)),
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
