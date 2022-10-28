import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentHomework extends StatefulWidget {
  final List<HomeworkModel> homework;
  final bool isClass;
  final StudentModel student;
  const StudentHomework({Key? key, required this.homework, required this.isClass, required this.student}) : super(key: key);

  @override
  State<StudentHomework> createState() => _StudentHomeworkState();
}

class _StudentHomeworkState extends State<StudentHomework> {
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<CompletionFlagModel?>(
    //   future: widget.homework.getCompletion(widget.student, forceRefresh: true),
    //   builder: (context, snapshot) {
    //     bool isChecked = false;
    //     bool isConfirmed = false;
    //     if (snapshot.hasData) {
    //       if (snapshot.data!.status == Status.completed) {
    //         isChecked = true;
    //       } else if (snapshot.data!.status == Status.confirmed) {
    //         isConfirmed = true;
    //       }
    //     }
    //     return Container(
    //       margin: const EdgeInsets.all(8),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Align(
    //             alignment: Alignment.centerLeft,
    //             child: Text(
    //               widget.isClass ? "Д/З класса" : "Д/З личное",
    //               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
    //             ),
    //           ),
    //           ListTile(
    //             title: Linkify(
    //               text: widget.homework.text,
    //               onOpen: (link) => Utils.openLink(link.url),
    //             ),
    //             trailing: IconButton(
    //               onPressed: PersonModel.currentUser!.currentType == PersonType.parent
    //                   ? null
    //                   : () async {
    //                       // var completion = await widget.homework.getCompletion(widget.student);
    //                       var completion = snapshot.data;
    //                       onTap(completion).whenComplete(() {
    //                         setState(() {});
    //                       });
    //                     },
    //               icon: Icon(isConfirmed
    //                   ? Icons.check_circle_outline_rounded
    //                   : isChecked
    //                       ? Icons.circle_outlined
    //                       : Icons.add_circle_outline),
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.isClass ? "Д/З класса" : "Д/З личное",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          ...widget.homework.map((hw) {
            bool isConfirmed = false;
            bool isChecked = false;
            return ListTile(
              title: Linkify(
                text: hw.text,
                onOpen: (link) => Utils.openLink(link.url),
              ),
              trailing: FutureBuilder<CompletionFlagModel?>(
                  future: hw.getCompletion(
                    widget.student,
                    forceRefresh: true,
                  ),
                  builder: (context, snapshot) {
                    return IconButton(
                      onPressed: PersonModel.currentUser!.currentType == PersonType.parent
                          ? null
                          : () async {
                              // var completion = await widget.homework.getCompletion(widget.student);
                              var completion = snapshot.data;
                              onTap(completion, hw).whenComplete(() {
                                setState(() {});
                              });
                            },
                      icon: Icon(isConfirmed
                          ? Icons.check_circle_outline_rounded
                          : isChecked
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
                } else if (c.status == Status.completed) {
                  await c.delete();
                }
                setState(() {});
                Get.back();
              },
              label: Text(c == null
                  ? 'сообщить о выполнении'
                  : c.status == Status.completed
                      ? 'отметить как невыполненное'
                      : 'выполнение уже подтверждено, его нельзя отметить как невыполненное'),
              icon: Icon(c == null
                  ? Icons.add
                  : c.status == Status.completed
                      ? Icons.close
                      : Icons.check),
            ),
          ),
        ),
      );
}
