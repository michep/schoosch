import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/widgets/selectablevaluelist_field.dart';
import 'package:schoosch/widgets/utils.dart';

class PersonPage extends StatefulWidget {
  final PersonModel person;
  final String title;

  const PersonPage(this.person, this.title, {Key? key}) : super(key: key);

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
    _middlename.value = TextEditingValue(text: widget.person.middlename == null ? '' : widget.person.middlename!);
    _firstname.value = TextEditingValue(text: widget.person.firstname);
    _email.value = TextEditingValue(text: widget.person.email);
    _birthday = widget.person.birthday;
    if (widget.person.types.contains('student')) isStudent = true;
    if (widget.person.types.contains('teacher')) isTeacher = true;
    if (widget.person.types.contains('parent')) isParent = true;
    if (widget.person.types.contains('admin')) isAdmin = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                      DateTimeField(
                        initialValue: _birthday,
                        format: DateFormat('dd MMM yyyy', 'ru'),
                        onChanged: (DateTime? date) => _birthday = date,
                        decoration: const InputDecoration(
                          label: Text('Дата рождения'),
                        ),
                        validator: (value) => Utils.validateDateTimeNotEmpty(value, 'Нужно указать дату рождения'),
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          return date;
                        },
                      ),
                    ],
                  ),
                ),
                isParent
                    ? SelectableValueListFormField<PersonModel>(
                        title: 'Связанные учащиеся',
                        initListFutureFunc: initChildren,
                        titleFunc: (value) => value?.fullName ?? '',
                        listFunc: () => PeopleListPage(InstitutionModel.currentInstitution, selectionMode: true, type: 'student'),
                        detailsFunc: (value) => PersonPage(value!, value.fullName),
                        listValidatorFunc: () => children.isEmpty ? 'Нужно выбрать учащихся' : null,
                        addElementFunc: addChild,
                        setElementFunc: setChild,
                        removeElementFunc: removeChild,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: ListTile(
                          onTap: null,
                          iconColor: Theme.of(context).disabledColor,
                          title: Text(
                            'Связанные учащиеся',
                            style: TextStyle(color: Theme.of(context).disabledColor),
                          ),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    child: const Text('Сохранить изменения'),
                    onPressed: () => save(widget.person),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<PersonModel>> initChildren() async {
    if (widget.person.asParent != null) {
      return widget.person.asParent!.children(forceRefresh: true).then((value) {
        children.addAll(value);
        return children;
      });
    } else {
      return widget.person.up!.asParent!.children(forceRefresh: true).then((value) {
        children.addAll(value);
        return children;
      });
    }
  }

  bool addChild(PersonModel? value) {
    if (value == null) return false;
    if (value.asStudent == null) {
      Utils.showErrorSnackbar(
        'Выбранный персонаж не является учащимся',
      );
      return false;
    }
    if (children.contains(value)) {
      Utils.showErrorSnackbar(
        'Выбранный учащийся уже присутствует в группе',
      );
      return false;
    }
    setState(() {
      children.add(value.asStudent!);
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
      var i = children.indexOf(sm);
      children.remove(sm);
      children.insert(i, sm);
    });
    return true;
  }

  bool removeChild(PersonModel value) {
    setState(() {
      children.remove(value);
    });
    return true;
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
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      if (isParent) {
        map['student_ids'] = children.map((e) => e.id!).toList();
      }
      map['type'] = <String>[];
      if (isStudent) map['type'].add('student');
      if (isTeacher) map['type'].add('teacher');
      if (isParent) map['type'].add('parent');
      if (isAdmin) map['type'].add('admin');
      map['firstname'] = _firstname.text;
      map['middlename'] = _middlename.text == '' ? null : _middlename.text;
      map['lastname'] = _lastname.text;
      map['email'] = _email.text;
      map['birthday'] = _birthday != null ? Timestamp.fromDate(_birthday!) : null;

      var nperson = PersonModel.fromMap(person.id, map);
      if (isParent) {
        await nperson.asParent!.save();
      } else {
        await nperson.save();
      }
      Get.back<PersonModel>(result: nperson);
    }
  }

  Future delete(PersonModel person) async {}
}
