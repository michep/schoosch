import 'package:schoosch/core/providers/base_dio_functions.dart';
import 'package:schoosch/old/model/class_model.dart';
import 'package:schoosch/old/model/institution_model.dart';
import 'package:schoosch/old/model/person_model.dart';

final class ClassRemoteDataSource {
  InstitutionModel? _currentInstitution;

  Future<void> init(InstitutionModel institution) async {
    _currentInstitution = institution;
  }

  Future<String> saveClass(ClassModel aclass) async {
    var data = aclass.toMap(withId: true);
    data['institution_id'] = _currentInstitution!.id;
    var js = await BaseDioFunctions.putMapData(
      path: '/class',
      data: data,
    );
    return js['id'];
  }

  Future<void> deleteClass(ClassModel aclass) async {
    await BaseDioFunctions.delete(path: '/class/${aclass.id}');
  }

  Future<List<ClassModel>> getAllClasses() async {
    var js = await BaseDioFunctions.getList(
      path: '/class',
    );
    return js.map((data) => ClassModel.fromMap(data['_id'], data)).toList();
  }

  Future<ClassModel> getClass(String id) async {
    var js = await BaseDioFunctions.getMapData(
      path: '/class/$id',
    );
    return ClassModel.fromMap(js['_id'], js);
  }

  Future<List<ClassModel>> getClassesByIds(List<String> ids) async {
    var js = await BaseDioFunctions.postList(
      path: '/class',
      data: ids,
    );
    return js.map((data) => ClassModel.fromMap(data['_id'], data)).toList();
  }

  Future<ClassModel?> getClassByStudent(PersonModel student) async {
    var js = await BaseDioFunctions.getMapData(
      path: '/class/student/${student.id}',
    );
    return ClassModel.fromMap(js['_id'], js);
  }
}
