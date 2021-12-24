import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/admin/venue.dart';
import 'package:schoosch/widgets/utils.dart';

class VenueListPage extends StatefulWidget {
  final InstitutionModel institution;
  final bool selectionMode;

  const VenueListPage(this.institution, {this.selectionMode = false, Key? key}) : super(key: key);

  @override
  State<VenueListPage> createState() => _VenueListPageState();
}

class _VenueListPageState extends State<VenueListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кабинеты и помещения'),
        actions: widget.selectionMode ? [] : [IconButton(onPressed: newVenue, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
        child: FutureBuilder<List<VenueModel>>(
            future: widget.institution.venues,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Utils.progressIndicator();
              var sorted = snapshot.data!;
              sorted.sort((a, b) => a.name.compareTo(b.name));
              return ListView(
                children: [
                  ...sorted.map(
                    (v) => ListTile(
                      onTap: () => onTap(v),
                      title: Text(v.name),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Future onTap(VenueModel venue) async {
    if (widget.selectionMode) {
      return Get.back(result: venue);
    } else {
      var res = await Get.to<String>(() => VenuePage(venue));
      if (res != null && res == 'refresh') {
        setState(() {});
      }
    }
  }

  Future newVenue() async {
    var nvenue = VenueModel.empty();
    var res = await Get.to<String>(() => VenuePage(nvenue));
    if (res != null && res == 'refresh') {
      setState(() {});
    }
  }
}
