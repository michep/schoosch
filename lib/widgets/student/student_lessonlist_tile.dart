import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/student/student_lesson_page.dart';

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
        future: widget._lesson.type != LessonType.empty
            ? Future.wait([
                widget._lesson.curriculum,
                widget._lesson.venue,
                widget._lesson.lessontime,
                widget._lesson.marksForStudentAsString(widget._student, widget._date),
              ])
            : Future.delayed(
                const Duration(
                  milliseconds: 0,
                ), () {
                return [];
              }),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const ListTile();
          }
          var list = snap.data! as List<dynamic>;
          var cur = widget._lesson.type != LessonType.empty ? list[0] as CurriculumModel : null;
          var ven = widget._lesson.type != LessonType.empty ? list[1] as VenueModel : null;
          var tim = widget._lesson.type != LessonType.empty ? list[2] as LessontimeModel : null;
          var mar = widget._lesson.type != LessonType.empty ? list[3] as String : null;
          return ListTile(
            leading: Text(widget._lesson.order.toString()),
            title: Text(widget._lesson.type == LessonType.empty ? 'Окно' : cur!.aliasOrName),
            tileColor: widget._lesson.type == LessonType.replacment ? Colors.grey.withOpacity(0.1) : null,
            trailing: widget._lesson.type == LessonType.empty
                ? null
                : mar != ""
                    ? Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.red, width: 1.5),
                        ),
                        child: Text(mar!),
                      )
                    : Container(
                        width: 0,
                      ),
            subtitle: widget._lesson.type == LessonType.empty ? null : Text('${tim!.formatPeriod()}, ${ven!.name}'),
            onTap: widget._lesson.type != LessonType.empty ? () => _onTap(widget._lesson, cur!, ven!, tim!) : null,
          );
        });
  }

  void _onTap(LessonModel les, CurriculumModel cur, VenueModel ven, LessontimeModel tim) {
    Get.to(() => StudentLessonPage(widget._student, les, cur, ven, tim, widget._date));
  }
}
