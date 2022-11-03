import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class TeacherTablePage extends StatelessWidget {
  final CurriculumModel currentcur;
  final ClassModel? aclass;
  final TeacherModel? teacher;
  const TeacherTablePage({
    Key? key,
    required this.currentcur,
    this.aclass,
    this.teacher,
  }) : super(key: key);

  List<Widget> _buildMarkCells(List<MarkModel> listmark) {
    listmark.sort((a, b) => b.date.compareTo(a.date));
    return List.generate(
      listmark.length,
      (index) => Container(
        alignment: Alignment.center,
        width: 120.0,
        height: 60.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black54),
        margin: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat.Md().format(listmark[index].date)),
            Text(listmark[index].mark.toString()),
          ],
        ),
      ),
    );
    // ) +
    // [
    //   Container(
    //     alignment: Alignment.center,
    //     width: 120.0,
    //     height: 60.0,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(12),
    //       color: Colors.black54,
    //     ),
    //     margin: const EdgeInsets.all(4.0),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const Text('средний'),
    //         Text(getSummaryMark(listmark)),
    //       ],
    //     ),
    //   )
    // ];
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

  List<Widget> _buildStudentCells(List<StudentModel> liststud) {
    return List.generate(
      liststud.length,
      (index) => Container(
        alignment: Alignment.center,
        width: 120.0,
        height: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey
          ),
        ),
        margin: const EdgeInsets.all(4.0),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            liststud[index].fullName,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSummaryMarks(Map<StudentModel, List<MarkModel>> data, List<StudentModel> liststud) {
    return List.generate(
      liststud.length,
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
              // getSummaryMark(
              //   data.values.toList()[index],
              // ),
              data[liststud[index]] == null ? 'нет данных' : getSummaryMark(
                data[liststud[index]]!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRows(Map<StudentModel, List<MarkModel>> data, List<StudentModel> liststud) {
    return List.generate(
      liststud.length,
      (index) => data[liststud[index]] == null
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
                data[liststud[index]]!,
              ),
            ),
      // }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        currentcur.aliasOrName,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder<List<StudentModel>>(
          future: aclass != null ? currentcur.classStudents(aclass!) : currentcur.students(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Utils.progressIndicator(),
              );
            }
            var students = snapshot.data!;
            return FutureBuilder<Map<StudentModel, List<MarkModel>>>(
              future: currentcur.getMarksByStudents(students),
              builder: (context, studsnapshot) {
                if (!studsnapshot.hasData) {
                  return Center(
                    child: Utils.progressIndicator(),
                  );
                }
                var data = studsnapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildStudentCells(students),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildRows(data, students),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                        top: 4,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildSummaryMarks(data, students),
                      ),
                    )
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
