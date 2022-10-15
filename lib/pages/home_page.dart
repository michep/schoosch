import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/class_selection_page.dart';
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
      appBar: MAppBar(
        S.of(context).appBarTitle,
        showProfile: true,
        showSendNotif: false,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (PersonModel.currentUser!.currentType != PersonType.observer)
              WeekSelector(key: ValueKey(Get.find<CurrentWeek>().currentWeek.weekNumber)),
            Expanded(
              child: _mainPageSelector(PersonModel.currentUser!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainPageSelector(PersonModel user) {
    if (user.currentType == PersonType.teacher) return TeacherScheduleSwitcher(PersonModel.currentTeacher!);
    if (user.currentType == PersonType.parent) {
      return FutureBuilder<StudentModel>(
          future: PersonModel.currentParent!.currentChild,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }
            return StudentScheduleSwitcher(snapshot.data!);
          });
    }
    if (user.currentType == PersonType.student) return StudentScheduleSwitcher(PersonModel.currentStudent!);
    if (user.currentType == PersonType.observer) return ObserverClassSelectionPage(PersonModel.currentObserver!);
    return const Center(child: Text('unknown person type'));
  }
}
