import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/tab_chip.dart';
import 'package:schoosch/widgets/teacher/class_homework_completions.dart';
import 'package:schoosch/widgets/teacher/students_absences.dart';
import 'package:schoosch/widgets/teacher/students_homework_completions.dart';
import 'package:schoosch/widgets/teacher/students_marks.dart';
import 'package:schoosch/widgets/utils.dart';

class ObserverLessonPage extends StatefulWidget {
  final LessonModel lesson;
  final CurriculumModel curriculum;
  final VenueModel venue;
  final LessontimeModel time;
  final DateTime date;
  final Map<String, HomeworkModel?> homeworks;

  const ObserverLessonPage(
      {Key? key, required this.lesson, required this.homeworks, required this.curriculum, required this.venue, required this.time, required this.date})
      : super(key: key);

  @override
  State<ObserverLessonPage> createState() => _ObserverLessonPageState();
}

class _ObserverLessonPageState extends State<ObserverLessonPage> {
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
                Text(widget.lesson.aclass.name),
                Text(Utils.formatDatetime(widget.date)),
                Text('${widget.lesson.order} ${S.of(context).lesson}'),
                Text(widget.time.formatPeriod()),
                FutureBuilder<TeacherModel?>(
                  future: widget.curriculum.master,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) return const SizedBox.shrink();
                    return Text(snapshot.data!.fullName);
                  },
                ),
                TabBar(
                  labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  isScrollable: true,
                  onTap: (i) => setState(() {
                    current = i;
                  }),
                  tabs: [
                    TabChip(text: S.of(context).currentLessonClassHomework, pos: 0, current: current),
                    TabChip(text: S.of(context).currentLessonPersonalHomeworks, pos: 1, current: current),
                    TabChip(text: S.of(context).currentLessonAbsences, pos: 2, current: current),
                    TabChip(text: S.of(context).currentLessonMarks, pos: 3, current: current),
                    TabChip(text: S.of(context).nextLessonClassHomework, pos: 4, current: current),
                    TabChip(text: S.of(context).nextLessonPersonalHomeworks, pos: 5, current: current),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ClassTaskWithCompetionsPage(
                        null,
                        widget.curriculum,
                        widget.date,
                        widget.lesson,
                        (d, f) => widget.lesson.homeworkThisLessonForClass(d, forceRefresh: f),
                        readOnly: true,
                      ),
                      StudentsTasksWithCompetionsPage(
                        null,
                        widget.curriculum,
                        widget.date,
                        widget.lesson,
                        (d, f) => widget.lesson.homeworkThisLessonForClassAndAllStudents(d, forceRefresh: f),
                        readOnly: true,
                      ),
                      StudentsAbsencePage(
                        widget.date,
                        widget.lesson,
                        readOnly: true,
                      ),
                      StudentsMarksPage(
                        widget.date,
                        widget.lesson,
                        readOnly: true,
                      ),
                      ClassTaskWithCompetionsPage(
                        null,
                        widget.curriculum,
                        widget.date,
                        widget.lesson,
                        (d, f) => widget.lesson.homeworOnDateForClass(d, forceRefresh: f),
                        readOnly: true,
                      ),
                      StudentsTasksWithCompetionsPage(
                        null,
                        widget.curriculum,
                        widget.date,
                        widget.lesson,
                        (d, f) => widget.lesson.homeworkOnDateForClassAndAllStudents(d, forceRefresh: f),
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
