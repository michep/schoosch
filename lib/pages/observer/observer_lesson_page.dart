import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(fullLessonInfo(context)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    curriculum.aliasOrName,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(DateFormat('d MMMM, EEEE', 'ru').format(date).capitalizeFirst!),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('${lesson.order} урок'),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(lessontime.formatPeriod()),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(venue.name),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
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
      child: FutureBuilder<List<CompletionFlagModel>>(
        future: widget.homework.getAllCompletions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('нет данных');
          }
          if (snapshot.data!.isEmpty) {
            return ExpansionTile(
              title: Text(widget.homework.text),
              children: const [Text('нет активных выполнений')],
            );
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
                  if (e.status == Status.completed || e.status == Status.confirmed) {
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
                      onTap: () async {
                        onTap(e).whenComplete(() {
                          setState(() {});
                        });
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

  Future<void> onTap(CompletionFlagModel c) => showModalBottomSheet(
      context: context,
      builder: (context) {
        return ElevatedButton.icon(
          onPressed: () {
            c.status == Status.completed ? widget.homework.unconfirmCompletion(c) : widget.homework.confirmCompletion(c);
          },
          label: Text(c.status == Status.completed ? 'отметить как не проверенное' : 'отметить как проверенное'),
          icon: Icon(c.status == Status.completed ? Icons.close : Icons.check),
        );
      });
}
