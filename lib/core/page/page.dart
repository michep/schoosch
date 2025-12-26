import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

abstract class Page {
  Future<void> init();

  Widget screen();

  GetPage toGetPage({required String pageName,});
}
