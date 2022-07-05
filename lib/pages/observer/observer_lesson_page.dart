import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';

class ObserverLessonPage extends StatelessWidget {
  final LessonModel lesson;
  final CurriculumModel curriculum;
  final VenueModel venue;
  final LessontimeModel lessontime;
  final DateTime date;
  final Map<String, HomeworkModel?> homeworks;
  const ObserverLessonPage(
      {Key? key, required this.lesson, required this.homeworks, required this.curriculum, required this.venue, required this.lessontime, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Урок'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const Text(
                  'Выполненные ДЗ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                if (!homeworks.values.every((element) => element == null))
                  ...homeworks.values.map((e) {
                    if (e != null) {
                      return HomeworkItem(homework: e);
                    } else {
                      return const SizedBox();
                    }
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeworkItem extends StatefulWidget {
  final HomeworkModel homework;
  const HomeworkItem({Key? key, required this.homework}) : super(key: key);

  @override
  State<HomeworkItem> createState() => _HomeworkItemState();
}

class _HomeworkItemState extends State<HomeworkItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder<List<CompletionFlagModel?>>(
        future: widget.homework.getAllCompletions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('нет данных');
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  widget.homework.text,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              ...snapshot.data!.map(
                (e) {
                  if (e!.status == Status.completed || e.status == Status.confirmed) {
                    return ListTile(
                      title: FutureBuilder<StudentModel>(
                          future: e.student,
                          builder: (context, usnapshot) {
                            if (!usnapshot.hasData) {
                              return const Text('нет информации');
                            }
                            return Text(usnapshot.data!.fullName);
                          }),
                      subtitle: Text(
                        DateFormat('HH:mm, MMM dd').format(e.completedTime!),
                      ),
                      trailing: e.status! == Status.confirmed ? const Icon(Icons.check) : null,
                      onTap: () {
                        if (e.status == Status.completed) {
                          Get.find<FStore>().currentUser!.asObserver!.confirmCompletion(widget.homework, e);
                        } else if (e.status == Status.confirmed) {
                          Get.find<FStore>().currentUser!.asObserver!.unconfirmCompletion(widget.homework, e);
                        }
                        setState(() {});
                      },
                      tileColor: e.status == Status.completed
                          ? const Color.fromARGB(153, 76, 175, 79)
                          : e.status == Status.confirmed
                              ? Colors.green
                              : null,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
