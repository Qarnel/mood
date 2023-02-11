import 'package:eventer/models/event_type.dart';
import 'package:isar/isar.dart';

part 'event.g.dart';

@collection
class Event {
  Id? id = Isar.autoIncrement;

  DateTime? date;

  IsarLink<EventType> type = IsarLink<EventType>();

  int? level;

  Event({this.id, this.date, EventType? eventType, this.level}) {
    type.value = eventType;
  }

  Event copyWith({Id? id, DateTime? date, EventType? eventType, int? level}) {
    return Event(
      id: id ?? this.id,
      date: date ?? this.date,
      eventType: eventType ?? type.value,
      level: level ?? this.level,
    );
  }

  static Event copyWithJson(Event? event, Map<String, dynamic> json) {
    return Event(
      id: event?.id,
      date: json.containsKey("date") ? json["date"] as DateTime : event?.date,
      eventType: json.containsKey("type") ? json["type"] : event?.type.value,
      level: json.containsKey("level") ? json["level"] as int : event?.level,
    );
  }

  static Event fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"] as Id,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      eventType: EventType.fromJson(json["eventType"]),
      level: json["level"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "date": date?.millisecondsSinceEpoch.toString(),
        "type": type,
        "level": level.toString(),
      };

  @ignore
  List<Object?> get props => [id, date, type, level];

  @ignore
  String get dateToString {
    return date != null ? date!.toLocal().toString() : "";
  }

  @ignore
  String get typeToString {
    return type.value != null ? type.value!.toString() : "";
  }

  @ignore
  String get levelToString {
    return level != null ? level!.toString() : "";
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
