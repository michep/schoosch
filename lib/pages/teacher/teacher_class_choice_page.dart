import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/pages/teacher/class_cur_marks_table_page.dart';
import 'package:schoosch/pages/teacher/class_cur_year_marks_table_page.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassChoicePage extends StatelessWidget {
  final CurriculumModel curriculum;
  final bool isYear;
  final bool isAbsences;
  const ClassChoicePage({
    super.key,
    required this.curriculum,
    this.isYear = false,
    this.isAbsences = false,
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
                    var periods = isYear
                        ? await InstitutionModel.currentInstitution.currentYearAndSemestersPeriods
                        : await InstitutionModel.currentInstitution.currentYearSemesterPeriods;
                    isYear
                        ? Get.to(
                            () => ClassCurriculumYearMarksTable(
                              currentcur: curriculum,
                              periods: periods,
                              aclass: snapshot.data![index],
                            ),
                          )
                        : Get.to(() => ClassCurriculumMarksTablePage(
                              currentcur: curriculum,
                              periods: periods,
                              aclass: snapshot.data![index],
                            ));
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
