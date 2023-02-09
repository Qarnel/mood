import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String? text;
  final List<String?>? textLines;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final TextOverflow overflow;
  final int maxLines;
  final MainAxisAlignment rowAxisAlignment;
  final CrossAxisAlignment columnAxisAlignment;
  List<Widget> childrenRow = <Widget>[];
  List<Widget> childrenColumn = <Widget>[];

  ButtonWidget({
    Key? key,
    this.onPressed,
    this.text,
    this.textLines,
    this.icon,
    this.foregroundColor,
    this.backgroundColor,
    this.overflow = TextOverflow.fade,
    this.maxLines = 1,
    this.rowAxisAlignment = MainAxisAlignment.start,
    this.columnAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key) {
    if (icon != null) {
      childrenRow.addAll([
        Icon(icon),
        const SizedBox(width: 20),
      ]);
    }
    if (text != null) {
      childrenRow.addAll([
        Flexible(
          child: FittedBox(
            child: Text(
              text!,
              overflow: overflow,
              maxLines: maxLines,
            ),
          ),
        ),
      ]);
    }
    if (textLines != null) {
      textLines!.forEach(_addElementToColumn);
    }
    childrenColumn.add(Row(
      mainAxisAlignment: rowAxisAlignment,
      children: childrenRow,
    ));
  }

  void _addElementToColumn(String? text) {
    if (text != null) {
      childrenColumn.add(
        FittedBox(
          child: Text(
            text,
            overflow: overflow,
            maxLines: maxLines,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: foregroundColor != null
            ? MaterialStateColor.resolveWith((states) => foregroundColor!)
            : null,
        backgroundColor: backgroundColor != null
            ? MaterialStateColor.resolveWith((states) => backgroundColor!)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: columnAxisAlignment,
          children: childrenColumn,
        ),
      ),
    );
  }
}
