import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/student/student_lesson_page.dart';

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
    return InkWell(
      onTap: () => _onTap(),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
          top: 10,
        ),
        child: SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 50,
                child: Center(
                  child: Text(
                    lesson.order.toString(),
                    style: const TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.type == LessonType.empty ? 'Окно' : cur!.aliasOrName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    if (lesson.type != LessonType.empty)
                      Text(
                        '${tim!.formatPeriod()}, ${ven!.name}',
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7)),
                      ),
                    const SizedBox(
                      height: 2,
                    ),
                    if (lesson.type != LessonType.empty)
                      FutureBuilder<Map<String, List<HomeworkModel>>>(
                        future: lesson.homeworkThisLessonForClassAndStudent(student, date),
                        builder: (context, hw) {
                          if (!hw.hasData) {
                            return const SizedBox.shrink();
                          }
                          var stud = hw.data!['student'];
                          var clas = hw.data!['class'];
                          String text = '';
                          if (clas!.isNotEmpty) {
                            text = clas.first.text;
                          } else if (stud!.isNotEmpty) {
                            text = stud.first.text;
                          }
                          return text.isNotEmpty
                              ? Text(
                                  'ДЗ: $text',
                                  // overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.onBackground.withOpacity(
                                          0.7,
                                        ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                child: lesson.type != LessonType.empty && mar != ''
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.red, width: 1.5),
                          ),
                          child: Text(mar!),
                        ),
                      )
                    : null,
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
