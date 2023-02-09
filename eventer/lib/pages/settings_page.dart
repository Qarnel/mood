import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:localization/src/localization_extension.dart';

import '../widgets/page_widget.dart';
import '../widgets/settings_widget.dart';

// ignore: must_be_immutable
class SettingsPage extends StatelessWidget {
  static const routeName = '/settings';
  String title = "Settings".i18n();

  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "Settings".i18n(),
      child: const SettingsWidget(),
    );
  }
}
