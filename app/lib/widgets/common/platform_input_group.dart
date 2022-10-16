import 'dart:io';
import 'package:flutter/cupertino.dart';

class PlatformInputGroup extends StatelessWidget {
  final List<Widget> children;
  final Widget? cupertinoHeader;

  const PlatformInputGroup(
      {Key? key, required this.children, this.cupertinoHeader})
      : super(key: key);

  List<Widget> materialChildren() {
    List<Widget> materialChildren = children;
    for (int i = 0; i < materialChildren.length; i++) {
      if (i % 2 != 0) {
        materialChildren.insert(
            i,
            const SizedBox(
              height: 12,
            ));
      }
    }
    return materialChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoFormSection.insetGrouped(
            header: cupertinoHeader,
            margin: EdgeInsets.zero,
            children: children)
        : Column(
            children: materialChildren(),
          );
  }
}
