import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_auth_controller.dart';
import 'package:schoosch/model/people_model.dart';
import 'package:schoosch/pages/home_page.dart';
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
            Text(_user.fullName),
            Text(_user.email),
            // Text(widget._user.currentType),
            Row(children: [
              Text(_user.currentType),
              ElevatedButton(
                child: const Text('сменить тип'),
                onPressed: () => _changeTypeBottomsheet(_user),
              ),
            ]),
            _user.currentType == 'parent'
                ? Row(children: [
                    FutureBuilder<StudentModel>(
                        future: _user.asParent!.currentChild,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Container();
                          return Text(snapshot.data!.fullName);
                        }),
                    ElevatedButton(
                      onPressed: () => _changeChildBottomsheet(_user.asParent!),
                      child: const Text('сменить ребенка'),
                    ),
                  ])
                : Container(),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Выйти из системы'),
            ),
          ],
        ),
      ),
    );
  }

  void _changeTypeBottomsheet(PeopleModel user) {
    Get.bottomSheet(
      Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...user.types.map((e) => ElevatedButton(
                  onPressed: () => _changeType(user, e),
                  child: Text(e),
                )),
          ],
        ),
      ),
    );
  }

  void _changeType(PeopleModel user, String type) {
    user.setType(type);
    Get.offAll(() => const HomePage());
  }

  void _changeChildBottomsheet(ParentModel user) {
    Get.bottomSheet(
      Card(
        child: FutureBuilder<List<StudentModel>>(
            future: user.children,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...snapshot.data!.map((e) => ElevatedButton(
                        onPressed: () => _changeChild(user, e),
                        child: Text(e.fullName),
                      )),
                ],
              );
            }),
      ),
    );
  }

  void _changeChild(ParentModel parent, StudentModel student) {
    parent.setChild(student);
    Get.offAll(() => const HomePage());
  }

  void _logout() async {
    await Get.find<FAuth>().logout();
    Get.offAll(() => const LoginPage());
  }
}
