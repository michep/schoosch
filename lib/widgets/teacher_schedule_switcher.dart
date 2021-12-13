import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/widgets/teacher_schedule.dart';

class TeacherScheduleSwitcher extends StatefulWidget {
  const TeacherScheduleSwitcher({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TeacherScheduleSwitcherState();
}

class TeacherScheduleSwitcherState extends State<TeacherScheduleSwitcher> {
  final _cw = Get.find<CurrentWeek>();
  int currentPage = -1;

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<ClassModel>(
    //     future: ClassModel.currentStudentClass(),
    //     builder: (context, classSnap) {
    //       if (!classSnap.hasData) return Utils.progressIndicator();
    return PageView.custom(
      controller: _cw.pageController,
      onPageChanged: _cw.setIdx,
      childrenDelegate: SliverChildBuilderDelegate(
        (context, idx) {
          return TeacherScheduleWidget(
            PeopleModel.currentUser,
            Week(year: 2021, weekNumber: idx % 100),
            key: ValueKey(idx),
          );
        },
      ),
    );
    // });
  }
}
