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
  final CurriculumModel curriculum;
  final VenueModel venue;
  final LessontimeModel time;
  final TeacherModel teacher;

  const TeacherLessonPage(this.lesson, this.curriculum, this.venue, this.time, this.date, this.teacher, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: MAppBar(curriculum.aliasOrName),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lesson.aclass.name),
                Text(Utils.formatDatetime(date)),
                Text('${lesson.order} ${S.of(context).lesson}'),
                Text(time.formatPeriod()),
                FutureBuilder<TeacherModel?>(
                  future: curriculum.master,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) return const SizedBox.shrink();
                    return Text(snapshot.data!.fullName);
                  },
                ),
                TabBar(
                  labelPadding: const EdgeInsets.all(16),
                  isScrollable: true,
                  tabs: [
                    Text(S.of(context).currentLessonClassHomework),
                    Text(S.of(context).currentLessonPersonalHomeworks),
                    Text(S.of(context).currentLessonAbsences),
                    Text(S.of(context).currentLessonMarks),
                    Text(S.of(context).nextLessonClassHomework),
                    Text(S.of(context).nextLessonPersonalHomeworks),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ClassTaskWithCompetionsPage(
                        teacher,
                        curriculum,
                        date,
                        lesson,
                        (d, f) => lesson.homeworkThisLessonForClass(d, forceRefresh: f),
                        readOnly: true,
                      ),
                      StudentsTasksWithCompetionsPage(
                        teacher,
                        curriculum,
                        date,
                        lesson,
                        (d, f) => lesson.homeworkThisLessonForClassAndAllStudents(d, forceRefresh: f),
                        readOnly: true,
                      ),
                      StudentsAbsencePage(
                        date,
                        lesson,
                      ),
                      StudentsMarksPage(
                        date,
                        lesson,
                      ),
                      ClassTaskWithCompetionsPage(
                        teacher,
                        curriculum,
                        date,
                        lesson,
                        (d, f) => lesson.homeworOnDateForClass(d, forceRefresh: f),
                      ),
                      StudentsTasksWithCompetionsPage(
                        teacher,
                        curriculum,
                        date,
                        lesson,
                        (d, f) => lesson.homeworkOnDateForClassAndAllStudents(d, forceRefresh: f),
                      ),
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
