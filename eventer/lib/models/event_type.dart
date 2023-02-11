import 'package:isar/isar.dart';

import 'event.dart';

part 'event_type.g.dart';

@collection
class EventType {
  Id? id = Isar.autoIncrement;

  @Index()
  String? name;

  @Backlink(to: "type")
  IsarLinks<Event> events = IsarLinks<Event>();

  EventType({this.id, this.name});

  EventType copyWith({Id? id, String? name}) {
    return EventType(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  static EventType copyWithJson(
      EventType? eventType, Map<String, dynamic> json) {
    return EventType(
      id: eventType?.id,
      name: json.containsKey("name") ? json["name"] as String : eventType?.name,
    );
  }

  static EventType fromJson(Map<String, dynamic> json) {
    return EventType(
      id: json["id"] as Id,
      name: json["name"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "name": name,
      };

  @ignore
  List<Object?> get props => [id, name];

  @ignore
  String get nameToString {
    return name != null ? name! : "";
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
