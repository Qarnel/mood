import 'dart:developer';

import 'package:eventer/repositories/event_type_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore: implementation_imports
import 'package:localization/src/localization_extension.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/event.dart';
import '../models/event_type.dart';
import '../pages/event_type_list_page.dart';
import '../repositories/event_repository.dart';

class EventForm extends StatefulWidget {
  final Event? event;

  const EventForm({this.event, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  late List<DropdownMenuItem<Object?>> _typeDropdownList;

  final _form = FormGroup({
    "date": FormControl<DateTime>(validators: [Validators.required]),
    "type": FormControl<int>(validators: [Validators.required]),
    "level": FormControl<int>(validators: [Validators.required])
  });

  @override
  void initState() {
    super.initState();

    updateState();

    EventTypeRepository().stream.forEach((element) {
      updateState();
    });

    _form.control("date").updateValue(widget.event?.date);
    if (widget.event?.type.value?.id != null) {
      print("value = ${widget.event?.type.value}");
      _form.control("type").updateValue(widget.event?.type.value?.id);
    }
    _form.control("level").updateValue(widget.event?.level);
  }

  void updateState() {
    setState(() {
      _typeDropdownList = EventTypeRepository()
          .getAllSync()
          .map((e) => DropdownMenuItem<int?>(
                value: e.id,
                child: Text(e.nameToString),
              ))
          .toList();
    });
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
            Row(
              children: [
                Expanded(
                  child: ReactiveDropdownField(
                    items: _typeDropdownList,
                    formControlName: "type",
                    decoration: InputDecoration(labelText: 'Type'.i18n()),
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => context.push(EventTypeListPage.routeName)),
              ],
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
    Map<String, Object?> results = {};
    results.addAll(_form.value);
    results["type"] = await EventTypeRepository().get(results["type"] as int);
    if (kDebugMode) {
      log("Results : $results");
    }
    event = Event.copyWithJson(event, results);
    if (kDebugMode) {
      log("Event : $event");
    }
    EventRepository().put(event);
    context.pop();
  }
}
