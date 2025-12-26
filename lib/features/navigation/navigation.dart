import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:schoosch/features/home_schedule/presentation/home_schedule_page.dart';
import 'package:schoosch/features/home_schedule/presentation/view/home_schedule_screen.dart';
import 'package:schoosch/features/homework/presentation/homework_page.dart';
import 'package:schoosch/features/homework/presentation/view/homework_screen.dart';

class Navigation {
  HomeSchedulePage homeSchedulePage = HomeSchedulePage();
  HomeworkPage homeworkPage = HomeworkPage();

  Future<void> init() async {
    //TODO: all pages init here
    await homeSchedulePage.init();
    await homeworkPage.init();
  }

  List<GetPage> pages() => [
    homeSchedulePage.toGetPage(
    ),
    homeworkPage.toGetPage(
      pageName: HomeworkScreenProvider.routeName,
    ),
  ];
}
