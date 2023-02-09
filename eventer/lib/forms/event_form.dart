import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:localization/src/localization_extension.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/event.dart';
import '../repositories/event_repository.dart';

class EventForm extends StatefulWidget {
  final Event? event;

  const EventForm({this.event, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _form = FormGroup({
    "date": FormControl<DateTime>(validators: [Validators.required]),
    "type": FormControl<String>(validators: [Validators.required]),
    "level": FormControl<int>(validators: [Validators.required])
  });

  @override
  void initState() {
    _form.control("date").updateValue(widget.event?.date);
    _form.control("type").updateValue(widget.event?.type);
    _form.control("level").updateValue(widget.event?.level);
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
            ReactiveDateTimePicker(
              formControlName: "date",
              type: ReactiveDatePickerFieldType.dateTime,
              decoration: InputDecoration(
                labelText: 'Date'.i18n(),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              firstDate: DateTime.now().subtract(const Duration(days: 40)),
              lastDate: DateTime.now().add(const Duration(days: 40)),
            ),
            const SizedBox(height: 10),
            ReactiveTextField(
              formControlName: "type",
              decoration: InputDecoration(labelText: 'Type'.i18n()),
              maxLength: 70,
            ),
            const SizedBox(height: 10),
            ReactiveSlider(
              formControlName: "level",
              min: 0,
              max: 100,
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
    Event? event = widget.event;
    event = Event.copyWithJson(event, _form.value);
    if (kDebugMode) {
      log("Event : $event");
    }
    EventRepository().put(event);
  }
}
