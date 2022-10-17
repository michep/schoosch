import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_auth_controller.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/pages/login_page.dart';
import 'package:schoosch/widgets/appbar.dart';

class ProfilePage extends StatelessWidget {
  final PersonModel _user;

  const ProfilePage(this._user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        S.of(context).userProfileTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_user.fullName),
            Text(_user.email),
            _changeTypeW(context, _user),
            _chateChildW(_user),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Выйти из системы'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chateChildW(PersonModel user) {
    return user.currentType == PersonType.parent
        ? FutureBuilder(
            future: Future.wait([user.asParent!.currentChild, user.asParent!.children()]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              var list = snapshot.data! as List<dynamic>;
              var currentChild = list[0] as StudentModel;
              var children = list[1] as List<StudentModel>;

              return Row(children: [
                Text(currentChild.fullName),
                children.length > 1
                    ? ElevatedButton(
                        onPressed: () => _changeChildBottomsheet(user.asParent!),
                        child: const Text('сменить ребенка'),
                      )
                    : const SizedBox.shrink(),
              ]);
            })
        : const SizedBox.shrink();
  }

  void _changeChildBottomsheet(ParentModel user) {
    Get.bottomSheet(
      Card(
        child: FutureBuilder<List<StudentModel>>(
            future: user.children(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
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

  void _changeChild(ParentModel parent, StudentModel student) async {
    if (await parent.currentChild != student) {
      parent.setChild(student);
      Get.offAll(() => const HomePage());
    }
    Get.back();
  }

  void _logout() async {
    await Get.find<FAuth>().logout();
    Get.offAll(() => const LoginPage());
  }

  Widget _changeTypeW(BuildContext context, PersonModel user) {
    return Row(children: [
      Text(user.currentType.name),
      user.types.length > 1
          ? ElevatedButton(
              child: const Text('сменить тип'),
              onPressed: () => _changeTypeBottomsheet(context, user),
            )
          : const SizedBox.shrink(),
    ]);
  }

  void _changeTypeBottomsheet(BuildContext context, PersonModel user) {
    Get.bottomSheet(
      Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...user.types.map((e) => ElevatedButton(
                  onPressed: () => _changeType(user, e),
                  child: Text(e.localizedName(S.of(context))),
                )),
          ],
        ),
      ),
    );
  }

  void _changeType(PersonModel user, PersonType type) {
    Widget target;
    if (user.currentType != type) {
      user.setType(type);
      if (type == PersonType.admin) {
        target = const AdminPage();
      } else {
        target = const HomePage();
      }
      Get.offAll(() => target);
    }
    Get.back();
  }
}
