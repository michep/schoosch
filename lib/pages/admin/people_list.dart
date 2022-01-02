import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/person_edit.dart';
import 'package:schoosch/widgets/utils.dart';

class PeopleListPage extends StatefulWidget {
  final InstitutionModel institution;
  final bool selectionMode;
  final String type;

  const PeopleListPage(this.institution, {this.selectionMode = false, this.type = 'all', Key? key}) : super(key: key);
  @override
  State<PeopleListPage> createState() => _PeopleListPageState();
}

class _PeopleListPageState extends State<PeopleListPage> {
  final TextEditingController _name = TextEditingController();
  late String typeValue;

  @override
  void initState() {
    typeValue = widget.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сотрудники, учителя и ученики'),
        actions: [IconButton(onPressed: newPerson, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              child: ExpansionTile(
                title: const Text('Поиск'),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (_) => setState(() {}),
                    controller: _name,
                    decoration: InputDecoration(
                      label: const Text('Имя'),
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
                        child: Text('Тип', style: TextStyle(color: Theme.of(context).hintColor)),
                      ),
                      DropdownButton<String>(
                        value: typeValue,
                        onChanged: (value) => setState(() {
                          typeValue = value ?? 'all';
                        }),
                        items: const [
                          DropdownMenuItem(
                            child: Text('Все типы'),
                            value: 'all',
                          ),
                          DropdownMenuItem(
                            child: Text('Учащийся'),
                            value: 'student',
                          ),
                          DropdownMenuItem(
                            child: Text('Преподаватель'),
                            value: 'teacher',
                          ),
                          DropdownMenuItem(
                            child: Text('Родитель \\ Наблюдатель'),
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
                  future: widget.institution.people,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Utils.progressIndicator();
                    var sorted = snapshot.data!;
                    sorted.sort((a, b) => a.fullName.compareTo(b.fullName));
                    return ListView(
                      children: [
                        ...sorted.where(filter).map(
                              (v) => ListTile(
                                onTap: () => onTap(v),
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

  bool filter(PersonModel person) {
    return person.fullName.toUpperCase().contains(_name.text.toUpperCase()) && (typeValue == 'all' || person.types.contains(typeValue));
  }

  Future onTap(PersonModel person) async {
    if (widget.selectionMode) {
      return Get.back(result: person);
    } else {
      var res = await Get.to<PersonModel>(
        () => PersonPage(person, person.fullName),
        transition: Transition.rightToLeft,
      );
      if (res is PersonModel) {
        setState(() {});
      }
    }
  }

  Future newPerson() async {
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
      var res = await Get.to<PersonModel>(
        () => PersonPage(nperson, 'Новый $type'),
      );
      if (res is PersonModel) {
        setState(() {});
      }
    }
  }

  void _selectType(String type) {
    Get.back(result: type);
  }
}
