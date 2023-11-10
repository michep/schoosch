import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/curriculum_edit.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class CurriculumListPage extends StatefulWidget {
  final InstitutionModel _institution;
  final bool selectionMode;

  const CurriculumListPage(this._institution, {this.selectionMode = false, super.key});

  @override
  State<CurriculumListPage> createState() => _CurriculumListPageState();
}

class _CurriculumListPageState extends State<CurriculumListPage> {
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: MAppBar(
        loc.curriculumList,
        actions: [IconButton(onPressed: _newCurriculum, icon: const Icon(Icons.add))],
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
                      label: Text(loc.name),
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
                  future: widget._institution.curriculums(forceRefresh: true),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Utils.progressIndicator();
                    var sorted = snapshot.data!;
                    sorted.sort((a, b) => a.name.compareTo(b.name));
                    return ListView(
                      children: [
                        ...sorted.where(_filter).map(
                              (v) => ListTile(
                                onTap: () => _onTap(v),
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

  bool _filter(CurriculumModel curriculum) {
    return (curriculum.name.toUpperCase().contains(_name.text.toUpperCase())) ||
        (curriculum.alias != null && curriculum.alias!.toUpperCase().contains(_name.text.toUpperCase()));
  }

  bool get _inSearch {
    return _name.text.isNotEmpty;
  }

  Future<void> _onTap(CurriculumModel curriculum) async {
    if (widget.selectionMode) {
      return Get.back<CurriculumModel>(result: curriculum);
    } else {
      var res = await Get.to<CurriculumModel>(() => CurriculumPage(curriculum, curriculum.name), transition: Transition.rightToLeft);
      if (res is CurriculumModel) {
        setState(() {});
      }
    }
  }

  Future<void> _newCurriculum() async {
    var ncurr = CurriculumModel.empty();
    var res = await Get.to<CurriculumModel>(() => CurriculumPage(ncurr, AppLocalizations.of(context)!.newCurriculum));
    if (res is CurriculumModel) {
      setState(() {});
    }
  }
}
