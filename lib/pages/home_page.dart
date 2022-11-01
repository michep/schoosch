import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/day_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/class_selection_page.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/day_selector.dart';
import 'package:schoosch/widgets/drawer.dart';
import 'package:schoosch/widgets/student/student_dayschedule_switcher.dart';
import 'package:schoosch/widgets/student/student_weekschedule_switcher.dart';
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
            // if (PersonModel.currentUser!.currentType != PersonType.observer) WeekSelector(key: ValueKey(Get.find<CurrentWeek>().currentWeek.weekNumber)),

            // DaySelector(
            //   key: ValueKey(
            //     int.parse(DateFormat('D').format(Get.find<CurrentDay>().currentDay)),
            //   ),
            // ),
            getSelector(),
            Expanded(
              child: _mainPageSelector(PersonModel.currentUser!),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSelector() {
    if (PersonModel.currentUser!.currentType == PersonType.observer) {
      return const SizedBox.shrink();
    } else {
      if (PersonModel.currentUser!.viewByDays && PersonModel.currentUser!.currentType == PersonType.student) {
        return DaySelector(
          key: ValueKey(
            int.parse(DateFormat('D').format(Get.find<CurrentDay>().currentDay)),
          ),
        );
      } else {
        return WeekSelector(
          key: ValueKey(Get.find<CurrentWeek>().currentWeek.weekNumber),
        );
      }
    }
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
            return StudentWeekScheduleSwitcher(snapshot.data!);
          });
    }
    if (user.currentType == PersonType.student) {
      return user.viewByDays ? StudentDayScheduleSwitcher(PersonModel.currentStudent!) : StudentWeekScheduleSwitcher(PersonModel.currentStudent!);
    }
    // if (user.currentType == PersonType.student) return StudentDayScheduleSwitcher(PersonModel.currentStudent!);
    if (user.currentType == PersonType.observer) return ObserverClassSelectionPage(PersonModel.currentObserver!);
    return const Center(child: Text('unknown person type'));
  }
}
