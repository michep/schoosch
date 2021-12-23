import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';

Widget drawerHeader(BuildContext context) {
  return DrawerHeader(
    decoration: BoxDecoration(color: Theme.of(context).primaryColor),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Get.find<FStore>().currentInstitution!.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Expanded(
          child: Get.find<FStore>().logoImageData != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.memory(
                    Get.find<FStore>().logoImageData!,
                  ),
                )
              : Container(),
        ),
      ],
    ),
  );
}
