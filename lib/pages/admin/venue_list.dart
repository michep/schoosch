import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/admin/venue_edit.dart';
import 'package:schoosch/widgets/utils.dart';

class VenueListPage extends StatefulWidget {
  final InstitutionModel _institution;
  final bool selectionMode;

  const VenueListPage(this._institution, {this.selectionMode = false, Key? key}) : super(key: key);

  @override
  State<VenueListPage> createState() => _VenueListPageState();
}

class _VenueListPageState extends State<VenueListPage> {
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.labelVenueListTitle),
        actions: [IconButton(onPressed: _newVenue, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              child: ExpansionTile(
                title: _inSearch ? Text(loc.labelSearch, style: const TextStyle(fontStyle: FontStyle.italic)) : Text(loc.labelSearch),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (_) => setState(() {}),
                    controller: _name,
                    decoration: InputDecoration(
                      label: Text(loc.labelName),
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
              child: FutureBuilder<List<VenueModel>>(
                  future: widget._institution.venues,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Utils.progressIndicator();
                    var sorted = snapshot.data!;
                    sorted.sort((a, b) => a.name.compareTo(b.name));
                    return Scrollbar(
                      isAlwaysShown: true,
                      child: ListView(
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
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  bool _filter(VenueModel venue) {
    return venue.name.toUpperCase().contains(_name.text.toUpperCase());
  }

  bool get _inSearch {
    return _name.text.isNotEmpty;
  }

  Future _onTap(VenueModel venue) async {
    if (widget.selectionMode) {
      return Get.back<VenueModel>(result: venue);
    } else {
      var res = await Get.to<VenueModel>(() => VenuePage(venue, venue.name), transition: Transition.rightToLeft);
      if (res is VenueModel) {
        setState(() {});
      }
    }
  }

  Future<void> _newVenue() async {
    var nvenue = VenueModel.empty();
    var res = await Get.to<VenueModel>(() => VenuePage(nvenue, S.of(context).labelNewVenue));
    if (res is VenueModel) {
      setState(() {});
    }
  }
}
