import 'dart:async';
import 'dart:developer';

import 'package:isar/isar.dart';

import '../models/event.dart';

class ListAction {
  int id;
  bool isDeletion;

  ListAction({required this.id, required this.isDeletion});
}

class EventRepository {
  static final EventRepository _singleton = EventRepository._internal();

  final StreamController<ListAction> _streamController = StreamController();
  Stream<ListAction> get stream => _streamController.stream;

  final bool sync = true;
  Isar? isar;

  factory EventRepository() {
    return _singleton;
  }

  EventRepository._internal() {
    log("EventRepository::EventRepository()");
    isar = Isar.openSync([EventSchema]);
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
      return isar?.events.getSync(id);
    } else {
      return await isar?.events.get(id);
    }
  }

  FutureOr<int> put(Event item) async {
    if (isar == null || !isar!.isOpen) {
      return Future<int>(() => -1);
    }

    if (sync) {
      return isar!.writeTxnSync<int>(() {
        int id = isar!.events.putSync(item);
        _streamController.add(ListAction(id: id, isDeletion: false));
        return id;
      });
    } else {
      return isar!.writeTxn<int>(() async {
        int id = await isar!.events.put(item);
        _streamController.add(ListAction(id: id, isDeletion: false));
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
        _streamController.add(ListAction(id: id, isDeletion: true));
        return result;
      });
    } else {
      log("EventRepository::delete() - async");
      return isar!.writeTxn<bool>(() async {
        bool result = await isar!.events.delete(id);
        _streamController.add(ListAction(id: id, isDeletion: true));
        return result;
      });
    }
  }
}
