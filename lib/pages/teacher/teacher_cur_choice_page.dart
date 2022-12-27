import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/teacher/teacher_class_choice_page.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class CurriculumChoicePage extends StatelessWidget {
  final bool isYear;
  const CurriculumChoicePage({Key? key, this.isYear = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(
        'Предмет',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<CurriculumModel>>(
          future: PersonModel.currentTeacher!.curriculums(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Utils.progressIndicator();
            }
            if (snapshot.data!.isEmpty) {
              return const Text('нет доступных предметов.');
            }
            return ListView.builder(
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(snapshot.data![index].aliasOrName),
                  onTap: () async {
                    var periods = await InstitutionModel.currentInstitution.currentYearSemesterPeriods;
                    // Get.to(() => TeacherTablePage(
                    //       currentcur: snapshot.data![index],
                    //       periods: periods,
                    //     ));
                  
                        Get.to(
                            () => ClassChoicePage(
                              curriculum: snapshot.data![index],
                              isYear: isYear,
                            ),
                          );
                  },
                );
              },
              itemCount: snapshot.data!.length,
            );
          },
        ),
      ),
    );
  }
}
