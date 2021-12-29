import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/person_edit.dart';
import 'package:schoosch/widgets/utils.dart';

class PeopleListPage extends StatefulWidget {
  final InstitutionModel institution;
  final bool selectionMode;

  const PeopleListPage(this.institution, {this.selectionMode = false, Key? key}) : super(key: key);

  @override
  State<PeopleListPage> createState() => _PeopleListPageState();
}

class _PeopleListPageState extends State<PeopleListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сотрудники, учителя и ученики'),
        actions: [IconButton(onPressed: newPerson, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
        child: FutureBuilder<List<PersonModel>>(
            future: widget.institution.people,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Utils.progressIndicator();
              var sorted = snapshot.data!;
              sorted.sort((a, b) => a.fullName.compareTo(b.fullName));
              return ListView(
                children: [
                  ...sorted.map(
                    (v) => ListTile(
                      onTap: () => onTap(v),
                      title: Text(v.fullName),
                      trailing: const Icon(Icons.chevron_right),
                      subtitle: Text(v.types.toString()),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Future onTap(PersonModel person) async {
    if (widget.selectionMode) {
      return Get.back(result: person);
    } else {
      var res = await Get.to<String>(() => PersonPage(person, person.fullName));
      if (res != null && res == 'refresh') {
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
    String? res;
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
      res = await Get.to<String>(() => PersonPage(nperson, 'Новый $type'));
      if (res != null && res == 'refresh') {
        setState(() {});
      }
    }
  }

  void _selectType(String type) {
    Get.back(result: type);
  }
}