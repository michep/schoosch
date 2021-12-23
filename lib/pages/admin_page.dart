import 'package:flutter/material.dart';
import 'package:schoosch/widgets/admindrawer.dart';
import 'package:schoosch/widgets/appbar.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: Drawer(
        child: AdminDrawer(),
      ),
      appBar: MAppBar(
        'Schoosch / Скуш',
        showProfile: true,
      ),
      body: SafeArea(
        child: Center(
          child: Text('admin page'),
        ),
      ),
    );
  }
}
