import 'package:schoosch/controller/blueprint_controller.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/pages/map/qr_scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloorSelection extends StatelessWidget {
  const FloorSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Positioned(
        bottom: 0,
        right: Get.find<BlueprintController>().side$.value ? 0 : null,
        left: !Get.find<BlueprintController>().side$.value ? 0 : null,
        // width: MediaQuery.of(context).size.width * 0.2,
        width: 97,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1.3,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Colors.blue.withOpacity(0.7),
          ),
          margin: const EdgeInsets.only(bottom: 100, left: 10, right: 10, top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: FutureBuilder<List<int>>(
              future: Get.find<FStore>().getAllFloors(),
              builder: (context, flors) {
                if (!flors.hasData) {
                  return Container(
                    height: 50,
                  );
                }
                if (flors.data!.isEmpty) {
                  return const SizedBox(height: 50, child: Text('OOOO'));
                }
                return Column(mainAxisSize: MainAxisSize.min, children: [
                  RawMaterialButton(
                    onPressed: () {
                      Get.to(const ScanPage());
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    child: const Icon(
                      Icons.qr_code_2,
                      color: Colors.black,
                      size: 30,
                    ),
                    padding: const EdgeInsets.all(15.0),
                    shape: const CircleBorder(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ...floorBtnsList(flors.data!),
                ]);
              }),
        ),
      );
    });
  }

  List<Widget> floorBtnsList(List<int> flors) {
    List<Widget> res = [];
    for (var i = 0; i < flors.length; i++) {
      res.add(
        Obx(() {
          return RawMaterialButton(
            onPressed: () {
              Get.find<BlueprintController>().chosenFloor$.value = flors[i];
            },
            elevation: Get.find<BlueprintController>().chosenFloor$.value == flors[i] ? 0 : 2.0,
            fillColor: Get.find<BlueprintController>().chosenFloor$.value == flors[i] ? Colors.grey[300] : Colors.white,
            child: Text(
              "${flors[i]}",
              style: const TextStyle(fontSize: 30),
            ),
            padding: const EdgeInsets.only(top: 15, bottom: 25, right: 15, left: 15),
            shape: const CircleBorder(),
          );
        }),
      );
    }
    return res;
  }
}
