import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/status_enum.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pages/admin/studyperiod_edit.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/status_filter.dart';
import 'package:schoosch/widgets/utils.dart';

class StudyPeriodListPage extends StatefulWidget {
  final InstitutionModel _institution;
  final bool selectionMode;
  final int? status;

  const StudyPeriodListPage(this._institution, {this.selectionMode = false, super.key, this.status});

  @override
  State<StudyPeriodListPage> createState() => _StudyPeriodListPageState();
}

class _StudyPeriodListPageState extends State<StudyPeriodListPage> {
  final ScrollController _scrollCtl = ScrollController();
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
                  StatusFilter(
                    onChange: (value) => setState(() {
                      _status = value;
                    }),
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
    return _status == null ? true : period.status == StatusModel.parse(_status!);
  }

  bool get _inSearch {
    return _status != null;
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
