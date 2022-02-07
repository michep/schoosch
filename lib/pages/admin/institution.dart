import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/widgets/appbar.dart';

class InstitutionPage extends StatelessWidget {
  final InstitutionModel institution;

  const InstitutionPage(this.institution, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        S.of(context).appBarTitle,
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
