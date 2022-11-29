import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/status_enum.dart';

class ModelStatusFormField extends StatelessWidget {
  final void Function(ModelStatus?) onChanged;
  final ModelStatus status;
  const ModelStatusFormField({Key? key, required this.status, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return FormField<String>(
      builder: ((state) {
        return InputDecorator(
          decoration: InputDecoration(
            label: Text(loc.modelStatusTitle),
          ),
          child: DropdownButton<ModelStatus>(
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: [
                ...ModelStatus.values.toList().map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.localizedName(loc)),
                      ),
                    ),
              ],
              value: status,
              onChanged: onChanged),
        );
      }),
    );
  }
}
