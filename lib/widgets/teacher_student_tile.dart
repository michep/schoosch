import 'package:flutter/material.dart';
import 'package:schoosch/model/curriculum_model.dart';
// import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/addhomeworksheet.dart';
import 'package:schoosch/widgets/addstudentmarksheet.dart';

class TeacherStudentTile extends StatefulWidget {
  final StudentModel student;
  final TeacherModel teacher;
  final CurriculumModel curriculum;
  final LessonModel lesson;
  final DateTime date;

  const TeacherStudentTile(this.date, this.lesson, this.curriculum, this.teacher, this.student, {Key? key}) : super(key: key);

  @override
  State<TeacherStudentTile> createState() => _TeacherStudentTileState();
}

class _TeacherStudentTileState extends State<TeacherStudentTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: Future.wait([
        // widget.lesson.homeworkForStudent(widget.student, widget.date),
        widget.lesson.marksForStudent(widget.student, widget.date, forceUpdate: true),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('не удалось загрузить данные.');
        // var homework = snapshot.data![0] as HomeworkModel?;
        var marks = snapshot.data![0] as List<MarkModel>?;
        return ExpansionTile(
          title: Text(
            widget.student.fullName,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => createHomework(context),
                icon: const Icon(Icons.auto_stories_outlined),
                iconSize: 25,
              ),
              IconButton(
                onPressed: () => createMark(context, widget.lesson.order, widget.curriculum, widget.date),
                iconSize: 25,
                icon: const Icon(Icons.text_increase_outlined),
              )
            ],
          ),
          // children: marks!.isNotEmpty ? marks
          //     .map((mark) => MarkTile(
          //           mark,
          //           () => updateMark(context, mark.id),
          //         ))
          //     .toList(): [const Text('нет оценок')],
          children: [
            // homework != null ? ListTile(
            //   title: Text(homework.text),
            // ) : const Text('нет домашнего задания'),
            if (marks!.isNotEmpty) ...marks.map((mark) => markTile(mark, context)).toList() else const Text('нет оценок'),
          ],
        );
      },
    );
  }

  Future<void> createMark(BuildContext context, int lessonorder, CurriculumModel curriculum, DateTime date) async {
    return await showModalBottomSheet(
      context: context,
      builder: (a) {
        return AddMarkSheet(
          widget.student,
          widget.teacher,
          lessonorder,
          curriculum,
          date,
          false,
        );
      },
    );
  }

  Future<void> createHomework(
    BuildContext context,
  ) async {
    return await showModalBottomSheet(
      context: context,
      builder: (a) {
        return AddHomeworkSheet(
          widget.teacher,
          widget.curriculum,
          widget.date,
          widget.student,
        );
      },
    );
  }

  Future<void> updateMark(BuildContext context, String docId) async {
    var isupdated = await showModalBottomSheet<bool>(
        context: context,
        builder: (a) {
          return AddMarkSheet(
            widget.student,
            widget.teacher,
            widget.lesson.order,
            widget.curriculum,
            widget.date,
            true,
            docId: docId,
          );
        });
    if (isupdated != null) {
      setState(() {});
    }
  }

  Widget markTile(MarkModel mark, BuildContext context) {
    return ListTile(
      trailing: Text(mark.mark.toString()),
      title: Text(mark.comment),
      onTap: () => updateMark(context, mark.id),
    );
  }
}
