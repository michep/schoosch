import 'package:flutter/material.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/widgets/appbar.dart';

class CurriculumListPage extends StatelessWidget {
  final InstitutionModel institution;

  const CurriculumListPage(this.institution, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(
        'Schoosch / Скуш',
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
