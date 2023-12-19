import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/marktype_model.dart';

class MarkTypeChip extends StatelessWidget {
  final MarkType marktype;

  const MarkTypeChip({
    required this.marktype,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: marktype.name,
      child: Chip(
        backgroundColor: Get.theme.colorScheme.primary,
        label: Text(
          marktype.label,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}
