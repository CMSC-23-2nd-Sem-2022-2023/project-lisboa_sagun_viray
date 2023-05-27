import 'dart:convert';

class AdminRecord {
  // Admin properties
  String id;
  String fname;
  String lname;
  String email;

  // constructor
  AdminRecord({
    required this.id,
    required this.fname,
    required this.lname,
    required this.email,
  });

  // creates new instance of Admin record using data stored in json
  factory AdminRecord.fromJson(Map<String, dynamic> json) {
    return AdminRecord(
        id: json['id'],
        fname: json['fname'],
        lname: json['lname'],
        email: json['email']);
  }

  static List<AdminRecord> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<AdminRecord>((dynamic d) => AdminRecord.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(AdminRecord Admin) {
    return {
      'fname': Admin.fname,
      'lname': Admin.lname,
      'email': Admin.email,
    };
  }
}
