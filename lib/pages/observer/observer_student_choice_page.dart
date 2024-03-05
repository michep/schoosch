import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pages/observer/observer_period_choice_page.dart';
import 'package:schoosch/pdf/pdf_preview.dart';
import 'package:schoosch/pdf/pdf_studentyearmarks.dart';
import 'package:schoosch/pdf/pdf_theme.dart';
import 'package:schoosch/widgets/appbar.dart';

class ObserverStudentChoicePage extends StatelessWidget {
  final List<StudyPeriodModel> periods;
  final List<StudentModel> students;
  final bool selectPeriods;

  const ObserverStudentChoicePage({
    required this.periods,
    required this.students,
    this.selectPeriods = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(
        'Ученик',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (_, index) {
            return ListTile(
              title: Text(students[index].fullName),
              onTap: () {
                if (selectPeriods) {
                  Get.to(() => ObserverPeriodChoicePage(
                        periods: periods,
                        student: students[index],
                      ));
                } else {
                  Get.to(
                    () => PDFPreview(
                      format: landscapePdfPageFormat,
                      generate: PDFStudentYearMarks(
                        periods: periods,
                        student: students[index],
                      ).generate,
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
