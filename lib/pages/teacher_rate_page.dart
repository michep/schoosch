import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/widgets/rateteachersheet.dart';
import 'package:schoosch/widgets/utils.dart';
import 'package:schoosch/model/people_model.dart';

class RatePage extends StatefulWidget {
  const RatePage({required this.teachers, Key? key}) : super(key: key);
  final Future<Map<PeopleModel, List<String>>> teachers;

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
        title: const Text('Учителя'),
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
                                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                                    elevation: 4,
                                    child: ListTile(
                                      leading: const Icon(Icons.person),
                                      title: Text(keys[elem].firstname + ' ' + keys[elem].lastname),
                                      subtitle: Text(per.join(', ')),
                                      trailing: FutureBuilder<double>(
                                          future: Get.find<FStore>().getAverageTeacherRating(keys[elem].id),
                                          // initialData: 0,
                                          builder: (context, snapshot) {
                                            return snapshot.hasData ? Text(snapshot.data!.toStringAsFixed(2)) : const Text('no ratings');
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
                          : const Text('No Teachers in This class'),
                    ],
                  )
                : Utils.progressIndicator();
          }),
    );
  }
}
