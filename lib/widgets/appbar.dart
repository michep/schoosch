import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/views/profile_page.dart';

class MAppBar extends StatelessWidget with PreferredSizeWidget {
  const MAppBar(this.title, {this.tabs, this.showProfile = false, Key? key}) : super(key: key);

  final String title;
  final List<Tab>? tabs;
  final bool showProfile;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: showProfile
          ? const [
              IconButton(
                icon: Icon(Icons.person),
                onPressed: _profile,
              ),
            ]
          : [],
      bottom: tabs != null ? TabBar(tabs: tabs!) : null,
    );
  }

  @override
  Size get preferredSize => tabs != null ? const Size.fromHeight(132) : const Size.fromHeight(48);

  static void _profile() {
    Get.to(() => ProfilePage());
  }
}
