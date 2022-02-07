import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/pages/admin/admin_drawer.dart';
import 'package:schoosch/widgets/appbar.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: AdminDrawer(),
      ),
      appBar: MAppBar(
        S.of(context).appBarTitle,
        showProfile: true,
      ),
      body: SafeArea(
        child: Center(
          child: Text(MediaQuery.of(context).size.aspectRatio.toStringAsFixed(2)),
        ),
      ),
    );
  }
}
