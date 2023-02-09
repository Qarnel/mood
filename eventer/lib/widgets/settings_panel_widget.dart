import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SettingsPanelWidget {
  static ExpansionPanel getExpansionPanel(
      BuildContext context, bool isExpanded, String name, Widget widget,
      {Color? color}) {
    return ExpansionPanel(
      canTapOnHeader: true,
      headerBuilder: (context, isOpen) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Text(name),
        );
      },
      body: Container(
        padding: const EdgeInsets.all(10),
        color: color,
        child: widget,
      ),
      isExpanded: isExpanded,
    );
  }
}
