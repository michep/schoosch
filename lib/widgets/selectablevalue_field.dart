import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef TitleFunc<T> = String Function(T? value);
typedef FutureFunc<T> = Future<T?> Function();
typedef WidgetFunc = Widget Function();
typedef CallbackMaybeFunc<T> = bool Function(T? value);

class SelectableValueFormField<T> extends StatefulWidget {
  final String title;
  final FutureFunc<T?> initFutureFunc;
  final WidgetFunc listFunc;
  final WidgetFunc? detailsFunc;
  final TitleFunc<T> titleFunc;
  final FormFieldValidator<String>? validatorFunc;
  final CallbackMaybeFunc<T> callback;

  const SelectableValueFormField({
    required this.title,
    required this.initFutureFunc,
    required this.listFunc,
    required this.titleFunc,
    required this.callback,
    this.detailsFunc,
    this.validatorFunc,
    Key? key,
  }) : super(key: key);

  @override
  _SelectableValueFormFieldState<T> createState() => _SelectableValueFormFieldState<T>();
}

class _SelectableValueFormFieldState<T> extends State<SelectableValueFormField<T>> {
  late final TextEditingController _controller = TextEditingController();
  T? _data;

  @override
  void initState() {
    widget.initFutureFunc().then((res) => setState(() => setValue(res)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
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
                    widget.detailsFunc != null
                        ? IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: openData,
                          )
                        : const SizedBox.shrink(),
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
      setState(() => setValue(res));
    }
  }

  Future<void> openData() async {
    if (widget.detailsFunc != null) {
      var res = await Get.to<T>(widget.detailsFunc, transition: Transition.rightToLeft);
      if (res != null) {
        setState(() => setValue(res));
      }
    }
  }

  void removeData() {
    setState(() => setValue(null));
  }

  void setValue(T? value) {
    if (widget.callback(value)) {
      _data = value;
      _controller.text = widget.titleFunc(value);
    } else {
      _data = null;
      _controller.text = '';
    }
  }
}
