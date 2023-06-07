import 'dart:convert';

class Log {
  final String date;
  final String name;
  final String location;

  Log({
    required this.date,
    required this.name,
    required this.location,
  });

  // Factory constructor to instantiate object from json format
  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      date: json['date'],
      name: json['name'],
      location: json['location'],
    );
  }

  static List<Log> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Log>((dynamic d) => Log.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Log log) {
    return {
      'date': log.date,
      'name': log.name,
      'location': log.location,
    };
  }
}
