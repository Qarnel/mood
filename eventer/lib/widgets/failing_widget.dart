import 'package:flutter/material.dart';

class FailingWidget extends StatelessWidget {
  final String? message;

  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => FailingWidget(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const FailingWidget({this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Card(
            child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Column(children: [
                  const Icon(Icons.error_outline_rounded),
                  Text(message ?? "")
                ])),
          ),
        ));
  }
}
