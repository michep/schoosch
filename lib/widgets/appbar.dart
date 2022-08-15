import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/profile_page.dart';

class MAppBar extends StatelessWidget with PreferredSizeWidget {
  const MAppBar(this._title, {this.showProfile = false, this.showSendNotif = false, Key? key, this.actions}) : super(key: key);

  final String _title;
  final bool showProfile;
  final bool showSendNotif;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_title),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      actions: [
        if (showProfile)
          const IconButton(
            icon: Icon(Icons.person),
            onPressed: _profile,
          ),
        if (showSendNotif)
          IconButton(
            icon: const Icon(Icons.notification_add),
            onPressed: () async {
              await Get.find<FStore>().sendNotif(
                [
                  PersonModel.currentUser!,
                ],
              );
            },
          ),
        if (actions != null) ...actions!,
      ],
      // bottom: tabs != null ? TabBar(tabs: tabs!) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);

  static void _profile() {
    Get.to(() => ProfilePage(PersonModel.currentUser!));
  }
}
