import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pages/teacher/period_mark_page.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class TeacherYearMarksTable extends StatefulWidget {
  final CurriculumModel currentcur;
  final ClassModel? aclass;
  final TeacherModel? teacher;
  final List<StudyPeriodModel> periods;

  const TeacherYearMarksTable({
    Key? key,
    required this.currentcur,
    required this.periods,
    this.aclass,
    this.teacher,
  }) : super(key: key);

  @override
  State<TeacherYearMarksTable> createState() => _TeacherYearMarksTableState();
}

class _TeacherYearMarksTableState extends State<TeacherYearMarksTable> {
  late StudyPeriodModel? selectedPeriod;

  @override
  void initState() {
    selectedPeriod = widget.periods.firstWhere(
      (element) => element.from.isBefore(DateTime.now()) && element.till.isAfter(DateTime.now()),
      orElse: () => widget.periods[widget.periods.length - 1],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        widget.currentcur.aliasOrName,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder<List<StudentModel>>(
          future: widget.aclass != null ? widget.currentcur.classStudents(widget.aclass!) : widget.currentcur.students(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Utils.progressIndicator(),
              );
            }
            var students = snapshot.data!;
            return FutureBuilder<List>(
              future: Future.wait(
                [
                  // widget.currentcur.getLessonMarksByStudents(students, selectedPeriod!),
                  widget.currentcur.getAllPeriodsMarksByStudents(
                    students,
                    widget.periods,
                    widget.teacher!,
                  ),
                ],
              ),
              builder: (context, studsnapshot) {
                if (!studsnapshot.hasData) {
                  return Center(
                    child: Utils.progressIndicator(),
                  );
                }
                // var data = studsnapshot.data![0];
                var dataPeriods = studsnapshot.data![0];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildStudentCells(students),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildRows(dataPeriods, students),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     bottom: 8.0,
                    //     top: 4,
                    //   ),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: _buildSummaryMarks(data, students),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     bottom: 8.0,
                    //     top: 0,
                    //   ),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: _buildPeriodMarks(dataPeriods, students),
                    //   ),
                    // )
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
    // listmark.sort((a, b) => b.date.compareTo(a.date));
    return List.generate(
          // listmark.length,
          widget.periods.length - 1,
          (index) => Container(
            alignment: Alignment.center,
            width: 90.0,
            height: 70.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black54,
            ),
            margin: const EdgeInsets.all(4.0),
            child: listmark.length >= index
                ? Center(
                    child: Text(
                      listmark[index].mark.toString(),
                    ),
                  )
                : null,
          ),
        ) +
        [
          Container(
            alignment: Alignment.center,
            width: 90.0,
            height: 70.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.secondary,
            ),
            margin: const EdgeInsets.all(4.0),
            child: const Icon(Icons.add),
          )
        ];
    ;
  }

  // String getSummaryMark(List<LessonMarkModel> listmark) {
  //   int sum = 0;
  //   for (MarkModel mark in listmark) {
  //     // var times = 1;
  //     // if (mark.type == MarkType.exam || mark.type == MarkType.test) {
  //     //   times = 2;
  //     // }
  //     // sum += mark.mark * times;
  //     sum += mark.mark;
  //   }
  //   return (sum / listmark.length).toStringAsFixed(1);
  // }

  List<Widget> _buildStudentCells(List<StudentModel> liststud) {
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
          liststud.length,
          (index) => Container(
            alignment: Alignment.center,
            width: 120.0,
            height: 70.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
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

  // List<Widget> _buildSummaryMarks(Map<StudentModel, List<LessonMarkModel>> data, List<StudentModel> liststud) {
  //   return List.generate(
  //     liststud.length,
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
  //             // getSummaryMark(
  //             //   data.values.toList()[index],
  //             // ),
  //             data[liststud[index]] == null
  //                 ? 'нет данных'
  //                 : getSummaryMark(
  //                     data[liststud[index]]!,
  //                   ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // List<Widget> _buildPeriodMarks(Map<StudentModel, PeriodMarkModel> data, List<StudentModel> liststud) {
  //   return List.generate(liststud.length, (index) {
  //     bool hasMark = data.keys.contains(liststud[index]);
  //     return Container(
  //       alignment: Alignment.center,
  //       width: 120.0,
  //       height: 60.0,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12),
  //         border: hasMark
  //             ? Border.all(
  //                 color: Colors.grey,
  //               )
  //             : null,
  //         color: hasMark ? Colors.black54 : Theme.of(context).colorScheme.secondary,
  //       ),
  //       margin: const EdgeInsets.all(4.0),
  //       child: GestureDetector(
  //         onTap: hasMark
  //             ? () async {
  //                 await editMark(data[liststud[index]]!);
  //               }
  //             : () async {
  //                 PeriodMarkModel mark = PeriodMarkModel.empty(
  //                   PersonModel.currentTeacher!.id!,
  //                   widget.currentcur.id!,
  //                   selectedPeriod!.id!,
  //                 );
  //                 await addPeriodMark(
  //                   liststud[index],
  //                   mark,
  //                 );
  //               },
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const Text('балл за период'),
  //             hasMark
  //                 ? Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                     mainAxisSize: MainAxisSize.max,
  //                     children: [
  //                       Text(data[liststud[index]]!.mark.toStringAsFixed(1)),
  //                       const Icon(
  //                         Icons.edit,
  //                         size: 16,
  //                       ),
  //                     ],
  //                   )
  //                 : const Icon(Icons.add),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

  List<Widget> _buildRows(Map<StudentModel, List<PeriodMarkModel>> data, List<StudentModel> liststud) {
    return <Widget>[
          Row(children: _buildPeriodCells()),
        ] +
        List.generate(
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
              : Row(
                  children: _buildMarkCells(
                    data[liststud[index]]!,
                  ),
                ),
        );
  }

  List<Widget> _buildPeriodCells() {
    return List.generate(
          widget.periods.length - 1,
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
                widget.periods[index].name,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ) +
        [
          Container(
            alignment: Alignment.center,
            width: 90.0,
            height: 70.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            margin: const EdgeInsets.all(4.0),
            child: Text(
              widget.periods.last.name,
            ),
          )
        ];
  }

  Future<void> addPeriodMark(
    StudentModel student,
    PeriodMarkModel mark,
  ) async {
    var res = await Get.to(
      () => PeriodMarkPage(
        student.id!,
        mark,
        S.of(context).setMarkTitle,
      ),
    );
    if (res is bool) {
      setState(() {});
      if (res) {
        print('Added mark successfully!');
      }
    }
  }

  Future<void> editMark(PeriodMarkModel mark) async {
    var res = await Get.to<bool>(
      () => PeriodMarkPage(mark.studentId, mark, S.of(context).updateMarkTitle, editMode: true),
    );
    if (res is bool) {
      setState(() {
        // forceRefresh = true;
      });
    }
  }
}
