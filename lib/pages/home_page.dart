import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/day_controller.dart';
import 'package:schoosch/controller/prefs_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/observer/class_selection.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/day_selector.dart';
import 'package:schoosch/widgets/drawer.dart';
import 'package:schoosch/widgets/student/student_dayschedule_switcher.dart';
import 'package:schoosch/widgets/student/student_weekschedule_switcher.dart';
import 'package:schoosch/widgets/teacher/teacher_schedule_switcher.dart';
import 'package:schoosch/widgets/week_selector.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: MDrawer(),
      ),
      appBar: MAppBar(
        AppLocalizations.of(context)!.appBarTitle,
        showProfile: true,
        showSendNotif: false,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _getSelector(),
            Expanded(
              child: _mainPageSelector(PersonModel.currentUser!, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSelector() {
    if (PersonModel.currentUser!.currentType == PersonType.observer) {
      return const SizedBox.shrink();
    } else {
      return Obx(() {
        var prefs = Get.find<PrefsController>();
        if (prefs.dayview && PersonModel.currentUser!.currentType == PersonType.student) {
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
      });
    }
  }

  Widget _mainPageSelector(PersonModel user, BuildContext context) {
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
      return Obx(() {
        var prefs = Get.find<PrefsController>();
        return prefs.dayview ? StudentDayScheduleSwitcher(PersonModel.currentStudent!) : StudentWeekScheduleSwitcher(PersonModel.currentStudent!);
      });
    }
    if (user.currentType == PersonType.observer) return ClassSelection(PersonModel.currentObserver!);
    return Center(child: Text(AppLocalizations.of(context)!.errorUnknownPersonType));
  }
}
