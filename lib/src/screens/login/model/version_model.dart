// To parse this JSON data, do
//
//     final version = versionFromJson(jsonString);

import 'dart:convert';

Version versionFromJson(String str) => Version.fromJson(json.decode(str));

String versionToJson(Version data) => json.encode(data.toJson());

class Version {
    String? version;
    bool? status;
    String? message;

    Version({
        this.version,
        this.status,
        this.message,
    });

    factory Version.fromJson(Map<String, dynamic> json) => Version(
        version: json["version"],
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "version": version,
        "status": status,
        "message": message,
    };
}
