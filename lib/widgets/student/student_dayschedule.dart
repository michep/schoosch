import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/student/student_lesson_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentDayScheduleWidget extends StatefulWidget {
  final ClassModel _class;
  final Week _week;
  final DateTime _currentdate;
  final StudentModel _student;

  const StudentDayScheduleWidget(this._student, this._class, this._week, this._currentdate, {super.key});

  @override
  State<StudentDayScheduleWidget> createState() => _StudentDayScheduleWidgetState();
}

class _StudentDayScheduleWidgetState extends State<StudentDayScheduleWidget> {
  bool forceRefresh = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StudentScheduleModel>>(
      future: widget._class.getStudentSchedulesWeek(widget._week, widget._student, forceRefresh: forceRefresh),
      builder: (context, schedules) {
        if (!schedules.hasData) {
          return Utils.progressIndicator();
        }
        if (schedules.data!.isEmpty) {
          return const Center(
            child: Text(
              'нет расписания на эту неделю',
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        forceRefresh = false;
        if (schedules.data!.length - 1 < widget._currentdate.weekday - 1) {
          return headedListview(
            child: const Center(
              child: Text('на этот день нет расписания'),
            ),
          );
        }
        var sched = schedules.data!.toList()[widget._currentdate.weekday - 1];
        return RefreshIndicator(
          onRefresh: () async {
            forceRefresh = true;
            setState(() {});
          },
          child: FutureBuilder<List<LessonModel>>(
            future: sched.studentLessons(widget._student),
            builder: (context, lessons) {
              if (!lessons.hasData) {
                return Center(
                  child: Utils.progressIndicator(),
                );
              }
              return headedListview(
                child: Column(
                  children: [
                    ...lessons.data!.map(
                      (lesson) => FutureBuilder(
                        future: lesson.type != LessonType.empty
                            ? Future.wait([
                                lesson.curriculum,
                                lesson.venue,
                                lesson.lessontime,
                                lesson.marksForStudentAsString(widget._student, widget._week.day(sched.day - 1)),
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
                          var list = snap.data!;
                          var cur = lesson.type != LessonType.empty ? list[0] as CurriculumModel : null;
                          var ven = lesson.type != LessonType.empty ? list[1] as VenueModel : null;
                          var tim = lesson.type != LessonType.empty ? list[2] as LessontimeModel : null;
                          var mar = lesson.type != LessonType.empty ? list[3] as String : null;
                          return StudentLessonTile(
                            lesson: lesson,
                            student: widget._student,
                            date: widget._week.day(sched.day - 1),
                            cur: cur,
                            ven: ven,
                            tim: tim,
                            mar: mar,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget headedListview({required Widget child}) => ListView(
        key: PageStorageKey(widget._currentdate),
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              DateFormat('EEEE', 'ru').format(widget._currentdate).capitalizeFirst!,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              DateFormat('d MMMM', 'ru').format(widget._currentdate).capitalizeFirst!,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          child,
        ],
      );
}
