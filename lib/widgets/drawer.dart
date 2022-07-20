import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/all_chats_page.dart';
import 'package:schoosch/pages/all_marks_table_page.dart';
import 'package:schoosch/pages/free_teachers_page.dart';
import 'package:schoosch/pages/teacher/teacher_cur_choice_page.dart';
import 'package:schoosch/pages/teacher_rate_page.dart';
import 'package:schoosch/widgets/drawerheader.dart';
import 'package:schoosch/pages/about_page.dart';

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
      items.add(
        TextButton.icon(
          onPressed: () {
            Get.to(() => RatePage(PersonModel.currentStudent!.studentClass));
          },
          icon: const Icon(Icons.insert_emoticon_outlined),
          label: const Text('Оценить учителей'),
        ),
      );
      // items.add(
      //   TextButton.icon(
      //     onPressed: () async {
      //       ClassModel? clas = await PersonModel.currentStudent!.studentClass;
      //       Get.to(() => SchoolMapPage(clas));
      //     },
      //     icon: const Icon(Icons.map_rounded),
      //     label: const Text('План школы'),
      //   ),
      // );
      items.add(
        TextButton.icon(
          onPressed: () async {
            // ClassModel? clas = await PersonModel.currentStudent!.studentClass;
            Get.to(() => const StudentsTablePage());
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
    items.add(
      TextButton.icon(
        onPressed: () {
          Get.to(() => const AllChatsPage());
        },
        icon: const Icon(Icons.chat_rounded),
        label: const Text('общение'),
      ),
    );
    items.add(
      TextButton.icon(
        onPressed: () {
          Get.to(() => const AboutPage());
        },
        icon: const Icon(Icons.info_outline),
        label: const Text('о приложении'),
      ),
    );

    return items;
  }
}
