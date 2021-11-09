import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/venue_model.dart';

class LessonListTile extends StatefulWidget {
  final LessonModel _lesson;

  const LessonListTile(this._lesson, {Key? key}) : super(key: key);

  @override
  State<LessonListTile> createState() => _LessonListTileState();
}

class _LessonListTileState extends State<LessonListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(widget._lesson.order.toString()),
      title: FutureBuilder<CurriculumModel>(
          future: widget._lesson.curriculum,
          builder: (context, curriculum) {
            if (!curriculum.hasData) {
              return const Text('');
            }
            return Text(curriculum.data!.name);
          }),
      trailing: FutureBuilder<VenueModel>(
          future: widget._lesson.venue,
          builder: (context, venue) {
            if (!venue.hasData) {
              return const Text('');
            }
            return Text(venue.data!.name);
          }),
      subtitle: FutureBuilder<LessontimeModel>(
          future: widget._lesson.lessontime,
          builder: (context, lessontime) {
            if (!lessontime.hasData) {
              return const Text('');
            }
            return Text(
                '${lessontime.data!.from.hour.toString().padLeft(2, '0')}:${lessontime.data!.from.minute.toString().padLeft(2, '0')}'
                '\u2014 ${lessontime.data!.till.hour.toString().padLeft(2, '0')}:${lessontime.data!.till.minute.toString().padLeft(2, '0')}');
          }),
      selected: widget._lesson.ready,
      selectedTileColor: Colors.green.shade100,
      onLongPress: _onLongPress,
    );
  }

  void _onLongPress() {
    setState(() {
      final fs = Get.find<FStore>();
      widget._lesson.ready = !widget._lesson.ready;
      fs.updateLesson(widget._lesson);
    });
  }
}
