import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:localization/src/localization_extension.dart';

import '../widgets/failing_widget.dart';
import '../widgets/appbar_widget.dart';

class FailPage extends StatelessWidget {
  static const routeName = '/fail';

  const FailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? item;

    final dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is String) {
      item = arguments;
    }

    return Scaffold(
        appBar: AppBarWidget("Error".i18n()),
        body: FailingWidget(message: item ?? "Error".i18n()));
  }
}
