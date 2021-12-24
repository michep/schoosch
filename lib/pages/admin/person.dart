import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';

class PersonPage extends StatelessWidget {
  final PersonModel person;
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _middlename = TextEditingController();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _email = TextEditingController();

  PersonPage(this.person, {Key? key}) : super(key: key) {
    _lastname.value = TextEditingValue(text: person.lastname);
    _middlename.value = TextEditingValue(text: person.middlename);
    _firstname.value = TextEditingValue(text: person.firstname);
    _email.value = TextEditingValue(text: person.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(person.fullName),
        actions: [
          IconButton(onPressed: () => delete(person), icon: const Icon(Icons.delete)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _lastname,
                  decoration: const InputDecoration(
                    label: Text('Фамилия'),
                  ),
                ),
                TextField(
                  controller: _firstname,
                  decoration: const InputDecoration(
                    label: Text('Имя'),
                  ),
                ),
                TextField(
                  controller: _middlename,
                  decoration: const InputDecoration(
                    label: Text('Отчество'),
                  ),
                ),
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('Сохранить изменения'),
              onPressed: () => save(person),
            ),
          ],
        ),
      ),
    );
  }

  Future save(PersonModel person) async {
    print(person.runtimeType);
  }

  Future delete(PersonModel person) async {}
}
