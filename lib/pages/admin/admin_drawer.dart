import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/pages/admin/institution_page.dart';
import 'package:schoosch/widgets/drawerheader.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        drawerHeader(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              child: const Text('Информация об учебном заведении'),
              onPressed: openInstitutionPage,
            ),
            TextButton(onPressed: () {}, child: const Text('Кабинеты и помещения')),
            TextButton(onPressed: () {}, child: const Text('Сотрудники, учителя и ученики')),
            TextButton(onPressed: () {}, child: const Text('Учебные предметы')),
            TextButton(onPressed: () {}, child: const Text('Классы')),
            TextButton(onPressed: () {}, child: const Text('Расписание уроков на неделю')),
          ],
        ),
      ],
    );
  }

  Future<void> openInstitutionPage() async {
    Get.back();
    Get.to<String>(() => InstitutionPage(InstitutionModel.currentInstitution));
  }
}
