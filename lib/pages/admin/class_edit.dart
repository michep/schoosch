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
  final ClassModel aclass;
  final String title;

  const ClassPage(this.aclass, this.title, {Key? key}) : super(key: key);

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _grade = TextEditingController();
  final TextEditingController _mastercont = TextEditingController();
  final TextEditingController _daylessontimecont = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<StudentModel> students = [];
  TeacherModel? master;
  DayLessontimeModel? dayLessontime;

  @override
  void initState() {
    _name.value = TextEditingValue(text: widget.aclass.name);
    _grade.value = TextEditingValue(text: widget.aclass.grade != 0 ? widget.aclass.grade.toString() : '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => delete(widget.aclass),
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
                        validator: gradeValidator,
                      ),
                      SelectableValueFormField<PersonModel>(
                        title: 'Преподаватель',
                        initFutureFunc: initMaster,
                        titleFunc: (value) => value?.fullName ?? '',
                        listFunc: () => PeopleListPage(
                          InstitutionModel.currentInstitution,
                          selectionMode: true,
                          type: 'teacher',
                        ),
                        detailsFunc: () => PersonPage(master!, master!.fullName),
                        validatorFunc: (value) => Utils.validateTextNotEmpty(value, 'Преподаватель должен быть выбран'),
                        callback: (value) => setMaster(value),
                      ),
                      SelectableValueFormField<DayLessontimeModel>(
                        title: 'Расписание времени уроков',
                        initFutureFunc: initLessonTime,
                        titleFunc: (value) => value?.name ?? '',
                        listFunc: () => DayLessontimeListPage(
                          InstitutionModel.currentInstitution,
                          selectionMode: true,
                        ),
                        // detailsFunc: () => PersonPage(master!, master!.fullName),
                        validatorFunc: (value) => Utils.validateTextNotEmpty(value, 'Расписание должно быть выбрано'),
                        callback: (value) => setLessonTime(value),
                      ),
                    ],
                  ),
                ),
                SelectableValueListFormField<PersonModel>(
                  title: 'Учащиеяся класса',
                  initListFutureFunc: initStudents,
                  titleFunc: (value) => value?.fullName ?? '',
                  listFunc: () => PeopleListPage(InstitutionModel.currentInstitution, selectionMode: true, type: 'student'),
                  detailsFunc: (value) => PersonPage(value!, value.fullName),
                  listValidatorFunc: () => students.isEmpty ? 'Нужно выбрать учащихся' : null,
                  addElementFunc: addChild,
                  setElementFunc: setChild,
                  removeElementFunc: removeChild,
                ),
                ElevatedButton(
                  child: const Text('Сохранить изменения'),
                  onPressed: () => save(widget.aclass),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<PersonModel> initMaster() async {
    return widget.aclass.master.then((value) {
      if (value != null) {
        _mastercont.text = value.fullName;
        master = value;
      }
      return master as PersonModel;
    });
  }

  bool setMaster(PersonModel? value) {
    if (value != null) {
      if (value.asTeacher != null) {
        master = value.asTeacher;
        return true;
      } else {
        if (value is TeacherModel) {
          master = (value);
          return true;
        } else {
          master = null;
          Utils.showErrorSnackbar(
            'Выбранный персонаж не является преподавателем',
          );
          return false;
        }
      }
    } else {
      master = null;
      return true;
    }
  }

  String? gradeValidator(String? value) {
    String? err;
    err = Utils.validateTextNotEmpty(value, 'Год обучения должен быть заполнен');
    if (err != null) return err;
    int? g = int.tryParse(value!);
    if (g == null) return 'Год обучения должен быть числом';
    if (g < 1 || g > 11) return 'Год обучения должен быть между 1 и 11';
  }

  Future<DayLessontimeModel?> initLessonTime() async {
    return widget.aclass.getDayLessontime().then((value) {
      return value;
    });
  }

  bool setLessonTime(DayLessontimeModel? value) {
    dayLessontime = value;
    return true;
  }

  Future<List<PersonModel>> initStudents() async {
    return widget.aclass.students(forceRefresh: true).then((value) {
      students.addAll(value);
      return students;
    });
  }

  bool addChild(PersonModel? value) {
    if (value == null) return false;
    if (value.asStudent == null) {
      Utils.showErrorSnackbar(
        'Выбранный персонаж не является учащимся',
      );
      return false;
    }
    if (students.contains(value)) {
      Utils.showErrorSnackbar(
        'Выбранный учащийся уже присутствует в группе',
      );
      return false;
    }
    setState(() {
      students.add(value.asStudent!);
    });
    return true;
  }

  bool setChild(PersonModel value) {
    StudentModel sm;
    if (!value.types.contains('student')) {
      Utils.showErrorSnackbar(
        'Выбранный персонаж больше не является учащимся',
      );
      return false;
    }

    value.asStudent != null ? sm = value.asStudent! : sm = (value as StudentModel);

    setState(() {
      var i = students.indexOf(sm);
      students.remove(sm);
      students.insert(i, sm);
    });
    return true;
  }

  bool removeChild(PersonModel value) {
    setState(() {
      students.remove(value);
    });
    return true;
  }

  Future<void> save(ClassModel aclass) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map['name'] = _name.text;
      map['grade'] = int.parse(_grade.text);
      map['master_id'] = master!.id!;
      map['lessontime_id'] = dayLessontime!.id!;
      map['student_ids'] = students.map((e) => e.id!).toList();

      var nclass = ClassModel.fromMap(aclass.id, map);
      await nclass.save();
      Get.back<ClassModel>(result: nclass);
    }
  }

  Future<void> delete(ClassModel aclass) async {}
}
