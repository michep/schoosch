import 'package:flutter/material.dart';

class TabChip extends StatelessWidget {
  final String text;
  final int pos;
  final int current;
  const TabChip({Key? key, required this.current, required this.pos, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: current == pos ? Theme.of(context).colorScheme.onBackground : Colors.transparent,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text),
      );
  }
}