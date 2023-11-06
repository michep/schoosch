import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/studyperiod_model.dart';

class StudyPeriodTypeFormField extends StatelessWidget {
  final void Function(StudyPeriodType?) onChanged;
  final StudyPeriodType periodType;
  const StudyPeriodTypeFormField({super.key, required this.periodType, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return FormField<String>(
      builder: ((state) {
        return InputDecorator(
          decoration: InputDecoration(
            label: Text(loc.studyPeriodTypeTitle),
          ),
          child: DropdownButton<StudyPeriodType>(
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: [
                ...StudyPeriodType.values.toList().map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.localizedName(loc)),
                      ),
                    ),
              ],
              value: periodType,
              onChanged: onChanged),
        );
      }),
    );
  }
}
