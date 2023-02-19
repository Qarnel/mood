import 'dart:async';
import 'dart:developer';

import 'package:isar/isar.dart';

import 'isar_repository.dart';
import '../models/event_type.dart';

class EventTypeListAction {
  int id;
  bool isAddition;
  bool isDeletion;

  EventTypeListAction(
      {required this.id, required this.isAddition, required this.isDeletion});
}

class EventTypeRepository {
  static final EventTypeRepository _singleton = EventTypeRepository._internal();

  final StreamController<EventTypeListAction> _streamController = StreamController();
  late Stream<EventTypeListAction> _stream;
  Stream<EventTypeListAction> get stream => _stream;

  final bool sync = true;
  Isar? isar;

  factory EventTypeRepository() {
    return _singleton;
  }

  EventTypeRepository._internal() {
    log("EventTypeRepository::EventTypeRepository()");
    _stream = _streamController.stream.asBroadcastStream();
    isar = IsarRepository().isar;
  }

  int getCountSync() {
    if (isar == null || !isar!.isOpen) {
      return 0;
    }
    return isar!.eventTypes.countSync();
  }

  List<EventType> getAllSync({int offset = 0, int limit = 9999999}) {
    if (isar == null || !isar!.isOpen) {
      return [];
    }
    final builder =
        isar?.eventTypes.where().sortByNameDesc().offset(offset).limit(limit);
    return builder!.findAllSync();
  }

  Future<List<EventType?>?> getAll(
      {int offset = 0, int limit = 9999999}) async {
    if (isar == null || !isar!.isOpen) {
      return Future<List<EventType?>?>(() => null);
    }
    final builder =
        isar?.eventTypes.where().sortByNameDesc().offset(offset).limit(limit);
    if (sync) {
      return builder!.findAllSync();
    } else {
      return await builder!.findAll();
    }
  }

  Future<EventType?> get(int id) async {
    if (isar == null || !isar!.isOpen) {
      return Future<EventType?>(() => null);
    }
    if (sync) {
      return isar?.eventTypes.getSync(id);
    } else {
      return await isar?.eventTypes.get(id);
    }
  }

  FutureOr<int> put(EventType item) async {
    if (isar == null || !isar!.isOpen) {
      return Future<int>(() => -1);
    }

    bool isAddition = (item.id == null);

    if (sync) {
      return isar!.writeTxnSync<int>(() {
        // putSync saves links
        int id = isar!.eventTypes.putSync(item);
        _streamController
            .add(EventTypeListAction(id: id, isAddition: isAddition, isDeletion: false));
        return id;
      });
    } else {
      return isar!.writeTxn<int>(() async {
        int id = await isar!.eventTypes.put(item);
        _streamController
            .add(EventTypeListAction(id: id, isAddition: isAddition, isDeletion: false));
        return id;
      });
    }
  }

  FutureOr<bool> delete(int id) async {
    log("EventTypeRepository::delete()");
    if (isar == null || !isar!.isOpen) {
      log("EventTypeRepository::delete() - isar not initialize");
      return Future<bool>(() => false);
    }

    if (sync) {
      log("EventTypeRepository::delete() - sync");
      return isar!.writeTxnSync<bool>(() {
        bool result = isar!.eventTypes.deleteSync(id);
        _streamController
            .add(EventTypeListAction(id: id, isAddition: false, isDeletion: true));
        return result;
      });
    } else {
      log("EventTypeRepository::delete() - async");
      return isar!.writeTxn<bool>(() async {
        bool result = await isar!.eventTypes.delete(id);
        _streamController
            .add(EventTypeListAction(id: id, isAddition: false, isDeletion: true));
        return result;
      });
    }
  }
}
