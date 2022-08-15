import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/pages/admin/person_edit.dart';
import 'package:schoosch/widgets/selectablevaluedropdown_field.dart';
import 'package:schoosch/widgets/utils.dart';

class MarkPage extends StatefulWidget {
  final String title;
  final LessonModel lesson;
  final MarkModel mark;
  final bool editMode;

  const MarkPage(this.lesson, this.mark, this.title, {Key? key, this.editMode = false}) : super(key: key);

  @override
  State<MarkPage> createState() => _MarkPageState();
}

class _MarkPageState extends State<MarkPage> {
  late TextEditingController commentCont;
  late TextEditingController markCont;
  final TextEditingController _studentcont = TextEditingController();

  StudentModel? _student;

  @override
  void initState() {
    super.initState();
    commentCont = TextEditingController.fromValue(TextEditingValue(text: widget.mark.comment));
    markCont = TextEditingController.fromValue(TextEditingValue(text: widget.mark.mark.toStringAsFixed(0)));
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView(
              children: [
                SelectableValueDropdownFormField<PersonModel>(
                  title: "Ученик",
                  initFutureFunc: _initStudent,
                  initOptionsFutureFunc: _initStudentOptions,
                  titleFunc: (value) => value?.fullName ?? '',
                  listFunc: () => PeopleListPage(widget.lesson.aclass.students, selectionMode: true, type: 'student'),
                  detailsFunc: () => PersonPage(_student!, _student!.fullName),
                  validatorFunc: (value) => Utils.validateTextAndvAlueNotEmpty<StudentModel>(value, _student, loc.errorStudentEmpty),
                  callback: (value) => _setStudent(value),
                ),
                TextField(
                  controller: markCont,
                  decoration: const InputDecoration(
                    label: Text('Оценка'),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: commentCont,
                  decoration: const InputDecoration(
                    label: Text('Комментарий'),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    onPressed: save,
                    child: Text(loc.saveChanges),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<PersonModel?> _initStudent() async {
    _student = (await widget.mark.student).asStudent;
    if (_student != null) {
      _studentcont.text = _student!.fullName;
      return _student;
    }
    return null;
  }

  Future<List<PersonModel>> _initStudentOptions() async {
    var ppl = await widget.lesson.aclass.students();
    return ppl;
  }

  bool _setStudent(PersonModel? value) {
    if (value != null) {
      _student = value as StudentModel;
      return true;
    } else {
      _student = null;
      return true;
    }
  }

  void save() async {
    var nmark = MarkModel.fromMap(
      widget.mark.id,
      {
        'teacher_id': widget.mark.teacherId,
        'student_id': _student!.id,
        'date': Timestamp.fromDate(widget.mark.date),
        'curriculum_id': widget.mark.curriculumId,
        'lesson_order': widget.mark.lessonOrder,
        'type': widget.mark.type,
        'comment': commentCont.value.text,
        'mark': int.parse(markCont.value.text),
      },
    );
    await nmark.save();
    Get.back<bool>(result: true);
  }
}
