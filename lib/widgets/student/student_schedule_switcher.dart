import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/student/student_schedule.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentScheduleSwitcher extends StatefulWidget {
  final StudentModel _student;
  const StudentScheduleSwitcher(this._student, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StudentScheduleSwitcherState();
}

class StudentScheduleSwitcherState extends State<StudentScheduleSwitcher> {
  final _cw = Get.find<CurrentWeek>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClassModel?>(
        future: widget._student.studentClass,
        builder: (context, classSnap) {
          if (!classSnap.hasData) return Utils.progressIndicator();
          if (classSnap.data == null) return const Center(child: Text('У ученика не определен класс'));
          return PageView.custom(
            controller: _cw.pageController,
            onPageChanged: _cw.setIdx,
            childrenDelegate: SliverChildBuilderDelegate(
              (context, idx) {
                return StudentScheduleWidget(
                  widget._student,
                  classSnap.data!,
                  Week(year: idx ~/ 100, weekNumber: idx % 100),
                  key: ValueKey(idx),
                );
              },
            ),
          );
        });
  }
}
