import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DynamicAutocomplete<T extends Object> extends StatefulWidget {
  final AutocompleteOptionsBuilder<T> optionsBuilder;
  final AutocompleteOptionToString<T> displayStringForOption;
  final AutocompleteOptionsViewBuilder<T> optionsViewBuilder;
  final TextEditingValue? initialValue;
  final AutocompleteOnSelected<T>? onSelected;
  final AutocompleteFieldViewBuilder? fieldViewBuilder;
  final FocusNode focusNode;
  final TextEditingController controller;

  const DynamicAutocomplete({
    super.key,
    required this.optionsBuilder,
    required this.optionsViewBuilder,
    required this.focusNode,
    required this.controller,
    this.fieldViewBuilder,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.initialValue,
    this.onSelected,
  });

  @override
  State<DynamicAutocomplete> createState() => _DynamicAutocompleteState<T>();
}

class _DynamicAutocompleteState<T extends Object>
    extends State<DynamicAutocomplete<T>> {
  final GlobalKey _autocompleteKey = GlobalKey();
  bool _openUpwards = false;
  bool _flag = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return RawAutocomplete<T>(
          focusNode: widget.focusNode,
          textEditingController: widget.controller,
          key: _autocompleteKey,
          optionsBuilder: widget.optionsBuilder,
          fieldViewBuilder: widget.fieldViewBuilder ??
              (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) =>
                  TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onSubmitted: (s) {
                      onFieldSubmitted();
                    },
                  ),
          optionsViewBuilder:
              (context, AutocompleteOnSelected<T> onSelected, options) {
            if (_flag == true) {
              _flag = false;
              return Align(
                  alignment: _openUpwards
                      ? AlignmentDirectional.bottomStart
                      : AlignmentDirectional.topStart,
                  child: Material(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.outline),
                        borderRadius: BorderRadius.circular(4)),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: 200.0, maxWidth: constraints.maxWidth),
                      child: widget.optionsViewBuilder(
                          context, onSelected, options),
                    ),
                  ));
            } else {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _updateDirection(context);
              });
            }
            return const SizedBox.shrink();
          },
          optionsViewOpenDirection: (_openUpwards)
              ? OptionsViewOpenDirection.up
              : OptionsViewOpenDirection.down,
          initialValue: widget.initialValue,
          onSelected: widget.onSelected,
        );
      },
    );
  }

  void _updateDirection(BuildContext context) {
    final RenderBox renderBox =
        _autocompleteKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    setState(() {
      _openUpwards = (position.dy + renderBox.size.height + 200 > screenHeight);
      _flag = true;
    });
  }
}
