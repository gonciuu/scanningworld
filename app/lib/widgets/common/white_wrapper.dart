import 'package:flutter/material.dart';

class WhiteWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const WhiteWrapper({Key? key,required this.child,this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
