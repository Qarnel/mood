import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../forms/event_form.dart';
import '../widgets/page_widget.dart';

class EventPage extends StatefulWidget {
  static const String routeName = '/login';

  const EventPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "Event".i18n(),
      child: const EventForm(),
    );
  }
}
