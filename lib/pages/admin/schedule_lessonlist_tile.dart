import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/admin/lesson_edit.dart';

class ScheduleLessonListTile extends StatefulWidget {
  final LessonModel _lesson;
  final Function(LessonModel) _removeLessonFunc;

  const ScheduleLessonListTile(this._lesson, this._removeLessonFunc, {Key? key}) : super(key: key);

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
          // widget._lesson.lessontime,
        ]),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const ListTile();
          }
          var list = snap.data! as List<dynamic>;
          var cur = list[0] as CurriculumModel;
          var ven = list[1] as VenueModel;
          // var tim = list[2] as LessontimeModel;
          return ListTile(
            title: Padding(
              child: Text(cur.name),
              padding: const EdgeInsets.only(left: 18),
            ),
            subtitle: Padding(
              child: Text('${cur.aliasOrName}, ${ven.name}'),
              padding: const EdgeInsets.only(left: 18),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () => _onTap(widget._lesson),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeLesson(widget._lesson),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _onTap(LessonModel lesson) async {
    var res = await Get.to<LessonModel>(() => LessonPage(lesson, 'Урок'), transition: Transition.rightToLeft);
    if (res is LessonModel) {
      setState(() {});
    }
  }

  void _removeLesson(LessonModel lesson) {
    widget._removeLessonFunc(lesson);
  }
}
