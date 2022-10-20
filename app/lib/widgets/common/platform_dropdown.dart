import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../theme/widgets_base_theme.dart';

class DropdownItem {
  final String value;
  final String label;

  DropdownItem({required this.value, required this.label});
}

class PlatformDropdown extends StatefulWidget {
  final List<DropdownItem> items;
  final DropdownItem value;
  final IconData? icon;
  final Function(String?) onChanged;

  const PlatformDropdown(
      {Key? key,
      required this.value,
      required this.items,
      required this.onChanged,
      this.icon})
      : super(key: key);

  @override
  State<PlatformDropdown> createState() => _PlatformDropdownState();
}

class _PlatformDropdownState extends State<PlatformDropdown> {
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    String currentValue = widget.value.value;
    String name = widget.items
        .firstWhere((DropdownItem item) => item.value == currentValue)
        .label;
    int selectedIndex = widget.items
        .indexWhere((DropdownItem item) => item.value == currentValue);

    final dropDownField = DropdownButtonFormField<String>(
        borderRadius: BorderRadius.circular(10),
        decoration: materialInputDecoration.copyWith(
            contentPadding: const EdgeInsets.only(right: 12),
            prefixIcon: Icon(widget.icon,color: Colors.black,)),
        value: widget.value.value,
        icon: const Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Icon(
            Icons.arrow_downward_sharp,
            color: Colors.black,
            size: 20,
          ),
        ),
        onChanged: widget.onChanged,
        items: widget.items.map<DropdownMenuItem<String>>((DropdownItem item) {
          return DropdownMenuItem<String>(
            value: item.value,
            child: Text(
              item.label,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
          );
        }).toList());


    // cupertino city picker
    final Widget cupertinoPicker = CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
           Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Icon(widget.icon,color: Colors.black),
          ),
          Expanded(
            child: Container(
              height: K_ITEM_EXTEND,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: CupertinoColors.label,
                  fontSize: 16.0,
                ),
                child: Semantics(
                  inMutuallyExclusiveGroup: true,
                  selected: true,
                  child: Text(name),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(
              CupertinoIcons.chevron_down,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
      onPressed: () => _showDialog(
        CupertinoPicker(
          scrollController: FixedExtentScrollController(
            initialItem: selectedIndex,
          ),
          magnification: 1.22,
          squeeze: 1.2,
          useMagnifier: true,
          itemExtent: K_ITEM_EXTEND,
          // This is called when selected item is changed.
          onSelectedItemChanged: (int selectedItem) {
            widget.onChanged(widget.items[selectedItem].value);
          },
          children: List<Widget>.generate(widget.items.length, (int index) {
            return Center(
              child: Text(
                widget.items[index].label,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }),
        ),
      ),
    );

    return Platform.isIOS ? cupertinoPicker : dropDownField;
  }
}
