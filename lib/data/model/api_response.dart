import 'dart:convert';

ApiResponse apiResponseFromJson(String str) => ApiResponse.fromJson(json.decode(str));

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  final bool error;
  final String message;

  ApiResponse({
    required this.error,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
  };
}
