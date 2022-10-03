import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';

class HomeworkCard extends StatefulWidget {
  final HomeworkModel homework;
  final bool isClass;
  final StudentModel student;
  const HomeworkCard({Key? key, required this.homework, required this.isClass, required this.student}) : super(key: key);

  @override
  State<HomeworkCard> createState() => _HomeworkCardState();
}

class _HomeworkCardState extends State<HomeworkCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CompletionFlagModel?>(
      future: widget.homework.getCompletion(widget.student),
      builder: (context, snapshot) {
        bool isChecked = false;
        bool isConfirmed = false;
        if (snapshot.hasData) {
          if (snapshot.data!.status == Status.completed) {
            isChecked = true;
          } else if (snapshot.data!.status == Status.confirmed) {
            isConfirmed = true;
          }
        }
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
              ListTile(
                title: Text(widget.homework.text),
                trailing: PersonModel.currentUser!.currentType == PersonType.parent
                    ? null
                    : IconButton(
                        onPressed: () async {
                          // var completion = await widget.homework.getCompletion(widget.student);
                          var completion = snapshot.data;
                          onTap(completion).whenComplete(() {
                            setState(() {});
                          });
                        },
                        icon: Icon(isConfirmed
                            ? Icons.check_circle_outline_rounded
                            : isChecked
                                ? Icons.circle_outlined
                                : Icons.add_circle_outline),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> onTap(CompletionFlagModel? c) => Get.bottomSheet(
        Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                if (c == null) {
                  await widget.homework.createCompletion(widget.student);
                } else if (c.status == Status.completed) {
                  await widget.homework.deleteCompletion(c, widget.student);
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
