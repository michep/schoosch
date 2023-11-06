import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';

class MarkFormField extends StatefulWidget {
  final int mark;
  final void Function(int?) onSaved;
  final String? Function(int?)? validator;

  const MarkFormField({
    super.key,
    required this.mark,
    required this.onSaved,
    this.validator,
  });

  @override
  State<MarkFormField> createState() => _MarkFormFieldState();
}

class _MarkFormFieldState extends State<MarkFormField> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return FormField<int>(
      initialValue: widget.mark,
      onSaved: widget.onSaved,
      validator: validate,
      builder: ((state) {
        var selStyle = ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(state.context).colorScheme.secondary));
        return InputDecorator(
          decoration: InputDecoration(
            label: Text(S.of(state.context).markTitle),
            errorText: errorText,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  state.didChange(1);
                  state.save();
                },
                style: state.value == 1 ? selStyle : null,
                child: const Text('1'),
              ),
              ElevatedButton(
                onPressed: () {
                  state.didChange(2);
                  state.save();
                },
                style: state.value == 2 ? selStyle : null,
                child: const Text('2'),
              ),
              ElevatedButton(
                onPressed: () {
                  state.didChange(3);
                  state.save();
                },
                style: state.value == 3 ? selStyle : null,
                child: const Text('3'),
              ),
              ElevatedButton(
                onPressed: () {
                  state.didChange(4);
                  state.save();
                },
                style: state.value == 4 ? selStyle : null,
                child: const Text('4'),
              ),
              ElevatedButton(
                onPressed: () {
                  state.didChange(5);
                  state.save();
                },
                style: state.value == 5 ? selStyle : null,
                child: const Text('5'),
              ),
            ],
          ),
        );
      }),
    );
  }

  String? validate(int? mark) {
    var err = widget.validator?.call(mark);
    setState(() {
      errorText = err;
    });
    return err;
  }
}
