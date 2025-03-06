class CreateShopModel {
  final bool success;
  final String message;

  CreateShopModel({
    required this.success,
    required this.message,
  });

  factory CreateShopModel.fromMap(Map<String, dynamic> json) {
    print("CreateShopModel JSON: $json");
    return CreateShopModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
    };
  }
}