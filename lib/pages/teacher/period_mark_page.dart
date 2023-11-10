import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/marktype_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/mark_field.dart';
// import 'package:schoosch/widgets/mark_type_field.dart';
import 'package:schoosch/widgets/utils.dart';

class PeriodMarkPage extends StatefulWidget {
  final String title;
  final PeriodMarkModel mark;
  final bool editMode;
  final String studentId;

  const PeriodMarkPage(this.studentId, this.mark, this.title, {super.key, this.editMode = false});

  @override
  State<PeriodMarkPage> createState() => _PeriodMarkPageState();
}

class _PeriodMarkPageState extends State<PeriodMarkPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentcont = TextEditingController();
  // final TextEditingController _studentcont = TextEditingController();
  // final ScrollController _scrollcon = ScrollController();
  late int mark;
  late MarkType markType;
  // StudentModel? _student;

  @override
  void initState() {
    mark = widget.mark.mark;
    // markType = widget.mark.type;
    _commentcont.value = TextEditingValue(text: widget.mark.comment);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: MAppBar(widget.title),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView(
              children: [
                // SelectableValueDropdownFormField<PersonModel>(
                //   title: loc.studentTitle,
                //   initFutureFunc: _initStudent,
                //   initOptionsFutureFunc: _initStudentOptions,
                //   titleFunc: (value) => value?.fullName ?? '',
                //   listFunc: () => PeopleListPage(widget.lesson.aclass.students, selectionMode: true, type: 'student', title: loc.classStudentsTitle),
                //   detailsFunc: () => PersonPage(_student!, _student!.fullName),
                //   validatorFunc: (value) => Utils.validateTextAndvAlueNotEmpty<StudentModel>(value, _student, loc.errorStudentEmpty),
                //   callback: (value) => _setStudent(value),
                // ),
                MarkFormField(
                  mark: widget.mark.mark,
                  onSaved: setMark,
                  validator: (value) => Utils.validateMark(value, AppLocalizations.of(context)!.errorMarkError),
                ),
                // MarkTypeFormField(
                //   markType: markType,
                //   onChanged: (v) {
                //     if (v is MarkType) {
                //       setState(() {
                //         markType = v;
                //       });
                //     }
                //   },
                // ),
                // TextFormField(
                //   decoration: InputDecoration(
                //     label: Text(AppLocalizations.of(context)!.commentTitle),
                //   ),
                //   controller: _commentcont,
                //   scrollController: _scrollcon,
                //   keyboardType: TextInputType.multiline,
                //   maxLines: 3,
                // ),
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

  // Future<PersonModel?> _initStudent() async {
  //   if (widget.mark.studentId.isNotEmpty) {
  //     _student = await widget.mark.student;
  //     _studentcont.text = _student!.fullName;
  //     return _student;
  //   }
  //   return null;
  // }

  // Future<List<PersonModel>> _initStudentOptions() async {
  //   var ppl = await widget.lesson.aclass.students();
  //   return ppl;
  // }

  // bool _setStudent(PersonModel? value) {
  //   if (value != null) {
  //     _student = value as StudentModel;
  //     return true;
  //   } else {
  //     _student = null;
  //     return true;
  //   }
  // }

  void save() async {
    if (_formKey.currentState!.validate()) {
      var nmark = PeriodMarkModel.fromMap(
        widget.mark.id,
        {
          'teacher_id': widget.mark.teacherId,
          'student_id': widget.studentId,
          'curriculum_id': widget.mark.curriculumId,
          'period_id': widget.mark.periodId,
          'type': 'period',
          'comment': '',
          'mark': mark,
        },
      );
      await nmark.save();
      Get.back<bool>(result: true);
    }
  }
}
