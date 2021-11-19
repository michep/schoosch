import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/week_controller.dart';

class AnimatedSwipeScheduleSwitcher extends StatelessWidget {
  final CurrentWeek _cw = Get.find<CurrentWeek>();
  final Widget child;

  AnimatedSwipeScheduleSwitcher({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          reverseDuration: const Duration(seconds: 0),
          switchInCurve: Curves.easeIn,
          layoutBuilder: layoutBuilder,
          transitionBuilder: transitionBuilder,
          child: Dismissible(
            confirmDismiss: onDismissed,
            key: ValueKey(_cw.currentWeek.id),
            resizeDuration: const Duration(seconds: 0),
            child: child,
          ),
        ));
  }

  Widget layoutBuilder(Widget? currentChild, List<Widget> previousChildren) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        ...previousChildren,
        if (currentChild != null) currentChild,
      ],
    );
  }

  Widget transitionBuilder(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: _cw.lastChange == 1
          ? Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0)).animate(animation)
          : Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0)).animate(animation),
      child: child,
    );
  }

  Future<bool> onDismissed(DismissDirection dir) async {
    switch (dir) {
      case DismissDirection.endToStart:
        return _cw.changeCurrentWeek(1);
      case DismissDirection.startToEnd:
        return _cw.changeCurrentWeek(-1);
      default:
        return false;
    }
  }
}
