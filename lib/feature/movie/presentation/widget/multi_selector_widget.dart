import 'package:dashboard/config/theme/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MultiSelectorWidget<T> extends StatelessWidget {
  final List<T>? items;
  final TextEditingController controller;
  final Widget Function(T item) selectedItemWidget;
  final Widget Function(T item) unselectedItemWidget;
  final Widget? errorWidget;
  final SearchMatchFn<T> searchMatchFn;
  final String labelText;
  final Function(T? item) selectItem;
  final bool disabled;
  final bool isLoading;
  final List<T> selectedValues;
  final Widget Function(T item) selectedItemBuilder;

  const MultiSelectorWidget(
      {super.key,
      required this.items,
      required this.selectedItemWidget,
      required this.labelText,
      required this.selectItem,
      required this.unselectedItemWidget,
      required this.selectedItemBuilder,
      required this.selectedValues,
      required this.searchMatchFn,
      required this.errorWidget,
      required this.controller,
      this.disabled = false,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    var itemsWidget = items
        ?.map((item) => DropdownMenuItem(
            enabled: false,
            value: item,
            child: _ItemWidget(
                selectedValues: selectedValues,
                selectedItemWidget: selectedItemWidget,
                unselectedItemWidget: unselectedItemWidget,
                item: item,
                selectItem: selectItem)))
        .toList();
    return DropdownButtonFormField2<T>(
      isExpanded: true,
      buttonStyleData: const ButtonStyleData(height: 30),
      decoration: InputDecoration(
        label: Text(labelText),
        enabled: !disabled,
        error: errorWidget,
        helper: isLoading
            ? SizedBox(
                width: 20,
                child: RepaintBoundary(
                    child: SpinKitThreeBounce(
                  size: 12,
                  color: CustomColor.loginBackgroundColor.getColor(context),
                )),
              )
            : null,
      ),
      items: itemsWidget,
      selectedItemBuilder: (c) =>
          items
              ?.map((e) => ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(0),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: selectedValues
                            .map((v) => selectedItemBuilder(v))
                            .toList(),
                      ),
                    ),
                  ))
              .toList() ??
          [],
      onChanged: disabled ? null : selectItem,
      value: selectedValues.lastOrNull,
      dropdownSearchData: DropdownSearchData(
        searchController: controller,
        searchMatchFn: searchMatchFn,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: controller,
            maxLines: 1,
            decoration: const InputDecoration(
              hintText: 'جستجو',
            ),
          ),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          boxShadow: const [],
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onMenuStateChange: (isOpen) {
        if (!isOpen) {
          controller.clear();
        }
      },
    );
  }
}

class _ItemWidget<T> extends StatefulWidget {
  final List<T> selectedValues;
  final Widget Function(T item) selectedItemWidget;
  final Widget Function(T item) unselectedItemWidget;
  final T item;
  final Function(T? item) selectItem;

  const _ItemWidget(
      {super.key,
      required this.selectedValues,
      required this.selectedItemWidget,
      required this.unselectedItemWidget,
      required this.item,
      required this.selectItem});

  @override
  State<_ItemWidget<T>> createState() => _ItemWidgetState<T>();
}

class _ItemWidgetState<T> extends State<_ItemWidget<T>> {
  late final List<T> internalSelectedValues;
  @override
  void initState() {
    internalSelectedValues = List.of(widget.selectedValues);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (internalSelectedValues.contains(widget.item)) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onTap: () {
              widget.selectItem(widget.item);
              setState(() {
                internalSelectedValues.remove(widget.item);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: widget.selectedItemWidget(widget.item)),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onTap: () {
              widget.selectItem(widget.item);
              setState(() {
                internalSelectedValues.add(widget.item);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: widget.unselectedItemWidget(widget.item)),
            ),
          ),
        ),
      );
    }
  }
}
