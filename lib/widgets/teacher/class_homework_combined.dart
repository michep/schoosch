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
                key: PageStorageKey(widget.readOnly ? 'thislessonhws' : 'nextlessonhws'),
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
    var res = await Get.to(
      () => HomeworkPage(
        widget._lesson,
        widget._curriculum,
        hw,
        const [],
        isPersonalHomework: isPersonalHomework,
      ),
    );
    if (res is bool && res == true) {
      setState(() {
        forceRefresh = true;
      });
    }
  }

  void toggleHomeworkCompletion(HomeworkModel hw, CompletionFlagModel completion) async {
    switch (completion.status) {
      case CompletionStatus.completed:
        await completion.confirm(PersonModel.currentUser!);
        break;
      case CompletionStatus.confirmed:
        await completion.unconfirm(PersonModel.currentUser!);
        break;
      default:
    }
    setState(() {
      forceRefresh = true;
    });
  }
}
