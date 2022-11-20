import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentsTablePage extends StatelessWidget {
  final StudentModel student;
  const StudentsTablePage({
    Key? key,
    required this.student,
  }) : super(key: key);

  List<Widget> _buildMarkCells(List<MarkModel> listmark) {
    return List.generate(
      listmark.length,
      (index) => Container(
        alignment: Alignment.center,
        width: 120.0,
        height: 60.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black54,
        ),
        margin: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat.Md().format(listmark[index].date)),
            Text(listmark[index].toString()),
          ],
        ),
      ),
    );
  }

  String getSummaryMark(List<MarkModel> listmark) {
    int sum = 0;
    for (MarkModel mark in listmark) {
      var times = 1;
      if (mark.type == MarkType.exam || mark.type == MarkType.test) {
        times = 2;
      }
      sum += mark.mark * times;
    }
    return (sum / listmark.length).toStringAsFixed(1);
  }

  List<Widget> _buildSubjectCells(List<CurriculumModel> listcur) {
    return List.generate(
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

  List<Widget> _buildRows(Map<CurriculumModel, List<MarkModel>> data, List<CurriculumModel> listcur) {
    return List.generate(
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
          : Column(
              children: _buildMarkCells(
                data[listcur[index]]!,
              ),
            ),
    );
  }

  List<Widget> _buildSummaryMarks(
    Map<CurriculumModel, List<MarkModel>> data,
    List<CurriculumModel> curs,
  ) {
    return List.generate(
      curs.length,
      (index) => Container(
        alignment: Alignment.center,
        width: 120.0,
        height: 60.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey,
          ),
          color: Colors.black54,
        ),
        margin: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('средний'),
            Text(
              data[curs[index]] == null
                  ? 'нет данных'
                  : getSummaryMark(
                      data[curs[index]]!,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(
        'все оценки',
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder<List<CurriculumModel>>(
          future: student.curriculums(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Utils.progressIndicator(),
              );
            }
            var curriculums = snapshot.data!;
            return FutureBuilder<Map<CurriculumModel, List<MarkModel>>>(
              future: student.getMarksByCurriculums(curriculums),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Utils.progressIndicator(),
                  );
                }
                var data = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildSubjectCells(curriculums),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildRows(data, curriculums),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8,
                        top: 4,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildSummaryMarks(
                          data,
                          curriculums,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
