import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  /// The list of items shown in the dropdown.
  final List<MyDropDownItem> items;

  /// Callback when the user selects an item.
  final void Function(MyDropDownItem)? onSelected;

  /// The item selected by default (if any).
  final MyDropDownItem? initialItem;

  /// Text style for the item shown in the button (selected item).
  final TextStyle? selectedItemTextStyle;

  /// Text style for items in the dropdown menu.
  final TextStyle? dropdownItemTextStyle;

  /// The placeholder text shown when [items] is empty.
  final String noItemsText;

  /// The icon shown on the right side of the dropdown.
  final Widget? icon;

  /// Background color of the dropdown menu.
  final Color? dropdownColor;

  final String? labelText;

  const DropdownWidget({
    required this.items,
    this.onSelected,
    this.initialItem,
    this.selectedItemTextStyle,
    this.dropdownItemTextStyle,
    this.noItemsText = 'No items available',
    this.icon,
    this.dropdownColor,
    this.labelText,
    super.key,
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  late MyDropDownItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = _chooseInitial();
    if (_selectedItem != null) {
      widget.onSelected?.call(_selectedItem!);
    }
  }

  MyDropDownItem? _chooseInitial() {
    if (widget.items.isEmpty) return null;
    if (widget.initialItem != null &&
        widget.items.contains(widget.initialItem)) {
      return widget.initialItem;
    }
    return widget.items.first;
  }

  @override
  void didUpdateWidget(covariant DropdownWidget old) {
    super.didUpdateWidget(old);

    // if items became non-empty, pick an initial
    if (old.items.isEmpty && widget.items.isNotEmpty) {
      setState(() => _selectedItem = _chooseInitial());
      if (_selectedItem != null) widget.onSelected!(_selectedItem!);
    }

    // if current selection vanished, reset
    if (_selectedItem != null && !widget.items.contains(_selectedItem)) {
      setState(
        () =>
            _selectedItem = widget.items.isNotEmpty ? widget.items.first : null,
      );
      if (_selectedItem != null) widget.onSelected!(_selectedItem!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = widget.items.isEmpty;

    return InputDecorator(
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownMenu<MyDropDownItem>(
        // Material 3 style options
        menuStyle: MenuStyle(
          elevation: WidgetStateProperty.all(4),
          // remove default border & padding
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide.none,
            ),
          ),
          backgroundColor:
              widget.dropdownColor != null
                  ? WidgetStateProperty.all(widget.dropdownColor)
                  : null,
        ),
        // 🔑 Remove the inner field border completely
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),

        // what we show when nothing’s selected
        hintText: isEmpty ? widget.noItemsText : null,
        leadingIcon:
            _selectedItem == null
                ? null
                : (_selectedItem!.imageAsset != null
                    ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset(
                        _selectedItem!.imageAsset!,
                        width: 20,
                        height: 20,
                      ),
                    )
                    : (_selectedItem!.icon != null
                        ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(_selectedItem!.icon, size: 20),
                        )
                        : null)),
        // the trailing icon
        trailingIcon: widget.icon,

        // seed the initial selection
        initialSelection: _selectedItem,

        // when the user picks one
        onSelected: (item) {
          if (item == null) return;
          setState(() => _selectedItem = item);
          widget.onSelected?.call(item);
        },

        // build the menu entries
        dropdownMenuEntries:
            widget.items.map((item) {
              // choose a leading widget: image, icon, or nothing
              Widget? leading;
              if (item.imageAsset != null) {
                leading = Image.asset(item.imageAsset!, width: 24, height: 24);
              } else if (item.icon != null) {
                leading = Icon(item.icon, size: 24);
              }

              return DropdownMenuEntry<MyDropDownItem>(
                value: item,
                label: item.label,
                leadingIcon: leading,
              );
            }).toList(),
      ),
    );
  }
}

class MyDropDownItem<T> {
  final String label;
  final T value;
  final String? imageAsset;
  final IconData? icon;

  MyDropDownItem({
    required this.label,
    required this.value,
    this.imageAsset,
    this.icon,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MyDropDownItem) return false;
    return label == other.label &&
        value == other.value &&
        imageAsset == other.imageAsset;
  }

  @override
  int get hashCode =>
      label.hashCode ^ value.hashCode ^ (imageAsset?.hashCode ?? 0);
}
