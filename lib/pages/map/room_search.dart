import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/blueprint_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/firestore_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/utils.dart';

class RoomSearch extends StatefulWidget {
  late final List<VenueModel> blueprints;
  final Map<TeacherModel, List<String>> teachersMap;
  final ClassModel? aclass;

  RoomSearch(this.aclass, this.teachersMap, {Key? key}) : super(key: key) {
    blueprints = Get.find<BlueprintController>().bluePrints;
  }

  @override
  State<RoomSearch> createState() => _RoomSearchState();
}

class _RoomSearchState extends State<RoomSearch> {
  final TextEditingController roomcont = TextEditingController();
  final TextEditingController roomtocont = TextEditingController();
  final TextEditingController teachercont = TextEditingController();
  String chosen = "";

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Positioned(
        right: Get.find<BlueprintController>().side$.value ? 0 : null,
        left: !Get.find<BlueprintController>().side$.value ? 0 : null,
        bottom: 0,
        // height: MediaQuery.of(context).size.height * 0.12,
        height: 97,
        width:
            Get.find<BlueprintController>().mode$.value == CurrentMode.watching ? MediaQuery.of(context).size.width * 0.66 : MediaQuery.of(context).size.width,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1200),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 1.3),
            color: Colors.black.withOpacity(0.7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: DropdownSearch<TeacherModel>(
                  popupProps: PopupProps.bottomSheet(
                    showSearchBox: true,
                    itemBuilder: (context, item, isSelected) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: !isSelected
                            ? null
                            : BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                        child: ListTile(
                          selected: isSelected,
                          title: Text('${item.firstname} ${item.middlename}'),
                          subtitle: Text(widget.teachersMap[item]!.join(', ')),
                        ),
                      );
                    },
                    bottomSheetProps: const BottomSheetProps(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    ),
                    searchFieldProps: TextFieldProps(
                      controller: teachercont,
                      decoration: const InputDecoration(
                        // border: OutlineInputBorder(borderSide: BorderSide.none),
                        border: UnderlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                        labelText: "поиск...",
                      ),
                    ),
                    title: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.8),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'УЧИТЕЛЯ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  dropdownButtonProps: const DropdownButtonProps(
                    icon: Icon(Icons.person_outline),
                    iconSize: 35,
                  ),
                  clearButtonProps: const ClearButtonProps(
                    isVisible: true,
                  ),
                  itemAsString: (item) => '${item.firstname} ${item.middlename}',
                  items: widget.teachersMap.keys.toList(),
                  dropdownBuilder: (context, item) {
                    if (item == null) {
                      return const Text('');
                    }
                    return Text(
                      '${item.firstname} ${item.middlename}',
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                  onChanged: (a) {
                    if (a != null) {
                      showMyDialog(a);
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Get.find<BlueprintController>().mode$.value != CurrentMode.watching
                  ? Expanded(
                      child: DropdownSearch<String>(
                        popupProps: PopupProps.bottomSheet(
                          showSearchBox: true,
                          showSelectedItems: true,
                          bottomSheetProps: const BottomSheetProps(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                          ),
                          searchFieldProps: TextFieldProps(
                            controller: roomtocont,
                            decoration: const InputDecoration(
                              // border: OutlineInputBorder(borderSide: BorderSide.none),
                              border: UnderlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                              labelText: "пройти от кабинета...",
                            ),
                          ),
                          title: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.8),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'КАБИНЕТЫ',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        dropdownButtonProps: const DropdownButtonProps(
                          icon: Icon(Icons.edit_location_alt_outlined),
                          iconSize: 35,
                        ),
                        items: widget.blueprints.where((element) => element.type == 'room' && element.name != 'unknown').map((e) => e.name).toList(),
                        onChanged: (a) {
                          if (a == null) {
                            Get.find<BlueprintController>().cancelPath();
                            roomtocont.text = '';
                          } else {
                            Get.find<BlueprintController>().findAPath(a);
                          }
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: DropdownSearch<String>(
                  // mode: Mode.BOTTOM_SHEET,
                  popupProps: PopupProps.bottomSheet(
                    showSearchBox: true,
                    showSelectedItems: true,
                    bottomSheetProps: const BottomSheetProps(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    ),
                    searchFieldProps: TextFieldProps(
                      controller: roomcont,
                      decoration: const InputDecoration(
                        // border: OutlineInputBorder(borderSide: BorderSide.none),
                        border: UnderlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                        labelText: "поиск...",
                      ),
                    ),
                    title: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.8),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'КАБИНЕТЫ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  dropdownButtonProps: const DropdownButtonProps(
                    icon: Icon(Icons.room_outlined),
                    iconSize: 35,
                  ),
                  clearButtonProps: const ClearButtonProps(
                    isVisible: true,
                  ),
                  items: widget.blueprints.where((element) => element.type == 'room' && element.name != 'unknown').map((e) => e.name).toList(),
                  onChanged: (a) {
                    if (a == null) {
                      Get.find<BlueprintController>().cancelFinding();
                      roomcont.text = '';
                    } else {
                      Get.find<BlueprintController>().findARoom(a);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> showMyDialog(TeacherModel teacher) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('${teacher.firstname} ${teacher.middlename}'),
          content: SingleChildScrollView(
            child: FutureBuilder<List<TeacherScheduleModel>>(
                future: Get.find<FStore>().getTeacherWeekSchedule(teacher, Week.current()),
                builder: (context, snapshota) {
                  if (!snapshota.hasData) {
                    return Utils.progressIndicator();
                  }
                  if (snapshota.data!.isEmpty) {
                    return const Text('на эту неделю расписания нет.');
                  }
                  return FutureBuilder<List<LessonModel>>(
                      future: snapshota.data!.where((element) => element.day == DateTime.now().weekday).toList()[0].getLessons(),
                      builder: (context, snapshotb) {
                        if (!snapshotb.hasData) {
                          return Utils.progressIndicator();
                        }
                        if (snapshotb.data!.isEmpty) {
                          return const Text('на сегодня уроков нет.');
                        }
                        return ListBody(
                            children: snapshotb.data!
                                .map((e) => ListTile(
                                    leading: Text('${e.order}'),
                                    title: FutureBuilder<CurriculumModel?>(
                                        future: e.curriculum,
                                        builder: (context, snapshotc) {
                                          if (!snapshotc.hasData) {
                                            return const Text('');
                                          }
                                          return Text(snapshotc.data!.aliasOrName);
                                        })))
                                .toList());
                      });
                }),
          ),
          actions: [
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close),
            ),
          ],
        );
      },
    );
  }
}
