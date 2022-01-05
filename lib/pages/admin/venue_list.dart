import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/admin/venue_edit.dart';
import 'package:schoosch/widgets/utils.dart';

class VenueListPage extends StatefulWidget {
  final InstitutionModel institution;
  final bool selectionMode;

  const VenueListPage(this.institution, {this.selectionMode = false, Key? key}) : super(key: key);

  @override
  State<VenueListPage> createState() => _VenueListPageState();
}

class _VenueListPageState extends State<VenueListPage> {
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кабинеты и помещения'),
        actions: widget.selectionMode ? [] : [IconButton(onPressed: newVenue, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              child: ExpansionTile(
                title: inSearch ? const Text('Поиск', style: TextStyle(fontStyle: FontStyle.italic)) : const Text('Поиск'),
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
              child: FutureBuilder<List<VenueModel>>(
                  future: widget.institution.venues,
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

  bool filter(VenueModel venue) {
    return venue.name.toUpperCase().contains(_name.text.toUpperCase());
  }

  bool get inSearch {
    return _name.text.isNotEmpty;
  }

  Future onTap(VenueModel venue) async {
    if (widget.selectionMode) {
      return Get.back<VenueModel>(result: venue);
    } else {
      var res = await Get.to<VenueModel>(() => VenuePage(venue, venue.name), transition: Transition.rightToLeft);
      if (res is VenueModel) {
        setState(() {});
      }
    }
  }

  Future<void> newVenue() async {
    var nvenue = VenueModel.empty();
    var res = await Get.to<VenueModel>(() => VenuePage(nvenue, 'Новый кабинет'));
    if (res is VenueModel) {
      setState(() {});
    }
  }
}
