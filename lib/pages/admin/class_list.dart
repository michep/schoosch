import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/pages/admin/class_edit.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassListPage extends StatefulWidget {
  final InstitutionModel institution;
  final bool selectionMode;

  const ClassListPage(this.institution, {this.selectionMode = false, Key? key}) : super(key: key);

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Учебные классы'),
        actions: widget.selectionMode ? [] : [IconButton(onPressed: newClass, icon: const Icon(Icons.add))],
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
                      label: const Text('Название'),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() {
                          _name.value = TextEditingValue.empty;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ClassModel>>(
                  future: widget.institution.classes,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Utils.progressIndicator();
                    var sorted = snapshot.data!;
                    sorted.sort((a, b) => a.name.compareTo(b.name));
                    return ListView(
                      children: [
                        ...sorted.where(filter).map(
                              (v) => ListTile(
                                onTap: () => onTap(v),
                                title: Text(v.name),
                                leading: widget.selectionMode ? const Icon(Icons.chevron_left) : null,
                                trailing: widget.selectionMode ? null : const Icon(Icons.chevron_right),
                                subtitle: Text(v.grade.toString()),
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

  bool filter(ClassModel aclass) {
    return aclass.name.toUpperCase().contains(_name.text.toUpperCase());
  }

  Future onTap(ClassModel aclass) async {
    if (widget.selectionMode) {
      return Get.back(result: aclass);
    } else {
      var res = await Get.to<String>(() => ClassPage(aclass, aclass.name), transition: Transition.rightToLeft);
      if (res != null && res == 'refresh') {
        setState(() {});
      }
    }
  }

  Future newClass() async {
    var nclass = ClassModel.empty();
    var res = await Get.to<String>(() => ClassPage(nclass, 'Новый учебный класс'));
    if (res != null && res == 'refresh') {
      setState(() {});
    }
  }
}
