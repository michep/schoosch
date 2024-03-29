import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pages/teacher/period_mark_page.dart';
import 'package:schoosch/pdf/pdf_classcurriculumyearmarks.dart';
import 'package:schoosch/pdf/pdf_preview.dart';
import 'package:schoosch/pdf/pdf_theme.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassCurriculumYearMarksTable extends StatefulWidget {
  final CurriculumModel currentcur;
  final ClassModel aclass;
  final List<StudyPeriodModel> periods;
  final bool readOnly;

  const ClassCurriculumYearMarksTable({
    super.key,
    required this.currentcur,
    required this.periods,
    required this.aclass,
    this.readOnly = false,
  });

  @override
  State<ClassCurriculumYearMarksTable> createState() => _ClassCurriculumYearMarksTableState();
}

class _ClassCurriculumYearMarksTableState extends State<ClassCurriculumYearMarksTable> {
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
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => PDFPreview(
                  format: landscapePdfPageFormat,
                  generate: PDFClassCurriculumYearMarks(
                    curriculum: widget.currentcur,
                    periods: widget.periods,
                    aclass: widget.aclass,
                  ).generate,
                ),
              );
            },
            icon: const Icon(Icons.print_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder<List<StudentModel>>(
          future: widget.currentcur.classStudents(widget.aclass),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Utils.progressIndicator(),
              );
            }
            var students = snapshot.data!;
            return FutureBuilder(
              future: widget.currentcur.getAllPeriodsMarksByStudents(
                students,
                widget.periods,
              ),
              builder: (context, studsnapshot) {
                if (!studsnapshot.hasData) {
                  return Center(
                    child: Utils.progressIndicator(),
                  );
                }
                var dataPeriods = studsnapshot.data!;
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
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildMarkCells(List<PeriodMarkModel?> listmark, StudentModel stud) {
    // listmark.sort((a, b) => b.date.compareTo(a.date));
    return List.generate(
      listmark.length,
      // widget.periods.length,
      (index) => Container(
        alignment: Alignment.center,
        width: 90.0,
        height: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: index == listmark.length - 1
              ? widget.readOnly || !(listmark[index] == null)
                  ? Colors.black54
                  : Get.theme.colorScheme.secondary
              : Colors.black54,
        ),
        margin: const EdgeInsets.all(4.0),
        child: index == listmark.length - 1
            ? GestureDetector(
                onTap: widget.readOnly
                    ? null
                    : listmark[index] == null
                        ? () async {
                            PeriodMarkModel mark = PeriodMarkModel.empty(
                              PersonModel.currentTeacher!.id!,
                              widget.currentcur.id!,
                              widget.periods.last.id!,
                            );
                            await addPeriodMark(
                              stud,
                              mark,
                            );
                          }
                        : () async {
                            await editMark(listmark[index]!);
                          },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Годовая'),
                    listmark[index] != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                listmark[index]!.mark.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              if (!widget.readOnly)
                                const Icon(
                                  Icons.edit,
                                  size: 16,
                                ),
                            ],
                          )
                        : const Icon(
                            Icons.add,
                          ),
                  ],
                ),
              )
            : listmark[index] != null
                ? Center(
                    child: Text(
                      listmark[index]!.mark.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                : null,
      ),
    );
  }

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

  List<Widget> _buildRows(Map<StudentModel, List<PeriodMarkModel?>> data, List<StudentModel> liststud) {
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
                  children: _buildMarkCells(data[liststud[index]]!, liststud[index]),
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
