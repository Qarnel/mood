import 'dart:developer';

import 'package:isar/isar.dart';

import '../models/event.dart';
import '../models/event_type.dart';

class IsarRepository {
  static final IsarRepository _singleton = IsarRepository._internal();

  Isar? _isar;
  Isar? get isar => _isar;

  factory IsarRepository() {
    return _singleton;
  }

  IsarRepository._internal() {
    log("IsarRepository::IsarRepository()");
    _isar = Isar.openSync([EventSchema, EventTypeSchema]);
  }
}
