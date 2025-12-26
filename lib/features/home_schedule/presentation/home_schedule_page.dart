import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:schoosch/core/page/page.dart' as p;
import 'package:schoosch/features/home_schedule/binding/home_schedule_binding.dart';
import 'package:schoosch/features/home_schedule/presentation/controller/home_schedule_screen_controller.dart';
import 'package:schoosch/features/home_schedule/presentation/view/home_schedule_screen.dart';

final class HomeSchedulePage extends p.Page {
  late final HomeScheduleBinding screenBinding;

  @override
  Future<void> init() async {
    screenBinding = HomeScheduleBinding();
  }

  @override
  Widget screen() {
    return HomeScheduleScreen();
  }

  @override
  GetPage toGetPage({required String pageName,}) {
    return GetPage(
      name: pageName,
      page: screen,
      binding: screenBinding,
    );
  }
}
