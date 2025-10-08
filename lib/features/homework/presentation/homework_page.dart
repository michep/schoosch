import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/core/page/page.dart' as p;
import 'package:schoosch/features/homework/domain/models/homework_model.dart';
import 'package:schoosch/features/homework/presentation/controller/homework_screen_controller.dart';
import 'package:schoosch/features/homework/presentation/view/homework_screen.dart';

final class HomeworkPage extends p.Page {
  HomeworkPage({
    required this.previousHomework
  });

  final HomeworkModel? previousHomework;

  late HomeworkScreenController screenController;

  @override
  Future<void> init() async {
    screenController = Get.find<HomeworkScreenController>()
        ..addEvent(InitializeHomeworkScreenEvent(previousHomework: previousHomework, teacherId: , curriculumId: , classId: , lessonId: ,),);
  }

  @override
  Widget screen() {
    return HomeworkScreen(screenController: screenController);
  }

  @override 
  GetPage toGetPage({required String pageName});
}