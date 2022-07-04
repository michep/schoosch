import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/observer_lesson_page.dart';

class ObserverDayTile extends StatelessWidget {
  final DayScheduleModel _schedule;
  final DateTime _date;
  const ObserverDayTile(this._schedule, this._date, {Key? key}) : super(key: key);

  void onTap(LessonModel les, CurriculumModel cur, VenueModel ven, LessontimeModel tim, Map<String, HomeworkModel?> homw) {
    Get.to(() =>
      ObserverLessonPage(
        lesson: les,
        curriculum: cur,
        venue: ven,
        lessontime: tim,
        date: _date,
        homeworks: homw,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LessonModel>>(
      future: _schedule.allLessons(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const SizedBox.shrink();
        }
        return ExpansionTile(
          title: Text(
            DateFormat('EEEE, d MMMM', 'ru').format(_date).capitalizeFirst!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            ...snap.data!.map(
              (les) => FutureBuilder(
                future: Future.wait([
                  les.curriculum,
                  les.lessontime,
                  les.venue,
                  les.homeworkForEveryone(_date),
                ]),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const ListTile();
                  }
                  var list = snapshot.data! as List<dynamic>;
                  var cur = list[0] as CurriculumModel;
                  var tim = list[1] as LessontimeModel;
                  var ven = list[2] as VenueModel;
                  var homw = list[3] as Map<String, HomeworkModel?>;
                  return ListTile(
                    title: Text(
                      les.toString(),
                    ),
                    subtitle: homw.values.every((element) => element == null) ? null : const Text('есть домашнее задание'),
                    onTap: () {
                      onTap(les, cur, ven, tim, homw);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
