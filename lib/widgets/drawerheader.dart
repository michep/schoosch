import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/institution_model.dart';

Widget drawerHeader(BuildContext context) {
  return DrawerHeader(
    decoration: BoxDecoration(color: Get.theme.primaryColor),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          InstitutionModel.currentInstitution.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: FutureBuilder<Uint8List?>(
              future: InstitutionModel.currentInstitution.getFile(InstitutionModel.currentInstitution.logo),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                return Image.memory(snapshot.data!);
              },
            ),
          ),
        ),
      ],
    ),
  );
}
