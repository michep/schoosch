import 'package:flutter/material.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/widgets/rateteachersheet.dart';
import 'package:schoosch/widgets/utils.dart';
import 'package:schoosch/model/person_model.dart';

class RatePage extends StatefulWidget {
  const RatePage({required this.aclass, Key? key}) : super(key: key);
  final Future<ClassModel?> aclass;

  @override
  State<RatePage> createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  Future<void> activateBottomSheet(BuildContext context, TeacherModel teach) async {
    return await showModalBottomSheet(
        context: context,
        builder: (_) {
          return RateSheet(teach);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Учителя'),
      ),
      body: FutureBuilder<ClassModel?>(
          future: widget.aclass,
          builder: (context, classsnap) {
            if (!classsnap.hasData) return Utils.progressIndicator();
            if (classsnap.data == null) return const Center(child: Text('У ученика не определен класс'));
            return FutureBuilder<Map<TeacherModel, List<String>>>(
                future: classsnap.data!.teachers,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Column(
                          children: [
                            snapshot.data!.keys.toList().isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.keys.length,
                                      itemBuilder: (context, elem) {
                                        var m = snapshot.data!;
                                        var teacher = m.keys.toList()[elem];
                                        var lessons = m[teacher]!;
                                        return Card(
                                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                                          elevation: 4,
                                          child: ListTile(
                                            leading: const Icon(Icons.person),
                                            title: Text(teacher.firstname + ' ' + teacher.lastname),
                                            subtitle: Text(lessons.join(', ')),
                                            trailing: FutureBuilder<double>(
                                                future: teacher.averageRating,
                                                builder: (context, snapshot) {
                                                  return snapshot.hasData
                                                      ? Text(snapshot.data!.toStringAsFixed(2))
                                                      : const Text('нет оценок');
                                                }),
                                            onTap: () {
                                              activateBottomSheet(context, teacher).then((_) => setState(() {}));
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const Text('Нет учителей'),
                          ],
                        )
                      : Utils.progressIndicator();
                });
          }),
    );
  }
}
