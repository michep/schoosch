import 'package:flutter/material.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/addhomeworksheet.dart';
import 'package:schoosch/widgets/addstudentmarksheet.dart';
import 'package:schoosch/widgets/mark_tile.dart';

class TeacherStudentTile extends StatelessWidget {
  final StudentModel student;
  final TeacherModel teacher;
  final CurriculumModel curriculum;
  final LessonModel lesson;
  final DateTime date;

  const TeacherStudentTile(
      this.date, this.lesson, this.curriculum, this.teacher, this.student,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: Future.wait([
        lesson.homeworkForStudent(student, date),
        lesson.marksForStudent(student, date)
      ]),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return const Text('sheeesh');
        var homework = snapshot.data![0] as HomeworkModel?;
        var marks = snapshot.data![1] as List<MarkModel>?;
        return ExpansionTile(
          title: Text(
            student.fullName,
          ),
          subtitle: homework != null ? Text(homework.text) : const Text(''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => createHomework(context),
                icon: const Icon(Icons.checklist_rounded),
                iconSize: 25,
              ),
              IconButton(
                onPressed: () =>
                    createMark(context, lesson.order, curriculum, date),
                iconSize: 25,
                icon: const Icon(Icons.auto_stories_outlined),
              )
            ],
          ),
          // children: marks!.isNotEmpty ? marks
          //     .map((mark) => MarkTile(
          //           mark,
          //           () => updateMark(context, mark.id),
          //         ))
          //     .toList(): [const Text('нет оценок')],
          children: marks!.isNotEmpty ? marks
              .map((mark) => markTile(mark, context))
              .toList(): [const Text('нет оценок')],
        );
      },
    );
  }

  Future<void> createMark(BuildContext context, int lessonorder,
      CurriculumModel curriculum, DateTime date) async {
    return await showModalBottomSheet(
        context: context,
        builder: (a) {
          return AddMarkSheet(
            student,
            teacher,
            lessonorder,
            curriculum,
            date,
            false,
          );
        });
  }

  Future<void> createHomework(
    BuildContext context,
  ) async {
    return await showModalBottomSheet(
        context: context,
        builder: (a) {
          return AddHomeworkSheet(
            teacher,
            curriculum,
            date,
            student,
          );
        });
  }

  Future<void> updateMark(BuildContext context, String docId) async {
    return await showModalBottomSheet(
        context: context,
        builder: (a) {
          return AddMarkSheet(
            student,
            teacher,
            lesson.order,
            curriculum,
            date,
            true,
            docId: docId,
          );
        });
  }

  Widget markTile(MarkModel _mark, BuildContext context) {
  return ListTile(
      trailing: Text(_mark.mark.toString()),
      title: Text(_mark.comment),
      onTap: () => updateMark(context, _mark.id),
    );
  }
}
