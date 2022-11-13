import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/admin/lesson_edit.dart';

class ScheduleLessonListTile extends StatefulWidget {
  final LessonModel _lesson;
  final Function(LessonModel) _removeLessonFunc;
  final Function(LessonModel) _updateLessonRunc;

  const ScheduleLessonListTile(this._lesson, this._removeLessonFunc, this._updateLessonRunc, {Key? key}) : super(key: key);

  @override
  State<ScheduleLessonListTile> createState() => _ScheduleLessonListTileState();
}

class _ScheduleLessonListTileState extends State<ScheduleLessonListTile> {
  late LessonModel lesson;

  @override
  void initState() {
    lesson = widget._lesson;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        lesson.curriculum,
        lesson.venue,
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
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: ListTile(
            title: Text(cur.name, overflow: TextOverflow.ellipsis),
            subtitle: Text('${cur.aliasOrName}, ${ven.name}', overflow: TextOverflow.ellipsis),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () => _onTap(lesson),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeLesson(lesson),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onTap(LessonModel lesson) async {
    var res = await Get.to<LessonModel>(() => LessonPage(lesson, S.of(context).lessonName), transition: Transition.rightToLeft);
    if (res is LessonModel) {
      setState(() {
        this.lesson = res;
        widget._updateLessonRunc(res);
      });
    }
  }

  void _removeLesson(LessonModel lesson) {
    widget._removeLessonFunc(lesson);
  }
}
