import 'dart:convert';

class UserRecord {
  // user properties
  String id;
  String fname;
  String lname;
  String email;

  // constructor
  UserRecord({
    required this.id,
    required this.fname,
    required this.lname,
    required this.email,
  });

  // creates new instance of user record using data stored in json
  factory UserRecord.fromJson(Map<String, dynamic> json) {
    return UserRecord(
        id: json['id'],
        fname: json['fname'],
        lname: json['lname'],
        email: json['email']);
  }

  static List<UserRecord> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<UserRecord>((dynamic d) => UserRecord.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(UserRecord user) {
    return {
      'fname': user.fname,
      'lname': user.lname,
      'email': user.email,
    };
  }
}
