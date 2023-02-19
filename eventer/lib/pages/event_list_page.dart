import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/page_widget.dart';
import '../pages/event_page.dart';
import '../widgets/event_list_widget.dart';

class EventListPage extends StatefulWidget {
  static const String routeName = '/';
  final String title = 'Eventer';

  const EventListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: widget.title,
      backButton: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.push(EventPage.routeName);
        },
      ),
      child: const EventListWidget(),
    );
  }
}
