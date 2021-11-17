import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';

class MDrawer extends StatelessWidget {
  const MDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          // decoration: const BoxDecoration(color: Colors.lightBlueAccent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Schoosch / Скуш',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
        ),
      ],
    );
  }
}
