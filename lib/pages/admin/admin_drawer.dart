import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/pages/admin/class_list.dart';
import 'package:schoosch/pages/admin/curriculum_list.dart';
import 'package:schoosch/pages/admin/institution.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/pages/admin/venue_list.dart';
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
            TextButton(
              child: const Text('Кабинеты и помещения'),
              onPressed: openVenuePage,
            ),
            TextButton(
              child: const Text('Сотрудники, учителя и ученики'),
              onPressed: openPeoplePage,
            ),
            TextButton(
              child: const Text('Учебные предметы'),
              onPressed: openCurriculumPage,
            ),
            TextButton(
              child: const Text('Учебные классы'),
              onPressed: openClassPage,
            ),
            TextButton(
              child: const Text('Расписание уроков на неделю'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  void openInstitutionPage() {
    Get.back();
    Get.to(() => InstitutionPage(InstitutionModel.currentInstitution));
  }

  void openVenuePage() {
    Get.back();
    Get.to(() => VenueListPage(InstitutionModel.currentInstitution));
  }

  Future<void> openPeoplePage() async {
    Get.back();
    Get.to(() => PeopleListPage(InstitutionModel.currentInstitution));
  }

  Future<void> openCurriculumPage() async {
    Get.back();
    Get.to(() => CurriculumListPage(InstitutionModel.currentInstitution));
  }

  Future<void> openClassPage() async {
    Get.back();
    Get.to(() => ClassListPage(InstitutionModel.currentInstitution));
  }
}
