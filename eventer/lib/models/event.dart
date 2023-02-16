import 'package:eventer/models/event_type.dart';
import 'package:isar/isar.dart';

part 'event.g.dart';

@collection
class Event {
  Id? id = Isar.autoIncrement;

  DateTime? date;

  IsarLink<EventType> type = IsarLink<EventType>();

  int? level;

  Event({this.id, this.date, this.level});

  Event copyWith({Id? id, DateTime? date, EventType? eventType, int? level}) {
    Event event = Event(
      id: id ?? this.id,
      date: date ?? this.date,
      level: level ?? this.level,
    );
    event.type.value = eventType ?? type.value;
    return event;
  }

  static Event copyWithJson(Event? event, Map<String, dynamic> json) {
    Event eventMerged = Event(
      id: event?.id,
      date: json.containsKey("date") ? json["date"] as DateTime : event?.date,
      
      level: json.containsKey("level") ? json["level"] as int : event?.level,
    );
    eventMerged.type.value = json.containsKey("type") ? json["type"] : event?.type.value;
    return eventMerged;
  }

  static Event fromJson(Map<String, dynamic> json) {
    Event event = Event(
      id: json["id"] as Id,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      level: json["level"] as int,
    );
    event.type.value = EventType.fromJson(json["eventType"]);
    return event;
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
    return type.value != null ? type.value!.nameToString : "";
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
