import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/marktype_model.dart';

class MarkTypeFormField extends StatefulWidget {
  final void Function(MarkType?) onChanged;
  final MarkType markType;
  final String? Function(MarkType?)? validator;
  const MarkTypeFormField({
    super.key,
    required this.markType,
    required this.onChanged,
    this.validator,
  });

  @override
  State<MarkTypeFormField> createState() => _MarkTypeFormFieldState();
}

class _MarkTypeFormFieldState extends State<MarkTypeFormField> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    List<MarkType> types = MarkType.getAllMarktypes();
    return FormField<MarkType>(
      initialValue: widget.markType,
      validator: validate,
      builder: ((state) {
        return InputDecorator(
          decoration: InputDecoration(
            label: Text(loc.markTypeTitle),
            errorText: errorText,
          ),

          // child: ChipsChoice<MarkType>.single(
          //   value: state.value ?? widget.markType,
          //   onChanged: (v) {
          //     widget.onChanged(v);
          //     state.didChange(v);
          //     state.save();
          //   },
          //   choiceItems: C2Choice.listFrom<MarkType, MarkType>(
          //     source: MarkType.getAllMarktypes(),
          //     value: (i, v) => v,
          //     label: (i, v) => v.name,
          //   ),
          //   choiceStyle: C2ChipStyle.toned(
          //     borderRadius: const BorderRadius.all(
          //       Radius.circular(5),
          //     ),
          //   ),
          //   wrapped: true,
          // ),

          child: Wrap(
            spacing: 5.0,
            children: [
              ...types.map(
                (e) => ChoiceChip(
                  label: Text(e.name),
                  selected: e == state.value,
                  selectedColor: Get.theme.colorScheme.secondary,
                  backgroundColor: Get.theme.colorScheme.primary,
                  onSelected: (bool selected) {
                    widget.onChanged(e);
                    state.didChange(e);
                    state.save();
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String? validate(MarkType? mark) {
    var err = widget.validator?.call(mark);
    setState(() {
      errorText = err;
    });
    return err;
  }
}
