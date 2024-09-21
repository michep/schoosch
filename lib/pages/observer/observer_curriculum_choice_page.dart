import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/status_enum.dart';
import 'package:schoosch/pages/teacher/class_cur_marks_table_page.dart';
import 'package:schoosch/pages/teacher/class_cur_year_marks_table_page.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class ObserverCurriculumChoicePage extends StatelessWidget {
  final bool isYear;
  final ClassModel aclass;

  const ObserverCurriculumChoicePage({
    required this.aclass,
    this.isYear = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(
        'Предмет',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<CurriculumModel>>(
          future: InstitutionModel.currentInstitution.currentYearPeriod.then((period) => aclass.curriculums(period!)),
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
                  title: Text(snapshot.data![index].aliasOrName),
                  onTap: () async {
                    var periods = isYear
                        ? await InstitutionModel.currentInstitution.currentYearAndSemestersPeriods
                        : await InstitutionModel.currentInstitution.currentYearSemesterPeriods;
                    isYear
                        ? Get.to(
                            () => ClassCurriculumYearMarksTable(
                              currentcur: snapshot.data![index],
                              periods: periods.where((e) => e.status == StatusModel.active).toList(),
                              aclass: aclass,
                            ),
                          )
                        : Get.to(() => ClassCurriculumMarksTablePage(
                              currentcur: snapshot.data![index],
                              periods: periods.where((e) => e.status == StatusModel.active).toList(),
                              aclass: aclass,
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
