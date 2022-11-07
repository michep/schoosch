import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/all_marks_table_page.dart';
import 'package:schoosch/pages/teacher/teacher_cur_choice_page.dart';
import 'package:schoosch/pdf/preview.dart';
import 'package:schoosch/pdf/pdf_schedule.dart';
import 'package:schoosch/widgets/drawerheader.dart';

class MDrawer extends StatelessWidget {
  const MDrawer({Key? key}) : super(key: key);

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
            // ClassModel? clas = await PersonModel.currentStudent!.studentClass;
            Get.to(() => StudentsTablePage(student: PersonModel.currentStudent!));
          },
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text('все оценки'),
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
          label: const Text('ваши оценки'),
        ),
      );
    } else if (PersonModel.currentUser!.currentType == PersonType.parent) {
      items.add(
        TextButton.icon(
          onPressed: () async {
            // ClassModel? clas = await PersonModel.currentStudent!.studentClass;
            StudentModel stud = await PersonModel.currentParent!.currentChild;
            Get.to(
              () => StudentsTablePage(
                student: stud,
              ),
            );
          },
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text('успеваемость'),
        ),
      );
    }
    // if(PersonModel.currentUser!.currentType == PersonType.observer) {
    //   items.add(
    //   TextButton.icon(
    //     onPressed: () {
    //       Get.to(() => const FreeTeachersPage());
    //     },
    //     icon: const Icon(Icons.free_cancellation_outlined),
    //     label: const Text('свободные уроки'),
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
    if (PersonModel.currentUser!.types.contains(PersonType.parent)) {
      items.add(
        TextButton.icon(
          onPressed: () async {
            Map<ClassModel, List<ClassScheduleModel>> data = {};
            var classes = await InstitutionModel.currentInstitution.classes;
            classes.sort((a, b) => a.grade.compareTo(b.grade));
            var cw = Get.find<CurrentWeek>().currentWeek;
            for (var cls in classes) {
              var sched = await cls.getClassSchedulesWeek(cw);
              data[cls] = sched;
            }
            Get.to(
              () => Preview(
                format: PdfPageFormat.a4.landscape,
                generate: PDFSchedule(
                  data: data,
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
