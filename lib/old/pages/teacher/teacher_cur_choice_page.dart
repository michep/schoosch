import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/old/model/curriculum_model.dart';
import 'package:schoosch/old/model/person_model.dart';
import 'package:schoosch/old/pages/teacher/teacher_class_choice_page.dart';
import 'package:schoosch/old/widgets/appbar.dart';
import 'package:schoosch/old/widgets/drawer.dart';
import 'package:schoosch/old/widgets/utils.dart';

class TeacherCurriculumChoicePage extends StatelessWidget {
  final TeacherModel teacher;
  final ReportType reportType;

  const TeacherCurriculumChoicePage({
    required this.teacher,
    required this.reportType,
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
          future: teacher.curriculums(),
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
                    Get.to(
                      () => TeacherClassChoicePage(
                        curriculum: snapshot.data![index],
                        reportType: reportType,
                      ),
                    );
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
