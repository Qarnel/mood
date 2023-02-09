import 'dart:developer';

import 'package:isar/isar.dart';

import '../models/event.dart';

class EventRepository {
  static final EventRepository _singleton = EventRepository._internal();

  Isar? isar;

  factory EventRepository() {
    return _singleton;
  }

  EventRepository._internal() {
    log("EventRepository::EventRepository()");
    isar = Isar.openSync([EventSchema]);
  }

  Future<Event?> get(int id) async {
    return await isar?.events.get(id);
  }

  Future<void> put(Event? item) async {
//     await isar.writeTxn(() {
//   await isar.events.put(item); // insert & update
// });
  }
}
