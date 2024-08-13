import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/absence_period_choice_page.dart';
import 'package:schoosch/pages/observer/observer_curriculum_choice_page.dart';
import 'package:schoosch/pages/observer/observer_student_choice_page.dart';
import 'package:schoosch/pages/student_marks_table_page.dart';
import 'package:schoosch/pages/student/student_year_marks_table_page.dart';
import 'package:schoosch/pages/teacher/teacher_cur_choice_page.dart';
import 'package:schoosch/pdf/pdf_preview.dart';
import 'package:schoosch/pdf/pdf_classesweekschedule.dart';
import 'package:schoosch/pdf/pdf_theme.dart';
import 'package:schoosch/widgets/drawerheader.dart';

enum ReportType {
  teacherPeriodMarks,
  teacherYearMarks,
}

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
            Get.to(() => StudentMarksTablePage(student: PersonModel.currentStudent!, periods: periods));
          },
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text('Успеваемость'),
        ),
      );
      items.add(
        TextButton.icon(
          onPressed: () async {
            var periods = await InstitutionModel.currentInstitution.currentYearAndSemestersPeriods;
            Get.to(() => StudentYearMarksTablePage(student: PersonModel.currentStudent!, periods: periods));
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
            Get.to(
              () => TeacherCurriculumChoicePage(
                teacher: PersonModel.currentTeacher!,
                reportType: ReportType.teacherPeriodMarks,
              ),
            );
          },
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text('Ваши оценки'),
        ),
      );
      items.add(
        TextButton.icon(
          onPressed: () async {
            // ClassModel? clas = await PersonModel.currentStudent!.studentClass;
            Get.to(() => TeacherCurriculumChoicePage(
                  teacher: PersonModel.currentTeacher!,
                  reportType: ReportType.teacherYearMarks,
                ));
          },
          icon: const Icon(Icons.power_input_rounded),
          label: const Text('Ваши итоговые оценки'),
        ),
      );
    } else if (PersonModel.currentUser!.currentType == PersonType.parent) {
      items.add(
        TextButton.icon(
          onPressed: () async {
            // ClassModel? clas = await PersonModel.currentStudent!.studentClass;
            var stud = await PersonModel.currentParent!.currentChild;
            var periods = await InstitutionModel.currentInstitution.currentYearSemesterPeriods;

            Get.to(() => StudentMarksTablePage(student: stud, periods: periods));
          },
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text('Успеваемость'),
        ),
      );
      items.add(
        TextButton.icon(
          onPressed: () async {
            var student = await PersonModel.currentParent!.currentChild;
            var periods = await InstitutionModel.currentInstitution.currentYearAndSemestersPeriods;

            Get.to(() => StudentYearMarksTablePage(student: student, periods: periods));
          },
          icon: const Icon(Icons.power_input_rounded),
          label: const Text('Итоговые оценки'),
        ),
      );
      items.add(
        TextButton.icon(
          onPressed: () async {
            var periods = await InstitutionModel.currentInstitution.currentYearSemesterPeriods;
            var student = await PersonModel.currentParent!.currentChild;
            var aclass = await (await PersonModel.currentParent!.currentChild).studentClass;
            Get.to(
              () => AbsencePeriodChoicePage(
                aclass: aclass,
                periods: periods,
                singleStudent: student,
              ),
            );
          },
          icon: const Icon(Icons.person_off_rounded),
          label: const Text('Пропуски'),
        ),
      );
    } else if (PersonModel.currentUser!.currentType == PersonType.observer) {
      items.add(
        TextButton.icon(
          onPressed: () async {
            Get.to(() => ObserverCurriculumChoicePage(
                  aclass: Get.find<ProxyStore>().currentObserverClass!,
                ));
          },
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text('Оценки учеников класса'),
        ),
      );
      items.add(
        TextButton.icon(
          onPressed: () async {
            Get.to(
              () => ObserverCurriculumChoicePage(
                aclass: Get.find<ProxyStore>().currentObserverClass!,
                isYear: true,
              ),
            );
          },
          icon: const Icon(Icons.power_input_rounded),
          label: const Text('Итоговые оценки учеников'),
        ),
      );
      items.add(
        TextButton.icon(
          onPressed: () async {
            var periods = await InstitutionModel.currentInstitution.currentYearSemesterPeriods;
            Get.to(
              () => AbsencePeriodChoicePage(
                aclass: Get.find<ProxyStore>().currentObserverClass!,
                periods: periods,
              ),
            );
          },
          icon: const Icon(Icons.person_off_rounded),
          label: const Text('Пропуски учеников'),
        ),
      );
      items.add(const Divider());
      items.add(
        TextButton.icon(
          onPressed: () async {
            var periods = await InstitutionModel.currentInstitution.currentYearSemesterPeriods;
            var students = await Get.find<ProxyStore>().currentObserverClass!.students();
            Get.to(() => ObserverStudentChoicePage(
                  periods: periods,
                  students: students,
                ));
          },
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text('Оценки ученика'),
        ),
      );
      items.add(
        TextButton.icon(
          onPressed: () async {
            var periods = await InstitutionModel.currentInstitution.currentYearAndSemestersPeriods;
            var students = await Get.find<ProxyStore>().currentObserverClass!.students();
            Get.to(() => ObserverStudentChoicePage(
                  periods: periods,
                  students: students,
                  selectPeriods: false,
                ));
          },
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text('Итоговые оценки ученика'),
        ),
      );
    }
    // if (PersonModel.currentUser!.currentType == PersonType.observer) {
    //   items.add(
    //     TextButton.icon(
    //       onPressed: () {
    //         Get.to(() => TeacherYearMarksTable(currentcur: currentcur, periods: periods));
    //       },
    //       icon: const Icon(Icons.power_input_rounded),
    //       label: const Text('Итоговые оценки'),
    //     ),
    //   );
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
    // if (PersonModel.currentUser!.types.contains(PersonType.admin)) {
    items.add(const Divider());
    items.add(
      TextButton.icon(
        onPressed: () async {
          var classes = await InstitutionModel.currentInstitution.classes;
          var cw = Get.find<CurrentWeek>().currentWeek;

          Get.to(
            () => PDFPreview(
              format: landscapePdfPageFormat,
              generate: PDFClassesWeekSchedule(
                classes: classes.where((element) => element.grade > 4).toList(),
                week: cw,
              ).generate,
            ),
          );
        },
        icon: const Icon(Icons.table_chart_outlined),
        label: const Text('Печать расписания'),
      ),
    );
    // }
    return items;
  }
}
