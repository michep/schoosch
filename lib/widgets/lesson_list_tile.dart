import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/lesson_page.dart';

class LessonListTile extends StatefulWidget {
  final LessonModel _lesson;
  final DateTime _date;

  const LessonListTile(this._lesson, this._date, {Key? key}) : super(key: key);

  @override
  State<LessonListTile> createState() => _LessonListTileState();
}

class _LessonListTileState extends State<LessonListTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          widget._lesson.curriculum,
          widget._lesson.venue,
          widget._lesson.lessontime,
          widget._lesson.marksCurrentStudentAsString,
        ]),
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
            title: Text(cur.name),
            trailing: Text(mar),
            subtitle: Text(tim.format(context) + ', ' + ven.name),
            onTap: () => _onTap(widget._lesson, cur, ven, tim),
          );
        });
  }

  void _onTap(LessonModel les, CurriculumModel cur, VenueModel ven, LessontimeModel tim) {
    Get.to(() => LessonPage(les, cur, ven, tim, widget._date));
  }
}
