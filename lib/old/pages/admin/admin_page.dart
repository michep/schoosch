import 'package:flutter/material.dart';
import 'package:schoosch/old/generated/l10n.dart';
import 'package:schoosch/old/pages/admin/admin_drawer.dart';
import 'package:schoosch/old/widgets/appbar.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

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
