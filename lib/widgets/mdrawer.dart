import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/pages/teacher_rate_page.dart';
import 'package:schoosch/widgets/mdrawerheader.dart';

class MDrawer extends StatelessWidget {
  const MDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        drawerHeader(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: menuItems(),
        ),
      ],
    );
  }

  List<Widget> menuItems() {
    List<Widget> items = [];
    if (PeopleModel.currentUser!.currentType == 'student') {
      items.add(
        TextButton.icon(
          onPressed: () {
            Get.to(() => RatePage(
                  aclass: PeopleModel.currentStudent!.studentClass,
                ));
          },
          icon: const Icon(Icons.insert_emoticon_rounded),
          label: const Text('Оценить учителей'),
        ),
      );
    }

    return items;
  }
}
