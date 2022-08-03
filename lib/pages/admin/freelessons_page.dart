import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/widgets/utils.dart';

class FreeLessonsPage extends StatefulWidget {
  final ClassModel aclass;
  const FreeLessonsPage(this.aclass, {Key? key}) : super(key: key);

  @override
  State<FreeLessonsPage> createState() => _FreeLessonsPageState();
}

class _FreeLessonsPageState extends State<FreeLessonsPage> {
  TextEditingController dateCont = TextEditingController();
  DateTime? date;

  List<int> freeLessons = [];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              TextFormField(
                controller: dateCont,
                onTap: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 1),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      date = value;
                    });
                    dateCont.text = DateFormat('dd/MM/yyyy').format(value);
                  }
                }),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'нужно указать искомую дату.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: isLoading || date == null ? null : () async {
                    setState(() {
                      isLoading = true;
                    });
                    freeLessons = await widget.aclass.freeLessonsForDate(date!).whenComplete(() {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  },
                  child: isLoading ? Utils.progressIndicator() : Text(loc.saveChanges),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    if (freeLessons.isNotEmpty)
                      ...freeLessons.map(
                        (e) => ListTile(
                          title: Text(
                            e.toString(),
                          ),
                        ),
                      ),
                    if(freeLessons.isEmpty) Center(
                      child: isLoading ? Utils.progressIndicator() : const Text('нет результатов.'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
