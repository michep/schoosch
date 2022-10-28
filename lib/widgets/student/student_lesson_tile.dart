import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/student_lesson_page.dart';

class StudentLessonTile extends StatelessWidget {
  final LessonModel lesson;
  final StudentModel student;
  final DateTime date;
  final CurriculumModel? cur;
  final VenueModel? ven;
  final LessontimeModel? tim;
  final String? mar;
  const StudentLessonTile({
    Key? key,
    required this.lesson,
    required this.student,
    required this.date,
    this.cur,
    this.ven,
    this.tim,
    this.mar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 6,
        ),
        child: SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lesson.order.toString()),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.type == LessonType.empty ? 'Окно' : cur!.aliasOrName),
                    if (lesson.type != LessonType.empty) Text('${tim!.formatPeriod()}, ${ven!.name}'),
                    if (lesson.type != LessonType.empty)
                      FutureBuilder<Map<String, List<HomeworkModel>>>(
                        future: lesson.homeworkThisLessonForClassAndStudent(student, date),
                        builder: (context, hw) {
                          if (!hw.hasData) {
                            return const SizedBox.shrink();
                          }
                          if (hw.data!['student'] == null && hw.data!['class'] == null) {
                            return const Text('нет дз');
                          }
                          var stud = hw.data!['student'];
                          var clas = hw.data!['class'];
                          if (clas!.isNotEmpty) {
                            return Text(clas.first.text);
                          } else if (stud!.isNotEmpty) {
                            return Text(stud.first.text);
                          } else {
                            return const Text('не заданы дз');
                          }
                        },
                      ),
                  ],
                ),
              ),
              if (lesson.type != LessonType.empty && mar != '')
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red, width: 1.5),
                  ),
                  child: Text(mar!),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap() {
    Get.to(() => StudentLessonPage(student, lesson, cur!, ven!, tim!, date));
  }
}
