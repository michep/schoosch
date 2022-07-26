import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/pages/admin/class_list.dart';
import 'package:schoosch/pages/admin/curriculum_list.dart';
import 'package:schoosch/pages/admin/daylessontime_list.dart';
import 'package:schoosch/pages/admin/institution.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/pages/admin/class_choice_page.dart';
import 'package:schoosch/pages/admin/venue_list.dart';
import 'package:schoosch/pages/free_teachers_page.dart';
import 'package:schoosch/widgets/drawerheader.dart';
import 'package:schoosch/pages/about_page.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return ListView(
      children: [
        drawerHeader(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: _openInstitutionPage,
              child: Text(loc.editInstitution),
            ),
            TextButton(
              onPressed: _openVenuesPage,
              child: Text(loc.venueList),
            ),
            TextButton(
              onPressed: _openPeoplePage,
              child: Text(loc.peopleList),
            ),
            TextButton(
              onPressed: _openCurriculumsPage,
              child: Text(loc.curriculumList),
            ),
            TextButton(
              onPressed: _openReplacementsPage,
              child: const Text('Replacements'),
            ),
            TextButton(
              onPressed: _openFreeTeachersPage,
              child: const Text('Free teachers'),
            ),
            TextButton(
              onPressed: _openFreeLessonsPage,
              child: const Text('Free lessons'),
            ),
            TextButton(
              onPressed: _openClassesPage,
              child: Text(loc.classList),
            ),
            TextButton(
              onPressed: _openDayLessontimePage,
              child: Text(loc.dayLessontimeList),
            ),
            TextButton(
              onPressed: _openSchedulesPage,
              child: Text(loc.dayScheduleList),
            ),
            TextButton(
              onPressed: _openAboutPage,
              child: const Text('о приложении'),
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

  Future<void> _openFreeTeachersPage() async {
    // Get.back();
    Get.to(() => FreeTeachersPage(InstitutionModel.currentInstitution));
  }

  Future<void> _openFreeLessonsPage() async {
    // Get.back();
    Get.to(() => ClassChoicePage(InstitutionModel.currentInstitution, false));
  }

  Future<void> _openClassesPage() async {
    // Get.back();
    Get.to(() => ClassListPage(InstitutionModel.currentInstitution));
  }

  Future<void> _openReplacementsPage() async {
    // Get.back();
    Get.to(() => ClassChoicePage(InstitutionModel.currentInstitution, true));
  }

  Future<void> _openDayLessontimePage() async {
    // Get.back();
    Get.to(() => DayLessontimeListPage(InstitutionModel.currentInstitution));
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
