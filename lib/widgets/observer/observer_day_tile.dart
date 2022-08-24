import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/observer/observer_lesson_page.dart';

class ObserverDayTile extends StatelessWidget {
  final DayScheduleModel _schedule;
  final DateTime _date;
  const ObserverDayTile(this._schedule, this._date, {Key? key}) : super(key: key);

  void onTap(LessonModel les, CurriculumModel cur, VenueModel ven, LessontimeModel tim, Map<String, HomeworkModel?> homw) {
    Get.to(
      () => ObserverLessonPage(
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
      future: _schedule.allLessons(
        date: _date,
        needsEmpty: true,
      ),
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
                future: les.type != LessonType.empty
                    ? Future.wait([
                        les.curriculum,
                        les.lessontime,
                        les.venue,
                        les.homeworkOnDateForClassAndAllStudents(_date),
                      ])
                    : Future.delayed(
                        const Duration(
                          milliseconds: 0,
                        ),
                        () {
                          return [];
                        },
                      ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const ListTile();
                  }
                  var list = snapshot.data! as List<dynamic>;
                  var cur = les.type != LessonType.empty ? list[0] as CurriculumModel : null;
                  var tim = les.type != LessonType.empty ? list[1] as LessontimeModel : null;
                  var ven = les.type != LessonType.empty ? list[2] as VenueModel : null;
                  var homw = les.type != LessonType.empty ? list[3] as Map<String, HomeworkModel?> : null;
                  return ListTile(
                    title: Text(
                      les.type != LessonType.empty ? cur!.aliasOrName : 'окно',
                    ),
                    leading: Text(
                      les.order.toString(),
                    ),
                    subtitle: les.type != LessonType.empty
                        ? homw!.values.every((element) => element == null)
                            ? null
                            : const Text('есть домашнее задание')
                        : null,
                    onTap: les.type != LessonType.empty
                        ? () {
                            onTap(les, cur!, ven!, tim!, homw!);
                          }
                        : null,
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
