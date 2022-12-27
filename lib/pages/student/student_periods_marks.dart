import 'package:flutter/material.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentPeriodicMarksScreen extends StatelessWidget {
  final List<StudyPeriodModel> periods;
  final StudentModel student;
  const StudentPeriodicMarksScreen({
    Key? key,
    required this.periods,
    required this.student,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final StudentModel student = PersonModel.currentStudent!;
    return Scaffold(
      appBar: const MAppBar('Оценки по периодам'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder<List<CurriculumModel>>(
          future: student.curriculums(),
          builder: (context, curssnapshot) {
            if (!curssnapshot.hasData) {
              return Center(
                child: Utils.progressIndicator(),
              );
            }
            var curriculums = curssnapshot.data!;
            return FutureBuilder<Map<CurriculumModel, List<PeriodMarkModel>>>(
              future: student.getAllPeriodsMarks(
                curriculums,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Utils.progressIndicator(),
                  );
                }
                var data = snapshot.data!;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildSubjectCells(curriculums),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildRows(data, curriculums),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     bottom: 8,
                    //     top: 4,
                    //   ),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: _buildSummaryMarks(
                    //       data,
                    //       curriculums,
                    //     ),
                    //   ),
                    // ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildMarkCells(List<PeriodMarkModel> listmark) {
    return List.generate(
      listmark.length,
      (index) => Container(
        alignment: Alignment.center,
        width: 90.0,
        height: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black54,
        ),
        margin: const EdgeInsets.all(4.0),
        child: Center(
          child: Text(
            listmark[index].mark.toString(),
          ),
        ),
      ),
    );
  }

  // String getSummaryMark(List<LessonMarkModel> listmark) {
  //   int sum = 0;

  //   for (MarkModel mark in listmark) {
  //     sum += mark.mark;
  //   }
  //   return (sum / listmark.length).toStringAsFixed(1);
  // }

  List<Widget> _buildSubjectCells(List<CurriculumModel> listcur) {
    return [
          Container(
            alignment: Alignment.center,
            width: 120.0,
            height: 70.0,
            color: Colors.transparent,
            margin: const EdgeInsets.all(4.0),
          ),
        ] +
        List.generate(
          listcur.length,
          (index) => Container(
            alignment: Alignment.center,
            width: 120.0,
            height: 70.0,
            // color: Colors.white,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            margin: const EdgeInsets.all(4.0),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                listcur[index].aliasOrName,
              ),
            ),
          ),
        );
  }

  List<Widget> _buildRows(Map<CurriculumModel, List<PeriodMarkModel>> data, List<CurriculumModel> listcur) {
    return <Widget>[
          Row(
            children: _buildPeriodCells(),
          ),
        ] +
        List.generate(
          listcur.length,
          (index) => data[listcur[index]] == null
              ? Container(
                  alignment: Alignment.center,
                  width: 120.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black54,
                  ),
                  margin: const EdgeInsets.all(4.0),
                  child: const Text('нет оценок.'),
                )
              : Row(
                  children: _buildMarkCells(
                    data[listcur[index]]!,
                  ),
                ),
        );
  }

  List<Widget> _buildPeriodCells() {
    return List.generate(
      periods.length,
      (index) => Container(
        alignment: Alignment.center,
        width: 90.0,
        height: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        margin: const EdgeInsets.all(4.0),
        child: Center(
          child: Text(
            periods[index].name,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // List<Widget> _buildSummaryMarks(
  //   Map<CurriculumModel, List<LessonMarkModel>> data,
  //   List<CurriculumModel> curs,
  // ) {
  //   return List.generate(
  //     curs.length,
  //     (index) => Container(
  //       alignment: Alignment.center,
  //       width: 120.0,
  //       height: 60.0,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(
  //           color: Colors.grey,
  //         ),
  //         color: Colors.black54,
  //       ),
  //       margin: const EdgeInsets.all(4.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           const Text('средний'),
  //           Text(
  //             data[curs[index]] == null
  //                 ? 'нет данных'
  //                 : getSummaryMark(
  //                     data[curs[index]]!,
  //                   ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
