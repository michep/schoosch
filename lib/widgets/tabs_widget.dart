import 'package:flutter/material.dart';
import 'package:schoosch/widgets/tab_chip.dart';

class TabsWidget extends StatefulWidget {
  final Map<String, Widget> pages;
  final bool isScrollable;
  const TabsWidget({super.key, required this.pages, required this.isScrollable});

  @override
  State<TabsWidget> createState() => _TabsWidgetState();
}

class _TabsWidgetState extends State<TabsWidget> with SingleTickerProviderStateMixin {
  late TabController tabcont;

  @override
  void initState() {
    tabcont = TabController(length: widget.pages.length, vsync: this);
    super.initState();
    tabcont.addListener(() {
      setState(() {
        current = tabcont.index;
      });
    });
  }

  @override
  void dispose() {
    tabcont.removeListener(() {});
    tabcont.dispose();
    super.dispose();
  }

  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: tabcont,
          isScrollable: widget.isScrollable,
          labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          indicatorWeight: 0.001,
          // onTap: (i) {
          //   // setState(() {
              
          //   // });
          // },
          tabs: [
            ...widget.pages.keys.toList().map(
                  (e) => TabChip(current: current, pos: widget.pages.keys.toList().indexOf(e), text: e),
                ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabcont,
            children: [
              ...widget.pages.values,
            ],
          ),
        ),
      ],
    );
  }
}
