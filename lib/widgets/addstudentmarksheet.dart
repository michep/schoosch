import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/person_model.dart';

class AddMarkSheet extends StatefulWidget {
  final StudentModel student;
  final TeacherModel teacher;
  final int lessonorder;
  final CurriculumModel curriculum;
  final DateTime date;
  const AddMarkSheet(this.student, this.teacher, this.lessonorder, this.curriculum, this.date, {Key? key}) : super(key: key);

  @override
  _AddMarkSheetState createState() => _AddMarkSheetState();
}

class _AddMarkSheetState extends State<AddMarkSheet> {
  int mark = 1;
  TextEditingController cont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("поставить оценку"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mark = 1;
                });
              },
              child: Text(
                "1",
                style: TextStyle(color: mark == 1 ? Colors.amber : Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mark = 2;
                });
              },
              child: Text(
                "2",
                style: TextStyle(color: mark == 2 ? Colors.amber : Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mark = 3;
                });
              },
              child: Text(
                "3",
                style: TextStyle(color: mark == 3 ? Colors.amber : Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mark = 4;
                });
              },
              child: Text(
                "4",
                style: TextStyle(color: mark == 4 ? Colors.amber : Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mark = 5;
                });
              },
              child: Text(
                "5",
                style: TextStyle(color: mark == 5 ? Colors.amber : Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: TextField(
            controller: cont,
            decoration: const InputDecoration(
              labelText: "комментарий к оценке",
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            widget.teacher
                .createMark(widget.student, mark, widget.lessonorder, widget.curriculum, 'regular', widget.date, comment: cont.text);
            mark = 1;
            cont.clear();
            Get.back();
          },
          child: const Text("поставить"),
        )
      ],
    );
  }
}
