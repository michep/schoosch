import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/curriculum_edit.dart';
import 'package:schoosch/widgets/utils.dart';

class CurriculumListPage extends StatefulWidget {
  final InstitutionModel institution;
  final bool selectionMode;

  const CurriculumListPage(this.institution, {this.selectionMode = false, Key? key}) : super(key: key);

  @override
  State<CurriculumListPage> createState() => _CurriculumListPageState();
}

class _CurriculumListPageState extends State<CurriculumListPage> {
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Учебные предметы'),
        actions: widget.selectionMode ? [] : [IconButton(onPressed: newCurriculum, icon: const Icon(Icons.add))],
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
              child: FutureBuilder<List<CurriculumModel>>(
                  future: widget.institution.curriculums,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Utils.progressIndicator();
                    var sorted = snapshot.data!;
                    sorted.sort((a, b) => a.aliasOrName.compareTo(b.aliasOrName));
                    return ListView(
                      children: [
                        ...sorted.where(filter).map(
                              (v) => ListTile(
                                onTap: () => onTap(v),
                                title: Text(v.name),
                                subtitle: FutureBuilder<TeacherModel?>(
                                    future: v.master,
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) return const SizedBox.shrink();
                                      return Text(snapshot.data!.fullName);
                                    }),
                                leading: widget.selectionMode ? const Icon(Icons.chevron_left) : null,
                                trailing: widget.selectionMode ? null : const Icon(Icons.chevron_right),
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

  bool filter(CurriculumModel curriculum) {
    return (curriculum.name.toUpperCase().contains(_name.text.toUpperCase())) ||
        (curriculum.alias != null && curriculum.alias!.toUpperCase().contains(_name.text.toUpperCase()));
  }

  Future onTap(CurriculumModel curriculum) async {
    if (widget.selectionMode) {
      return Get.back(result: curriculum);
    } else {
      var res = await Get.to<String>(() => CurriculumPage(curriculum, curriculum.name), transition: Transition.rightToLeft);
      if (res != null && res == 'refresh') {
        setState(() {});
      }
    }
  }

  Future newCurriculum() async {
    var ncurr = CurriculumModel.empty();
    var res = await Get.to<String>(() => CurriculumPage(ncurr, 'Новый учебный предмет'));
    if (res != null && res == 'refresh') {
      setState(() {});
    }
  }
}
