import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_auth_controller.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/pages/login_page.dart';
import 'package:schoosch/widgets/appbar.dart';

class ProfilePage extends StatelessWidget {
  final PeopleModel _user;

  const ProfilePage(this._user, {Key? key}) : super(key: key);

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
            Text(_user.type),
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
    // Get.find<FStore>().resetCurrentUser();
    await Get.find<FAuth>().logout();
    Get.offAll(() => const LoginPage());
  }
}
