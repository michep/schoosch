import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/widgets/appbar.dart';

class InstitutionPage extends StatelessWidget {
  final InstitutionModel institution;

  const InstitutionPage(this.institution, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        AppLocalizations.of(context)!.appBarTitle,
        showProfile: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(institution.name),
            Text(institution.address),
          ],
        ),
      ),
    );
  }
}
