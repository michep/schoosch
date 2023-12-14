import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/marktype_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/mark_type_field.dart';
import 'package:schoosch/widgets/teacher/mark_student_tile.dart';
import 'package:schoosch/widgets/utils.dart';
// import 'package:schoosch/widgets/mark_type_field.dart';

class ClassMarkPage extends StatefulWidget {
  final String title;
  final LessonModel lesson;
  final DateTime date;
  final LessonMarkModel mark;
  const ClassMarkPage(this.lesson, this.title, this.date, this.mark, {super.key});

  @override
  State<ClassMarkPage> createState() => _ClassMarkPageState();
}

class _ClassMarkPageState extends State<ClassMarkPage> {
  final TextEditingController _name = TextEditingController();
  late MarkType? marktype;

  @override
  void initState() {
    //
    marktype = widget.mark.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => Get.back<bool>(result: true),
      child: Scaffold(
        appBar: MAppBar(widget.title),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 10, left: 10),
            child: Column(
              children: [
                TextField(
                  onChanged: (_) => setState(() {}),
                  controller: _name,
                  decoration: InputDecoration(
                    label: Text(loc.personName),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() {
                        _name.value = TextEditingValue.empty;
                      }),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MarkTypeFormField(
                  markType: widget.mark.type,
                  onChanged: (type) {
                    if (type is MarkType) {
                      marktype = type;
                      widget.mark.type = marktype!;
                    }
                  },
                  validator: (value) => Utils.validateType(value, S.of(context).errorUnknownMarkType),
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<StudentModel>>(
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
                    List<StudentModel> studs = snapshot.data!.where(_filter).toList();
                    return Expanded(
                      child: ListView.builder(
                        itemCount: studs.length,
                        itemBuilder: (context, index) {
                          return MarkStudentTile(
                            student: studs[index],
                            lesson: widget.lesson,
                            date: widget.date,
                            mark: widget.mark,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _filter(PersonModel person) {
    return person.fullName.toUpperCase().contains(_name.text.toUpperCase());
  }

  Future<List<StudentModel>> _initStudents() async {
    return widget.lesson.aclass.students();
  }
}
