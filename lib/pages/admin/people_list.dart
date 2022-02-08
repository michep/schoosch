import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/person_edit.dart';
import 'package:schoosch/widgets/utils.dart';

class PeopleListPage extends StatefulWidget {
  final InstitutionModel _institution;
  final bool selectionMode;
  final String type;

  const PeopleListPage(this._institution, {this.selectionMode = false, this.type = 'all', Key? key}) : super(key: key);
  @override
  State<PeopleListPage> createState() => _PeopleListPageState();
}

class _PeopleListPageState extends State<PeopleListPage> {
  final TextEditingController _name = TextEditingController();
  late String _typeValue;

  @override
  void initState() {
    _typeValue = widget.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.peopleList),
        actions: [IconButton(onPressed: _newPerson, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              child: ExpansionTile(
                title: _inSearch ? Text(loc.search, style: const TextStyle(fontStyle: FontStyle.italic)) : Text(loc.search),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (_) => setState(() {}),
                    controller: _name,
                    decoration: InputDecoration(
                      label: Text(loc.personName),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() {
                          _name.value = TextEditingValue.empty;
                        }),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(loc.personType, style: TextStyle(color: Theme.of(context).hintColor)),
                      ),
                      DropdownButton<String>(
                        value: _typeValue,
                        onChanged: (value) => setState(() {
                          _typeValue = value ?? 'all';
                        }),
                        items: [
                          DropdownMenuItem(
                            child: Text(loc.personTypeAll),
                            value: 'all',
                          ),
                          DropdownMenuItem(
                            child: Text(loc.personTypeStudent),
                            value: 'student',
                          ),
                          DropdownMenuItem(
                            child: Text(loc.personTypeTeacher),
                            value: 'teacher',
                          ),
                          DropdownMenuItem(
                            child: Text(loc.personTypeParent),
                            value: 'parent',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<PersonModel>>(
                  future: widget._institution.people,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Utils.progressIndicator();
                    var sorted = snapshot.data!;
                    sorted.sort((a, b) => a.fullName.compareTo(b.fullName));
                    return Scrollbar(
                      isAlwaysShown: true,
                      child: ListView(
                        children: [
                          ...sorted.where(_filter).map(
                                (v) => ListTile(
                                  onTap: () => _onTap(v),
                                  title: Text(v.fullName),
                                  leading: widget.selectionMode ? const Icon(Icons.chevron_left) : null,
                                  trailing: widget.selectionMode ? null : const Icon(Icons.chevron_right),
                                  subtitle: Text(v.types.toString()),
                                ),
                              ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  bool _filter(PersonModel person) {
    return person.fullName.toUpperCase().contains(_name.text.toUpperCase()) && (_typeValue == 'all' || person.types.contains(_typeValue));
  }

  bool get _inSearch {
    return _name.text.isNotEmpty || _typeValue != 'all';
  }

  Future<void> _onTap(PersonModel person) async {
    if (widget.selectionMode) {
      return Get.back<PersonModel>(result: person);
    } else {
      var res = await Get.to<PersonModel>(() => PersonPage(person, person.fullName), transition: Transition.rightToLeft);
      if (res is PersonModel) {
        setState(() {});
      }
    }
  }

  Future<void> _newPerson() async {
    List<String> types = ['student', 'teacher', 'parent'];
    var type = await Get.bottomSheet<String>(
      Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...types.map((e) => ElevatedButton(
                  onPressed: () => _selectType(e),
                  child: Text(e),
                )),
          ],
        ),
      ),
    );
    PersonModel nperson;
    if (type != null) {
      switch (type) {
        case 'teacher':
          nperson = TeacherModel.empty();
          break;
        case 'parent':
          nperson = ParentModel.empty();
          break;
        case 'student':
          nperson = StudentModel.empty();
          break;
        default:
          return;
      }
      var res = await Get.to<PersonModel>(() => PersonPage(nperson, S.of(context).newPerson(type)));
      if (res is PersonModel) {
        setState(() {});
      }
    }
  }

  void _selectType(String type) {
    Get.back(result: type);
  }
}
