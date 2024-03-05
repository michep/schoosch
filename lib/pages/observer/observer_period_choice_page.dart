import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pdf/pdf_preview.dart';
import 'package:schoosch/pdf/pdf_studentperiodmarks.dart';
import 'package:schoosch/pdf/pdf_theme.dart';
import 'package:schoosch/widgets/appbar.dart';

class ObserverPeriodChoicePage extends StatelessWidget {
  final List<StudyPeriodModel?> periods;
  final StudentModel student;

  const ObserverPeriodChoicePage({
    required this.periods,
    required this.student,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(
        'Четверть',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: periods.length,
          itemBuilder: (_, index) {
            return ListTile(
              title: Text(periods[index]!.name),
              onTap: () {
                Get.to(
                  () => PDFPreview(
                    format: landscapePdfPageFormat,
                    generate: PDFStudentPeriodMarks(
                      period: periods[index]!,
                      student: student,
                    ).generate,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
