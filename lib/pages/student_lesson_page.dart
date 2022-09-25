import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/student/homeworks_page.dart';
import 'package:schoosch/widgets/student/marks_page.dart';
import 'package:schoosch/widgets/tab_chip.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentLessonPage extends StatefulWidget {
  final StudentModel _student;
  final DateTime _date;
  final LessonModel _lesson;
  final CurriculumModel _curriculum;
  final VenueModel _venue;
  final LessontimeModel _time;
  const StudentLessonPage(this._student, this._lesson, this._curriculum, this._venue, this._time, this._date, {Key? key}) : super(key: key);

  @override
  State<StudentLessonPage> createState() => _StudentLessonPageState();
}

class _StudentLessonPageState extends State<StudentLessonPage> {
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MAppBar(S.of(context).lessonTitle),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget._curriculum.aliasOrName} ${widget._lesson.type == LessonType.replacment ? '(замена)' : ''}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(Utils.formatDatetime(widget._date)),
                Text('${widget._lesson.order} урок'),
                Text(widget._time.formatPeriod()),
                FutureBuilder<TeacherModel?>(
                  future: widget._curriculum.master,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) return const SizedBox.shrink();
                    return Text(snapshot.data!.fullName);
                  },
                ),
                TabBar(
                  isScrollable: false,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  onTap: (i) => setState(() {
                    current = i;
                  }),
                  tabs: [
                    TabChip(current: current, pos: 0, text: 'ДЗ на этот урок'),
                    TabChip(current: current, pos: 1, text: 'Оценки')
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      HomeworksForStudentPage(widget._lesson, widget._date, widget._student),
                      MarksForStudentPage(widget._lesson, widget._date, widget._student),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
