import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:schoosch/pages/admin/admin_drawer.dart';
import 'package:schoosch/widgets/appbar.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: AdminDrawer(),
      ),
      appBar: MAppBar(
        AppLocalizations.of(context)!.appBarTitle,
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
