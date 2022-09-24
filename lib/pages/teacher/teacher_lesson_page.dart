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

class TeacherLessonPage extends StatefulWidget {
  final DateTime date;
  final LessonModel lesson;
  final CurriculumModel curriculum;
  final VenueModel venue;
  final LessontimeModel time;
  final TeacherModel teacher;

  const TeacherLessonPage(this.lesson, this.curriculum, this.venue, this.time, this.date, this.teacher, {Key? key}) : super(key: key);

  @override
  State<TeacherLessonPage> createState() => _TeacherLessonPageState();
}

class _TeacherLessonPageState extends State<TeacherLessonPage> {
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: MAppBar(widget.curriculum.aliasOrName),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.lesson.aclass.name,
                  style: const TextStyle(fontSize: 17),
                ),
                Text(
                  Utils.formatDatetime(widget.date),
                  style: const TextStyle(fontSize: 17),
                ),
                Text(
                  '${widget.lesson.order} ${S.of(context).lesson}',
                  style: const TextStyle(fontSize: 17),
                ),
                Text(
                  widget.time.formatPeriod(),
                  style: const TextStyle(fontSize: 17),
                ),
                FutureBuilder<TeacherModel?>(
                  future: widget.curriculum.master,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) return const SizedBox.shrink();
                    return Text(
                      snapshot.data!.fullName,
                      style: const TextStyle(fontSize: 17),
                    );
                  },
                ),
                TabBar(
                  labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  isScrollable: true,
                  indicatorWeight: 0.001,
                  onTap: (value) {
                    setState(() {
                      current = value;
                    });
                  },
                  tabs: [
                    tabChip(context: context, text: S.of(context).currentLessonClassHomework, pos: 0),
                    tabChip(context: context, text: S.of(context).currentLessonPersonalHomeworks, pos: 1),
                    tabChip(context: context, text: S.of(context).currentLessonAbsences, pos: 2),
                    tabChip(context: context, text: S.of(context).currentLessonMarks, pos: 3),
                    tabChip(context: context, text: S.of(context).nextLessonClassHomework, pos: 4),
                    tabChip(context: context, text: S.of(context).nextLessonPersonalHomeworks, pos: 5),
                    // Text(S.of(context).currentLessonClassHomework),
                    // Text(S.of(context).currentLessonPersonalHomeworks),
                    // Text(S.of(context).currentLessonAbsences),
                    // Text(S.of(context).currentLessonMarks),
                    // Text(S.of(context).nextLessonClassHomework),
                    // Text(S.of(context).nextLessonPersonalHomeworks),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ClassTaskWithCompetionsPage(
                        widget.teacher,
                        widget.curriculum,
                        widget.date,
                        widget.lesson,
                        (d, f) => widget.lesson.homeworkThisLessonForClass(d, forceRefresh: f),
                        readOnly: true,
                      ),
                      StudentsTasksWithCompetionsPage(
                        widget.teacher,
                        widget.curriculum,
                        widget.date,
                        widget.lesson,
                        (d, f) => widget.lesson.homeworkThisLessonForClassAndAllStudents(d, forceRefresh: f),
                        readOnly: true,
                      ),
                      StudentsAbsencePage(
                        widget.date,
                        widget.lesson,
                      ),
                      StudentsMarksPage(
                        widget.date,
                        widget.lesson,
                      ),
                      ClassTaskWithCompetionsPage(
                        widget.teacher,
                        widget.curriculum,
                        widget.date,
                        widget.lesson,
                        (d, f) => widget.lesson.homeworOnDateForClass(d, forceRefresh: f),
                      ),
                      StudentsTasksWithCompetionsPage(
                        widget.teacher,
                        widget.curriculum,
                        widget.date,
                        widget.lesson,
                        (d, f) => widget.lesson.homeworkOnDateForClassAndAllStudents(d, forceRefresh: f),
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

  Widget tabChip({required BuildContext context, required String text, required int pos}) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: current == pos ? Theme.of(context).colorScheme.onBackground : Colors.transparent,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text),
      );
}
