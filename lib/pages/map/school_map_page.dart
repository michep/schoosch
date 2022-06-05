import 'package:schoosch/controller/blueprint_controller.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/map/floor.dart';
import 'package:schoosch/pages/map/floor_selection.dart';
import 'package:schoosch/pages/map/room_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchoolMapPage extends StatefulWidget {
  final ClassModel? aclass;
  const SchoolMapPage(this.aclass, {Key? key}) : super(key: key);

  @override
  State<SchoolMapPage> createState() => _SchoolMapPageState();
}

class _SchoolMapPageState extends State<SchoolMapPage> {
  final BlueprintController bpc = Get.find<BlueprintController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Get.find<FStore>().currentInstitution!.name,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.find<BlueprintController>().side$.value = !Get.find<BlueprintController>().side$.value;
            },
            icon: Obx(() {
              return Icon(Get.find<BlueprintController>().side$.value ? Icons.align_horizontal_left_rounded : Icons.align_horizontal_right_rounded);
            }),
          )
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: InteractiveViewer(
              maxScale: 2,
              minScale: 0.5,
              constrained: false,
              boundaryMargin: const EdgeInsets.only(left: 800, right: 800, top: 800, bottom: 800),
              child: Container(
                // color: Colors.amber.withOpacity(0.1),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTapDown: hitTest,
                  onLongPressEnd: cancelHitTest,
                  child: Obx(() {
                    bpc.makeFloor(bpc.chosenFloor$.value);
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 700),
                      child: Floor(
                        bpc.bluePrints$,
                        bpc.chosenRoom$.value,
                        // bpc.nodesPath$,
                        bpc.nodesList$,
                        key: ValueKey(bpc.chosenFloor$.value),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          FutureBuilder<Map<TeacherModel, List<String>>>(
              future: widget.aclass!.teachers,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Positioned(
                    bottom: 0,
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 1.3), color: Colors.blue.withOpacity(0.7)),
                      child: Container(),
                    ),
                  );
                }
                return RoomSearch(widget.aclass, snapshot.data!);
              }),
          const FloorSelection(),
        ],
      ),
    );
  }

  void hitTest(TapDownDetails details) {
    for (var b in bpc.bluePrints$) {
      if (b.path.contains(details.localPosition)) {
        if (b.type == 'room') {
          bpc.chosenRoom$.value = b.name;
        }
      }
    }
  }

  void cancelHitTest(LongPressEndDetails details) {
    if (bpc.bluePrints$.firstWhere((element) => element.name == bpc.chosenRoom$.value).path.contains(details.localPosition)) {
      bpc.cancelFinding();
    }
  }
}
