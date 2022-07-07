import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class FindChat extends StatefulWidget {
  const FindChat({Key? key}) : super(key: key);

  @override
  State<FindChat> createState() => _FindChatState();
}

class _FindChatState extends State<FindChat> {
  final TextEditingController inputcont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: inputcont,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              FutureBuilder<List<PersonModel>>(
                future: Get.find<FStore>().currentInstitution!.people,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                      child: Center(
                        child: Utils.progressIndicator(),
                      ),
                    );
                  }
                  var sorted = snapshot.data!;
                  sorted.sort((a, b) => a.fullName.compareTo(b.fullName));
                  return Expanded(
                    child: ListView(
                      children: [
                        ...sorted.where(_filter).map(
                              (e) => ListTile(
                                title: Text(e.fullName),
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                onTap: () async {
                                  bool exists = await e.alreadyHasChat();
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      exists: exists,
                                      person: e,
                                    ),
                                  );
                                },
                              ),
                            ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _filter(PersonModel person) {
    return person.fullName.toUpperCase().contains(inputcont.text.toUpperCase());
  }
}

class Dialog extends StatefulWidget {
  final bool exists;
  final PersonModel person;
  const Dialog({
    Key? key,
    required this.exists,
    required this.person,
  }) : super(key: key);

  @override
  State<Dialog> createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.exists ? 'чат существует' : 'начать чат'),
      content: Text(
        widget.exists ? 'Чат с пользователем ${widget.person.fullName} уже существует' : 'Хотите начать чат с пользователем ${widget.person.fullName}?',
      ),
      actions: !isloading
          ? [
              if (!widget.exists)
                TextButton.icon(
                  onPressed: () async {
                    setState(() {
                      isloading = true;
                    });
                    await Get.find<FStore>().currentInstitution!.createChatRoom(widget.person);
                    setState(() {
                      isloading = false;
                    });
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('начать'),
                ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
                label: const Text('закрыть'),
              ),
            ]
          : [
              Center(child: Utils.progressIndicator()),
            ],
    );
  }
}
