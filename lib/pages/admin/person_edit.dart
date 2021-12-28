import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/widgets/utils.dart';

class PersonPage extends StatefulWidget {
  final PersonModel person;

  PersonPage(this.person, {Key? key}) : super(key: key) {}

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _middlename = TextEditingController();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _birthday;
  bool isStudent = false;
  bool isTeacher = false;
  bool isParent = false;
  bool isAdmin = false;
  final List<StudentModel> children = [];

  @override
  void initState() {
    _lastname.value = TextEditingValue(text: widget.person.lastname);
    _middlename.value = TextEditingValue(text: widget.person.middlename);
    _firstname.value = TextEditingValue(text: widget.person.firstname);
    _email.value = TextEditingValue(text: widget.person.email);
    _birthday = widget.person.birthday;
    if (widget.person.types.contains('student')) isStudent = true;
    if (widget.person.types.contains('teacher')) isTeacher = true;
    if (widget.person.types.contains('parent')) isParent = true;
    if (widget.person.types.contains('admin')) isAdmin = true;
    if (isParent) {
      widget.person.asParent!.children.then((value) {
        setState(() {
          children.addAll(value);
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.fullName),
        actions: [
          IconButton(onPressed: () => delete(widget.person), icon: const Icon(Icons.delete)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _lastname,
                        decoration: const InputDecoration(
                          label: Text('Фамилия'),
                        ),
                        validator: (value) => Utils.validateTextNotEmpty(value, 'Фамилия должна быть заполнена'),
                      ),
                      TextFormField(
                        controller: _firstname,
                        decoration: const InputDecoration(
                          label: Text('Имя'),
                        ),
                        validator: (value) => Utils.validateTextNotEmpty(value, 'Имя должно быть заполнено'),
                      ),
                      TextFormField(
                        controller: _middlename,
                        decoration: const InputDecoration(
                          label: Text('Отчество'),
                        ),
                      ),
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                          label: Text('Email'),
                        ),
                        validator: (value) => Utils.validateTextNotEmpty(value, 'Email адрес должен быть заполнен'),
                      ),
                      DateTimeFormField(
                        initialValue: _birthday,
                        onDateSelected: (DateTime? date) => _birthday = date,
                        decoration: const InputDecoration(
                          label: Text('Дата рождения'),
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        validator: (value) => Utils.validateDateTimeNotEmpty(value, ''),
                      ),
                    ],
                  ),
                ),
                isParent
                    ? childrenFormField(context)
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: ListTile(
                          onTap: null,
                          iconColor: Theme.of(context).disabledColor,
                          title: Text(
                            'Связанные учащиеся',
                            style: TextStyle(color: Theme.of(context).disabledColor),
                          ),
                          // trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                CheckboxListTile(
                  title: const Text('Учащийся'),
                  value: isStudent,
                  onChanged: (isParent || isTeacher) ? null : (value) => roleChecked('student', value),
                ),
                CheckboxListTile(
                  title: const Text('Преподаватель'),
                  value: isTeacher,
                  onChanged: (isStudent) ? null : (value) => roleChecked('teacher', value),
                ),
                CheckboxListTile(
                  title: const Text('Родитель / Наблюдатель'),
                  value: isParent,
                  onChanged: (isStudent) ? null : (value) => roleChecked('parent', value),
                ),
                CheckboxListTile(
                  title: const Text('Администратор системы'),
                  value: isAdmin,
                  onChanged: (value) => roleChecked('admin', value),
                ),
                ElevatedButton(
                  onPressed: () => save(widget.person),
                  child: const Text('Сохранить изменения'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget childrenFormField(BuildContext context) {
    return FormField<List<StudentModel>>(
      validator: (_) {
        return (children.isEmpty) ? 'Нужно выбрать учащегося' : null;
      },
      builder: (fieldstate) => ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text('Связанные учащиеся (${children.length})'),
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
          ...children.map((s) => ListTile(
                title: Text(s.fullName),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => removeChild(s),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> addChild() async {
    var res = await Get.to<PersonModel>(() => PeopleListPage(InstitutionModel.currentInstitution, selectionMode: true));
    if (res != null && !children.contains(res)) {
      setState(() {
        children.add(res.asStudent!);
      });
    }
  }

  void removeChild(StudentModel student) {
    setState(() {
      children.remove(student);
    });
  }

  void roleChecked(String role, bool? value) {
    if (value != null) {
      switch (role) {
        case 'student':
          isStudent = value;
          break;
        case 'teacher':
          isTeacher = value;
          break;
        case 'parent':
          isParent = value;
          break;
        case 'admin':
          isAdmin = value;
          break;
      }
      setState(() {});
    }
  }

  Future save(PersonModel person) async {
    var per = person;
    if (_formKey.currentState!.validate()) {
      per.types.clear();
      if (isStudent) person.types.add('student');
      if (isTeacher) person.types.add('teacher');
      if (isParent) person.types.add('parent');
      if (isAdmin) person.types.add('admin');
      if (person.types.contains('parent')) {
        if (person.asParent == null) {
          var map = person.toMap();
          map['student_ids'] = [];
          for (var e in children) {
            map['student_ids'].add(e.id!);
          }
          per = PersonModel.fromMap(person.id, map);
        }
        per = per.asParent!;
      }
      per.firstname = _firstname.text;
      per.middlename = _middlename.text;
      per.lastname = _lastname.text;
      per.email = _email.text;
      per.birthday = _birthday;
      await per.save();
      Get.back(result: 'refresh');
    }
  }

  Future delete(PersonModel person) async {}
}
