class BaseModel {
  final String message;
  final bool status;
  BaseModel({required this.status, required this.message});
  factory BaseModel.fromMap(Map<String, dynamic> json) {
    return BaseModel(
      status: json['success'] ?? false,
      message: json['message'] == null ? "" : json['message'].toString(),
    );
  }
}
