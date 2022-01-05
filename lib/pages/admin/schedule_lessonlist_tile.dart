import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/admin/lesson_edit.dart';

class ScheduleLessonListTile extends StatefulWidget {
  final LessonModel _lesson;

  const ScheduleLessonListTile(this._lesson, {Key? key}) : super(key: key);

  @override
  State<ScheduleLessonListTile> createState() => _StudentLessonListTileState();
}

class _StudentLessonListTileState extends State<ScheduleLessonListTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          widget._lesson.curriculum,
          widget._lesson.venue,
          widget._lesson.lessontime,
        ]),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const ListTile();
          }
          var list = snap.data! as List<dynamic>;
          var cur = list[0] as CurriculumModel;
          var ven = list[1] as VenueModel;
          var tim = list[2] as LessontimeModel;
          return ListTile(
            leading: const Icon(Icons.drag_handle),
            title: Text(cur.name),
            subtitle: Text(cur.aliasOrName + ', ' + ven.name),
            trailing: const Icon(Icons.chevron_right), //TODO: make REMOVE action available for lessons list
            onTap: () => onTap(widget._lesson),
          );
        });
  }

  Future<void> onTap(LessonModel lesson) async {
    var res = await Get.to<LessonModel>(() => LessonPage(lesson, 'Урок'), transition: Transition.rightToLeft);
    if (res is LessonModel) {
      setState(() {});
    }
  }
}
