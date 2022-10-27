import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/teacher/class_homework_combined.dart';
import 'package:schoosch/widgets/teacher/students_absences.dart';
import 'package:schoosch/widgets/teacher/students_marks.dart';
import 'package:schoosch/widgets/utils.dart';

class ObserverLessonPage extends StatefulWidget {
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
  State<ObserverLessonPage> createState() => _ObserverLessonPageState();
}

class _ObserverLessonPageState extends State<ObserverLessonPage> {
  int current = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    pages = [
      ClassHomeworksCombinedPage(
        null,
        widget.curriculum,
        widget.date,
        widget.lesson,
        (d, f) => widget.lesson.homeworkThisLessonForClassAndAllStudents(d, forceRefresh: f),
        (d, f) => widget.lesson.homeworkThisLessonForClass(d, forceRefresh: f),
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
      ClassHomeworksCombinedPage(
        null,
        widget.curriculum,
        widget.date,
        widget.lesson,
        (d, f) => widget.lesson.homeworkNextLessonForClassAndAllStudents(d, forceRefresh: f),
        (d, f) => widget.lesson.homeworkNextLessonForClass(d, forceRefresh: f),
        readOnly: true,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// <<<<<<< HEAD
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
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: pages[current],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
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
              text: 'Отсутствующие',
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
