import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/pages/admin/person_edit.dart';
import 'package:schoosch/widgets/selectablevaluedropdown_field.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentsMarksPage extends StatefulWidget {
  final LessonModel _lesson;
  final DateTime _date;

  const StudentsMarksPage(this._date, this._lesson, {Key? key}) : super(key: key);

  @override
  State<StudentsMarksPage> createState() => _StudentsMarksPageState();
}

class _StudentsMarksPageState extends State<StudentsMarksPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Map<String, List<MarkModel>>>(
          future: widget._lesson.getAllMarks(widget._date),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return ListView(
              children: [
                ...snapshot.data!.keys.map(
                  (e) => MarkListTile(
                    e,
                    widget._lesson,
                    widget._date,
                    deleteMark,
                    editMark,
                    key: ValueKey(e),
                  ),
                )
              ].toList(),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: addMark,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Future<void> addMark() async {
    var res = await Get.to<bool>(
      () => MarkSheet(
          widget._lesson,
          MarkModel.empty()
            ..curriculumId = widget._lesson.curriculumId!
            ..lessonOrder = widget._lesson.order
            ..teacherId = PersonModel.currentUser!.id!
            ..date = widget._date,
          'Поставить оценку'),
    );
    if (res is bool) {
      setState(() {});
    }
  }

  void deleteMark(MarkModel mark) {
    mark.delete().then((value) => setState(() {}));
  }

  Future<void> editMark(MarkModel mark) async {
    var res = await Get.to<bool>(
      () => MarkSheet(widget._lesson, mark, 'Изменить оценку', editMode: true),
    );
    if (res is bool) {
      setState(() {});
    }
  }
}

class MarkListTile extends StatefulWidget {
  final String studentId;
  final LessonModel lesson;
  final DateTime date;
  final void Function(MarkModel) deleteFunc;
  final Future<void> Function(MarkModel) editFunc;

  const MarkListTile(this.studentId, this.lesson, this.date, this.deleteFunc, this.editFunc, {Key? key}) : super(key: key);

  @override
  State<MarkListTile> createState() => _MarkListTileState();
}

class _MarkListTileState extends State<MarkListTile> {
  StudentModel? student;

  @override
  void initState() {
    super.initState();
    InstitutionModel.currentInstitution.getPerson(widget.studentId).then((value) {
      if (mounted) {
        setState(() {
          student = value.asStudent;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (student == null) return const SizedBox.shrink();
    return FutureBuilder<List<MarkModel>>(
      future: widget.lesson.marksForStudent(student!, widget.date, forceUpdate: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return ExpansionTile(
          title: Text(student!.fullName),
          subtitle: Text(marksString(snapshot.data!)),
          children: [
            ...snapshot.data!.map((e) => MarkTile(e, widget.deleteFunc, widget.editFunc, key: ValueKey(e.id))).toList(),
          ],
        );
      },
    );
  }

  String marksString(List<MarkModel?> marks) {
    List<String> ms = [];
    for (var m in marks) {
      ms.add(m!.mark.toString());
    }
    return ms.join('; ');
  }
}

class MarkTile extends StatelessWidget {
  final MarkModel mark;
  final void Function(MarkModel) deleteFunc;
  final Future<void> Function(MarkModel) editFunc;

  const MarkTile(this.mark, this.deleteFunc, this.editFunc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(mark.comment),
      leading: Text(mark.mark.toString()),
      subtitle: FutureBuilder<PersonModel>(
        future: mark.teacher,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return Text(snapshot.data!.fullName);
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => editFunc(mark),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => deleteFunc(mark),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

class MarkSheet extends StatefulWidget {
  final String title;
  final LessonModel lesson;
  final MarkModel mark;
  final bool editMode;

  const MarkSheet(this.lesson, this.mark, this.title, {Key? key, this.editMode = false}) : super(key: key);

  @override
  State<MarkSheet> createState() => _MarkSheetState();
}

class _MarkSheetState extends State<MarkSheet> {
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
