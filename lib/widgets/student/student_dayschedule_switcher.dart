import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isoweek/isoweek.dart';
// import 'package:mongo_dart/mongo_dart.dart';
import 'package:schoosch/controller/day_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/student/student_dayschedule.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentDayScheduleSwitcher extends StatefulWidget {
  final StudentModel _student;
  const StudentDayScheduleSwitcher(this._student, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StudentDayScheduleSwitcherState();
}

class StudentDayScheduleSwitcherState extends State<StudentDayScheduleSwitcher> {
  final _cd = Get.find<CurrentDay>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClassModel?>(
        future: widget._student.studentClass,
        builder: (context, classSnap) {
          if (!classSnap.hasData) return Utils.progressIndicator();
          if (classSnap.data == null) return const Center(child: Text('У ученика не определен класс'));
          return PageView.custom(
            controller: _cd.pageController,
            onPageChanged: _cd.setIdx,
            childrenDelegate: SliverChildBuilderDelegate(
              (context, idx) {
                var dt = DateFormat('y D').parse('${idx ~/ 1000} ${idx % 1000}');
                return StudentDayScheduleWidget(
                  widget._student,
                  classSnap.data!,
                  Week(year: idx ~/ 1000, weekNumber: Week.fromDate(dt).weekNumber),
                  dt,
                  key: ValueKey(idx),
                );
              },
            ),
          );
        });
  }
}
