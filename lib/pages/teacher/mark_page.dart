import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/pages/admin/person_edit.dart';
import 'package:schoosch/widgets/appbar.dart';
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
  int mark = 0;
  final TextEditingController _studentcont = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  StudentModel? _student;

  @override
  void initState() {
    super.initState();
    mark = widget.mark.mark;
    commentCont = TextEditingController.fromValue(TextEditingValue(text: widget.mark.comment));
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: MAppBar(widget.title),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView(
              children: [
                SelectableValueDropdownFormField<PersonModel>(
                  title: S.of(context).studentTitle,
                  initFutureFunc: _initStudent,
                  initOptionsFutureFunc: _initStudentOptions,
                  titleFunc: (value) => value?.fullName ?? '',
                  listFunc: () => PeopleListPage(widget.lesson.aclass.students, selectionMode: true, type: 'student', title: loc.classStudentsTitle),
                  detailsFunc: () => PersonPage(_student!, _student!.fullName),
                  validatorFunc: (value) => Utils.validateTextAndvAlueNotEmpty<StudentModel>(value, _student, loc.errorStudentEmpty),
                  callback: (value) => _setStudent(value),
                ),
                MarkFormField(
                  mark: widget.mark.mark,
                  onSaved: setMark,
                ),
                TextFormField(
                  controller: commentCont,
                  decoration: InputDecoration(
                    label: Text(S.of(context).commentTitle),
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

  void setMark(int? mark) {
    this.mark = mark!;
  }

  Future<PersonModel?> _initStudent() async {
    if (widget.mark.studentId.isNotEmpty) {
      _student = (await widget.mark.student).asStudent;
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
          'mark': mark,
        },
      );
      await nmark.save();
      Get.back<bool>(result: true);
    }
  }
}

class MarkFormField extends StatelessWidget {
  final int mark;
  final void Function(int?) onSaved;
  final String? Function(int?)? validator;

  const MarkFormField({
    Key? key,
    required this.mark,
    required this.onSaved,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<int>(
      initialValue: mark,
      onSaved: onSaved,
      validator: validator,
      builder: ((state) {
        var selStyle = ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(state.context).colorScheme.secondary));
        return InputDecorator(
          decoration: InputDecoration(label: Text(S.of(state.context).markTitle)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  state.didChange(1);
                  state.save();
                },
                style: state.value == 1 ? selStyle : null,
                child: const Text('1'),
              ),
              ElevatedButton(
                onPressed: () {
                  state.didChange(2);
                  state.save();
                },
                style: state.value == 2 ? selStyle : null,
                child: const Text('2'),
              ),
              ElevatedButton(
                onPressed: () {
                  state.didChange(3);
                  state.save();
                },
                style: state.value == 3 ? selStyle : null,
                child: const Text('3'),
              ),
              ElevatedButton(
                onPressed: () {
                  state.didChange(4);
                  state.save();
                },
                style: state.value == 4 ? selStyle : null,
                child: const Text('4'),
              ),
              ElevatedButton(
                onPressed: () {
                  state.didChange(5);
                  state.save();
                },
                style: state.value == 5 ? selStyle : null,
                child: const Text('5'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
