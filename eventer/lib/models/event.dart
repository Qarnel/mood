import 'package:isar/isar.dart';

part 'event.g.dart';

@collection
class Event {
  Id? id = Isar.autoIncrement;

  DateTime? date;

  String? type;

  int? level;

  Event({this.id, this.date, this.type, this.level});

  Event copyWith({Id? id, DateTime? date, String? type, int? level}) {
    return Event(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      level: level ?? this.level,
    );
  }

  static Event copyWithJson(Event? event, Map<String, dynamic> json) {
    return Event(
      id: event?.id,
      date: json.containsKey("date") ? json["date"] as DateTime : event?.date,
      type: json.containsKey("type") ? json["type"] as String : event?.type,
      level: json.containsKey("level") ? json["level"] as int : event?.level,
    );
  }

  static Event fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"] as Id,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      type: json["type"] as String,
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

  @override
  String toString() {
    return toJson().toString();
  }
}
