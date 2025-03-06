class CreateUserModel {
  final bool success;
  final String message;
  final String? token;

  CreateUserModel({
    required this.success,
    required this.message,

    this.token,
  });

  factory CreateUserModel.fromMap(Map<String, dynamic> json) {
    print("CreateUserModel JSON: $json");
    return CreateUserModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],


      // Ensure this matches the key from the backend
    );
  }
}
