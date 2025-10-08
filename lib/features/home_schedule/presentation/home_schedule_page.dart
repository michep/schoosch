import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:schoosch/core/page/page.dart' as p;
import 'package:schoosch/features/home_schedule/presentation/view/home_schedule_screen.dart';
import 'package:schoosch/features/homework/presentation/view/homework_screen.dart';

final class HomeSchedulePage extends p.Page {
  @override
  Future<void> init() async {
    
  }

  @override
  Widget screen() {
    return HomeScheduleScreen(lesson: lesson, curriculum: curriculum, venue: venue, time: time, date: date, teacher: teacher);
  }

  @override 
  GetPage toGetPage({required String pageName});
}