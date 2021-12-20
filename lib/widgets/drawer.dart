import 'package:flutter/material.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/people_model.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Get.find<FStore>().currentInstitution!.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Expanded(
                child: Get.find<FStore>().logoImageData != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.memory(
                          Get.find<FStore>().logoImageData!,
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: menuItems(),
        ),
      ],
    );
  }

  List<Widget> menuItems() {
    List<Widget> items = [];
    if (PeopleModel.currentUser?.type == 'student') {
      items.add(
        TextButton.icon(
          onPressed: () {
            Get.to(() => RatePage(
                  aclass: (StudentModel.currentUser).studentClass,
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
