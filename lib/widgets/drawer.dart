import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/all_marks_table_page.dart';
import 'package:schoosch/pages/student/student_periods_marks.dart';
import 'package:schoosch/pages/teacher/teacher_cur_choice_page.dart';
import 'package:schoosch/pdf/pdf_preview.dart';
import 'package:schoosch/pdf/pdf_classesweekschedule.dart';
import 'package:schoosch/pdf/pdf_theme.dart';
import 'package:schoosch/widgets/drawerheader.dart';

class MDrawer extends StatelessWidget {
  const MDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        drawerHeader(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _menuItems(),
        ),
      ],
    );
  }

  List<Widget> _menuItems() {
    List<Widget> items = [];
    if (PersonModel.currentUser!.currentType == PersonType.student) {
      // items.add(
      //   TextButton.icon(
      //     onPressed: () {
      //       Get.to(() => RatePage(PersonModel.currentStudent!.studentClass));
      //     },
      //     icon: const Icon(Icons.insert_emoticon_outlined),
      //     label: const Text('Оценить учителей'),
      //   ),
      // );
      // if (Get.find<BlueprintController>().canShow) {
      //   items.add(
      //     TextButton.icon(
      //       onPressed: () async {
      //         ClassModel? clas = await PersonModel.currentStudent!.studentClass;
      //         Get.to(() => SchoolMapPage(clas));
      //       },
      //       icon: const Icon(Icons.map_rounded),
      //       label: const Text('План школы'),
      //     ),
      //   );
      // }
      items.add(
        TextButton.icon(
          onPressed: () async {
            var periods = await InstitutionModel.currentInstitution.currentYearSemesterPeriods;
            Get.to(() => StudentsTablePage(student: PersonModel.currentStudent!, periods: periods));
          },
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text('Все оценки'),
        ),
      );
      items.add(
        TextButton.icon(
          onPressed: () async {
            var periods = await InstitutionModel.currentInstitution.currentYearAndSemestersPeriods;
            Get.to(() => StudentPeriodicMarksScreen(student: PersonModel.currentStudent!, periods: periods));
          },
          icon: const Icon(Icons.power_input_rounded),
          label: const Text('Итоговые оценки'),
        ),
      );
    } else if (PersonModel.currentUser!.currentType == PersonType.teacher) {
      items.add(
        TextButton.icon(
          onPressed: () async {
            // ClassModel? clas = await PersonModel.currentStudent!.studentClass;
            Get.to(() => const CurriculumChoicePage());
          },
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text('Ваши оценки'),
        ),
      );
      items.add(
        TextButton.icon(
          onPressed: () async {
            // ClassModel? clas = await PersonModel.currentStudent!.studentClass;
            Get.to(
              () => const CurriculumChoicePage(
                isYear: true,
              ),
            );
          },
          icon: const Icon(Icons.power_input_rounded),
          label: const Text('Итоговые оценки'),
        ),
      );
    } else if (PersonModel.currentUser!.currentType == PersonType.parent) {
      items.add(
        TextButton.icon(
          onPressed: () async {
            // ClassModel? clas = await PersonModel.currentStudent!.studentClass;
            var stud = await PersonModel.currentParent!.currentChild;
            var periods = await InstitutionModel.currentInstitution.currentYearSemesterPeriods;

            Get.to(() => StudentsTablePage(student: stud, periods: periods));
          },
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text('Успеваемость'),
        ),
      );
      items.add(
        TextButton.icon(
          onPressed: () async {
            // ClassModel? clas = await PersonModel.currentStudent!.studentClass;
            var stud = await PersonModel.currentParent!.currentChild;
            var periods = await InstitutionModel.currentInstitution.currentYearSemesterPeriods;

            Get.to(() => StudentPeriodicMarksScreen(
                  periods: periods,
                  student: stud,
                ));
          },
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text('Итоговые оценки'),
        ),
      );
    }
    // if(PersonModel.currentUser!.currentType == PersonType.observer) {
    //   items.add(
    //   TextButton.icon(
    //     onPressed: () {
    //       Get.to(() => TeacherYearMarksTable(currentcur: currentcur, periods: periods));
    //     },
    //     icon: const Icon(Icons.power_input_rounded),
    //     label: const Text('Итоговые оценки'),
    //   ),
    // );
    // }
    // items.add(
    //   TextButton.icon(
    //     onPressed: () {
    //       Get.to(() => const AllChatsPage());
    //     },
    //     icon: const Icon(Icons.chat_rounded),
    //     label: const Text('общение'),
    //   ),
    // );
    // items.add(
    //   TextButton.icon(
    //     onPressed: () {
    //       Get.to(() => const AboutPage());
    //     },
    //     icon: const Icon(Icons.info_outline),
    //     label: const Text('о приложении'),
    //   ),
    // );
    if (PersonModel.currentUser!.types.contains(PersonType.admin)) {
      items.add(
        TextButton.icon(
          onPressed: () async {
            var classes = await InstitutionModel.currentInstitution.classes;
            var cw = Get.find<CurrentWeek>().currentWeek;

            Get.to(
              () => PDFPreview(
                format: landscapePdfPageFormat,
                generate: PDFClassesWeekSchedule(
                  classes: classes.sublist(4),
                  week: cw,
                ).generate,
              ),
            );
          },
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text('Печать расписания'),
        ),
      );
    }
    return items;
  }
}
