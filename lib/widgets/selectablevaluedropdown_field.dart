import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:schoosch/widgets/autocomplete.dart' as autocomlete;

typedef TitleFunc<T> = String Function(T? value);
typedef FutureFunc<T> = Future<T?> Function();
typedef WidgetFunc = Widget Function();
typedef CallbackMaybeFunc<T> = bool Function(T? value);
typedef ListFutureFunc<T> = Future<List<T>> Function();

class SelectableValueDropdownFormField<T extends Object> extends StatefulWidget {
  final String title;
  final FutureFunc<T?> initFutureFunc;
  final ListFutureFunc<T> initOptionsFutureFunc;
  final WidgetFunc listFunc;
  final WidgetFunc? detailsFunc;
  final TitleFunc<T> titleFunc;
  final FormFieldValidator<String>? validatorFunc;
  final CallbackMaybeFunc<T> callback;

  const SelectableValueDropdownFormField({
    required this.title,
    required this.initFutureFunc,
    required this.initOptionsFutureFunc,
    required this.listFunc,
    required this.titleFunc,
    required this.callback,
    this.detailsFunc,
    this.validatorFunc,
    Key? key,
  }) : super(key: key);

  @override
  SelectableValueDropdownFormFieldState<T> createState() => SelectableValueDropdownFormFieldState<T>();
}

class SelectableValueDropdownFormFieldState<T extends Object> extends State<SelectableValueDropdownFormField<T>> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scroll = ScrollController();
  final List<T> _options = [];
  final _key1 = GlobalKey();
  double _width = 0;
  T? _data;

  @override
  void initState() {
    widget.initFutureFunc().then((res) => _setValue(res));
    widget.initOptionsFutureFunc().then((options) => setState(() {
          _options.addAll(options);
        }));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _width = _key1.currentContext!.size!.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return autocomlete.RawAutocomplete<T>(
      textEditingController: _controller,
      focusNode: _focusNode,
      optionsViewBuilder: optionsViewBuilder,
      fieldViewBuilder: fieldViewBuilder,
      optionsBuilder: optionsBuilder,
      onSelected: (option) => _setValue(option),
      initialValueFuture: widget.initFutureFunc,
    );
  }

  Widget fieldViewBuilder(BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
    return TextFormField(
      key: _key1,
      readOnly: _data != null,
      showCursor: _data == null,
      keyboardType: _data != null ? TextInputType.none : TextInputType.text,
      controller: textEditingController,
      focusNode: focusNode,
      onFieldSubmitted: (value) => onFieldSubmitted(),
      decoration: InputDecoration(
        label: Text(widget.title),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: _data == null
              ? IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _selectData,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.detailsFunc != null
                        ? IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: _openData,
                          )
                        : const SizedBox.shrink(),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _removeData,
                    ),
                  ],
                ),
        ),
      ),
      validator: widget.validatorFunc,
    );
  }

  Widget optionsViewBuilder(BuildContext context, AutocompleteOnSelected<T> onSelected, Iterable<T> options) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200, maxWidth: _width),
          child: Scrollbar(
            controller: _scroll,
            thumbVisibility: true,
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(8.0),
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final T option = options.elementAt(index);
                return InkWell(
                  onTap: () {
                    onSelected(option);
                  },
                  child: Builder(
                    builder: (BuildContext context) {
                      final bool highlight = autocomlete.AutocompleteHighlightedOption.of(context) == index;
                      if (highlight) {
                        SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
                          Scrollable.ensureVisible(context, alignment: 0.5);
                        });
                      }
                      return Container(
                        color: highlight ? Theme.of(context).focusColor : null,
                        padding: const EdgeInsets.all(16.0),
                        child: Text(option.toString()),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  FutureOr<Iterable<T>> optionsBuilder(TextEditingValue textEditingValue) {
    return _options.where((option) {
      return option.toString().toLowerCase().contains(textEditingValue.text.toLowerCase());
    });
  }

  Future<void> _selectData() async {
    var res = await Get.to<T>(widget.listFunc, transition: Transition.rightToLeft);
    if (res != null) {
      _setValue(res);
    }
  }

  Future<void> _openData() async {
    if (widget.detailsFunc != null) {
      var res = await Get.to<T>(widget.detailsFunc, transition: Transition.rightToLeft);
      if (res != null) {
        _setValue(res);
      }
    }
  }

  void _removeData() {
    _setValue(null);
  }

  void _setValue(T? value) {
    setState(() {
      if (widget.callback(value)) {
        _data = value;
        _controller.text = widget.titleFunc(value);
      } else {
        _data = null;
        _controller.text = '';
      }
    });
  }
}
