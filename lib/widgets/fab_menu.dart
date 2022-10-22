import 'package:flutter/material.dart';

class FABMenu extends StatefulWidget {
  // final int childCount;
  // final Map<IconData, void Function()> children;
  final List<FABmenuchild> children;
  final Color colorClosed;
  final Color colorOpen;
  const FABMenu({
    Key? key,
    // required this.childCount,
    required this.children,
    required this.colorClosed,
    required this.colorOpen,
  }) : super(key: key);

  @override
  State<FABMenu> createState() => _FABMenuState();
}

class _FABMenuState extends State<FABMenu> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  // late Animation<Color> _animationColor;
  late Animation<double> _animationIcon;
  late Animation<double> _animationButton;
  double fabheight = 56;
  bool isOpened = false;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animationIcon = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      _animationController,
    );
    // _animationColor = Tween<Color>(
    //   begin: widget.colorClosed,
    //   end: widget.colorOpen,
    // ).animate(
    //   CurvedAnimation(
    //     parent: _animationController,
    //     curve: const Interval(0, 1, curve: Curves.linear),
    //   ),
    // );
    _animationButton = Tween<double>(begin: fabheight, end: -14).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          0.75,
          curve: Curves.easeInOut,
        ),
      ),
    );
    super.initState();
  }

  void animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget _toggle() {
    return FloatingActionButton(
      onPressed: animate,
      backgroundColor: widget.colorClosed,
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animationIcon,
      ),
    );
  }

  // Widget _hwclass() {
  //   return FloatingActionButton(
  //     onPressed: null,
  //     backgroundColor: Theme.of(context).colorScheme.background,
  //     child: const Icon(Icons.groups_rounded),
  //   );
  // }

  // Widget _hwstudent() {
  //   return FloatingActionButton(
  //     onPressed: null,
  //     backgroundColor: Theme.of(context).colorScheme.background,
  //     child: const Icon(Icons.person_rounded),
  //   );
  // }

  Widget _hwsbutton(FABmenuchild child) {
    return child.isVisible
        ? Transform(
            transform: Matrix4.translationValues(
              0,
              _animationButton.value * (widget.children.length - widget.children.indexOf(child)),
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (child.title != null && isOpened)
                  Container(
                    padding: const EdgeInsets.all(6),
                    color: widget.colorOpen,
                    child: Text(child.title!),
                  ),
                const SizedBox(
                  width: 8,
                ),
                FloatingActionButton(
                  key: ValueKey(child),
                  heroTag: ValueKey(child),
                  onPressed: child.onPressed,
                  backgroundColor: widget.colorOpen,
                  child: Icon(child.icon),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
    //       );
    // return FloatingActionButton(
    //   key: ValueKey(child),
    //   heroTag: ValueKey(child),
    //   onPressed: child.onPressed,
    //   backgroundColor: widget.colorOpen,
    //   child: Icon(child.icon),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ...widget.children.keys.toList().map((e) {
        //   var l = widget.children.keys.toList();
        //   return Transform(
        //     transform: Matrix4.translationValues(
        //       0,
        //       _animationButton.value * (l.length - l.indexOf(e)),
        //       0,
        //     ),
        //     child: _hwsbutton(
        //       widget.children[e]!,
        //       e,
        //       ValueKey(e),
        //     ),
        //   );
        // }),
        ...widget.children.map((e) {
          return _hwsbutton(e);
        }),
        // Transform(
        //   transform: Matrix4.translationValues(0, _animationButton.value * 2, 0),
        //   child: _hwstudent(),
        // ),
        // Transform(
        //   transform: Matrix4.translationValues(0, _animationButton.value * 1, 0),
        //   child: _hwclass(),
        // ),
        _toggle(),
      ],
    );
  }
}

class FABmenuchild {
  late final IconData icon;
  late final bool isVisible;
  late final void Function() onPressed;
  late final String? title;

  FABmenuchild({
    required this.icon,
    this.isVisible = true,
    required this.onPressed,
    this.title,
  });
}

// class FABmenuchild extends StatelessWidget {
//   FABmenuchild({Key? key}) : super(key: key);

//   late Animation<double> anim;

//   void setAnimationController

//   @override
//   Widget build(BuildContext context) {
//     return Transform(
//       transform: Matrix4.translationValues(
//         0,
//         _animationButton.value * (l.length - l.indexOf(e)),
//         0,
//       ),
//       child: FloatingActionButton(
//       key: key,
//       heroTag: key,
//       onPressed: onTap,
//       backgroundColor: widget.colorOpen,
//       child: Icon(icon),
//     ),
//     );
//   }
// }
