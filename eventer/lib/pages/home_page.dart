import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';

import '../widgets/event_list_widget.dart';
import '../widgets/page_widget.dart';
import '../widgets/statistics_widget.dart';
import 'event_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _currentTabIndex = 0;

  @override
  initState() {
    super.initState();
    _currentTabIndex = 0;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  static const int indexEventsTab = 0;
  final kTabPages = <Widget>[
    const EventListWidget(),
    const StatisticsWidget(),
  ];
  final kBottomNavBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: const Icon(Icons.event), label: "Events".i18n()),
    BottomNavigationBarItem(
        icon: const Icon(Icons.screen_rotation), label: "Statistics".i18n())
  ];

  @override
  Widget build(BuildContext context) {
    assert(kTabPages.length == kBottomNavBarItems.length);

    final bottomNavBar = BottomNavigationBar(
      items: kBottomNavBarItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
    );

    final FloatingActionButton floatingActionButton = FloatingActionButton(
      heroTag: "new",
      onPressed: () {
        context.push(EventPage.routeName);
      },
      child: const Icon(Icons.add),
    );

    return PageWidget(
      title: "Eventer".i18n(),
      backButton: false,
      bottomNavigationBar: bottomNavBar,
      floatingActionButton:
          (_currentTabIndex == indexEventsTab) ? floatingActionButton : null,
      child: kTabPages[_currentTabIndex],
    );
  }
}
