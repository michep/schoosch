import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/mark_model.dart';

class MarkTypeFormField extends StatelessWidget {
  final void Function(MarkType?) onChanged;
  final MarkType markType;
  const MarkTypeFormField({Key? key, required this.markType, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return FormField<String>(
      builder: ((state) {
        return InputDecorator(
          decoration: InputDecoration(
            label: Text(loc.markTypeTitle),
          ),
          child: DropdownButton<MarkType>(
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: [
                ...MarkType.values.toList().map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.localizedName(loc)),
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
