import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pages/admin/studyperiod_edit.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class StudyPeriodListPage extends StatefulWidget {
  final InstitutionModel _institution;
  final bool selectionMode;

  const StudyPeriodListPage(this._institution, {this.selectionMode = false, super.key});

  @override
  State<StudyPeriodListPage> createState() => _StudyPeriodListPageState();
}

class _StudyPeriodListPageState extends State<StudyPeriodListPage> {
  final TextEditingController _name = TextEditingController();
  final ScrollController _scrollCtl = ScrollController();

  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: MAppBar(
        loc.studyPeriodList,
        actions: [IconButton(onPressed: _newStudyPeriod, icon: const Icon(Icons.add))],
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
              child: FutureBuilder<List<StudyPeriodModel>>(
                  future: widget._institution.studyperiods,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Utils.progressIndicator();
                    var sorted = snapshot.data!;
                    sorted.sort((a, b) => a.name.compareTo(b.name));
                    return ListView(
                      controller: _scrollCtl,
                      children: [
                        ...sorted.where(_filter).map(
                              (v) => ListTile(
                                onTap: () => _onTap(v),
                                title: Text(v.name),
                                subtitle: Text(v.type.localizedName(loc)),
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

  bool _filter(StudyPeriodModel period) {
    return period.name.toUpperCase().contains(_name.text.toUpperCase());
  }

  bool get _inSearch {
    return _name.text.isNotEmpty;
  }

  Future _onTap(StudyPeriodModel period) async {
    if (widget.selectionMode) {
      return Get.back<StudyPeriodModel>(result: period);
    } else {
      var res = await Get.to<StudyPeriodModel>(() => StudyPeriodPage(period, period.name), transition: Transition.rightToLeft);
      if (res is StudyPeriodModel) {
        setState(() {});
      }
    }
  }

  Future<void> _newStudyPeriod() async {
    var nperiod = StudyPeriodModel.empty();
    var res = await Get.to<StudyPeriodModel>(() => StudyPeriodPage(nperiod, 'Новый учебный период'));
    if (res is StudyPeriodModel) {
      setState(() {});
    }
  }
}
