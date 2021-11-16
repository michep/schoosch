import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/utils.dart';
import 'package:schoosch/model/people_model.dart';
import '../controller/fire_store_controller.dart';

class RatePage extends StatelessWidget {
  RatePage({required this.teachers, Key? key}) : super(key: key);
  Future<Map<String, PeopleModel>> teachers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teachers:"),
      ),
      body: FutureBuilder<Map<String, PeopleModel>>(
          future: teachers,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Column(
                    children: [
                      snapshot.data!.keys.toList().isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemBuilder: (context, elem) {
                                  var m = snapshot.data!;
                                  var keys = m.keys.toList();
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 7),
                                    elevation: 4,
                                    child: ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text(m[keys[elem]]!.firstname),
                                      subtitle: Text(keys[elem]),
                                      trailing: TextButton.icon(
                                        onPressed: () {Get.find<FStore>().saveRate('hjsgf', 'hkjFDHKJA', DateTime.now(), 8);},
                                        icon: Icon(Icons.star_border),
                                        label: Text("Rate"),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: snapshot.data!.keys.length,
                              ),
                            )
                          : Text("No Teachers in This class"),
                    ],
                  )
                : Utils.progressIndicator();
          }),
    );
  }
}
