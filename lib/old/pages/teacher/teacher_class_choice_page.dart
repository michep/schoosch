import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/old/model/class_model.dart';
import 'package:schoosch/old/model/curriculum_model.dart';
import 'package:schoosch/old/model/institution_model.dart';
import 'package:schoosch/old/model/status_enum.dart';
import 'package:schoosch/old/pages/teacher/class_cur_marks_table_page.dart';
import 'package:schoosch/old/pages/teacher/class_cur_year_marks_table_page.dart';
import 'package:schoosch/old/widgets/appbar.dart';
import 'package:schoosch/old/widgets/drawer.dart';
import 'package:schoosch/old/widgets/utils.dart';

class TeacherClassChoicePage extends StatelessWidget {
  final CurriculumModel curriculum;
  final ReportType reportType;

  const TeacherClassChoicePage({
    super.key,
    required this.curriculum,
    required this.reportType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(
        'Класс',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<ClassModel>>(
          future: curriculum.classes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Utils.progressIndicator();
            }
            if (snapshot.data!.isEmpty) {
              return const Text('нет доступных предметов.');
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  onTap: () async {
                    switch (reportType) {
                      case ReportType.teacherPeriodMarks:
                        var periods = await InstitutionModel.currentInstitution.currentYearSemesterPeriods;
                        Get.to(() => ClassCurriculumMarksTablePage(
                              currentcur: curriculum,
                              periods: periods.where((e) => e.status == StatusModel.active).toList(),
                              aclass: snapshot.data![index],
                            ));
                        break;
                      case ReportType.teacherYearMarks:
                        var periods = await InstitutionModel.currentInstitution.currentYearAndSemestersPeriods;
                        Get.to(() => ClassCurriculumYearMarksTable(
                              currentcur: curriculum,
                              periods: periods.where((e) => e.status == StatusModel.active).toList(),
                              aclass: snapshot.data![index],
                            ));
                        break;
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
