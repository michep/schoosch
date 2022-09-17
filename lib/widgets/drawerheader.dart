import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/storage_controller.dart';
import 'package:schoosch/model/institution_model.dart';

Widget drawerHeader(BuildContext context) {
  return DrawerHeader(
    decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
        // Expanded(
        //   child: Get.find<FStorage>().logoImageData != null
        //       ? Padding(
        //           padding: const EdgeInsets.only(top: 10),
        //           child: Image.memory(
        //             Get.find<FStorage>().logoImageData!,
        //           ),
        //         )
        //       : const SizedBox.shrink(),
        // ),
      ],
    ),
  );
}
