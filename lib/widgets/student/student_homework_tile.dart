import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/attachments_model.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/attachments.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentHomeworkTile extends StatefulWidget {
  final List<HomeworkModel> homework;
  final bool isClass;
  final StudentModel student;
  final void Function() refresh;
  const StudentHomeworkTile({super.key, required this.homework, required this.isClass, required this.student, required this.refresh});

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
          ...widget.homework.map(
            (hw) => homeworkTile(hw),
          ),
        ],
      ),
    );
  }

  Future<void> onTap(CompletionFlagModel? c, HomeworkModel hw) {
    bool hasCompletion = c != null;
    List<AttachmentModel> attachments = [];
    return Get.bottomSheet(
      // Card(
      //   child: Padding(
      //     padding: const EdgeInsets.all(10.0),
      //     child: ElevatedButton.icon(
      //       onPressed: () async {
      //         if (c == null) {
      //           await hw.createCompletion(widget.student);
      //         } else if (c.status == CompletionStatus.completed) {
      //           await c.delete();
      //         }
      //         widget.refresh();
      //         Get.back();
      //       },
      //       label: Text(
      //         c == null
      //             ? S.of(context).setCompleted
      //             : c.status == CompletionStatus.completed
      //             ? S.of(context).setUncompleted
      //             : S.of(context).errorCanNotBeUncompleted,
      //       ),
      //       icon: Icon(
      //         c == null
      //             ? Icons.add
      //             : c.status == CompletionStatus.completed
      //             ? Icons.close
      //             : Icons.check,
      //       ),
      //     ),
      //   ),
      // ),
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hasCompletion) Text("Добавить файлы к ответу:"),
            if (!hasCompletion)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Attachments(
                  attachments: attachments,
                  localOnly: true,
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(
                    Colors.white,
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    Get.theme.colorScheme.secondary,
                  ),
                  minimumSize: WidgetStatePropertyAll(
                    Size(MediaQuery.of(context).size.width * 0.8, 50),
                  ),
                ),
                onPressed: () async {
                  if (!hasCompletion) {
                    await hw.createCompletion(widget.student, attachments);
                  } else if (c.status == CompletionStatus.completed) {
                    await c.delete();
                  }
                  widget.refresh();
                  Get.back();
                },
                label: Text(
                  !hasCompletion
                      ? S.of(context).setCompleted
                      : c.status == CompletionStatus.completed
                      ? S.of(context).setUncompleted
                      : S.of(context).errorCanNotBeUncompleted,
                ),
                icon: Icon(
                  !hasCompletion
                      ? Icons.add
                      : c.status == CompletionStatus.completed
                      ? Icons.close
                      : Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget homeworkTile(HomeworkModel homework) {
    List<AttachmentModel> attachments = homework.getAttachments();
    bool isConfirmed = false;
    bool isCompleted = false;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Get.theme.primaryColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Linkify(
                      text: homework.text,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      onOpen: (link) => Utils.openLink(link.url),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: FutureBuilder<CompletionFlagModel?>(
                      future: homework.getStudentCompletion(widget.student),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) return const SizedBox.shrink();
                        if (snapshot.data?.status == CompletionStatus.completed) isCompleted = true;
                        if (snapshot.data?.status == CompletionStatus.confirmed) isConfirmed = true;
                        return IconButton(
                          onPressed: PersonModel.currentUser!.currentType == PersonType.parent
                              ? null
                              : () => onTap(
                                  snapshot.data,
                                  homework,
                                ),
                          icon: Icon(
                            isConfirmed
                                ? Icons.check_circle_outline_rounded
                                : isCompleted
                                ? Icons.circle_outlined
                                : Icons.add_circle_outline,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              if (attachments.isNotEmpty)
                const SizedBox(
                  height: 8,
                ),
              if (attachments.isNotEmpty) Text('Прикрепленные файлы:'),
              if (attachments.isNotEmpty)
                const SizedBox(
                  height: 4,
                ),
              ...attachments.map((e) {
                return Attachment(
                  attachment: e,
                  readOnly: true,
                  isExpanded: true,
                  onDelete: (a) {},
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
