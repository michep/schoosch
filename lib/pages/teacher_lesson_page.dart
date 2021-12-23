import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';

class TeacherLessonPage extends StatelessWidget {
  final DateTime _date;
  final LessonModel _lesson;
  final CurriculumModel _curiculum;
  final VenueModel _venue;
  final LessontimeModel _time;

  const TeacherLessonPage(this._lesson, this._curiculum, this._venue, this._time, this._date, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar("Урок"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(fullLessonInfo(context)),
          const SizedBox(
            height: 10,
          ),
          Text(
            _curiculum.name,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(DateFormat('d MMMM, EEEE', 'ru').format(_date).capitalizeFirst!),
          const SizedBox(
            height: 5,
          ),
          Text(_lesson.order.toString() + ' урок'),
          const SizedBox(
            height: 5,
          ),
          Text(_time.format(context)),
          const SizedBox(
            height: 5,
          ),
          Text(_venue.name),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  String fullLessonInfo(BuildContext context) {
    return DateFormat('d MMMM, EEEE', 'ru').format(_date).capitalizeFirst! +
        ', ' +
        _lesson.order.toString() +
        ' урок, ' +
        _time.format(context);
  }
}
