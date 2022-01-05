import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/utils.dart';

class VenuePage extends StatefulWidget {
  final VenueModel venue;
  final String title;

  const VenuePage(this.venue, this.title, {Key? key}) : super(key: key);

  @override
  State<VenuePage> createState() => _VenuePageState();
}

class _VenuePageState extends State<VenuePage> {
  final TextEditingController _name = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _name.value = TextEditingValue(text: widget.venue.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => delete(widget.venue),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                    label: Text('Название кабинета или помещения'),
                  ),
                  validator: (value) => Utils.validateTextNotEmpty(value, 'Название должно быть заполнено'),
                ),
                ElevatedButton(
                  child: const Text('Сохранить изменения'),
                  onPressed: () => save(widget.venue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> save(VenueModel venue) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map['name'] = _name.text;

      var nvenue = VenueModel.fromMap(venue.id, map);
      await nvenue.save();
      Get.back<VenueModel>(result: nvenue);
    }
  }

  Future<void> delete(VenueModel venue) async {}
}
