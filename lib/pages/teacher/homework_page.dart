import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/proxy_controller.dart';
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
  final CurriculumModel curriculum;
  final HomeworkModel homework;
  final StudentModel? student = null;
  final bool isPersonalHomework;
  final List<String> studentIds;

  const HomeworkPage(this.lesson, this.curriculum, this.homework, this.studentIds, {Key? key, this.isPersonalHomework = true}) : super(key: key);

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  final _formKey = GlobalKey<FormState>();
  final _studentFieldKey = GlobalKey<FormFieldState>();
  StudentModel? _student;
  DateTime? _todate;
  final TextEditingController _studentcont = TextEditingController();
  final TextEditingController _commentcont = TextEditingController();
  final TextEditingController _todatecont = TextEditingController();
  final ScrollController _scrollcon = ScrollController();

  @override
  void initState() {
    _student = widget.student;
    _commentcont.value = TextEditingValue(text: widget.homework.text);
    if (_student != null) _studentcont.value = TextEditingValue(text: _student!.fullName);
    if (widget.homework.todate != null) {
      _todate = widget.homework.todate;
      _todatecont.value = TextEditingValue(text: DateFormat('dd MMM yyyy').format(widget.homework.todate!));
    } else {
      Get.find<ProxyStore>().getNextLessonDate(widget.lesson.aclass, widget.curriculum, widget.homework.date).then(
            (value) => setState(
              () {
                _todate = value;
                _todatecont.value = TextEditingValue(text: DateFormat('dd MMM yyyy').format(value));
              },
            ),
          );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: MAppBar(S.of(context).homeworkTitle),
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
                if (widget.isPersonalHomework)
                  SelectableValueDropdownFormField<PersonModel>(
                    key: _studentFieldKey,
                    title: loc.studentTitle,
                    initFutureFunc: _initStudent,
                    initOptionsFutureFunc: _initStudentOptions,
                    titleFunc: (value) => value?.fullName ?? '',
                    listFunc: () => PeopleListPage(widget.lesson.aclass.students, selectionMode: true, type: 'student', title: loc.classStudentsTitle),
                    detailsFunc: () => PersonPage(_student!, _student!.fullName),
                    validatorFunc: (value) => Utils.validateTextNotEmpty(value, S.of(context).errorStudentEmpty),
                    callback: (value) => _setStudent(value),
                  ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text(S.of(context).homeworkTextTitle),
                  ),
                  controller: _commentcont,
                  maxLines: 3,
                  scrollController: _scrollcon,
                  validator: (value) => Utils.validateTextNotEmpty(value, S.of(context).errorHomeworkTextEmpty),
                ),
                DateTimeField(
                  controller: _todatecont,
                  initialValue: _todate,
                  format: DateFormat('dd MMM yyyy'),
                  onChanged: (DateTime? date) => _todate = date,
                  decoration: InputDecoration(
                    label: Text(loc.todateTitle),
                  ),
                  onShowPicker: (context, currentValue) async {
                    var date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    return date;
                  },
                  validator: (value) => Utils.validateDateTimeNotEmpty(value, loc.errorScheduleFromDateEmpty),
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
          'date': widget.homework.date.toIso8601String(),
          'todate': _todate?.toIso8601String(),
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
