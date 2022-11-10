import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentHomeworkTile extends StatefulWidget {
  final List<HomeworkModel> homework;
  final bool isClass;
  final StudentModel student;
  final void Function() refresh;
  const StudentHomeworkTile({Key? key, required this.homework, required this.isClass, required this.student, required this.refresh}) : super(key: key);

  @override
  State<StudentHomeworkTile> createState() => _StudentHomeworkTileState();
}

class _StudentHomeworkTileState extends State<StudentHomeworkTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.isClass ? S.of(context).classHomeworkTitle : S.of(context).personalHomeworkTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          ...widget.homework.map((hw) {
            bool isConfirmed = false;
            bool isCompleted = false;
            return ListTile(
              title: Linkify(
                text: hw.text,
                onOpen: (link) => Utils.openLink(link.url),
              ),
              trailing: FutureBuilder<CompletionFlagModel?>(
                  future: hw.getStudentCompletion(widget.student),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) return const SizedBox.shrink();
                    if (snapshot.data?.status == CompletionStatus.completed) isCompleted = true;
                    if (snapshot.data?.status == CompletionStatus.confirmed) isConfirmed = true;
                    return IconButton(
                      onPressed: PersonModel.currentUser!.currentType == PersonType.parent ? null : () => onTap(snapshot.data, hw),
                      icon: Icon(isConfirmed
                          ? Icons.check_circle_outline_rounded
                          : isCompleted
                              ? Icons.circle_outlined
                              : Icons.add_circle_outline),
                    );
                  }),
            );
          })
        ],
      ),
    );
  }

  Future<void> onTap(CompletionFlagModel? c, HomeworkModel hw) => Get.bottomSheet(
        Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                if (c == null) {
                  await hw.createCompletion(widget.student);
                } else if (c.status == CompletionStatus.completed) {
                  await c.delete();
                }
                widget.refresh();
                Get.back();
              },
              label: Text(c == null
                  ? S.of(context).setCompleted
                  : c.status == CompletionStatus.completed
                      ? S.of(context).setUncompleted
                      : S.of(context).errorCanNotBeUncompleted),
              icon: Icon(c == null
                  ? Icons.add
                  : c.status == CompletionStatus.completed
                      ? Icons.close
                      : Icons.check),
            ),
          ),
        ),
      );
}
