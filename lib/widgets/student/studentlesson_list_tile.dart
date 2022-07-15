import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/student_lesson_page.dart';

class StudentLessonListTile extends StatefulWidget {
  final LessonModel _lesson;
  final StudentModel _student;
  final DateTime _date;

  const StudentLessonListTile(this._student, this._lesson, this._date, {Key? key}) : super(key: key);

  @override
  State<StudentLessonListTile> createState() => _StudentLessonListTileState();
}

class _StudentLessonListTileState extends State<StudentLessonListTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget._lesson.getReplacement(widget._date).then((value) {
          if (value != null) {
            return Future.wait([
              value.curriculum,
              value.venue,
              value.lessontime,
              value.marksForStudentAsString(widget._student, widget._date),
            ]);
          } else {
            return Future.wait([
              widget._lesson.curriculum,
              widget._lesson.venue,
              widget._lesson.lessontime,
              widget._lesson.marksForStudentAsString(widget._student, widget._date),
            ]);
          }
        }),
        // future: Future.wait([
        //   widget._lesson.curriculum,
        //   widget._lesson.venue,
        //   widget._lesson.lessontime,
        //   widget._lesson.marksForStudentAsString(widget._student, widget._date),
        // ]),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const ListTile();
          }
          var list = snap.data! as List<dynamic>;
          var cur = list[0] as CurriculumModel;
          var ven = list[1] as VenueModel;
          var tim = list[2] as LessontimeModel;
          var mar = list[3] as String;
          return ListTile(
            leading: Text(widget._lesson.order.toString()),
            title: Text(cur.aliasOrName),
            trailing: mar != ""
                ? Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.red, width: 1.5),
                    ),
                    child: Text(mar),
                  )
                : Container(
                    width: 0,
                  ),
            subtitle: Text('${tim.format(context)}, ${ven.name}'),
            onTap: () => _onTap(widget._lesson, cur, ven, tim),
          );
        });
  }

  void _onTap(LessonModel les, CurriculumModel cur, VenueModel ven, LessontimeModel tim) {
    Get.to(() => StudentLessonPage(widget._student, les, cur, ven, tim, widget._date));
  }
}
