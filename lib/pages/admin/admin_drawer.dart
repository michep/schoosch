import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/pages/admin/class_list.dart';
import 'package:schoosch/pages/admin/curriculum_list.dart';
import 'package:schoosch/pages/admin/institution.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/pages/admin/venue_list.dart';
import 'package:schoosch/widgets/drawerheader.dart';
import 'package:schoosch/pages/about_page.dart';

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
              onPressed: _openInstitutionPage,
            ),
            TextButton(
              child: const Text('Кабинеты и помещения'),
              onPressed: _openVenuesPage,
            ),
            TextButton(
              child: const Text('Сотрудники, учителя и ученики'),
              onPressed: _openPeoplePage,
            ),
            TextButton(
              child: const Text('Учебные предметы'),
              onPressed: _openCurriculumsPage,
            ),
            TextButton(
              child: const Text('Учебные классы'),
              onPressed: _openClassesPage,
            ),
            TextButton(
              child: const Text('Расписание уроков на неделю'),
              onPressed: _openSchedulesPage,
            ),
            TextButton(
              child: const Text('о приложении'),
              onPressed: _openAboutPage,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openInstitutionPage() async {
    // Get.back();
    Get.to(() => InstitutionPage(InstitutionModel.currentInstitution));
  }

  Future<void> _openVenuesPage() async {
    // Get.back();
    Get.to(() => VenueListPage(InstitutionModel.currentInstitution));
  }

  Future<void> _openPeoplePage() async {
    // Get.back();
    Get.to(() => PeopleListPage(InstitutionModel.currentInstitution));
  }

  Future<void> _openCurriculumsPage() async {
    // Get.back();
    Get.to(() => CurriculumListPage(InstitutionModel.currentInstitution));
  }

  Future<void> _openClassesPage() async {
    // Get.back();
    Get.to(() => ClassListPage(InstitutionModel.currentInstitution));
  }

  Future<void> _openSchedulesPage() async {
    // Get.back();
    Get.to(() => ClassListPage(InstitutionModel.currentInstitution, listMode: ClassListMode.schedules));
  }

  Future<void> _openAboutPage() async {
    // Get.back();
    Get.to(() => const AboutPage());
  }
}
