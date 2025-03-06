class OTPVerificationResponse {
  final String message;
  final bool success;
  final String? token;

  OTPVerificationResponse({
    required this.message,
    required this.success,
    this.token,
  });

  factory OTPVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OTPVerificationResponse(
      message: json['message'],
      success: json['success'],
      token: json['token'],
    );
  }
}
