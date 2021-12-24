import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';

class VenuePage extends StatelessWidget {
  final VenueModel venue;
  final TextEditingController _name = TextEditingController();

  VenuePage(this.venue, {Key? key}) : super(key: key) {
    _name.value = TextEditingValue(text: venue.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(venue.name),
        actions: [
          IconButton(onPressed: () => delete(venue), icon: const Icon(Icons.delete)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    label: Text('Название'),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('Сохранить изменения'),
              onPressed: () => save(venue),
            ),
          ],
        ),
      ),
    );
  }

  Future save(VenueModel venue) async {
    venue.name = _name.text;
    await venue.save();
    Get.back(result: 'refresh');
  }

  Future delete(VenueModel venue) async {}
}
