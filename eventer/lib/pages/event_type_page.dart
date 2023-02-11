import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../forms/event_type_form.dart';
import '../models/event_type.dart';
import '../widgets/page_widget.dart';

class EventTypePage extends StatefulWidget {
  static const String routeName = '/eventtype';
  final EventType? eventType;

  const EventTypePage({this.eventType, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventTypePageState createState() => _EventTypePageState();
}

class _EventTypePageState extends State<EventTypePage> {
  EventType? _eventType;

  @override
  void initState() {
    super.initState();
    _eventType = widget.eventType;
  }

  @override
  Widget build(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is EventType) {
      _eventType = arguments;
    }

    return PageWidget(
      title: "Event Type".i18n(),
      child: EventTypeForm(eventType: _eventType),
    );
  }
}
