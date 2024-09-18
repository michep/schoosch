import 'package:flutter/material.dart';

class StatusFilter extends StatefulWidget {
  final void Function(int? value) onChange;

  const StatusFilter({
    required this.onChange,
    super.key,
  });

  @override
  State<StatusFilter> createState() => _StatusFilterState();
}

class _StatusFilterState<T> extends State<StatusFilter> {
  int? _status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text('Статус'),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: DropdownButton<int>(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            value: _status,
            items: const [
              DropdownMenuItem(
                value: 1,
                child: Text('Активно'),
              ),
              DropdownMenuItem(
                value: 0,
                child: Text('Выключено'),
              ),
              DropdownMenuItem(
                value: null,
                child: Text('Все'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _status = value;
              });
              widget.onChange(value);
            },
          ),
        ),
      ],
    );
  }
}
