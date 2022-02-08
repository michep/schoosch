import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/blueprint_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/utils.dart';

class RoomSearch extends StatefulWidget {
  late List<VenueModel> blueprints;
  Map<TeacherModel, List<String>> teachersMap;
  ClassModel? aclass;

  RoomSearch(this.aclass, this.teachersMap, {Key? key}) : super(key: key) {
    blueprints = Get.find<Blueprint_Controller>().bluePrints;
  }

  @override
  State<RoomSearch> createState() => _RoomSearchState();
}

class _RoomSearchState extends State<RoomSearch> {
  final TextEditingController roomcont = TextEditingController();
  final TextEditingController teachercont = TextEditingController();
  String chosen = "";

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      height: MediaQuery.of(context).size.height * 0.12,
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 1.3),
            color: Colors.blue.withOpacity(0.7)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: DropdownSearch<String>(
                mode: Mode.BOTTOM_SHEET,
                showSelectedItems: true,
                dropDownButton: const Icon(
                  Icons.room_outlined,
                  size: 35,
                ),
                items: widget.blueprints
                    .where((element) =>
                        element.type == 'room' && element.name != 'unknown')
                    .map((e) => e.name)
                    .toList(),
                onChanged: (a) {
                  if (a == null) {
                    Get.find<Blueprint_Controller>().cancelFinding();
                    roomcont.text = '';
                  } else {
                    Get.find<Blueprint_Controller>().findARoom(a);
                  }
                },
                showSearchBox: true,
                showClearButton: true,
                // selectedItem: cont.text,
                searchFieldProps: TextFieldProps(
                  controller: roomcont,
                  decoration: const InputDecoration(
                    // border: OutlineInputBorder(borderSide: BorderSide.none),
                    border: UnderlineInputBorder(),
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                    labelText: "поиск...",
                  ),
                ),
                popupTitle: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.only(
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
                popupShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: DropdownSearch<TeacherModel>(
                mode: Mode.BOTTOM_SHEET,
                dropDownButton: const Icon(
                  Icons.person_outline,
                  size: 35,
                ),
                itemAsString: (item) => '${item!.firstname} ${item.middlename}',
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
                popupItemBuilder: (context, item, isSelected) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: !isSelected
                        ? null
                        : BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
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
                showSearchBox: true,
                showClearButton: true,
                // selectedItem: cont.text,
                searchFieldProps: TextFieldProps(
                  controller: teachercont,
                  decoration: const InputDecoration(
                    // border: OutlineInputBorder(borderSide: BorderSide.none),
                    border: UnderlineInputBorder(),
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                    labelText: "поиск...",
                  ),
                ),
                popupTitle: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.only(
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
                popupShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                future: Get.find<FStore>()
                    .getTeacherWeekSchedule(teacher, Week.current()),
                builder: (context, snapshota) {
                  if (!snapshota.hasData) {
                    return Utils.progressIndicator();
                  }
                  if (snapshota.data!.isEmpty) {
                    return const Text('no scahedule');
                  }
                  return FutureBuilder<List<LessonModel>>(
                      future: snapshota.data!
                          .where((element) =>
                              element.day == DateTime.now().weekday)
                          .toList()[0]
                          .getLessons(),
                      builder: (context, snapshotb) {
                        if (!snapshotb.hasData) {
                          return Utils.progressIndicator();
                        }
                        if (snapshotb.data!.isEmpty) {
                          return const Text('no lessons for today');
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
                                          return Text(
                                              snapshotc.data!.aliasOrName);
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
