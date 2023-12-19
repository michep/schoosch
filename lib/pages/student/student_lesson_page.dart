import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/student/student_homeworks.dart';
import 'package:schoosch/widgets/student/student_marks.dart';
import 'package:schoosch/widgets/utils.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class StudentLessonPage extends StatefulWidget {
  final StudentModel student;
  final DateTime date;
  final LessonModel lesson;
  final CurriculumModel curriculum;
  final VenueModel venue;
  final LessontimeModel time;

  const StudentLessonPage({
    required this.student,
    required this.lesson,
    required this.curriculum,
    required this.venue,
    required this.time,
    required this.date,
    super.key,
  });

  @override
  State<StudentLessonPage> createState() => _StudentLessonPageState();
}

class _StudentLessonPageState extends State<StudentLessonPage> with SingleTickerProviderStateMixin {
  late final List<Widget> pages;
  int current = 0;
  final bucket = PageStorageBucket();

  @override
  void initState() {
    pages = [
      StudentHomeworks(
        widget.lesson,
        widget.date,
        widget.student,
      ),
      StudentMarks(
        widget.lesson,
        widget.date,
        widget.student,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(S.of(context).lessonTitle),
      body: PageStorage(
        bucket: bucket,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.curriculum.aliasOrName} ${widget.lesson.type == LessonType.replacment ? '(замена)' : ''}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  Utils.formatDatetime(widget.date),
                  style: const TextStyle(fontSize: 17),
                ),
                Text(
                  '${widget.lesson.order} урок',
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
      ),
      bottomNavigationBar: Container(
        color: Get.theme.colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: GNav(
          onTabChange: (i) => setState(() {
            current = i;
          }),
          gap: 8,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: Get.theme.colorScheme.onBackground.withOpacity(0.5),
          activeColor: Get.theme.colorScheme.onBackground,
          tabActiveBorder: Border.all(
            color: Get.theme.colorScheme.onBackground,
          ),
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          tabs: [
            GButton(
              icon: Icons.menu_book_rounded,
              text: S.of(context).currentLessonHomeworks,
            ),
            GButton(
              icon: Icons.thumb_up_alt_rounded,
              text: S.of(context).currentLessonMarks,
            ),
          ],
        ),
      ),
    );
  }
}
