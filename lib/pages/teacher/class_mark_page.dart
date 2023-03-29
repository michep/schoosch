import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/teacher/mark_student_tile.dart';
import 'package:schoosch/widgets/utils.dart';
// import 'package:schoosch/widgets/mark_type_field.dart';

class ClassMarkPage extends StatefulWidget {
  final String title;
  final LessonModel lesson;
  final DateTime date;
  final LessonMarkModel mark;
  const ClassMarkPage(this.lesson, this.title, this.date, this.mark, {Key? key}) : super(key: key);

  @override
  State<ClassMarkPage> createState() => _ClassMarkPageState();
}

class _ClassMarkPageState extends State<ClassMarkPage> {
  @override
  void initState() {
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: MAppBar(widget.title),
      body: SafeArea(
        child: FutureBuilder<List<StudentModel>>(
          future: _initStudents(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Utils.progressIndicator());
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('В классе нет учеников.'),
              );
            }
            List<StudentModel> studs = snapshot.data!;
            return ListView.builder(
              itemCount: studs.length,
              itemBuilder: (context, index) {
                return MarkStudentTile(
                  student: studs[index],
                  lesson: widget.lesson,
                  date: widget.date,
                  mark: widget.mark,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<StudentModel>> _initStudents() async {
    return widget.lesson.aclass.students();
  }
}
