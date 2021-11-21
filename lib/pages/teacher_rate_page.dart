import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/utils.dart';
import 'package:schoosch/model/people_model.dart';
import '../controller/fire_store_controller.dart';
import '../widgets/rateteachersheet.dart';

class RatePage extends StatefulWidget {
  RatePage({required this.teachers, Key? key}) : super(key: key);
  Future<Map<PeopleModel, List<String>>> teachers;

  @override
  State<RatePage> createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {

  Future<void> activateBottomSheet(BuildContext context, PeopleModel teach) async {
    return await showModalBottomSheet(
        context: context,
        builder: (_) {
          return RateSheet(teach);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Учителя'),
      ),
      body: FutureBuilder<Map<PeopleModel, List<String>>>(
          future: widget.teachers,
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
                                  var per = m[keys[elem]]!;
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 7),
                                    elevation: 4,
                                    child: ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text(keys[elem].firstname +
                                          ' ' +
                                          keys[elem].lastname),
                                      subtitle: Text(per.join(', ')),
                                      trailing: FutureBuilder<double>(
                                          future: Get.find<FStore>()
                                              .getAverageTeacherRating(
                                                  keys[elem].id),
                                          // initialData: 0,
                                          builder: (context, snapshot) {
                                            return snapshot.hasData
                                                ? Text(snapshot.data!
                                                    .toStringAsFixed(2))
                                                : Text('no ratings');
                                          }),
                                      onTap: () {
                                        activateBottomSheet(context, keys[elem]).then((_) => setState(() {}));
                                      },
                                    ),
                                  );
                                },
                                itemCount: snapshot.data!.keys.length,
                              ),
                            )
                          : Text('No Teachers in This class'),
                    ],
                  )
                : Utils.progressIndicator();
          }),
    );
  }
}
