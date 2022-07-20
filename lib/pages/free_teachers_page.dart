import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class FreeTeachersPage extends StatefulWidget {
  final InstitutionModel institution;
  const FreeTeachersPage(this.institution, {Key? key}) : super(key: key);

  @override
  State<FreeTeachersPage> createState() => _FreeTeachersPageState();
}

class _FreeTeachersPageState extends State<FreeTeachersPage> {
  TextEditingController dayCont = TextEditingController();
  TextEditingController orderCont = TextEditingController();

  DateTime? date;

  List<PersonModel> resList = [];
  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Card(
              //   child: Column(
              //     children: [
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
                keyboardType: TextInputType.number,
              ),
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: isLoad ? null : () async {
                    if (date != null || orderCont.text.isNotEmpty) {
                      setState(() {
                        isLoad = true;
                      });
                      resList = await widget.institution.findFreeTeachers(
                        date!,
                        int.parse(orderCont.text),
                      ).whenComplete(() {
                        setState(() {
                          isLoad = false;
                        });
                      });
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
                  children: [
                    if (resList.isNotEmpty)
                      ...resList.map(
                        (e) {
                          return ListTile(
                            title: Text(e.fullName),
                          );
                        },
                      ),
                    if (resList.isEmpty)
                      Center(
                        child: isLoad ? Utils.progressIndicator() : const Text('нет свободных учителей.'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
