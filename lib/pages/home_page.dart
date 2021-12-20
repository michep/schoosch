import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/drawer.dart';
import 'package:schoosch/widgets/student/student_schedule_switcher.dart';
import 'package:schoosch/widgets/teacher/teacher_schedule_switcher.dart';
import 'package:schoosch/widgets/week_selector.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: MDrawer(),
      ),
      appBar: const MAppBar(
        'Schoosch / Скуш',
        showProfile: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WeekSelector(key: ValueKey(Get.find<CurrentWeek>().currentWeek.weekNumber)),
            Expanded(
              child: mainPage(PeopleModel.currentUser!),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainPage(PeopleModel user) {
    switch (user.type) {
      case 'teacher':
        return TeacherScheduleSwitcher(TeacherModel.currentUser);
      case 'parent':
        return FutureBuilder<StudentModel>(
            future: ParentModel.currentUser.selectedStudent,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return StudentScheduleSwitcher(snapshot.data!);
            });
      default:
        return StudentScheduleSwitcher(StudentModel.currentUser);
    }
  }
}
