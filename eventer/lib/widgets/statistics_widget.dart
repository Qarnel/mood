import 'dart:typed_data';

import 'package:d_chart/d_chart.dart';
import 'package:fftea/fftea.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:localization/src/localization_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/event.dart';
import '../models/event_type.dart';
import '../repositories/event_repository.dart';
import '../repositories/event_type_repository.dart';

// ignore: must_be_immutable
class StatisticsWidget extends StatefulWidget {
  final EventTypeRepository eventTypeRepository = EventTypeRepository();
  final EventRepository eventRepository = EventRepository();

  StatisticsWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StatisticsWidgetState createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget> {
  bool _isLoading = true;
  var data = [];
  EventType? _selectedEventType;
  late List<DropdownMenuItem<Object?>> _typeDropdownList;
  final _form = FormGroup({
    "type": FormControl<int>(value: -1),
  });

  @override
  void initState() {
    super.initState();
    _selectedEventType = null;
    _typeDropdownList = widget.eventTypeRepository
        .getAllSync()
        .map((e) => DropdownMenuItem<int?>(
              value: e.id,
              child: Text(e.nameToString),
            ))
        .toList();
    _typeDropdownList.add(DropdownMenuItem<int?>(
      value: -1,
      child: Text("ALL".i18n()),
    ));
    updateState(null);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> updateState(eventTypeId) async {
    setState(() {
      _isLoading = true;
    });

    if (eventTypeId == null || eventTypeId == -1) {
      _selectedEventType = null;
    } else {
      _selectedEventType =
          await widget.eventTypeRepository.get(eventTypeId as int);
    }

    List<Event> events = widget.eventRepository.getAllSync();

    final FFT fft = FFT(events.length);
    final Float64x2List frequence = fft.realFft(
        events.map((e) => e.date!.millisecondsSinceEpoch.toDouble()).toList());

    data = frequence.toList();

    setState(() {
      _isLoading = false;
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
            ReactiveDropdownField(
              items: _typeDropdownList,
              formControlName: "type",
              decoration: InputDecoration(labelText: 'Type'.i18n()),
              onChanged: (control) async {
                updateState(control.value);
              },
            ),
            const SizedBox(height: 10),
            _isLoading == true
                ? const Text("LOADING >>>>>>>>>>")
                : Expanded(
                    child: DChartBar(
                      data: [
                        {
                          'id': 'Bar',
                          'data': data,
                        },
                      ],
                      barColor: (barData, index, id) {
                        return Colors.green;
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
