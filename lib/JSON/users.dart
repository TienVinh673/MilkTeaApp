import 'dart:convert';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));

String usersToMap(Users data) => json.encode(data.toMap());

class Users {
  final int? usrId;
  final String usrName;
  final String email;
  final String usrPassword;
  final String? phone;
  final String? address;

  Users({
    this.usrId,
    required this.usrName,
    required this.email,
    required this.usrPassword,
    this.phone,
    this.address,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
    usrId: json["usrId"],
    usrName: json["usrName"],
    email: json["email"],
    usrPassword: json["usrPassword"],
    phone: json["phone"],
    address: json["address"],
  );

  Map<String, dynamic> toMap() => {
    "usrId": usrId,
    "usrName": usrName,
    "email": email,
    "usrPassword": usrPassword,
    "phone": phone ?? '',
    "address": address ?? '',
  };
}
