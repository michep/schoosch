import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/attachments.dart';

class InstitutionPage extends StatelessWidget {
  final InstitutionModel institution;

  const InstitutionPage(this.institution, {super.key});

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
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
            Attachments(
              attachments: [institution.logo],
              limit: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ElevatedButton(
                child: Text(loc.saveChanges),
                onPressed: () => print('save'), //TODO:
              ),
            ),
          ],
        ),
      ),
    );
  }
}
