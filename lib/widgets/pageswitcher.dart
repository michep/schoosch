import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/widgets/student_schedule.dart';
import 'package:schoosch/widgets/utils.dart';

class SchedulePageView extends StatefulWidget {
  const SchedulePageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SchedulePageViewState();
}

class SchedulePageViewState extends State<SchedulePageView> {
  final _cw = Get.find<CurrentWeek>();
  int currentPage = -1;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClassModel>(
        future: ClassModel.currentStudentClass(),
        builder: (context, classSnap) {
          if (!classSnap.hasData) return Utils.progressIndicator();
          return PageView.custom(
            controller: _cw.pageController,
            onPageChanged: _cw.setIdx,
            childrenDelegate: SliverChildBuilderDelegate(
              (context, idx) {
                return StudentScheduleWidget(
                  classSnap.data!,
                  Week(year: 2021, weekNumber: idx % 100),
                  key: ValueKey(idx),
                );
              },
            ),
          );
        });
  }
}
