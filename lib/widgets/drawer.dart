import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/teacher_rate_page.dart';
import 'package:schoosch/widgets/drawerheader.dart';
import 'package:schoosch/pages/about_page.dart';
import 'package:schoosch/pages/map/school_map_page.dart';

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
    if (PersonModel.currentUser!.currentType == 'student') {
      items.add(
        TextButton.icon(
          onPressed: () {
            Get.to(() => RatePage(PersonModel.currentStudent!.studentClass));
          },
          icon: const Icon(Icons.insert_emoticon_outlined),
          label: const Text('Оценить учителей'),
        ),
      );
      items.add(TextButton.icon(
        onPressed: () async {
          ClassModel? clas = await PersonModel.currentStudent!.studentClass;
          Get.to(() => SchoolMapPage(clas));
        },
        icon: const Icon(Icons.map_rounded),
        label: const Text('План школы'),
      ));
    } else if (PersonModel.currentUser!.currentType == 'teacher') {}

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
