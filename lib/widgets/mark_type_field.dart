import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/mark_model.dart';

class MarkTypeFormField extends StatelessWidget {
  final void Function(String?) onChanged;
  final String markType;
  const MarkTypeFormField({Key? key, required this.markType, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: ((state) {
        return InputDecorator(
          decoration: InputDecoration(
            label: Text(S.of(context).markTypeTitle),
          ),
          child: DropdownButton<String>(
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: [
                ...MarkType.values.toList().map(
                      (e) => DropdownMenuItem(
                        value: MarkModel.stringFromType(e),
                        child: Text(
                          MarkModel.localizedTypeName(
                            S.of(context),
                            e,
                          ),
                        ),
                      ),
                    ),
              ],
              value: markType,
              onChanged: onChanged),
        );
      }),
    );
  }
}
