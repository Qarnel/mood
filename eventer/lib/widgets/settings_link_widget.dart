import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/settings_page.dart';

// ignore: must_be_immutable
class SettingsLinkWidget extends StatelessWidget {
  const SettingsLinkWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _actionNavigate(context),
      icon: const Icon(Icons.settings),
    );
  }

  void _actionNavigate(BuildContext context) {
    //Navigator.pushNamed(context, SettingsPage.routeName);
    context.push(SettingsPage.routeName);
  }
}
