import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/pages/admin/person_edit.dart';
import 'package:schoosch/widgets/utils.dart';

class CurriculumPage extends StatefulWidget {
  final CurriculumModel curriculum;
  final String title;

  const CurriculumPage(this.curriculum, this.title, {Key? key}) : super(key: key);

  @override
  State<CurriculumPage> createState() => _VenuePageState();
}

class _VenuePageState extends State<CurriculumPage> {
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
    widget.curriculum.students.then((value) {
      setState(() {
        students.addAll(value);
      });
    });
    widget.curriculum.master.then((value) {
      if (value != null) {
        setState(() {
          _mastercont.text = value.fullName;
          master = value;
        });
      }
    });
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
                      masterFormField(context),
                    ],
                  ),
                ),
                childrenFormField(context),
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

  Widget masterFormField(BuildContext context) {
    return TextFormField(
      controller: _mastercont,
      showCursor: false,
      keyboardType: TextInputType.none,
      decoration: InputDecoration(
        label: const Text(
          'Преподаватель',
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: master == null
              ? IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: selectMaster,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: openMaster,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: removeMaster,
                    ),
                  ],
                ),
        ),
      ),
      validator: (value) => Utils.validateTextNotEmpty(value, 'Преподаватель должен быть выбран'),
    );
  }

  Future<void> selectMaster() async {
    var res = await Get.to<PersonModel>(
      () => PeopleListPage(
        InstitutionModel.currentInstitution,
        selectionMode: true,
        type: 'teacher',
      ),
      transition: Transition.rightToLeft,
    );
    if (res is PersonModel) {
      if (res.asTeacher == null) {
        removeMaster();
        Utils.showErrorSnackbar(
          'Выбранный персонаж не является преподавателем',
        );
        return;
      }
      setState(() {
        _mastercont.text = res.fullName;
        master = res.asTeacher;
      });
    }
  }

  Future<void> openMaster() async {
    var res = await Get.to<PersonModel>(
      () => PersonPage(master!, master!.fullName),
      transition: Transition.rightToLeft,
    );
    if (res is PersonModel) {
      if (res.asTeacher == null) {
        removeMaster();
        Utils.showErrorSnackbar(
          'Выбранный персонаж больше не является преподавателем',
        );
        return;
      }
      setState(() {
        _mastercont.text = res.fullName;
        master = res.asTeacher;
      });
    }
  }

  void removeMaster() {
    setState(() {
      master = null;
      _mastercont.text = '';
    });
  }

  Widget childrenFormField(BuildContext context) {
    return FormField<List<StudentModel>>(
      initialValue: students,
      builder: (fieldstate) => ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text('Группа учащихся (${students.length})'),
        subtitle: fieldstate.hasError
            ? Text(fieldstate.errorText!, style: TextStyle(fontSize: 12, color: Theme.of(context).errorColor))
            : const SizedBox.shrink(),
        trailing: IconButton(
          icon: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: addChild,
        ),
        children: [
          ...students.map((s) => ListTile(
                title: SelectableText(s.fullName),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () => openChild(s),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeChild(s),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Future<void> addChild() async {
    var res = await Get.to<PersonModel>(
      () => PeopleListPage(
        InstitutionModel.currentInstitution,
        selectionMode: true,
        type: 'student',
      ),
      transition: Transition.rightToLeft,
    );
    if (res is PersonModel) {
      if (res.asStudent == null) {
        Utils.showErrorSnackbar(
          'Выбранный персонаж не является учащимся',
        );
        return;
      }
      if (students.contains(res)) {
        Utils.showErrorSnackbar(
          'Выбранный учащийся уже присутствует в группе',
        );
        return;
      }
      setState(() {
        students.add(res.asStudent!);
      });
    }
  }

  Future<void> openChild(StudentModel student) async {
    var res = await Get.to<PersonModel>(
      () => PersonPage(student, student.fullName),
      transition: Transition.rightToLeft,
    );
    if (res is PersonModel) {
      if (res.asStudent == null) {
        removeChild(student);
        Utils.showErrorSnackbar(
          'Выбранный персонаж больше не является учащимся',
        );
        return;
      }
      setState(() {
        var i = students.indexOf(student);
        students.remove(student);
        students.insert(i, res.asStudent!);
      });
    }
  }

  void removeChild(StudentModel student) {
    setState(() {
      students.remove(student);
    });
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
