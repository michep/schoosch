import 'package:flutter/material.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/widgets/appbar.dart';

class VenuePage extends StatelessWidget {
  final InstitutionModel institution;

  const VenuePage(this.institution, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(
        'Schoosch / Скуш',
        showProfile: true,
      ),
      body: SafeArea(
        child: Center(
          child: Text('venue'),
        ),
      ),
    );
  }
}
