import 'package:directed_graph/directed_graph.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
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
  // late RxList<NodeModel> nodesPath$;
  late final BidirectedGraph<NodeModel> bg;
  List<VenueModel> _allBluePrints = [];
  List<NodeModel> _allNodes = [];
  List<VenueModel> _currentBluePrints = [];
  List<NodeModel> _curpath = [];
  Map<String, List<String>> _connections = {};
  final List<NodeModel> _curpathonfloor = [];
  // late RxList<NodeModel> nodesList$;

  BlueprintController() {
    chosenRoom$ = _chosenroom.obs;
    chosenroomfrom$ = _roomgofrom.obs;
    chosenFloor$ = 1.obs;
    side$ = true.obs;
    mode$ = CurrentMode.watching.obs;
    // nodesPath$ = <NodeModel>[].obs;
    // nodesList$ = _curpathonfloor.obs;
  }

  Future<void> init() async {
    _allBluePrints = await InstitutionModel.currentInstitution.venues;
    _allNodes = await Get.find<FStore>().getAllNodes();
    _connections = await Get.find<FStore>().getAllNodeConnections();
    // bg = getGraph(_allNodes, _connections);
    bg = getGraph();
  }

  RxList<VenueModel> get bluePrints$ => _currentBluePrints.obs;

  RxList<NodeModel> get nodesList$ => _curpathonfloor.obs;

  List<VenueModel> get bluePrints => _allBluePrints;

  void findARoom(String name) {
    var found = _allBluePrints.firstWhereOrNull((element) => (element.name == name));
    if (found != null) {
      chosenFloor$.value = found.floor!;
      chosenRoom$.value = found.name;
      mode$.value = CurrentMode.searching;
    }
  }

  void findAPath(String name) {
    var found = _allBluePrints.firstWhereOrNull((element) => (element.name == name));
    if (found != null) {
      chosenroomfrom$.value = found.name;
      mode$.value = CurrentMode.pathing;
    }
    _curpath = bestPath(chosenroomfrom$.value!, chosenRoom$.value!);
    chosenFloor$.refresh();
  }

  void cancelFinding() {
    chosenRoom$.value = null;
    mode$.value = CurrentMode.watching;
    _curpath.clear();
    _curpathonfloor.clear();
  }

  void cancelPath() {
    chosenroomfrom$.value = null;
    mode$.value = CurrentMode.searching;
    _curpath.clear();
    _curpathonfloor.clear();
  }

  void makeFloor(int floor) {
    _currentBluePrints = _allBluePrints.where((element) => element.floor == floor).toList();
    if (_curpath.isNotEmpty) {
      _curpathonfloor.clear();
      _curpathonfloor.addAll(_curpath.where((element) => element.floor == floor).toList());
    } else {
      _curpathonfloor.clear();
    }
  }

  // BidirectedGraph getGraph(List<NodeModel> nodes, Map<String, List<String>> connects) {
  BidirectedGraph<NodeModel> getGraph() {
    Map<NodeModel, Set<NodeModel>> res = {};
    for (String i in _connections.keys) {
      var n = findNode(i);
      res[n] = {};
      var ll = _connections[i]!;
      for (String l in ll) {
        var m = findNode(l);
        res[n]!.add(m);
      }
    }
    return BidirectedGraph<NodeModel>(res);
  }

  NodeModel findNode(String id) {
    return _allNodes.firstWhere((element) => element.id == id);
  }

  List<NodeModel> bestPath(String start, String finish) {
    return bg
        .shortestPath(
          _allNodes.firstWhere((element) => element.name == start),
          _allNodes.firstWhere((element) => element.name == finish),
        )
        .toList();
  }
}

enum CurrentMode { watching, searching, pathing }
