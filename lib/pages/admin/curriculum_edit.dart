import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/pages/admin/person_edit.dart';
import 'package:schoosch/widgets/selectablevalue_field.dart';
import 'package:schoosch/widgets/selectablevaluelist_field.dart';
import 'package:schoosch/widgets/utils.dart';

class CurriculumPage extends StatefulWidget {
  final CurriculumModel curriculum;
  final String title;

  const CurriculumPage(this.curriculum, this.title, {Key? key}) : super(key: key);

  @override
  State<CurriculumPage> createState() => _CurriculumPageState();
}

class _CurriculumPageState extends State<CurriculumPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _alias = TextEditingController();
  final TextEditingController _mastercont = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<StudentModel> students = [];
  TeacherModel? master;

  @override
  void initState() {
    _name.value = TextEditingValue(text: widget.curriculum.name);
    _alias.value = TextEditingValue(text: widget.curriculum.alias ?? '');
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
            onPressed: () => delete(widget.curriculum),
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
                            'Название учебного предмета',
                          ),
                        ),
                        validator: (value) => Utils.validateTextNotEmpty(value, 'Название должно быть заполнено'),
                      ),
                      TextFormField(
                        controller: _alias,
                        decoration: const InputDecoration(
                          label: Text(
                            'Альтернативное название',
                          ),
                        ),
                      ),
                      SelectableValueFormField<PersonModel>(
                        title: 'Преподаватель',
                        initFutureFunc: initMaster,
                        titleFunc: (value) => value?.fullName ?? '',
                        listFunc: () => PeopleListPage(InstitutionModel.currentInstitution, selectionMode: true, type: 'teacher'),
                        detailsFunc: () => PersonPage(master!, master!.fullName),
                        validatorFunc: (value) => Utils.validateTextNotEmpty(value, 'Преподаватель должен быть выбран'),
                        callback: (value) => setMaster(value),
                      ),
                    ],
                  ),
                ),
                SelectableValueListFormField<PersonModel>(
                  title: 'Группа учащихся',
                  initListFutureFunc: initStudents,
                  titleFunc: (value) => value?.fullName ?? '',
                  listFunc: () => PeopleListPage(InstitutionModel.currentInstitution, selectionMode: true, type: 'student'),
                  detailsFunc: (value) => PersonPage(value!, value.fullName),
                  addElementFunc: addStudent,
                  setElementFunc: setStudent,
                  removeElementFunc: removeStudent,
                ),
                ElevatedButton(
                  child: const Text('Сохранить изменения'),
                  onPressed: () => save(widget.curriculum),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<PersonModel> initMaster() async {
    return widget.curriculum.master.then((value) {
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

  Future<List<PersonModel>> initStudents() async {
    return widget.curriculum.students(forceRefresh: true).then((value) {
      students.addAll(value);
      return students;
    });
  }

  bool addStudent(PersonModel? value) {
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

  bool setStudent(PersonModel value) {
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

  bool removeStudent(PersonModel value) {
    setState(() {
      students.remove(value);
    });
    return true;
  }

  Future<void> save(CurriculumModel curriculum) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map['name'] = _name.text;
      map['alias'] = _alias.text.isNotEmpty ? _alias.text : null;
      map['master_id'] = master!.id!;
      map['student_ids'] = students.map((e) => e.id!).toList();

      var ncurriculum = CurriculumModel.fromMap(curriculum.id, map);
      await ncurriculum.save();
      Get.back<CurriculumModel>(result: ncurriculum);
    }
  }

  Future<void> delete(CurriculumModel curriculum) async {}
}
