import 'package:flutter/material.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/widgets/appbar.dart';

class HomeworkPage extends StatefulWidget {
  final LessonModel lesson;
  final HomeworkModel homework;

  const HomeworkPage(this.lesson, this.homework, {Key? key}) : super(key: key);

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar('Домашнее задание'),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView(
              children: [
                Text(widget.homework.date.toString()),
                FutureBuilder<CurriculumModel?>(
                  future: widget.lesson.curriculum,
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    return Text(snapshot.data!.aliasOrName);
                  }),
                ),
                Text(widget.homework.text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
