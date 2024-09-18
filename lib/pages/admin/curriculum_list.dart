import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/status_enum.dart';
import 'package:schoosch/pages/admin/curriculum_edit.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/status_filter.dart';
import 'package:schoosch/widgets/utils.dart';

class CurriculumListPage extends StatefulWidget {
  final InstitutionModel _institution;
  final bool selectionMode;
  final int? status;

  const CurriculumListPage(this._institution, {this.selectionMode = false, super.key, this.status});

  @override
  State<CurriculumListPage> createState() => _CurriculumListPageState();
}

class _CurriculumListPageState extends State<CurriculumListPage> {
  final TextEditingController _name = TextEditingController();
  int? _status;

  @override
  void initState() {
    super.initState();
    _status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
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
                  StatusFilter(
                    onChange: (value) => setState(() {
                      _status = value;
                    }),
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
    return ((curriculum.name.toUpperCase().contains(_name.text.toUpperCase())) ||
            (curriculum.alias != null && curriculum.alias!.toUpperCase().contains(_name.text.toUpperCase()))) &&
        (_status == null ? true : curriculum.status == StatusModel.parse(_status!));
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
    var res = await Get.to<CurriculumModel>(() => CurriculumPage(ncurr, S.of(context).newCurriculum));
    if (res is CurriculumModel) {
      setState(() {});
    }
  }
}
