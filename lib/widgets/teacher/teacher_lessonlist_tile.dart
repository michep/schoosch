import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/teacher/teacher_lesson_page.dart';

class TeacherLessonListTile extends StatefulWidget {
  final LessonModel _lesson;
  final DateTime _date;

  const TeacherLessonListTile(this._lesson, this._date, {super.key});

  @override
  State<TeacherLessonListTile> createState() => _TeacherLessonListTileState();
}

class _TeacherLessonListTileState extends State<TeacherLessonListTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          widget._lesson.curriculum,
          widget._lesson.venue,
          widget._lesson.lessontime,
          widget._lesson.homeworkThisLessonForClassAndAllStudents(widget._date),
          widget._lesson.homeworkNextLessonForClassAndAllStudents(widget._date),
          widget._lesson.getAllLessonMarks(widget._date),
        ]),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const ListTile();
          }
          var list = snap.data!;
          var cur = list[0] as CurriculumModel;
          var ven = list[1] as VenueModel;
          var tim = list[2] as LessontimeModel;
          var hwtoday = list[3] as Map<String, List>;
          var hwnext = list[4] as Map<String, List>;
          var mar = list[5] as Map<String, List>;
          // var mar = list[3] as String;
          return ListTile(
            leading: Text(widget._lesson.order.toString()),
            title: Text(cur.aliasOrName),
            // trailing: Text(widget._lesson.aclass.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hwtoday.isNotEmpty)
                  const Icon(
                    Icons.arrow_downward_rounded,
                    size: 16,
                  ),
                const SizedBox(
                  width: 8,
                ),
                if (hwnext.isNotEmpty)
                  const Icon(
                    Icons.arrow_upward_rounded,
                    size: 16,
                  ),
                const SizedBox(
                  width: 8,
                ),
                if (mar.isNotEmpty)
                  const Icon(
                    Icons.thumb_up_off_alt_rounded,
                    size: 16,
                  ),
              ],
            ),
            subtitle: Text(
              '${tim.formatPeriod()}, ${ven.name}, ${widget._lesson.aclass.name}',
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            tileColor: widget._lesson.type == LessonType.replacment
                ? Colors.grey.withOpacity(0.1)
                : widget._lesson.type == LessonType.replaced
                    ? Colors.black54
                    : null,
            onTap: () => _onTap(widget._lesson, cur, ven, tim),
          );
        });
  }

  void _onTap(LessonModel les, CurriculumModel cur, VenueModel ven, LessontimeModel tim) async {
    var master = await cur.master;
    // Get.to(() => TeacherLessonPage(les, cur, ven, tim, widget._date, master!));
    Get.to(() => TeacherLessonPage(
          lesson: les,
          curriculum: cur,
          venue: ven,
          time: tim,
          date: widget._date,
          teacher: master!,
        ));
  }
}
