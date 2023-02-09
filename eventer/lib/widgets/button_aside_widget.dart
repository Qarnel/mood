import 'package:flutter/material.dart';

class ButtonAsideWidget extends StatelessWidget {
  final Widget child;
  final Widget button;
  final double flexChild;

  const ButtonAsideWidget({
    Key? key,
    required this.child,
    required this.button,
    this.flexChild = 0.7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: (100 * flexChild).floor(),
          child: child,
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: (100 * (1 - flexChild)).floor(),
          child: button,
        ),
      ],
    );
  }
}
