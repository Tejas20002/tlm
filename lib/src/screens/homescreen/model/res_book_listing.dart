// To parse this JSON data, do
//
//     final resBookListing = resBookListingFromJson(jsonString);

import 'dart:convert';

ResBookListing resBookListingFromJson(String str) => ResBookListing.fromJson(json.decode(str));

String resBookListingToJson(ResBookListing data) => json.encode(data.toJson());

class ResBookListing {
    List<Book>? book;
    bool? status;
    String? message;

    ResBookListing({
        this.book,
        this.status,
        this.message,
    });

    factory ResBookListing.fromJson(Map<String, dynamic> json) => ResBookListing(
        book: json["book"] == null ? [] : List<Book>.from(json["book"]!.map((x) => Book.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "book": book == null ? [] : List<dynamic>.from(book!.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Book {
    int? id;
    String? name;
    String? grade;
    String? subject;
    int? status;
    String? bookPart;
    String? createdAt;
    String? updatedAt;
    String? deletedAt;

    Book({
        this.id,
        this.name,
        this.grade,
        this.subject,
        this.status,
        this.bookPart,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        name: json["name"],
        grade: json["grade"],
        subject: json["subject"],
        status: json["status"],
        bookPart: json["book_part"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "grade": grade,
        "subject": subject,
        "status": status,
        "book_part": bookPart,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
    };
}
