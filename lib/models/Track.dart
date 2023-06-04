import 'Album.dart';
import 'Artist.dart';

class Track {
  String name;
  String id;
  int duration_ms;

  Track({required this.name, required this.id, required this.duration_ms});
  static Track fromJason(dynamic json) {
    String name = json["name"] ?? "nema";
    int duration = json["duration_ms"] ?? 0;
    String id = json["id"] ?? "nema";
    return Track(name: name, id: id, duration_ms: duration);
  }
}
