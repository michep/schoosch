import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pdf/pdf_classcurriculumperiodabsences.dart';
import 'package:schoosch/pdf/pdf_preview.dart';
import 'package:schoosch/pdf/pdf_theme.dart';
import 'package:schoosch/widgets/appbar.dart';

class AbsencePeriodChoicePage extends StatelessWidget {
  final ClassModel aclass;
  final List<StudyPeriodModel?> periods;
  final StudentModel? singleStudent;

  const AbsencePeriodChoicePage({
    required this.aclass,
    required this.periods,
    this.singleStudent,
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
                    generate: PDFClassCurriculumPeriodAbsences(
                      period: periods[index]!,
                      aclass: aclass,
                      singleStudent: singleStudent,
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
