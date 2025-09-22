import 'package:dio/dio.dart';

class BaseDioFunctions {
  static final Dio _dio = Dio();
  static bool forceLocal = false;

  BaseDioFunctions({required bool isLocal}) {
    forceLocal = isLocal;
  }

  static Uri baseUriFunction({required String path, bool isLocal = false}) {
    if (isLocal || forceLocal) {
      return Uri.http('localhost:8182', '/schoosch/api$path');
    } else {
      return Uri.https('www.chepaykin.org', '/schoosch/api$path');
    }
  }

  static Options baseOptions({Map<String, dynamic>? options}) {
    options ??= {};
    Map<String, dynamic> headers = {'Content-Type': 'application/json'};
    headers.addAll(options);
    return Options(
      headers: headers,
    );
  }

  static Future<T> get<T>({required String path}) async {
    var res = await _dio.getUri(
      baseUriFunction(path: path),
    );
    return res.data!;
  }

  static Future<List<dynamic>> getList({required String path}) async {
    var res = await _dio.getUri<List>(
      baseUriFunction(path: path),
    );
    return res.data!;
  }

  static Future<Map<String, dynamic>> getMapData({required String path}) async {
    var res = await _dio.getUri<Map<String, dynamic>>(
      baseUriFunction(path: path),
    );
    return res.data!;
  }

  static Future<List<dynamic>> postList({
    required String path,
    Object? data,
  }) async {
    var res = await _dio.postUri<List>(
      baseUriFunction(path: path),
      options: baseOptions(),
      data: data,
    );
    return res.data!;
  }

  static Future<Map<String, dynamic>> putMapData({
    required String path,
    Map<String, dynamic>? data,
  }) async {
    var res = await _dio.putUri<Map<String, dynamic>>(
      baseUriFunction(path: path),
      options: baseOptions(),
      data: data,
    );
    return res.data!;
  }

  static Future<void> delete({required String path}) async {
    await _dio.deleteUri(
      baseUriFunction(path: path),
    );
  }
}
