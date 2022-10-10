import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
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

class ObserverLessonPage extends StatelessWidget {
  final LessonModel lesson;
  final CurriculumModel curriculum;
  final VenueModel venue;
  final LessontimeModel time;
  final DateTime date;
  final Map<String, List<HomeworkModel>> homeworks;

  const ObserverLessonPage(
      {Key? key, required this.lesson, required this.homeworks, required this.curriculum, required this.venue, required this.time, required this.date})
      : super(key: key);

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
                        null,
                        curriculum,
                        date,
                        lesson,
                        (d, f) => lesson.homeworkThisLessonForClass(d, forceRefresh: f),
                        readOnly: true,
                      ),
                      StudentsTasksWithCompetionsPage(
                        null,
                        curriculum,
                        date,
                        lesson,
                        (d, f) => lesson.homeworkThisLessonForClassAndAllStudents(d, forceRefresh: f),
                        readOnly: true,
                      ),
                      StudentsAbsencePage(
                        date,
                        lesson,
                        readOnly: true,
                      ),
                      StudentsMarksPage(
                        date,
                        lesson,
                        readOnly: true,
                      ),
                      ClassTaskWithCompetionsPage(
                        null,
                        curriculum,
                        date,
                        lesson,
                        (d, f) => lesson.homeworkNextLessonForClass(d, forceRefresh: f),
                        readOnly: true,
                      ),
                      StudentsTasksWithCompetionsPage(
                        null,
                        curriculum,
                        date,
                        lesson,
                        (d, f) => lesson.homeworkNextLessonForClassAndAllStudents(d, forceRefresh: f),
                        readOnly: true,
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
