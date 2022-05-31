import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/pages/admin/class_edit.dart';
import 'package:schoosch/pages/admin/schedule_days_list.dart';
import 'package:schoosch/widgets/utils.dart';

enum ClassListMode { classes, schedules }

class ClassListPage extends StatefulWidget {
  final InstitutionModel _institution;
  final bool selectionMode;
  final ClassListMode listMode;

  const ClassListPage(this._institution, {this.selectionMode = false, this.listMode = ClassListMode.classes, Key? key}) : super(key: key);

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.classList),
        actions: [IconButton(onPressed: _newClass, icon: const Icon(Icons.add))],
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
              child: FutureBuilder<List<ClassModel>>(
                  future: widget._institution.classes,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Utils.progressIndicator();
                    var sorted = snapshot.data!;
                    sorted.sort((a, b) => a.name.compareTo(b.name));
                    return Scrollbar(
                      thumbVisibility: true,
                      child: ListView(
                        children: [
                          ...sorted.where(_filter).map(
                                (v) => ListTile(
                                  onTap: () => widget.listMode == ClassListMode.classes ? _onTapClass(v) : _onTapSchedule(v),
                                  title: Text(v.name),
                                  subtitle: Text(v.grade.toString()),
                                  leading: widget.selectionMode ? const Icon(Icons.chevron_left) : null,
                                  trailing: widget.selectionMode ? null : const Icon(Icons.chevron_right),
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

  bool _filter(ClassModel aclass) {
    return aclass.name.toUpperCase().contains(_name.text.toUpperCase());
  }

  bool get _inSearch {
    return _name.text.isNotEmpty;
  }

  Future<void> _onTapClass(ClassModel aclass) async {
    if (widget.selectionMode) {
      return Get.back<ClassModel>(result: aclass);
    } else {
      var res = await Get.to<ClassModel>(() => ClassPage(aclass, aclass.name), transition: Transition.rightToLeft);
      if (res is ClassModel) {
        setState(() {});
      }
    }
  }

  Future<void> _onTapSchedule(ClassModel aclass) async {
    if (widget.selectionMode) {
      return Get.back<ClassModel>(result: aclass);
    } else {
      var res = await Get.to<ClassModel>(() => ScheduleDaysListPage(aclass), transition: Transition.rightToLeft);
      if (res is ClassModel) {
        setState(() {});
      }
    }
  }

  Future<void> _newClass() async {
    var nclass = ClassModel.empty();
    var res = await Get.to<ClassModel>(() => ClassPage(nclass, S.of(context).newClass));
    if (res is ClassModel) {
      setState(() {});
    }
  }
}
