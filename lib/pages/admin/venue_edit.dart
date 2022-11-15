import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class VenuePage extends StatefulWidget {
  final VenueModel _venue;
  final String _title;

  const VenuePage(this._venue, this._title, {Key? key}) : super(key: key);

  @override
  State<VenuePage> createState() => _VenuePageState();
}

class _VenuePageState extends State<VenuePage> {
  final TextEditingController _name = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _name.value = TextEditingValue(text: widget._venue.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: MAppBar(
        widget._title,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _delete(widget._venue),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    label: Text(loc.venueName),
                  ),
                  validator: (value) => Utils.validateTextNotEmpty(value, loc.errorNameEmpty),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    child: Text(loc.saveChanges),
                    onPressed: () => _save(widget._venue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save(VenueModel venue) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map['name'] = _name.text;

      var nvenue = VenueModel.fromMap(venue.id, map);
      await nvenue.save();
      Get.back<VenueModel>(result: nvenue);
    }
  }

  Future<void> _delete(VenueModel venue) async {
    venue.delete();
    Get.back<VenueModel>(result: venue);
  }
}
