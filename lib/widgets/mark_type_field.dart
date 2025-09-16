import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/marktype_model.dart';

class MarkTypeFormField extends StatefulWidget {
  final void Function(MarkType?) onChanged;
  final MarkType markType;
  final String? Function(MarkType?)? validator;
  final bool editMode;

  const MarkTypeFormField({
    super.key,
    required this.markType,
    required this.onChanged,
    this.validator,
    this.editMode = false,
  });

  @override
  State<MarkTypeFormField> createState() => _MarkTypeFormFieldState();
}

class _MarkTypeFormFieldState extends State<MarkTypeFormField> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    List<MarkType> types = InstitutionModel.currentInstitution.marktypesSync;
    return FormField<MarkType>(
      initialValue: widget.markType,
      validator: validate,
      builder: ((state) {
        return InputDecorator(
          decoration: InputDecoration(
            label: Text(loc.markTypeTitle),
            errorText: errorText,
          ),
          child: Wrap(
            spacing: 5.0,
            runSpacing: 5.0,
            children: [
              ...types.map(
                (e) => chip(state, e),
              ),
              if (widget.editMode && !types.contains(widget.markType))
                chip(
                  state,
                  widget.markType,
                  deprecated: true,
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

  Widget chip(FormFieldState<MarkType> state, MarkType mt, {bool deprecated = false}) => ChoiceChip(
    label: Text(mt.name),
    selected: mt == state.value,
    selectedColor: !deprecated ? Get.theme.colorScheme.secondary : Get.theme.colorScheme.secondary.withValues(alpha: 0.5),
    backgroundColor: !deprecated ? Get.theme.colorScheme.primary : Get.theme.colorScheme.primary.withValues(alpha: 0.5),
    onSelected: (bool selected) {
      widget.onChanged(mt);
      state.didChange(mt);
      state.save();
    },
  );
}
