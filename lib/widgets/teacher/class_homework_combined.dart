import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/teacher/homework_page.dart';
import 'package:schoosch/widgets/fab_menu.dart';
import 'package:schoosch/widgets/teacher/class_homework_tile.dart';
import 'package:schoosch/widgets/teacher/student_homework_tile.dart';

class ClassHomeworksCombinedPage extends StatefulWidget {
  final DateTime _date;
  final CurriculumModel _curriculum;
  final TeacherModel? _teacher;
  final LessonModel _lesson;
  final Future<Map<String, List<HomeworkModel>>> Function(DateTime, bool) _hwsFuture;

  final bool readOnly;

  const ClassHomeworksCombinedPage(this._teacher, this._curriculum, this._date, this._lesson, this._hwsFuture, {Key? key, this.readOnly = false})
      : super(key: key);

  @override
  State<ClassHomeworksCombinedPage> createState() => _ClassHomeworksCombinedPageState();
}

class _ClassHomeworksCombinedPageState extends State<ClassHomeworksCombinedPage> {
  HomeworkModel? hw;
  late bool forceRefresh;

  @override
  void initState() {
    forceRefresh = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<HomeworkModel>> hws = {};
    bool buildForceRefresh = forceRefresh;
    return Stack(
      children: [
        FutureBuilder<Map<String, List<HomeworkModel>>>(
          future: widget._hwsFuture(widget._date, buildForceRefresh),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) return const SizedBox.shrink();
            hws = snapshot.data!;
            forceRefresh = false;
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  forceRefresh = true;
                });
              },
              child: ListView(
                children: [
                  const Text(
                    'ДЗ классу',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  ...(hws['class'] ?? []).map(
                    (hw) {
                      return ClassHomeworkTile(
                        homework: hw,
                        toggleHomeworkCompletion: toggleHomeworkCompletion,
                        editHomework: editHomework,
                        readOnly: widget.readOnly,
                        forceRefresh: buildForceRefresh,
                      );
                    },
                  ).toList(),
                  const Text(
                    'ДЗ личные',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  ...hws.keys.where((element) => element != 'class').map(
                    (idx) {
                      return StudentHomeworkTile(
                        homeworks: hws[idx]!,
                        toggleHomeworkCompletion: toggleHomeworkCompletion,
                        editHomework: editHomework,
                        readOnly: widget.readOnly,
                      );
                    },
                  ).toList(),
                ],
              ),
            );
          },
        ),
        // ListView(
        //   children: [
        //     const Text(
        //       'ДЗ классу',
        //       style: TextStyle(
        //         fontSize: 17,
        //       ),
        //     ),
        //     FutureBuilder<HomeworkModel?>(
        //       future: widget._hwFuture(widget._date, forceRefresh).then((v) {
        //         if (!eXITINFINITELOOPNOW) {
        //           setState(() {
        //             buttonVisible = !(widget.readOnly || v != null);
        //           });
        //           eXITINFINITELOOPNOW = true;
        //         }
        //         return v;
        //       }),
        //       builder: (context, snapHW) {
        //         // if (snapHW.connectionState == ConnectionState.done) {

        //         // }
        //         hw = snapHW.data;
        //         return snapHW.hasData
        //             ? FutureBuilder<List<CompletionFlagModel>>(
        //                 future: hw!.getAllCompletions(),
        //                 builder: (context, snapCompl) {
        //                   if (!snapCompl.hasData) return const SizedBox.shrink();
        //                   return ExpansionTile(
        //                     leading: Text(
        //                       Utils.formatDatetime(
        //                         hw!.date,
        //                         format: 'dd MMM',
        //                       ),
        //                     ),
        //                     title: Linkify(
        //                       text: hw!.text,
        //                       onOpen: (link) => _openLink(link.url),
        //                       overflow: TextOverflow.ellipsis,
        //                       maxLines: 10,
        //                     ),
        //                     trailing: widget.readOnly
        //                         ? null
        //                         : IconButton(
        //                             icon: const Icon(Icons.edit),
        //                             onPressed: () => editClassHomework(hw!),
        //                           ),
        //                     children: [
        //                       ...snapCompl.data!.map(
        //                         (compl) => ClassHomeworkCompetionTile(
        //                           hw!,
        //                           compl,
        //                           toggleHomeworkCompletion,
        //                         ),
        //                       ),
        //                     ],
        //                   );
        //                 },
        //               )
        //             : const Center(
        //                 child: Text(
        //                   'Вы еще не задавали ДЗ.',
        //                 ),
        //               );
        //       },
        //     ),
        //     FutureBuilder<Map<String, List<HomeworkModel>>>(
        //       future: widget._hwsFuture(widget._date, forceRefresh),
        //       builder: (context, snapHWs) {
        //         if (snapHWs.connectionState == ConnectionState.done) {
        //           hws.clear();
        //           hws.addAll(snapHWs.data!);
        //           hws.remove('class');
        //           hws.removeWhere((key, value) => value == null);
        //           studentsIdsWithHW = hws.keys.toList();
        //         }
        //         if (snapHWs.hasData) {
        //           List<Widget> hww = [];
        //           for (var hwl in snapHWs.data!.values) {
        //             for (var hw in hwl) {
        //               if (hw.studentId == null) continue;
        //               var w = StudentHomeworkCompetionTile(
        //                 hw,
        //                 widget._lesson,
        //                 null,
        //                 (hws) => editStudentHomework(hws, studentsIdsWithHW, false),
        //                 toggleHomeworkCompletion,
        //                 readOnly: widget.readOnly,
        //               );
        //               hww.add(w);
        //             }
        //           }
        //           return Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               const Align(
        //                 alignment: Alignment.centerLeft,
        //                 child: Text(
        //                   'ДЗ личные',
        //                   style: TextStyle(
        //                     fontSize: 17,
        //                   ),
        //                 ),
        //               ),
        //               ...hww,
        //             ],
        //           );
        //         } else {
        //           return const SizedBox.shrink();
        //         }
        //       },
        //     ),
        //   ],
        // ),
        Visibility(
          visible: !widget.readOnly,
          child: Align(
            alignment: Alignment.bottomRight,
            child: FABMenu(
              children: [
                FABmenuchild(
                  icon: Icons.groups_rounded,
                  onPressed: () => addHomework(
                    isPersonal: false,
                  ),
                  title: 'Классу',
                ),
                FABmenuchild(
                  icon: Icons.person_rounded,
                  onPressed: () => addHomework(
                    isPersonal: true,
                    studentIDs: hws.keys.toList(),
                  ),
                  title: 'Личное',
                ),
              ],
              colorClosed: Theme.of(context).colorScheme.secondary,
              colorOpen: Theme.of(context).colorScheme.background,
            ),
          ),
        ),
      ],
    );
  }

  void addHomework({
    required bool isPersonal,
    List<String> studentIDs = const [],
  }) async {
    var res = await Get.to<bool>(
      () => HomeworkPage(
        widget._lesson,
        widget._curriculum,
        HomeworkModel.fromMap(
          null,
          {
            'class_id': widget._lesson.aclass.id,
            'date': widget._date.toIso8601String(),
            'todate': null,
            'text': '',
            'teacher_id': widget._teacher!.id,
            'curriculum_id': widget._curriculum.id,
          },
        ),
        !isPersonal ? const [] : studentIDs,
        isPersonalHomework: isPersonal,
      ),
    );
    if (res is bool && res == true) {
      setState(() {
        forceRefresh = true;
      });
    }
  }

  void editHomework(HomeworkModel hw, bool isPersonalHomework) async {
    var res = await Get.to(() => HomeworkPage(widget._lesson, widget._curriculum, hw, const [], isPersonalHomework: false));
    if (res is bool && res == true) {
      setState(() {
        forceRefresh = true;
      });
    }
  }

  // void editStudentHomework(HomeworkModel hw, List<String> studentIDs, bool classHwExists) async {
  //   studentIDs.remove(hw.studentId);
  //   var res = await Get.to(() => HomeworkPage(widget._lesson, widget._curriculum, hw, studentIDs, isPersonalHomework: true));
  //   if (res is bool && res == true) {
  //     setState(() {
  //       forceRefresh = true;
  //     });
  //   }
  // }

  // void editClassHomework(HomeworkModel hw) async {
  //   var res = await Get.to(() => HomeworkPage(widget._lesson, widget._curriculum, hw, const [], isPersonalHomework: false));
  //   if (res is bool && res == true) {
  //     setState(() {
  //       forceRefresh = true;
  //     });
  //   }
  // }

  void toggleHomeworkCompletion(HomeworkModel hw, CompletionFlagModel completion) async {
    switch (completion.status) {
      case Status.completed:
        await completion.confirm(PersonModel.currentUser!);
        break;
      case Status.confirmed:
        await completion.unconfirm(PersonModel.currentUser!);
        break;
      default:
    }
    setState(() {
      forceRefresh = true;
    });
  }
}
