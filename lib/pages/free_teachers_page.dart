import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/person_model.dart';

class FreeTeachersPage extends StatefulWidget {
  const FreeTeachersPage({Key? key}) : super(key: key);

  @override
  State<FreeTeachersPage> createState() => _FreeTeachersPageState();
}

class _FreeTeachersPageState extends State<FreeTeachersPage> {
  TextEditingController dayCont = TextEditingController();
  TextEditingController orderCont = TextEditingController();

  DateTime? date;

  List<PersonModel> resList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  TextField(
                    controller: dayCont,
                    onTap: () => showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 1),
                      lastDate: DateTime(DateTime.now().year + 1),
                    ).then((value) {
                      if (value != null) {
                        date = value;
                        dayCont.text = DateFormat('dd/MM/yyyy').format(value);
                      }
                    }),
                  ),
                  TextField(
                    controller: orderCont,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                onPressed: () async {
                  if (date != null || orderCont.text.isNotEmpty) {
                    resList = await Get.find<FStore>().getFreeTeachersOnLesson(date!, int.parse(orderCont.text));
                    setState(() {});
                  }
                },
                child: const Text('найти'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: [...resList.map((e) {
                  return ListTile(
                    title: Text(e.fullName),
                  );
                })],
              ),
            )
          ],
        ),
      ),
    );
  }
}
