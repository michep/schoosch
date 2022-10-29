import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/day_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentScheduleSwitcher extends StatefulWidget {
  final StudentModel _student;
  const StudentScheduleSwitcher(this._student, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StudentScheduleSwitcherState();
}

class StudentScheduleSwitcherState extends State<StudentScheduleSwitcher> {
  final _cd = Get.find<CurrentDay>();

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(future: widget._class.get, builder: (context, snapshot) {},)
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
                // return StudentScheduleWidget(
                //   widget._student,
                //   classSnap.data!,
                //   Week(year: idx ~/ 100, weekNumber: idx % 100),
                //   key: ValueKey(idx),
                // );
                return Container();
              },
            ),
          );
        });
  }
}