import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/marktype_model.dart';
import 'package:schoosch/pages/admin/marktype_edit.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class MarktypeListPage extends StatefulWidget {
  final InstitutionModel _institution;
  final bool selectionMode;

  const MarktypeListPage(this._institution, {this.selectionMode = false, super.key});

  @override
  State<MarktypeListPage> createState() => _MarktypeListPageState();
}

class _MarktypeListPageState extends State<MarktypeListPage> {
  final TextEditingController _name = TextEditingController();
  final ScrollController _scrollCtl = ScrollController();

  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: MAppBar(
        loc.venueList,
        actions: [IconButton(onPressed: _newMarktype, icon: const Icon(Icons.add))],
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
              child: FutureBuilder<List<MarkType>>(
                  future: widget._institution.marktypes,
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

  bool _filter(MarkType type) {
    return type.name.toUpperCase().contains(_name.text.toUpperCase());
  }

  bool get _inSearch {
    return _name.text.isNotEmpty;
  }

  Future _onTap(MarkType type) async {
    if (widget.selectionMode) {
      return Get.back<MarkType>(result: type);
    } else {
      var res = await Get.to<MarkType>(() => MarktypePage(type, type.name), transition: Transition.rightToLeft);
      if (res is MarkType) {
        setState(() {});
      }
    }
  }

  Future<void> _newMarktype() async {
    var ntype = MarkType.empty();
    var res = await Get.to<MarkType>(() => MarktypePage(ntype, AppLocalizations.of(context)!.newMarkType));
    if (res is MarkType) {
      setState(() {});
    }
  }
}
