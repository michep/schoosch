import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/views/profile_page.dart';

class MAppBar extends StatelessWidget with PreferredSizeWidget {
  const MAppBar(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: const [
        IconButton(
          icon: Icon(Icons.person),
          onPressed: _profile,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);

  static void _profile() {
    Get.to(() => ProfilePage());
  }
}
