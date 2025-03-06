import 'dart:convert';

class CreateProductModel {
  final bool success;
  final String message;

  CreateProductModel({
    required this.success,
    required this.message,
  });

  // Factory method to create an instance from JSON
  factory CreateProductModel.fromMap(Map<String, dynamic> json) {
    return CreateProductModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "Something went wrong",
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toMap() {
    return {
      "success": success,
      "message": message,
    };
  }

  // Convert JSON string to object
  factory CreateProductModel.fromJson(String source) =>
      CreateProductModel.fromMap(json.decode(source));

  // Convert object to JSON string
  String toJson() => json.encode(toMap());
}
