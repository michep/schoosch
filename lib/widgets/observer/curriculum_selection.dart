import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/teacher/teacher_marks_table_page.dart';
import 'package:schoosch/widgets/utils.dart';

class CurriculumSelection extends StatelessWidget {
  final ClassModel _class;
  const CurriculumSelection(this._class, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isYear = false;
    return FutureBuilder<List<CurriculumModel>>(
      future: _class.curriculums(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Utils.progressIndicator();
        }
        if (snapshot.data!.isEmpty) {
          return const Text('нет предметов');
        }
        return Column(
          children: [
            // SizedBox(
            //   height: 60,
            //   child: TableTypeRow(isYear: isYear),
            // ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var cur = snapshot.data!.elementAt(index);
                  return FutureBuilder<TeacherModel?>(
                      future: cur.master,
                      builder: (context, teachersnap) {
                        if (!teachersnap.hasData) {
                          return const SizedBox.shrink();
                        }
                        var teacher = teachersnap.data!;
                        return ListTile(
                          title: Text(cur.name),
                          subtitle: Text(teacher.abbreviatedName),
                          onTap: () async {
                            var periods = await InstitutionModel.currentInstitution.currentYearSemesterPeriods;
                            Get.to(
                              () => TeacherTablePage(
                                currentcur: cur,
                                periods: periods,
                                aclass: _class,
                                teacher: teacher,
                                readOnly: true,
                              ),
                            );
                          },
                        );
                      });
                },
                itemCount: snapshot.data!.length,
              ),
            )
          ],
        );
      },
    );
  }
}

// class TableTypeRow extends StatefulWidget {
//   bool isYear;
//   TableTypeRow({required this.isYear});

//   @override
//   State<StatefulWidget> createState() => _TableTypeRowState();
// }

// class _TableTypeRowState extends State<TableTypeRow> {
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: widget.isYear ? Colors.transparent : Get.theme.colorScheme.primary),
//             onPressed: () {
//               setState(() {
//                 widget.isYear = false;
//               });
//             },
//             child: Text('Четвертные')),
//         ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: !widget.isYear ? Colors.transparent : Get.theme.colorScheme.primary),
//             onPressed: () {
//               setState(() {
//                 widget.isYear = true;
//               });
//             },
//             child: Text('Итоговые')),
//       ],
//     );
//   }
// }
