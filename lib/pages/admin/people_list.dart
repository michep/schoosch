import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/person_edit.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class PeopleListPage extends StatefulWidget {
  final Future<List<PersonModel>> Function() peopleFutureFunc;
  final bool selectionMode;
  final String type;
  final String? title;

  const PeopleListPage(this.peopleFutureFunc, {this.selectionMode = false, this.type = 'all', this.title, super.key});
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
      appBar: MAppBar(
        widget.title ?? S.of(context).peopleList,
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
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(loc.personType, style: TextStyle(color: Get.theme.hintColor)),
                  ),
                  DropdownButton<String>(
                    value: _typeValue,
                    onChanged: (value) => setState(() {
                      _typeValue = value ?? 'all';
                    }),
                    items: [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text(loc.personTypeAll),
                      ),
                      DropdownMenuItem(
                        value: 'student',
                        child: Text(loc.personTypeStudent),
                      ),
                      DropdownMenuItem(
                        value: 'teacher',
                        child: Text(loc.personTypeTeacher),
                      ),
                      DropdownMenuItem(
                        value: 'observer',
                        child: Text(loc.personTypeObserver),
                      ),
                      DropdownMenuItem(
                        value: 'parent',
                        child: Text(loc.personTypeParent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<PersonModel>>(
                  future: widget.peopleFutureFunc(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Utils.progressIndicator();
                    var sorted = snapshot.data!;
                    sorted.sort((a, b) => a.fullName.compareTo(b.fullName));

                    return ListView(
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
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  bool _filter(PersonModel person) {
    return person.fullName.toUpperCase().contains(_name.text.toUpperCase()) && (_typeValue == 'all' || person.types.containsString(_typeValue));
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
    List<PersonType> types = [PersonType.student, PersonType.teacher, PersonType.parent];
    var type = await Get.bottomSheet<PersonType>(
      Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...types.map((e) => ElevatedButton(
                  onPressed: () => _selectType(e),
                  child: Text(e.name),
                )),
          ],
        ),
      ),
    );
    PersonModel nperson;
    if (type != null) {
      switch (type) {
        case PersonType.teacher:
          nperson = TeacherModel.empty();
          break;
        case PersonType.parent:
          nperson = ParentModel.empty();
          break;
        case PersonType.student:
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

  void _selectType(PersonType type) {
    Get.back(result: type);
  }
}
