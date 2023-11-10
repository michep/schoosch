import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:schoosch/model/status_enum.dart';

class ModelStatusFormField extends StatelessWidget {
  final void Function(StatusModel?) onChanged;
  final StatusModel status;
  const ModelStatusFormField({super.key, required this.status, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context)!;
    return FormField<String>(
      builder: ((state) {
        return InputDecorator(
          decoration: InputDecoration(
            label: Text(loc.modelStatusTitle),
          ),
          child: DropdownButton<StatusModel>(
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: [
                ...StatusModel.values.toList().map(
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
