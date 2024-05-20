// To parse this JSON data, do
//
//     final resLogin = resLoginFromJson(jsonString);

import 'dart:convert';

ResLogin resLoginFromJson(String str) => ResLogin.fromJson(json.decode(str));

String resLoginToJson(ResLogin data) => json.encode(data.toJson());

class ResLogin {
    User? user;
    String? token;
    bool? status;
    String? message;

    ResLogin({
        this.user,
        this.token,
        this.status,
        this.message,
    });

    factory ResLogin.fromJson(Map<String, dynamic> json) => ResLogin(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        token: json["token"],
        status: json["status"] ?? false,
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "token": token,
        "status": status,
        "message": message,
    };
}

class User {
    int? id;
    String? name;
    String? email;
    String? role;
    String? employeeCode;
    int? status;
    String? createdAt;
    String? updatedAt;
    String? deletedAt;

    User({
        this.id,
        this.name,
        this.email,
        this.role,
        this.employeeCode,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        employeeCode: json["employee_code"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "employee_code": employeeCode,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
    };
}
