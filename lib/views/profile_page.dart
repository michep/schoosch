import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/fire_auth.dart';
import 'package:schoosch/data/fire_store.dart';
import 'package:schoosch/data/people_model.dart';
import 'package:schoosch/views/login_page.dart';
import 'package:schoosch/widgets/appbar.dart';

class ProfilePage extends StatelessWidget {
  final _auth = Get.find<FAuth>();
  final _data = Get.find<FStore>();
  late final PeopleModel _user;

  ProfilePage({Key? key}) : super(key: key) {
    _user = _data.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar('Профиль пользователя'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${_user.lastname} ${_user.firstname} ${_user.middlename}'),
            Text(_user.email),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Выйти из системы'),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    await _auth.logout();
    Get.offAll(() => const LoginPage());
  }
}
