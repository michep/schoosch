import 'package:flutter/material.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/tablemarkcell.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentMarksTablePage extends StatefulWidget {
  final StudentModel student;
  final List<StudyPeriodModel> periods;

  const StudentMarksTablePage({
    super.key,
    required this.student,
    required this.periods,
  });

  @override
  State<StudentMarksTablePage> createState() => _StudentMarksTablePageState();
}

class _StudentMarksTablePageState extends State<StudentMarksTablePage> {
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
      appBar: const MAppBar(
        'все оценки',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<StudyPeriodModel>(
              value: selectedPeriod,
              items: [
                ...widget.periods.map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
                    )),
              ],
              onChanged: (value) => setState(() {
                selectedPeriod = value;
              }),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder<List<CurriculumModel>>(
                future: widget.student.curriculums(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Utils.progressIndicator(),
                    );
                  }
                  var curriculums = snapshot.data!;
                  return FutureBuilder<Map<CurriculumModel, List<LessonMarkModel>>>(
                    future: widget.student.getLessonMarksByCurriculums(
                      curriculums,
                      selectedPeriod!,
                    ),
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
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMarkCells(List<LessonMarkModel> listmark) {
    return List.generate(
      listmark.length,
      (index) => TableMarkCell(lessonmark: listmark[index]),
    );
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

  List<Widget> _buildRows(Map<CurriculumModel, List<LessonMarkModel>> data, List<CurriculumModel> listcur) {
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
    Map<CurriculumModel, List<LessonMarkModel>> data,
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
              data[curs[index]] == null ? 'нет данных' : Utils.calculateWeightedAverageMark(data[curs[index]]!).toStringAsFixed(1),
            ),
          ],
        ),
      ),
    );
  }
}
