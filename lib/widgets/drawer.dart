import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/teacher_rate_page.dart';
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
    if (PersonModel.currentUser!.currentType == 'student') {
      items.add(
        TextButton.icon(
          onPressed: () {
            Get.to(() => RatePage(PersonModel.currentStudent!.studentClass));
          },
          icon: const Icon(Icons.insert_emoticon_rounded),
          label: const Text('Оценить учителей'),
        ),
      );
    }

    return items;
  }
}
