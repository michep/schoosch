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
  final bool renewing;
  final String docId;
  const AddMarkSheet(this.student, this.teacher, this.lessonorder, this.curriculum, this.date, this.renewing, {Key? key, this.docId = ''}) : super(key: key);

  @override
  AddMarkSheetState createState() => AddMarkSheetState();
}

class AddMarkSheetState extends State<AddMarkSheet> {
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
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(mark == 1 ? Colors.amber : Colors.black)),
              child: const Text(
                "1",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mark = 2;
                });
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(mark == 1 ? Colors.amber : Colors.black)),
              child: const Text("2"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mark = 3;
                });
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(mark == 1 ? Colors.amber : Colors.black)),
              child: const Text("3"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mark = 4;
                });
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(mark == 1 ? Colors.amber : Colors.black)),
              child: const Text("4"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mark = 5;
                });
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(mark == 1 ? Colors.amber : Colors.black)),
              child: const Text("5"),
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
            !widget.renewing
                ? widget.teacher.createMark(widget.student, mark, widget.lessonorder, widget.curriculum, 'regular', widget.date, comment: cont.text)
                : widget.teacher.updateMark(mark, widget.docId);
            mark = 1;
            cont.clear();
            Get.back<bool>(result: true);
          },
          child: const Text("поставить"),
        )
      ],
    );
  }
}
