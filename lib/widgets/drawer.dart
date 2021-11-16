import 'package:flutter/material.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import '../pages/teacher_rate_page.dart';
import 'package:get/get.dart';

class MDrawer extends StatelessWidget {
  const MDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: const Text(
            'Schoosch / Скуш',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Column(
          children: [
            TextButton.icon(
              onPressed: () {
                Get.to(() => RatePage(teachers: Get.find<FStore>().getUserTeachers(),));
              },
              icon: Icon(Icons.access_alarms),
              label: Text("What"),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ],
    );
  }
}
