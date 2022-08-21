import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/pages/admin/person_edit.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/selectablevaluedropdown_field.dart';
import 'package:schoosch/widgets/utils.dart';

class HomeworkPage extends StatefulWidget {
  final LessonModel lesson;
  final HomeworkModel homework;
  final StudentModel? student;
  final bool personalHomework;

  const HomeworkPage(this.lesson, this.homework, {Key? key, this.personalHomework = true, this.student}) : super(key: key);

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  final _formKey = GlobalKey<FormState>();
  StudentModel? _student;
  final TextEditingController _studentcont = TextEditingController();
  final TextEditingController _commentcont = TextEditingController();
  final ScrollController _scrollcon = ScrollController();

  @override
  void initState() {
    _student = widget.student;
    _commentcont.value = TextEditingValue(text: widget.homework.text);
    if (_student != null) _studentcont.value = TextEditingValue(text: _student!.fullName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: const MAppBar('Домашнее задание'),
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                if (widget.personalHomework)
                  SelectableValueDropdownFormField<PersonModel>(
                    title: loc.studentTitle,
                    initFutureFunc: _initStudent,
                    initOptionsFutureFunc: _initStudentOptions,
                    titleFunc: (value) => value?.fullName ?? '',
                    listFunc: () => PeopleListPage(widget.lesson.aclass.students, selectionMode: true, type: 'student', title: loc.classStudentsTitle),
                    detailsFunc: () => PersonPage(_student!, _student!.fullName),
                    validatorFunc: (value) => Utils.validateTextAndvAlueNotEmpty<StudentModel>(value, _student, loc.errorStudentEmpty),
                    callback: (value) => _setStudent(value),
                  ),
                Scrollbar(
                  controller: _scrollcon,
                  thumbVisibility: true,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Задание'),
                    ),
                    controller: _commentcont,
                    maxLines: 3,
                    scrollController: _scrollcon,
                    validator: (value) => Utils.validateTextNotEmpty(value, 'Текст задания не может быть пустым'),
                  ),
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
    if (widget.homework.studentId != null) {
      _student = (await widget.homework.student)!;
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
    if (_formKey.currentState!.validate()) {
      var nhw = HomeworkModel.fromMap(
        widget.homework.id,
        {
          'date': Timestamp.fromDate(widget.homework.date),
          'text': _commentcont.value.text,
          'class_id': widget.homework.classId,
          'student_id': _student?.id,
          'teacher_id': widget.homework.teacherId,
          'curriculum_id': widget.homework.curriculumId,
        },
      );
      await nhw.save();
      Get.back<bool>(result: true);
    }
  }
}
