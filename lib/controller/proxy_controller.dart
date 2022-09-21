import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';

class ProxyStore extends GetxController {
  final String host;
  late final InstitutionModel institution;
  PersonModel? _currentUser;

  ProxyStore(this.host);

  Future<void> init(String userEmail) async {
    institution = await _geInstitutionIdByUserEmail(userEmail);
    _currentUser = await _getPersonByEmail(userEmail);
  }

  Future<void> reset() async {
    return init(_currentUser!.email);
  }

  void resetCurrentUser() {
    _currentUser = null;
  }

  PersonModel? get currentUser => _currentUser;

  Future<InstitutionModel> _geInstitutionIdByUserEmail(String email) async {
    var res = await http.get(Uri.http(host, '/institution/email/$email'));
    var js = jsonDecode(res.body) as Map<String, dynamic>;
    return InstitutionModel.fromMap(js['_id'], js);
  }

  Future<PersonModel> _getPersonByEmail(String email) async {
    var res = await http.get(Uri.http(host, '/person/email/$email'));
    var js = jsonDecode(res.body) as Map<String, dynamic>;
    return PersonModel.fromMap(js['_id'], js);
  }

  Future<List<ClassModel>> getAllClasses() async {
    var res = await http.get(Uri.http(host, '/class'));
    var js = jsonDecode(res.body) as List;
    return js.map((data) => ClassModel.fromMap(data['_id'], data)).toList();
  }

  Future<ClassModel> getClass(String id) async {
    var res = await http.get(Uri.http(host, '/class/$id'));
    var js = jsonDecode(res.body) as Map<String, dynamic>;
    return ClassModel.fromMap(js['_id'], js);
  }

  Future<String> saveClass(ClassModel aclass) async {
    var data = aclass.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await http.put(Uri.http(host, '/class'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    return jsonDecode(res.body)['id'];
  }

  Future<void> deleteClass(ClassModel aclass) async {
    var data = aclass.toMap(withId: true);
    await http.delete(Uri.http(host, '/class'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
  }

  Future<List<VenueModel>> getAllVenues() async {
    var res = await http.get(Uri.http(host, '/venue'));
    var js = jsonDecode(res.body) as List;
    return js.map((data) => VenueModel.fromMap(data['_id'], data)).toList();
  }

  Future<VenueModel> getVenue(String id) async {
    var res = await http.put(Uri.http(host, '/venue/$id'));
    var js = jsonDecode(res.body) as Map<String, dynamic>;
    return VenueModel.fromMap(js['_id'], js);
  }

  Future<String> saveVenue(VenueModel venue) async {
    var data = venue.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await http.put(Uri.http(host, '/venue'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    return jsonDecode(res.body)['id'];
  }

  Future<void> deleteVenue(VenueModel venue) async {
    var data = venue.toMap(withId: true);
    await http.delete(Uri.http(host, '/venue'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
  }

  Future<List<DayLessontimeModel>> getAllDayLessontime() async {
    var res = await http.get(Uri.http(host, '/lessontime'));
    var js = jsonDecode(res.body) as List;
    return js.map((data) => DayLessontimeModel.fromMap(data['_id'], data)).toList();
  }

  Future<DayLessontimeModel> getDayLessontime(String id) async {
    var res = await http.get(Uri.http(host, '/lessontime/$id'));
    var js = jsonDecode(res.body) as Map<String, dynamic>;
    return DayLessontimeModel.fromMap(js['_id'], js);
  }

  Future<String> saveDayLessontime(DayLessontimeModel dayLessontime) async {
    var data = dayLessontime.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await http.put(Uri.http(host, '/lessontime'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    return jsonDecode(res.body)['id'];
  }

  Future<List<LessontimeModel>> getLessontimes(String id) async {
    var res = await http.get(Uri.http(host, '/lessontime/$id/time'));
    var js = jsonDecode(res.body) as List;
    return js.map((data) => LessontimeModel.fromMap(data['_id'], data)).toList();
  }

  Future<String> saveLessontime(DayLessontimeModel daylessontime, LessontimeModel lessontime) async {
    var data = lessontime.toMap(withId: true);
    data['institution_id'] = institution.id;
    data['lessontime_id'] = daylessontime.id!;
    var res = await http.put(Uri.http(host, '/lessontime/${daylessontime.id!}/time'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    return jsonDecode(res.body)['id'];
  }

  Future<void> deleteLessontime(DayLessontimeModel daylessontime, LessontimeModel lessontime) async {
    var data = lessontime.toMap(withId: true);
    await http.delete(Uri.http(host, '/lessontime/${daylessontime.id!}/time'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
  }

  Future<List<PersonModel>> getAllPeople() async {
    var res = await http.get(Uri.http(host, '/person'));
    var js = jsonDecode(res.body) as List;
    return js.map((data) => PersonModel.fromMap(data['_id'], data)).toList();
  }

  Future<PersonModel> getPerson(String id) async {
    var res = await http.get(Uri.http(host, '/person/$id'));
    var js = jsonDecode(res.body) as Map<String, dynamic>;
    return PersonModel.fromMap(js['_id'], js);
  }

  Future<List<PersonModel>> getPeopleByIds(List<String> ids) async {
    var res = await http.post(Uri.http(host, '/person'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(ids));
    var js = jsonDecode(res.body) as List;
    return js.map((data) => PersonModel.fromMap(data['_id'], data)).toList();
  }

  Future<String> savePerson(PersonModel person) async {
    var data = person.toMap(withId: true);
    data['institution_id'] = institution.id;
    var res = await http.put(Uri.http(host, '/person'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    return jsonDecode(res.body)['id'];
  }
}
