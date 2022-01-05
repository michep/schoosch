import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef TitleFunc<T> = String Function(T? value);
typedef WidgetFunc = Widget Function();
typedef CallbackFunc<T> = void Function(T? value);

class SelectableValueFormField<T> extends StatefulWidget {
  final String title;
  final Future<T?> initFuture;
  final WidgetFunc listFunc;
  final WidgetFunc detailsFunc;
  final TitleFunc titleFunc;
  final FormFieldValidator<String> validatorFunc;
  final CallbackFunc? callback;
  final TextEditingController? controller;

  const SelectableValueFormField({
    required this.title,
    required this.initFuture,
    required this.listFunc,
    required this.detailsFunc,
    required this.titleFunc,
    required this.validatorFunc,
    this.callback,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _SelectableValueFormFieldState createState() => _SelectableValueFormFieldState();
}

class _SelectableValueFormFieldState<T> extends State<SelectableValueFormField<T>> {
  late TextEditingController _controller;
  T? _data;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    widget.initFuture.then((value) => setState(() {
          _controller.text = widget.titleFunc(value);
          setValue(value);
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      showCursor: false,
      keyboardType: TextInputType.none,
      decoration: InputDecoration(
        label: Text(widget.title),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: _data == null
              ? IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: selectData,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: openData,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: removeData,
                    ),
                  ],
                ),
        ),
      ),
      validator: widget.validatorFunc,
    );
  }

  Future<void> selectData() async {
    var res = await Get.to<T>(widget.listFunc, transition: Transition.rightToLeft);
    if (res != null) {
      setState(() {
        _controller.text = widget.titleFunc(res);
        setValue(res);
      });
    }
  }

  Future<void> openData() async {
    var res = await Get.to<T>(widget.detailsFunc, transition: Transition.rightToLeft);
    if (res != null) {
      setState(() {
        _controller.text = widget.titleFunc(res);
        setValue(res);
      });
    }
  }

  void removeData() {
    setState(() {
      _controller.text = '';
      setValue(null);
    });
  }

  void setValue(T? value) {
    _data = value;
    if (widget.callback != null) widget.callback!(value);
  }
}
