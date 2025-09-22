import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get.dart';
import 'package:schoosch/old/controller/auth_controller.dart';
import 'package:schoosch/old/model/class_model.dart';
import 'package:schoosch/old/model/institution_model.dart';
import 'package:schoosch/old/model/person_model.dart';

class DataStore extends getx.GetxController {
  late InstitutionModel institution;
  PersonModel? _currentUser;
  ClassModel? currentObserverClass;
  final Dio dio = Dio();
  Uri Function(String) baseUriFunc;

  DataStore(this.baseUriFunc);

  Future<void> init(String userEmail, {required List<GetxController> controllers}) async {
    // await Future.forEach(
    //   controllers,
    //   (cont) {
    //     // cont.init();
    //     var contType = cont.;
    //     Get.put<contType>(cont);
    //   },
    // );

    if (dio.httpClientAdapter is IOHttpClientAdapter) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        HttpClient client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          var currentToken = getx.Get.find<FAuth>().token;
          options.headers.addAll({'Authorization': 'Bearer $currentToken'});
          return handler.next(options);
        },
      ),
    );

    // institution = await _geInstitutionIdByUserEmail(userEmail);
    // await institution.prefetchMarkTypes();
    // _currentUser = await _getPersonByEmail(userEmail);
  }
}
