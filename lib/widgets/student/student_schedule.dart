import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/student_lesson_page.dart';
import 'package:schoosch/widgets/student/student_dayschedule_tile.dart';
import 'package:schoosch/widgets/student/student_lesson_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentScheduleWidget extends StatefulWidget {
  final ClassModel _class;
  final Week _week;
  final StudentModel _student;

  const StudentScheduleWidget(this._student, this._class, this._week, {Key? key}) : super(key: key);

  @override
  State<StudentScheduleWidget> createState() => _StudentScheduleWidgetState();
}

class _StudentScheduleWidgetState extends State<StudentScheduleWidget> {
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
        var sched = schedules.data!.toList()[DateTime.now().weekday - 1];
        return RefreshIndicator(
          onRefresh: () async {
            forceRefresh = true;
            setState(() {});
          },
          // child: ListView(
          //   children: [
          // ...schedules.data!.map((schedule) => ClassDayScheduleTile(schedule, widget._student, widget._week.day(schedule.day - 1))),
          //   ],
          // ),
          child: FutureBuilder<List<LessonModel>>(
              future: sched.studentLessons(widget._student),
              builder: (context, lessons) {
                if (!lessons.hasData) {
                  return Center(
                    child: Utils.progressIndicator(),
                  );
                }
                return ListView(
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
                          var list = snap.data! as List<dynamic>;
                          var cur = lesson.type != LessonType.empty ? list[0] as CurriculumModel : null;
                          var ven = lesson.type != LessonType.empty ? list[1] as VenueModel : null;
                          var tim = lesson.type != LessonType.empty ? list[2] as LessontimeModel : null;
                          var mar = lesson.type != LessonType.empty ? list[3] as String : null;
                          // return ListTile(
                          //   leading: Text(lesson.order.toString()),
                          //   title: Text(lesson.type == LessonType.empty ? 'Окно' : cur!.aliasOrName),
                          //   tileColor: lesson.type == LessonType.replacment ? Colors.grey.withOpacity(0.1) : null,
                          //   trailing: lesson.type == LessonType.empty
                          //       ? null
                          //       : mar != ""
                          //           ? Container(
                          //               padding: const EdgeInsets.all(5),
                          //               decoration: BoxDecoration(
                          //                 borderRadius: BorderRadius.circular(4),
                          //                 border: Border.all(color: Colors.red, width: 1.5),
                          //               ),
                          //               child: Text(mar!),
                          //             )
                          //           : Container(
                          //               width: 0,
                          //             ),
                          //   subtitle: lesson.type == LessonType.empty ? null : Text('${tim!.formatPeriod()}, ${ven!.name}'),
                          //   onTap: lesson.type != LessonType.empty
                          //       ? () => _onTap(
                          //             lesson,
                          //             cur!,
                          //             ven!,
                          //             tim!,
                          //             widget._week.day(sched.day - 1),
                          //           )
                          //       : null,
                          // );
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
                );
              }),
        );
      },
    );
  }

  void _onTap(LessonModel les, CurriculumModel cur, VenueModel ven, LessontimeModel tim, DateTime date) {
    Get.to(() => StudentLessonPage(widget._student, les, cur, ven, tim, date));
  }
}
