import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/teacher/homework_page.dart';
import 'package:schoosch/widgets/teacher/class_homework_completion_tile.dart';
import 'package:schoosch/widgets/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassTaskWithCompetionsPage extends StatefulWidget {
  final DateTime _date;
  final LessonModel _lesson;
  final CurriculumModel _curriculum;
  final TeacherModel? _teacher;
  final Future<HomeworkModel?> Function(DateTime, bool) _hwFuture;
  final bool readOnly;

  const ClassTaskWithCompetionsPage(this._teacher, this._curriculum, this._date, this._lesson, this._hwFuture, {Key? key, this.readOnly = false})
      : super(key: key);

  @override
  State<ClassTaskWithCompetionsPage> createState() => _ClassTaskWithCompetionsPageState();
}

class _ClassTaskWithCompetionsPageState extends State<ClassTaskWithCompetionsPage> {
  HomeworkModel? hw;

  @override
  Widget build(BuildContext context) {
    var buttonVisible = false;
    return FutureBuilder<HomeworkModel?>(
      future: widget._hwFuture(widget._date, true),
      builder: (context, snapHW) {
        if (snapHW.connectionState == ConnectionState.done) {
          buttonVisible = !(widget.readOnly || snapHW.data != null);
        }
        hw = snapHW.data;
        return Stack(
          children: [
            snapHW.hasData
                ? FutureBuilder<List<CompletionFlagModel>>(
                    future: hw!.getAllCompletions(),
                    builder: (context, snapCompl) {
                      if (!snapCompl.hasData) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(S.of(context).classHomeworkTitle),
                          ListTile(
                            // onTap: () => editClassHomework(hw),
                            leading: Text(Utils.formatDatetime(hw!.date, format: 'dd MMM')),
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
                          ),
                          Text(S.of(context).classHomeworkCompletionsTitle),
                          Expanded(
                            child: ListView(
                              children: [
                                ...snapCompl.data!.map((compl) => ClassHomeworkCompetionTile(hw!, compl, toggleHomeworkCompletion)),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : const Center(
                    child: Text('Вы еще не задали ДЗ.'),
                  ),
            Visibility(
              visible: buttonVisible,
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: addClassHomework,
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void addClassHomework() async {
    var res = await Get.to<bool>(
      () => HomeworkPage(
        widget._lesson,
        widget._curriculum,
        HomeworkModel.fromMap(
          null,
          {
            'class_id': widget._lesson.aclass.id,
            'date': widget._date,
            'todate': null, //TODO
            'text': '',
            'teacher_id': widget._teacher!.id,
            'curriculum_id': widget._curriculum.id,
          },
        ),
        const [],
        hw != null,
        isPersonalHomework: false,
      ),
    );
    if (res is bool && res == true) {
      setState(() {});
    }
  }

  void editClassHomework(HomeworkModel hw) async {
    var res = await Get.to(() => HomeworkPage(widget._lesson, widget._curriculum, hw, const [], true, isPersonalHomework: false));
    if (res is bool && res == true) {
      setState(() {});
    }
  }

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
    setState(() {});
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
