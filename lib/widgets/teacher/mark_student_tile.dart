import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class MarkStudentTile extends StatefulWidget {
  final StudentModel student;
  final LessonModel lesson;
  final DateTime date;
  final LessonMarkModel mark;
  const MarkStudentTile({required this.student, required this.lesson, required this.date, required this.mark, super.key});

  @override
  State<MarkStudentTile> createState() => _MarkStudentTileState();
}

class _MarkStudentTileState extends State<MarkStudentTile> {
  int? value;
  bool forceRefresh = false;

  @override
  Widget build(BuildContext context) {
    var selStyle = ButtonStyle(backgroundColor: MaterialStateProperty.all(Get.theme.colorScheme.secondary));
    return Card(
      color: Colors.black.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.student.fullName,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      value = 1;
                    });
                  },
                  style: value == 1 ? selStyle : null,
                  child: const Text('1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      value = 2;
                    });
                  },
                  style: value == 2 ? selStyle : null,
                  child: const Text('2'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      value = 3;
                    });
                  },
                  style: value == 3 ? selStyle : null,
                  child: const Text('3'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      value = 4;
                    });
                  },
                  style: value == 4 ? selStyle : null,
                  child: const Text('4'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      value = 5;
                    });
                  },
                  style: value == 5 ? selStyle : null,
                  child: const Text('5'),
                ),
                IconButton(
                  onPressed: () {
                    save();
                    setState(() {
                      forceRefresh = true;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            FutureBuilder<List<LessonMarkModel>>(
              future: _getStudentMarks(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Utils.progressIndicator();
                }
                if (snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                }
                List<LessonMarkModel> marks = snapshot.data!;
                return SizedBox(
                  height: 40,
                  child: GridView.count(
                    crossAxisCount: 8,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.3,
                    children: [
                      ...marks.map(
                        (e) => Container(
                          // padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${e.mark.toString()};',
                                ),
                                const SizedBox(width: 3,),
                                Text(e.type.label),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<LessonMarkModel>> _getStudentMarks() async {
    Map<String, List<LessonMarkModel>> allmarks = await widget.lesson.getAllLessonMarks(widget.date, forceRefresh: forceRefresh);
    var studmarks = allmarks[widget.student.id];
    forceRefresh = false;
    if (studmarks != null) {
      return studmarks;
    } else {
      return [];
    }
    // return allmarks[widget.student.id]!;
  }

  void save() async {
    if (value != null) {
      var nmark = LessonMarkModel.fromMap(
        widget.mark.id,
        {
          'teacher_id': widget.mark.teacherId,
          'student_id': widget.student.id,
          'date': widget.mark.date.toIso8601String(),
          'curriculum_id': widget.mark.curriculumId,
          'lesson_order': widget.mark.lessonOrder,
          // 'type': markType.nameString,
          'type_id': widget.mark.type.id,
          'comment': '',
          'mark': value,
        },
      );
      await nmark.save();
      // Get.back<bool>(result: true);
      // setState(() {});
    }
  }
}
