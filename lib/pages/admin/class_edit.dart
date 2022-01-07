import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/daylessontime_list.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/pages/admin/person_edit.dart';
import 'package:schoosch/widgets/selectablevalue_field.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
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
                        decoration: const InputDecoration(
                          label: Text(
                            'Название учебного класса',
                          ),
                        ),
                        validator: (value) => Utils.validateTextNotEmpty(value, 'Название должно быть заполнено'),
                      ),
                      TextFormField(
                        controller: _grade,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text(
                            'Год обучения',
                          ),
                        ),
                        validator: _gradeValidator,
                      ),
                      SelectableValueFormField<PersonModel>(
                        title: 'Преподаватель',
                        initFutureFunc: _initMaster,
                        titleFunc: (value) => value?.fullName ?? '',
                        listFunc: () => PeopleListPage(
                          InstitutionModel.currentInstitution,
                          selectionMode: true,
                          type: 'teacher',
                        ),
                        detailsFunc: () => PersonPage(_master!, _master!.fullName),
                        validatorFunc: (value) => Utils.validateTextNotEmpty(value, 'Преподаватель должен быть выбран'),
                        callback: (value) => _setMaster(value),
                      ),
                      SelectableValueFormField<DayLessontimeModel>(
                        title: 'Расписание времени уроков',
                        initFutureFunc: _initLessonTime,
                        titleFunc: (value) => value?.name ?? '',
                        listFunc: () => DayLessontimeListPage(
                          InstitutionModel.currentInstitution,
                          selectionMode: true,
                        ),
                        // detailsFunc: () => PersonPage(master!, master!.fullName),
                        validatorFunc: (value) => Utils.validateTextNotEmpty(value, 'Расписание должно быть выбрано'),
                        callback: (value) => _setLessonTime(value),
                      ),
                    ],
                  ),
                ),
                SelectableValueListFormField<PersonModel>(
                  title: 'Учащиеяся класса',
                  initListFutureFunc: _initStudents,
                  titleFunc: (value) => value?.fullName ?? '',
                  listFunc: () => PeopleListPage(InstitutionModel.currentInstitution, selectionMode: true, type: 'student'),
                  detailsFunc: (value) => PersonPage(value!, value.fullName),
                  listValidatorFunc: () => _students.isEmpty ? 'Нужно выбрать учащихся' : null,
                  addElementFunc: _addChild,
                  setElementFunc: _setChild,
                  removeElementFunc: _removeChild,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    child: const Text('Сохранить изменения'),
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

  Future<PersonModel> _initMaster() async {
    return widget._aclass.master.then((value) {
      if (value != null) {
        _mastercont.text = value.fullName;
        _master = value;
      }
      return _master as PersonModel;
    });
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
          Utils.showErrorSnackbar(
            'Выбранный персонаж не является преподавателем',
          );
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
    err = Utils.validateTextNotEmpty(value, 'Год обучения должен быть заполнен');
    if (err != null) return err;
    int? g = int.tryParse(value!);
    if (g == null) return 'Год обучения должен быть числом';
    if (g < 1 || g > 11) return 'Год обучения должен быть между 1 и 11';
  }

  Future<DayLessontimeModel?> _initLessonTime() async {
    return widget._aclass.getDayLessontime().then((value) {
      return value;
    });
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
    if (value == null) return false;
    if (value.asStudent == null) {
      Utils.showErrorSnackbar(
        'Выбранный персонаж не является учащимся',
      );
      return false;
    }
    if (_students.contains(value)) {
      Utils.showErrorSnackbar(
        'Выбранный учащийся уже присутствует в группе',
      );
      return false;
    }
    setState(() {
      _students.add(value.asStudent!);
    });
    return true;
  }

  bool _setChild(PersonModel value) {
    StudentModel sm;
    if (!value.types.contains('student')) {
      Utils.showErrorSnackbar(
        'Выбранный персонаж больше не является учащимся',
      );
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

  Future<void> _delete(ClassModel aclass) async {}
}
