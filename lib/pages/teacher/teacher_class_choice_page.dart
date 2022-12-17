import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
// import 'package:schoosch/model/person_model.dart';
// import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pages/teacher/teacher_marks_table_page.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassChoicePage extends StatelessWidget {
  final CurriculumModel curriculum;
  // final List<StudyPeriodModel> periods;
  const ClassChoicePage({Key? key, required this.curriculum,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(
        'Предмет',
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
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  onTap: () async {
                    var periods = await InstitutionModel.currentInstitution.currentYearSemesterPeriods;
                    Get.to(() => TeacherTablePage(
                          // currentcur: snapshot.data![index],
                          currentcur: curriculum,
                          periods: periods,
                          aclass: snapshot.data![index],
                        ));
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
