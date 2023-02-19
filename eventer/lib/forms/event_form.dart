import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore: implementation_imports
import 'package:localization/src/localization_extension.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/event.dart';
import '../pages/event_type_list_page.dart';
import '../repositories/event_repository.dart';
import '../repositories/event_type_repository.dart';

class EventForm extends StatefulWidget {
  final EventTypeRepository eventTypeRepository = EventTypeRepository();
  final EventRepository eventRepository = EventRepository();
  final Event? event;

  EventForm({this.event, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  StreamSubscription<EventTypeListAction>? _streamSubsciption;
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

    _streamSubsciption = widget.eventTypeRepository.stream.listen((element) {
      updateState();
    });

    _form.control("date").updateValue(widget.event?.date);
    if (widget.event?.type.value?.id != null) {
      _form.control("type").updateValue(widget.event?.type.value?.id);
    }
    _form.control("level").updateValue(widget.event?.level);
  }

  @override
  void dispose() {
    _streamSubsciption?.cancel();
    super.dispose();
  }

  void updateState() {
    setState(() {
      _typeDropdownList = widget.eventTypeRepository
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
              builder: (contextForm, form, child) {
                return ElevatedButton(
                  onPressed: () {
                    if (form.valid) {
                      _onSubmit(form);
                      contextForm.pop();
                    }
                  },
                  child: Text("Submit".i18n()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmit(form) async {
    Event? event = widget.event;
    Map<String, Object?> results = {};
    results.addAll(form.value);
    results["eventType"] =
        await widget.eventTypeRepository.get(results["type"] as int);
    event = Event.copyWithJson(event, results);
    await widget.eventRepository.put(event);
  }
}
