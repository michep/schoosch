import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/daylessontime_list.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/pages/admin/person_edit.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/selectablevaluedropdown_field.dart';
import 'package:schoosch/widgets/selectablevaluelist_field.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassPage extends StatefulWidget {
  final ClassModel _aclass;
  final String _title;

  const ClassPage(this._aclass, this._title, {Key? key}) : super(key: key);

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _grade = TextEditingController();
  final TextEditingController _mastercont = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<StudentModel> _students = [];
  TeacherModel? _master;
  DayLessontimeModel? _dayLessontime;

  @override
  void initState() {
    _name.value = TextEditingValue(text: widget._aclass.name);
    _grade.value = TextEditingValue(text: widget._aclass.grade != 0 ? widget._aclass.grade.toString() : '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: MAppBar(
        widget._title,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _delete(widget._aclass),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _name,
                        decoration: InputDecoration(
                          label: Text(loc.className),
                        ),
                        validator: (value) => Utils.validateTextNotEmpty(value, loc.errorNameEmpty),
                      ),
                      TextFormField(
                        controller: _grade,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: Text(loc.classGrade),
                        ),
                        validator: _gradeValidator,
                      ),
                      SelectableValueDropdownFormField<PersonModel>(
                        title: loc.classMaster,
                        initFutureFunc: _initMaster,
                        initOptionsFutureFunc: _initMasterOptions,
                        titleFunc: (value) => value?.fullName ?? '',
                        listFunc: () => PeopleListPage(
                          InstitutionModel.currentInstitution.people,
                          selectionMode: true,
                          type: 'teacher',
                        ),
                        detailsFunc: () => PersonPage(_master!, _master!.fullName),
                        validatorFunc: (value) => Utils.validateTextNotEmpty(value, loc.errorTeacherEmpty),
                        callback: (value) => _setMaster(value),
                      ),
                      SelectableValueDropdownFormField<DayLessontimeModel>(
                        title: loc.classSchedule,
                        initFutureFunc: _initLessonTime,
                        initOptionsFutureFunc: _initLessonTimeOptions,
                        titleFunc: (value) => value?.name ?? '',
                        listFunc: () => DayLessontimeListPage(
                          InstitutionModel.currentInstitution,
                          selectionMode: true,
                        ),
                        validatorFunc: (value) => Utils.validateTextNotEmpty(value, loc.errorClassScheduleEmpty),
                        callback: (value) => _setLessonTime(value),
                      ),
                    ],
                  ),
                ),
                SelectableValueListFormField<PersonModel>(
                  title: loc.classStudents,
                  initListFutureFunc: _initStudents,
                  titleFunc: (value) => value?.fullName ?? '',
                  listFunc: () => PeopleListPage(InstitutionModel.currentInstitution.people, selectionMode: true, type: 'student'),
                  detailsFunc: (value) => PersonPage(value!, value.fullName),
                  listValidatorFunc: () => _students.isEmpty ? loc.errorClassStudentsEmpty : null,
                  addElementFunc: _addChild,
                  setElementFunc: _setChild,
                  removeElementFunc: _removeChild,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    child: Text(loc.saveChanges),
                    onPressed: () => _save(widget._aclass),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<PersonModel?> _initMaster() async {
    return widget._aclass.master.then((value) {
      if (value != null) {
        _mastercont.text = value.fullName;
        _master = value;
        return value;
      }
      return null;
    });
  }

  Future<List<PersonModel>> _initMasterOptions() async {
    var ppl = await InstitutionModel.currentInstitution.people();
    return ppl.where((element) => element.asTeacher != null).toList();
  }

  bool _setMaster(PersonModel? value) {
    if (value != null) {
      if (value.asTeacher != null) {
        _master = value.asTeacher;
        return true;
      } else {
        if (value is TeacherModel) {
          _master = (value);
          return true;
        } else {
          _master = null;
          Utils.showErrorSnackbar(S.of(context).errorPersonIsNotATeacher);
          return false;
        }
      }
    } else {
      _master = null;
      return true;
    }
  }

  String? _gradeValidator(String? value) {
    String? err;
    var loc = S.of(context);
    err = Utils.validateTextNotEmpty(value, loc.errorClassGradeEmpty);
    if (err != null) return err;
    int? g = int.tryParse(value!);
    if (g == null) return loc.errorClassGradeNotANumber;
    if (g < 1 || g > 11) return loc.errorClassGradeNotInRange;
    return null;
  }

  Future<DayLessontimeModel?> _initLessonTime() async {
    return widget._aclass.getDayLessontime();
  }

  Future<List<DayLessontimeModel>> _initLessonTimeOptions() async {
    return InstitutionModel.currentInstitution.daylessontimes;
  }

  bool _setLessonTime(DayLessontimeModel? value) {
    _dayLessontime = value;
    return true;
  }

  Future<List<PersonModel>> _initStudents() async {
    return widget._aclass.students(forceRefresh: true).then((value) {
      _students.addAll(value);
      return _students;
    });
  }

  bool _addChild(PersonModel? value) {
    var loc = S.of(context);
    if (value == null) return false;
    if (value.asStudent == null) {
      Utils.showErrorSnackbar(loc.errorPersonIsNotAStudent);
      return false;
    }
    if (_students.contains(value)) {
      Utils.showErrorSnackbar(loc.errorStudentAlreadyPresent);
      return false;
    }
    setState(() {
      _students.add(value.asStudent!);
    });
    return true;
  }

  bool _setChild(PersonModel value) {
    StudentModel sm;
    var loc = S.of(context);
    if (!value.types.contains(PersonType.student)) {
      Utils.showErrorSnackbar(loc.errorPersonIsNotAStudent);
      return false;
    }

    value.asStudent != null ? sm = value.asStudent! : sm = (value as StudentModel);

    setState(() {
      var i = _students.indexOf(sm);
      _students.remove(sm);
      _students.insert(i, sm);
    });
    return true;
  }

  bool _removeChild(PersonModel value) {
    setState(() {
      _students.remove(value);
    });
    return true;
  }

  Future<void> _save(ClassModel aclass) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map['name'] = _name.text;
      map['grade'] = int.parse(_grade.text);
      map['master_id'] = _master!.id!;
      map['lessontime_id'] = _dayLessontime!.id!;
      map['student_ids'] = _students.map((e) => e.id!).toList();

      var nclass = ClassModel.fromMap(aclass.id, map);
      await nclass.save();
      Get.back<ClassModel>(result: nclass);
    }
  }

  Future<void> _delete(ClassModel aclass) async {
    await aclass.delete();
    Get.back<ClassModel>(result: aclass);
  }
}
