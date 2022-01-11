import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/person_model.dart';

class AddHomeworkSheet extends StatefulWidget {
  final TeacherModel teacher;
  final CurriculumModel curriculum;
  final DateTime date;
  final StudentModel? student;

  const AddHomeworkSheet(
    this.teacher,
    this.curriculum,
    this.date,
    this.student, {
    Key? key,
  }) : super(key: key);

  @override
  _AddHomeworkSheetState createState() => _AddHomeworkSheetState();
}

class _AddHomeworkSheetState extends State<AddHomeworkSheet> {
  TextEditingController cont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('добавить дз'),
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: TextField(
            controller: cont,
            decoration: const InputDecoration(labelText: 'пишите сюда...'),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            widget.teacher.createHomework(cont.text, widget.curriculum, widget.date, student: widget.student);
            cont.clear();
            Get.back();
          },
          icon: const Icon(Icons.add_box_outlined),
          label: const Text('сохранить'),
        ),
      ],
    );
  }
}
