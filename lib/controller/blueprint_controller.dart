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
  List<NodeModel> _curpath = [];
  final List<NodeModel> _curpathonfloor = [];
  // late RxList<NodeModel> nodesList$;

  BlueprintController() {
    chosenRoom$ = _chosenroom.obs;
    chosenroomfrom$ = _roomgofrom.obs;
    chosenFloor$ = 1.obs;
    side$ = true.obs;
    mode$ = CurrentMode.Watching.obs;
    nodesPath$ = [NodeModel(floor: 0, position: const Offset(0, 0))].obs;
    // nodesList$ = _curpathonfloor.obs;
  }

  Future<void> init() async {
    _allBluePrints = await InstitutionModel.currentInstitution.venues;
    // _curpathonfloor.addAll([NodeModel(floor: 0, position: const Offset(0, 0))]);
    // _curpath.addAll([NodeModel(floor: 0, position: const Offset(0, 0))]);
  }

  RxList<VenueModel> get bluePrints$ => _currentBluePrints.obs;

  RxList<NodeModel> get nodesList$ => _curpathonfloor.obs;

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
    if (found != null) {
      chosenroomfrom$.value = found.name;
      mode$.value = CurrentMode.Pathing;
    }
    // nodesPath$.value = testPath(chosenroomfrom$.value!, chosenRoom$.value!);
    _curpath = testPath(chosenroomfrom$.value!, chosenRoom$.value!);
    chosenFloor$.refresh();
  }

  void cancelFinding() {
    chosenRoom$.value = null;
    mode$.value = CurrentMode.Watching;
    // nodesPath$.value = [NodeModel(floor: 0, position: const Offset(0, 0))];
    // _curpath = [NodeModel(floor: 0, position: const Offset(0, 0))];
    _curpath.clear();
    _curpathonfloor.clear();
  }

  void cancelPath() {
    chosenroomfrom$.value = null;
    mode$.value = CurrentMode.Searching;
    // nodesPath$.value = [NodeModel(floor: 0, position: const Offset(0, 0))];
    // _curpath = [NodeModel(floor: 0, position: const Offset(0, 0))];
    _curpath.clear();
    _curpathonfloor.clear();
  }

  void makeFloor(int floor) {
    _currentBluePrints = _allBluePrints.where((element) => element.floor == floor).toList();
    if (_curpath.isNotEmpty) {
      // _curpathonfloor = _curpath.where((element) => element.floor == floor).toList();
      _curpathonfloor.clear();
      _curpathonfloor.addAll(_curpath.where((element) => element.floor == floor).toList());
    } else {
      _curpathonfloor.clear();
    }
    // if (nodesPath$ != [NodeModel(floor: 0, position: const Offset(0, 0))]) {
    //   _curpathonfloor = nodesPath$.where((element) => element.floor == floor).toList();
    // } else {
    //   _curpathonfloor = [NodeModel(floor: 0, position: const Offset(0, 0))];
    // }
  }

  // void changeMode(CurrentMode newmode) {
  //   mode$.value = newmode;
  // }
}

enum CurrentMode { Watching, Searching, Pathing }
