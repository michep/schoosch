import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/widgets/selectablevaluelist_field.dart';
import 'package:schoosch/widgets/utils.dart';

class PersonPage extends StatefulWidget {
  final PersonModel _person;
  final String _title;

  const PersonPage(this._person, this._title, {Key? key}) : super(key: key);

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
  bool _isStudent = false;
  bool _isTeacher = false;
  bool _isParent = false;
  bool _isAdmin = false;
  final List<StudentModel> _children = [];

  @override
  void initState() {
    _lastname.value = TextEditingValue(text: widget._person.lastname);
    _middlename.value = TextEditingValue(text: widget._person.middlename == null ? '' : widget._person.middlename!);
    _firstname.value = TextEditingValue(text: widget._person.firstname);
    _email.value = TextEditingValue(text: widget._person.email);
    _birthday = widget._person.birthday;
    if (widget._person.types.contains('student')) _isStudent = true;
    if (widget._person.types.contains('teacher')) _isTeacher = true;
    if (widget._person.types.contains('parent')) _isParent = true;
    if (widget._person.types.contains('admin')) _isAdmin = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
        actions: [
          IconButton(onPressed: () => _delete(widget._person), icon: const Icon(Icons.delete)),
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
                        decoration: InputDecoration(
                          label: Text(loc.labelPersonLastName),
                        ),
                        validator: (value) => Utils.validateTextNotEmpty(value, loc.errorPersonLastNameEmpty),
                      ),
                      TextFormField(
                        controller: _firstname,
                        decoration: InputDecoration(
                          label: Text(loc.labelPersonFirstName),
                        ),
                        validator: (value) => Utils.validateTextNotEmpty(value, loc.errorPersonFirstNameEmpty),
                      ),
                      TextFormField(
                        controller: _middlename,
                        decoration: InputDecoration(
                          label: Text(loc.labelPersonMiddleName),
                        ),
                      ),
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          label: Text(loc.labelPersonEmail),
                        ),
                        validator: (value) => Utils.validateTextNotEmpty(value, loc.errorPersonEmailEmpty),
                      ),
                      DateTimeField(
                        initialValue: _birthday,
                        format: DateFormat('dd MMM yyyy'),
                        onChanged: (DateTime? date) => _birthday = date,
                        decoration: InputDecoration(
                          label: Text(loc.labelPersonBirthday),
                        ),
                        validator: (value) => Utils.validateDateTimeNotEmpty(value, loc.errorPersonBirthdayEmpty),
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
                _isParent
                    ? SelectableValueListFormField<PersonModel>(
                        title: loc.labelPersonRelatedStudents,
                        initListFutureFunc: _initChildren,
                        titleFunc: (value) => value?.fullName ?? '',
                        listFunc: () => PeopleListPage(InstitutionModel.currentInstitution, selectionMode: true, type: 'student'),
                        detailsFunc: (value) => PersonPage(value!, value.fullName),
                        listValidatorFunc: () => _children.isEmpty ? loc.errorPersonParentStudentsEmpty : null,
                        addElementFunc: _addChild,
                        setElementFunc: _setChild,
                        removeElementFunc: _removeChild,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: ListTile(
                          onTap: null,
                          iconColor: Theme.of(context).disabledColor,
                          title: Text(
                            loc.labelPersonRelatedStudents,
                            style: TextStyle(color: Theme.of(context).disabledColor),
                          ),
                        ),
                      ),
                CheckboxListTile(
                  title: Text(loc.labelPersonTypeStudent),
                  value: _isStudent,
                  onChanged: (_isParent || _isTeacher) ? null : (value) => _roleChecked('student', value),
                ),
                CheckboxListTile(
                  title: Text(loc.labelPersonTypeTeacher),
                  value: _isTeacher,
                  onChanged: (_isStudent) ? null : (value) => _roleChecked('teacher', value),
                ),
                CheckboxListTile(
                  title: Text(loc.labelPersonTypeParent),
                  value: _isParent,
                  onChanged: (_isStudent) ? null : (value) => _roleChecked('parent', value),
                ),
                CheckboxListTile(
                  title: Text(loc.labelPersonTypeAdmin),
                  value: _isAdmin,
                  onChanged: (value) => _roleChecked('admin', value),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    child: Text(loc.labelSaveChanges),
                    onPressed: () => _save(widget._person),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<PersonModel>> _initChildren() async {
    if (widget._person.asParent != null) {
      return widget._person.asParent!.children(forceRefresh: true).then((value) {
        _children.addAll(value);
        return _children;
      });
    } else {
      return widget._person.up!.asParent!.children(forceRefresh: true).then((value) {
        _children.addAll(value);
        return _children;
      });
    }
  }

  bool _addChild(PersonModel? value) {
    var loc = S.of(context);
    if (value == null) return false;
    if (value.asStudent == null) {
      Utils.showErrorSnackbar(loc.errorPersonIsNotAStudent);
      return false;
    }
    if (_children.contains(value)) {
      Utils.showErrorSnackbar(loc.errorStudentAlreadyPresent);
      return false;
    }
    setState(() {
      _children.add(value.asStudent!);
    });
    return true;
  }

  bool _setChild(PersonModel value) {
    StudentModel sm;
    if (!value.types.contains('student')) {
      Utils.showErrorSnackbar(S.of(context).errorPersonIsNotAStudent);
      return false;
    }

    value.asStudent != null ? sm = value.asStudent! : sm = (value as StudentModel);

    setState(() {
      var i = _children.indexOf(sm);
      _children.remove(sm);
      _children.insert(i, sm);
    });
    return true;
  }

  bool _removeChild(PersonModel value) {
    setState(() {
      _children.remove(value);
    });
    return true;
  }

  void _roleChecked(String role, bool? value) {
    if (value != null) {
      switch (role) {
        case 'student':
          _isStudent = value;
          break;
        case 'teacher':
          _isTeacher = value;
          break;
        case 'parent':
          _isParent = value;
          break;
        case 'admin':
          _isAdmin = value;
          break;
      }
      setState(() {});
    }
  }

  Future _save(PersonModel person) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      if (_isParent) {
        map['student_ids'] = _children.map((e) => e.id!).toList();
      }
      map['type'] = <String>[];
      if (_isStudent) map['type'].add('student');
      if (_isTeacher) map['type'].add('teacher');
      if (_isParent) map['type'].add('parent');
      if (_isAdmin) map['type'].add('admin');
      map['firstname'] = _firstname.text;
      map['middlename'] = _middlename.text == '' ? null : _middlename.text;
      map['lastname'] = _lastname.text;
      map['email'] = _email.text;
      map['birthday'] = _birthday != null ? Timestamp.fromDate(_birthday!) : null;

      var nperson = PersonModel.fromMap(person.id, map);
      if (_isParent) {
        await nperson.asParent!.save();
      } else {
        await nperson.save();
      }
      Get.back<PersonModel>(result: nperson);
    }
  }

  Future _delete(PersonModel person) async {}
}
