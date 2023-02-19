import 'dart:async';
import 'dart:developer';

import 'package:isar/isar.dart';

import 'isar_repository.dart';
import '../models/event.dart';
import '../models/event_type.dart';

class EventListAction {
  int id;
  bool isAddition;
  bool isDeletion;

  EventListAction(
      {required this.id, required this.isAddition, required this.isDeletion});
}

class EventRepository {
  static final EventRepository _singleton = EventRepository._internal();

  final StreamController<EventListAction> _streamController =
      StreamController();
  late Stream<EventListAction> _stream;
  Stream<EventListAction> get stream => _stream;

  final bool sync = true;
  Isar? isar;

  factory EventRepository() {
    return _singleton;
  }

  EventRepository._internal() {
    log("EventRepository::EventRepository()");
    _stream = _streamController.stream.asBroadcastStream();
    isar = IsarRepository().isar;
  }

  int getCountSync() {
    if (isar == null || !isar!.isOpen) {
      return 0;
    }
    return isar!.events.countSync();
  }

  List<Event> getAllSync({int offset = 0, int limit = 9999999}) {
    if (isar == null || !isar!.isOpen) {
      return [];
    }
    final builder =
        isar?.events.where().sortByDateDesc().offset(offset).limit(limit);
    return builder!.findAllSync();
  }

  Future<List<Event?>?> getAll({int offset = 0, int limit = 9999999}) async {
    if (isar == null || !isar!.isOpen) {
      return Future<List<Event?>?>(() => null);
    }
    final builder =
        isar?.events.where().sortByDateDesc().offset(offset).limit(limit);
    if (sync) {
      return builder!.findAllSync();
    } else {
      return await builder!.findAll();
    }
  }

  Future<Event?> get(int id) async {
    if (isar == null || !isar!.isOpen) {
      return Future<Event?>(() => null);
    }
    if (sync) {
      Event? item = isar?.events.getSync(id);
      item?.type.loadSync();
      return item;
    } else {
      Event? item = await isar?.events.get(id);
      await item?.type.load();
      return item;
    }
  }

  FutureOr<int> put(Event item) async {
    if (isar == null || !isar!.isOpen) {
      return Future<int>(() => -1);
    }

    bool isAddition = (item.id == null);

    if (sync) {
      return isar!.writeTxnSync<int>(() {
        // putSync saves links
        int id = isar!.events.putSync(item);
        if (item.type.value != null) {
          isar!.eventTypes.putSync(item.type.value!);
        }
        item.type.saveSync();

        _streamController.add(
            EventListAction(id: id, isAddition: isAddition, isDeletion: false));
        return id;
      });
    } else {
      return isar!.writeTxn<int>(() async {
        int id = await isar!.events.put(item);
        await item.type.save();
        _streamController.add(
            EventListAction(id: id, isAddition: isAddition, isDeletion: false));
        return id;
      });
    }
  }

  FutureOr<bool> delete(int id) async {
    log("EventRepository::delete()");
    if (isar == null || !isar!.isOpen) {
      log("EventRepository::delete() - isar not initialize");
      return Future<bool>(() => false);
    }

    if (sync) {
      log("EventRepository::delete() - sync");
      return isar!.writeTxnSync<bool>(() {
        bool result = isar!.events.deleteSync(id);
        _streamController
            .add(EventListAction(id: id, isAddition: false, isDeletion: true));
        return result;
      });
    } else {
      log("EventRepository::delete() - async");
      return isar!.writeTxn<bool>(() async {
        bool result = await isar!.events.delete(id);
        _streamController
            .add(EventListAction(id: id, isAddition: false, isDeletion: true));
        return result;
      });
    }
  }
}
