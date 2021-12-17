import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/widgets/student_schedule.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentScheduleSwitcher extends StatefulWidget {
  const StudentScheduleSwitcher({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StudentScheduleSwitcherState();
}

class StudentScheduleSwitcherState extends State<StudentScheduleSwitcher> {
  final _cw = Get.find<CurrentWeek>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClassModel>(
        future: (StudentModel.currentUser).studentClass,
        builder: (context, classSnap) {
          if (!classSnap.hasData) return Utils.progressIndicator();
          return PageView.custom(
            controller: _cw.pageController,
            onPageChanged: _cw.setIdx,
            childrenDelegate: SliverChildBuilderDelegate(
              (context, idx) {
                return StudentScheduleWidget(
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
