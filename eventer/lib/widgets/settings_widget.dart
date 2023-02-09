import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:localization/src/localization_extension.dart';

import '../widgets/settings_panel_widget.dart';

// ignore: must_be_immutable
class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  List<bool> expanded = List<bool>.filled(1, false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          expanded[panelIndex] = !isExpanded;
        });
      },
      expandedHeaderPadding: const EdgeInsets.all(0),
      animationDuration: const Duration(milliseconds: 300),
      //animation duration while expanding/collapsing
      children: <ExpansionPanel>[
        SettingsPanelWidget.getExpansionPanel(
            context, expanded[0], "Theme".i18n(), EasyDynamicThemeAutoSwitch()),
      ],
    );
  }
}
