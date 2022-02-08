import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:get/get.dart';
// import './blueprint_data.dart';

class BlueprintController extends GetxController {
  String? _chosenroom;
  late Rx<String?> chosenRoom$;
  late RxInt chosenFloor$;
  late RxBool side$;
  List<VenueModel> _allBluePrints = [];
  List<VenueModel> _currentBluePrints = [];

  BlueprintController() {
    chosenRoom$ = _chosenroom.obs;
    chosenFloor$ = 1.obs;
    side$ = true.obs;
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
    }
  }

  void cancelFinding() {
    chosenRoom$.value = null;
  }

  void makeFloor(int floor) {
    _currentBluePrints = _allBluePrints.where((element) => element.floor == floor).toList();
  }
}
