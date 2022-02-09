import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/pages/admin/person_edit.dart';
import 'package:schoosch/widgets/selectablevaluedropdown_field.dart';
import 'package:schoosch/widgets/selectablevaluelist_field.dart';
import 'package:schoosch/widgets/utils.dart';

class CurriculumPage extends StatefulWidget {
  final CurriculumModel _curriculum;
  final String _title;

  const CurriculumPage(this._curriculum, this._title, {Key? key}) : super(key: key);

  @override
  State<CurriculumPage> createState() => _CurriculumPageState();
}

class _CurriculumPageState extends State<CurriculumPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _alias = TextEditingController();
  final TextEditingController _mastercont = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<StudentModel> _students = [];
  TeacherModel? _master;

  @override
  void initState() {
    _name.value = TextEditingValue(text: widget._curriculum.name);
    _alias.value = TextEditingValue(text: widget._curriculum.alias ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _delete(widget._curriculum),
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
                          label: Text(loc.curriculumName),
                        ),
                        validator: (value) => Utils.validateTextNotEmpty(value, loc.errorNameEmpty),
                      ),
                      TextFormField(
                        controller: _alias,
                        decoration: InputDecoration(
                          label: Text(loc.curriculumAlternateName),
                        ),
                      ),
                      SelectableValueDropdownFormField<PersonModel>(
                        title: loc.curriculumTeacher,
                        initFutureFunc: _initMaster,
                        initOptionsFutureFunc: _initMasterOptions,
                        titleFunc: (value) => value?.fullName ?? '',
                        listFunc: () => PeopleListPage(InstitutionModel.currentInstitution, selectionMode: true, type: 'teacher'),
                        detailsFunc: () => PersonPage(_master!, _master!.fullName),
                        validatorFunc: (value) => Utils.validateTextAndvAlueNotEmpty<TeacherModel>(value, _master, loc.errorTeacherEmpty),
                        callback: (value) => _setMaster(value),
                      ),
                    ],
                  ),
                ),
                SelectableValueListFormField<PersonModel>(
                  title: loc.curriculumStudents,
                  initListFutureFunc: _initStudents,
                  titleFunc: (value) => value?.fullName ?? '',
                  listFunc: () => PeopleListPage(InstitutionModel.currentInstitution, selectionMode: true, type: 'student'),
                  detailsFunc: (value) => PersonPage(value!, value.fullName),
                  addElementFunc: _addStudent,
                  setElementFunc: _setStudent,
                  removeElementFunc: _removeStudent,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    child: Text(loc.saveChanges),
                    onPressed: () => _save(widget._curriculum),
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
    return widget._curriculum.master.then((value) {
      if (value != null) {
        _mastercont.text = value.fullName;
        _master = value;
      }
      return _master as PersonModel;
    });
  }

  Future<List<PersonModel>> _initMasterOptions() async {
    var ppl = await InstitutionModel.currentInstitution.people;
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

  Future<List<PersonModel>> _initStudents() async {
    return widget._curriculum.students(forceRefresh: true).then((value) {
      _students.addAll(value);
      return _students;
    });
  }

  bool _addStudent(PersonModel? value) {
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

  bool _setStudent(PersonModel value) {
    StudentModel sm;
    if (!value.types.contains(PersonType.student)) {
      Utils.showErrorSnackbar(S.of(context).errorPersonIsNotAStudent);
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

  bool _removeStudent(PersonModel value) {
    setState(() {
      _students.remove(value);
    });
    return true;
  }

  Future<void> _save(CurriculumModel curriculum) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map['name'] = _name.text;
      map['alias'] = _alias.text.isNotEmpty ? _alias.text : null;
      map['master_id'] = _master!.id!;
      map['student_ids'] = _students.map((e) => e.id!).toList();

      var ncurriculum = CurriculumModel.fromMap(curriculum.id, map);
      await ncurriculum.save();
      Get.back<CurriculumModel>(result: ncurriculum);
    }
  }

  Future<void> _delete(CurriculumModel curriculum) async {}
}
