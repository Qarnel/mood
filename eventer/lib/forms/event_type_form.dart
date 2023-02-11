import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore: implementation_imports
import 'package:localization/src/localization_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/event_type.dart';
import '../repositories/event_type_repository.dart';

class EventTypeForm extends StatefulWidget {
  final EventType? eventType;

  const EventTypeForm({this.eventType, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventTypeFormState createState() => _EventTypeFormState();
}

class _EventTypeFormState extends State<EventTypeForm> {
  final _form = FormGroup({
    "name": FormControl<String>(validators: [Validators.required]),
  });

  @override
  void initState() {
    _form.control("name").updateValue(widget.eventType?.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ReactiveForm(
        formGroup: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ReactiveTextField(
              formControlName: "name",
              decoration: InputDecoration(labelText: 'Name'.i18n()),
              maxLength: 70,
            ),
            const SizedBox(height: 10),
            ReactiveFormConsumer(
              builder: (context, form, child) {
                return ElevatedButton(
                    onPressed: form.valid ? _onSubmit : null,
                    child: Text("Submit".i18n()));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (kDebugMode) {
      log("Submited : ${_form.value}");
    }
    EventType? eventType = widget.eventType;
    eventType = EventType.copyWithJson(eventType, _form.value);
    if (kDebugMode) {
      log("EventType : $eventType");
    }
    EventTypeRepository().put(eventType);
    context.pop();
  }
}
