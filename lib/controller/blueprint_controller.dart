import 'package:flutter/cupertino.dart';
import 'package:schoosch/model/dummy_nodes_data.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/node_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:get/get.dart';
// import './blueprint_data.dart';

class BlueprintController extends GetxController {
  String? _chosenroom;
  String? _roomgofrom;
  late Rx<String?> chosenRoom$;
  late Rx<String?> chosenroomfrom$;
  late RxInt chosenFloor$;
  late RxBool side$;
  late Rx<CurrentMode> mode$;
  late RxList<NodeModel> nodesPath$; 
  List<VenueModel> _allBluePrints = [];
  List<VenueModel> _currentBluePrints = []; 

  BlueprintController() {
    chosenRoom$ = _chosenroom.obs;
    chosenroomfrom$ = _roomgofrom.obs;
    chosenFloor$ = 1.obs;
    side$ = true.obs;
    mode$ = CurrentMode.Watching.obs;
    nodesPath$ = [NodeModel(floor: 0, position: const Offset(0, 0))].obs;
  }

  Future<void> init() async {
    _allBluePrints = await InstitutionModel.currentInstitution.venues;
  }

  RxList<VenueModel> get bluePrints$ => _currentBluePrints.obs;

  List<VenueModel> get bluePrints => _allBluePrints;

  void findARoom(String name) {
    var found = _allBluePrints.firstWhereOrNull((element) => (element.name == name));
    if (found != null) {
      chosenFloor$.value = found.floor;
      chosenRoom$.value = found.name;
      mode$.value = CurrentMode.Searching;
    }
  }

  void findAPath(String name) {
    var found = _allBluePrints.firstWhereOrNull((element) => (element.name == name));
    if(found != null) {
      chosenroomfrom$.value = found.name;
      mode$.value = CurrentMode.Pathing;
    }
    nodesPath$.value = testPath(chosenroomfrom$.value!, chosenRoom$.value!);
  }

  void cancelFinding() {
    chosenRoom$.value = null;
    mode$.value = CurrentMode.Watching;
    nodesPath$.value = [NodeModel(floor: 0, position: const Offset(0, 0))];
  }

  void cancelPath() {
    chosenroomfrom$.value = null;
    mode$.value = CurrentMode.Searching;
    nodesPath$.value = [NodeModel(floor: 0, position: const Offset(0, 0))];
  }

  void makeFloor(int floor) {
    _currentBluePrints = _allBluePrints.where((element) => element.floor == floor).toList();
  }

  // void changeMode(CurrentMode newmode) {
  //   mode$.value = newmode;
  // }
}

enum CurrentMode {
  Watching,
  Searching,
  Pathing
}
