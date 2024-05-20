//Base model
class ResBaseModel {
  String message;
  int statusCode;
  bool success;

  ResBaseModel({required this.message, required this.statusCode, required this.success});

  factory ResBaseModel.fromJson(Map<String, dynamic> json) {
    return ResBaseModel(
      message: json['message'],
      statusCode: json['statusCode'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    data['statusCode'] = statusCode;
    data['success'] = success;
    return data;
  }
}
