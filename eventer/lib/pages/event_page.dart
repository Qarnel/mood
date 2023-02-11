import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../forms/event_form.dart';
import '../models/event.dart';
import '../widgets/page_widget.dart';

class EventPage extends StatefulWidget {
  static const String routeName = '/event';
  final Event? event;

  const EventPage({this.event, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Event? _item;

  @override
  void initState() {
    super.initState();
    _item = widget.event;

  }

  @override
  Widget build(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is Event) {
      _item = arguments;
    }

    return PageWidget(
      title: "Event".i18n(),
      child: EventForm(event: _item),
    );
  }
}
