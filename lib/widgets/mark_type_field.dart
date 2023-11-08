import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
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
    return FormField<MarkType>(
      validator: validate,
      builder: ((state) {
        return InputDecorator(
          decoration: InputDecoration(
            label: Text(loc.markTypeTitle),
          ),
          // child: DropdownButton<MarkType>(
          //     isExpanded: true,
          //     underline: const SizedBox.shrink(),
          //     items: [
          //       ...MarkType.values.toList().map(
          //             (e) => DropdownMenuItem(
          //               value: e,
          //               child: Text(e.localizedName(loc)),
          //             ),
          //           ),
          //     ],
          //     value: markType,
          //     onChanged: onChanged),
          child: ChipsChoice<MarkType>.single(
            value: state.value ?? widget.markType,
            onChanged: (v) {
              widget.onChanged(v);
              state.didChange(v);
              state.save();
            },
            choiceItems: C2Choice.listFrom<MarkType, MarkType>(
              source: MarkType.getAllMarktypes(),
              value: (i, v) => v,
              label: (i, v) => v.name,
            ),
            choiceStyle: C2ChipStyle.toned(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            wrapped: true,
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
