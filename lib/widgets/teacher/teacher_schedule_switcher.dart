import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/teacher/teacher_weekschedule.dart';

class TeacherScheduleSwitcher extends StatefulWidget {
  final TeacherModel _teacher;

  const TeacherScheduleSwitcher(this._teacher, {super.key});

  @override
  State<StatefulWidget> createState() => TeacherScheduleSwitcherState();
}

class TeacherScheduleSwitcherState extends State<TeacherScheduleSwitcher> {
  final _cw = Get.find<CurrentWeek>();
  final bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: bucket,
      child: PageView.custom(
        controller: _cw.pageController,
        onPageChanged: _cw.setIdx,
        childrenDelegate: SliverChildBuilderDelegate(
          (context, idx) {
            return TeacherScheduleWidget(
              widget._teacher,
              Week(year: idx ~/ 100, weekNumber: idx % 100),
              key: ValueKey(idx),
            );
          },
        ),
      ),
    );
  }
}
