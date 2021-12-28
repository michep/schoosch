import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/utils.dart';

class VenuePage extends StatefulWidget {
  final VenueModel venue;

  const VenuePage(this.venue, {Key? key}) : super(key: key);

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
        title: Text(widget.venue.name),
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
      venue.name = _name.text;
      await venue.save();
      Get.back(result: 'refresh');
    }
  }

  Future<void> delete(VenueModel venue) async {}
}
