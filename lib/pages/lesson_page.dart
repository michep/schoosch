import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';

class LessonPage extends StatelessWidget {
  final DateTime _date;
  final LessonModel _lesson;
  final CurriculumModel _curiculum;
  final VenueModel _venue;
  final LessontimeModel _time;

  const LessonPage(this._lesson, this._curiculum, this._venue, this._time, this._date, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(_curiculum.name),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(fullLessonInfo(context)),
          Text(_venue.name),
          FutureBuilder<List<HomeworkModel>?>(
              future: _lesson.homework,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('');
                }
                if (snapshot.data!.isEmpty) {
                  return const Text('нет домашнего задания на этот день');
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int i) {
                      return ListTile(
                        title: Text(snapshot.data![i].text),
                        onLongPress: () {},
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }

  void onDismissed(DismissDirection dir) {
    Get.back();
  }

  String fullLessonInfo(BuildContext context) {
    return DateFormat('d MMMM, EEEE', 'ru').format(_date).capitalizeFirst! +
        ', ' +
        _lesson.order.toString() +
        ' урок, ' +
        _time.format(context);
  }
}
