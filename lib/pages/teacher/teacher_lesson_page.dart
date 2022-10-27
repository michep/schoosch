import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/teacher/class_homework_combined.dart';
import 'package:schoosch/widgets/teacher/students_absences.dart';
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
  late final List<Widget> pages;

  @override
  void initState() {
    pages = [
      ClassHomeworksCombinedPage(
        widget.teacher,
        widget.curriculum,
        widget.date,
        widget.lesson,
        (d, f) => widget.lesson.homeworkThisLessonForClassAndAllStudents(d, forceRefresh: f),
        (d, f) => widget.lesson.homeworkThisLessonForClass(d, forceRefresh: f),
        readOnly: true,
        key: const ValueKey(0),
      ),
      StudentsAbsencePage(
        widget.date,
        widget.lesson,
      ),
      StudentsMarksPage(
        widget.date,
        widget.lesson,
      ),
      ClassHomeworksCombinedPage(
        widget.teacher,
        widget.curriculum,
        widget.date,
        widget.lesson,
        (d, f) => widget.lesson.homeworkNextLessonForClassAndAllStudents(d, forceRefresh: f),
        (d, f) => widget.lesson.homeworkNextLessonForClass(d, forceRefresh: f),
        key: const ValueKey(1),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Divider(
                indent: 50,
                endIndent: 50,
                thickness: 3,
              ),
              Expanded(
                child: pages[current],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: GNav(
          onTabChange: (i) => setState(() {
            current = i;
          }),
          gap: 8,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
          activeColor: Theme.of(context).colorScheme.onBackground,
          tabActiveBorder: Border.all(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          tabs: const [
            GButton(
              icon: Icons.menu_book_rounded,
              text: 'ДЗ на сегодня',
            ),
            GButton(
              icon: Icons.person_off_rounded,
              text: 'Отсутствующщие',
            ),
            GButton(
              icon: Icons.thumb_up_alt_rounded,
              text: 'Оценки',
            ),
            GButton(
              icon: Icons.edit_note_rounded,
              text: 'Задать ДЗ',
            ),
          ],
        ),
      ),
    );
  }
}
