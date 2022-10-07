import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/teacher/homework_page.dart';
import 'package:schoosch/widgets/fab_menu.dart';
import 'package:schoosch/widgets/teacher/class_homework_completion_tile.dart';
import 'package:schoosch/widgets/teacher/students_homework_completion_tile.dart';
import 'package:schoosch/widgets/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ClassTasksCombinedPage extends StatefulWidget {
  final DateTime _date;
  final CurriculumModel _curriculum;
  final TeacherModel? _teacher;
  final LessonModel _lesson;
  final Future<Map<String, HomeworkModel?>> Function(DateTime, bool) _hwsFuture;
  final Future<HomeworkModel?> Function(DateTime, bool) _hwFuture;

  final bool readOnly;

  const ClassTasksCombinedPage(this._teacher, this._curriculum, this._date, this._lesson, this._hwsFuture, this._hwFuture, {Key? key, this.readOnly = false})
      : super(key: key);

  @override
  State<ClassTasksCombinedPage> createState() => _ClassTasksCombinedPageState();
}

class _ClassTasksCombinedPageState extends State<ClassTasksCombinedPage> {
  HomeworkModel? hw;
  late bool eXITINFINITELOOPNOW = false;
  late bool buttonVisible = false;

  // @override
  // void initState() {
  //   eXITINFINITELOOPNOW = false;
  //   buttonVisible = false;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    List<String> studentsIdsWithHW = [];
    Map<String, dynamic> hws = {};
    // var buttonVisible = false;
    return Stack(
      children: [
        ListView(
          children: [
            const Text(
              'ДЗ классу',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            FutureBuilder<HomeworkModel?>(
              future: widget._hwFuture(widget._date, true).then((v) {
                if (!eXITINFINITELOOPNOW) {
                  setState(() {
                    buttonVisible = !(widget.readOnly || v != null);
                  });
                  eXITINFINITELOOPNOW = true;
                }
                return v;
              }),
              builder: (context, snapHW) {
                // if (snapHW.connectionState == ConnectionState.done) {

                // }
                hw = snapHW.data;
                return snapHW.hasData
                    ? FutureBuilder<List<CompletionFlagModel>>(
                        future: hw!.getAllCompletions(),
                        builder: (context, snapCompl) {
                          if (!snapCompl.hasData) return const SizedBox.shrink();
                          return ExpansionTile(
                            leading: Text(
                              Utils.formatDatetime(
                                hw!.date,
                                format: 'dd MMM',
                              ),
                            ),
                            title: Linkify(
                              text: hw!.text,
                              onOpen: (link) => _openLink(link.url),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                            ),
                            trailing: widget.readOnly
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => editClassHomework(hw!),
                                  ),
                            children: [
                              ...snapCompl.data!.map(
                                (compl) => ClassHomeworkCompetionTile(
                                  hw!,
                                  compl,
                                  toggleHomeworkCompletion,
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'Вы еще не задавали ДЗ.',
                        ),
                      );
              },
            ),
            FutureBuilder<Map<String, HomeworkModel?>>(
              future: widget._hwsFuture(widget._date, true),
              builder: (context, snapHWs) {
                if (snapHWs.connectionState == ConnectionState.done) {
                  hws.clear();
                  hws.addAll(snapHWs.data!);
                  hws.remove('class');
                  hws.removeWhere((key, value) => value == null);
                  studentsIdsWithHW = hws.keys.toList();
                }
                return snapHWs.hasData
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'ДЗ личные',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          if (hws.isEmpty)
                            const Center(
                              child: Text(
                                'Вы еще не задавали личных ДЗ.',
                              ),
                            )
                          else
                            ...hws.values.map(
                              (e) {
                                return FutureBuilder<List<CompletionFlagModel>>(
                                  future: e!.getAllCompletions(),
                                  builder: (context, snapcompl) {
                                    if (!snapcompl.hasData) return const SizedBox.shrink();
                                    var compl = snapcompl.data!.isNotEmpty ? snapcompl.data![0] : null;
                                    return StudentHomeworkCompetionTile(
                                      e,
                                      widget._lesson,
                                      compl,
                                      (hws) => editStudentHomework(hws, studentsIdsWithHW),
                                      toggleHomeworkCompletion,
                                      readOnly: widget.readOnly,
                                    );
                                  },
                                );
                              },
                            ),
                        ],
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
        Visibility(
          visible: !widget.readOnly,
          child: Align(
            alignment: Alignment.bottomRight,
            // child: FloatingActionButton(
            //   onPressed: () => addStudentHomework(hws.keys.toList()),
            //   child: const Icon(Icons.add),
            // ),
            // child: SpeedDial(
            //   renderOverlay: false,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(16),
            //   ),
            //   animatedIcon: AnimatedIcons.add_event,
            //   spaceBetweenChildren: 15,
            //   spacing: 10,
            //   childPadding: const EdgeInsets.all(2),
            //   children: [
            //     SpeedDialChild(
            //       child: const Icon(Icons.groups_rounded, size: 25,),
            //       label: 'классу',
            //       onTap: () => addHomework(
            //         isPersonal: false,
            //       ),
            //       labelStyle: const TextStyle(fontSize: 16,)
            //     ),
            //     SpeedDialChild(
            //       child: const Icon(Icons.person, size: 25,),
            //       label: 'личное',
            //       onTap: () => addHomework(
            //         isPersonal: true,
            //         studentIDs: hws.keys.toList(),
            //       ),
            //       labelStyle: const TextStyle(fontSize: 16,)
            //     ),
            //   ],
            // ),
            child: FABMenu(
              children: [
                FABmenuchild(
                  icon: Icons.groups_rounded,
                  onPressed: () => addHomework(
                    isPersonal: false,
                  ),
                  isVisible: buttonVisible,
                ),
                FABmenuchild(
                  icon: Icons.person_rounded,
                  onPressed: () => addHomework(
                    isPersonal: true,
                    studentIDs: hws.keys.toList(),
                  ),
                  isVisible: !widget.readOnly,
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

  // void addStudentHomework({required bool isPersonal, List<String> studentIDs = const [],}) async {
  //   var res = await Get.to<bool>(
  //     () => HomeworkPage(
  //       widget._lesson,
  //       HomeworkModel.fromMap(
  //         null,
  //         {
  //           'class_id': widget._lesson.aclass.id,
  //           'date': Timestamp.fromDate(widget._date),
  //           'text': '',
  //           'teacher_id': widget._teacher!.id,
  //           'curriculum_id': widget._curriculum.id,
  //         },
  //       ),
  //       isPersonal ? const [] : studentIDs,
  //       personalHomework: isPersonal,
  //     ),
  //   );
  //   if (res is bool && res == true) {
  //     setState(() {});
  //   }
  // }

  void addHomework({
    required bool isPersonal,
    List<String> studentIDs = const [],
  }) async {
    var res = await Get.to<bool>(
      () => HomeworkPage(
        widget._lesson,
        HomeworkModel.fromMap(
          null,
          {
            'class_id': widget._lesson.aclass.id,
            'date': Timestamp.fromDate(widget._date),
            'text': '',
            'teacher_id': widget._teacher!.id,
            'curriculum_id': widget._curriculum.id,
          },
        ),
        !isPersonal ? const [] : studentIDs,
        personalHomework: isPersonal,
      ),
    );
    if (res is bool && res == true) {
      setState(() {
        eXITINFINITELOOPNOW = false;
      });
    }
  }

  void editStudentHomework(HomeworkModel hw, List<String> studentIDs) async {
    studentIDs.remove(hw.studentId);
    var res = await Get.to(() => HomeworkPage(widget._lesson, hw, studentIDs, personalHomework: true));
    if (res is bool && res == true) {
      setState(() {});
    }
  }

  void toggleHomeworkCompletion(HomeworkModel hw, CompletionFlagModel completion) async {
    switch (completion.status) {
      case Status.completed:
        await hw.confirmCompletion(completion, PersonModel.currentUser!);
        break;
      case Status.confirmed:
        await hw.unconfirmCompletion(completion, PersonModel.currentUser!);
        break;
      default:
    }
    setState(() {});
  }

  void editClassHomework(HomeworkModel hw) async {
    var res = await Get.to(() => HomeworkPage(widget._lesson, hw, const [], personalHomework: false));
    if (res is bool && res == true) {
      setState(() {});
    }
  }

  Future<void> _openLink(String adress) async {
    final url = Uri.parse(adress);
    if (!(await launchUrl(url))) {
      Get.showSnackbar(
        const GetSnackBar(
          title: 'Ой...',
          message: 'Не получилось открыть ссылку.',
        ),
      );
    }
  }
}
