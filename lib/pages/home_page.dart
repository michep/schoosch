import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/drawer.dart';
import 'package:schoosch/widgets/student_schedule_switcher.dart';
import 'package:schoosch/widgets/teacher_schedule_switcher.dart';
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
        return const TeacherScheduleSwitcher();
      case 'parent':
        throw 'parent view not implemented yet';
      default:
        return const StudentScheduleSwitcher();
    }
  }
}
